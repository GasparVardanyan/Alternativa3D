package  
{
	
	import away3d.containers.*;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.render.BSPRenderer;
	import away3d.core.render.Renderer;
	import away3d.debug.AwayStats;
	import away3d.events.Loader3DEvent;
	import away3d.lights.PointLight3D;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.loaders.Obj;
	import away3d.materials.ShadingColorMaterial;
	import away3d.primitives.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.plugin.away3d.*;
	import jiglib.vehicles.JCar;
	import jiglib.vehicles.JWheel;

	/**
	 * ...
	 * @author Muzer
	 */
	
	[SWF(width="800", height="600", backgroundColor="#222266", frameRate="60")]
	public class Away3DTriangleMesh extends Sprite
	{
		public var view:View3D;
		private var materia:ShadingColorMaterial;
		private var mylight:PointLight3D;
		
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		
		private var steerFR :ObjectContainer3D;
		private var steerFL :ObjectContainer3D;
		private var wheelFR :Mesh;
		private var wheelFL :Mesh;
		private var wheelBR :Mesh;
		private var wheelBL :Mesh;
		
		private var carBody:JCar;
		private var physics:Away3DPhysics;
		
		public function Away3DTriangleMesh() 
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			init3D();
			
			var stats:AwayStats = new AwayStats(view);
			addChild(stats);
		}
		
		private function init3D():void {
			
			view = new View3D();
			view.renderer=Renderer.CORRECT_Z_ORDER;
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);
			
			mylight = new PointLight3D();
			view.scene.addLight(mylight);
			mylight.ambient = 0.4;
			mylight.y = 600;
			mylight.z = -800;
			
			physics = new Away3DPhysics(view, 8);
			
			materia = new ShadingColorMaterial(0x77ee77);
			
			var obj:Obj = new Obj({material:materia});
			var loader:Loader3D = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSceneSuccess);
			loader.loadGeometry("res/scene.obj", obj);
			
			materia = new ShadingColorMaterial(0xeeeeff);
			var collada:Collada = new Collada({material:materia});
			collada.scaling = 2;
			loader = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onCarSuccess);
			loader.loadGeometry("res/car.dae", collada);
			view.scene.addChild(loader);
			
			view.camera.y = mylight.y;
			view.camera.z = mylight.z;
			view.camera.lookAt(new Vector3D());
			view.camera.zoom = 5;
		}
		
		private function onSceneSuccess(event:Loader3DEvent):void{
			var sceneMesh:Mesh=event.loader.handle as Mesh;
			view.scene.addChild(sceneMesh);
			
			var rot:Matrix3D=new Matrix3D();
			rot.appendRotation(180,new Vector3D(0,1,0));
			
			var triangleMesh:JTriangleMesh = physics.createMesh(sceneMesh, new Vector3D(0, 0, 0), rot, 10, 10);
			
			materia = new ShadingColorMaterial(0xeeee00);
			ballBody = new Vector.<RigidBody>();
			for (var i:int = 0; i < 3; i++)
			{
				ballBody[i] = physics.createSphere({ material:this.materia, radius:22 });
				ballBody[i].moveTo(new Vector3D( -500+1000*Math.random(),100+500*Math.random(), -500+1000*Math.random()));
			}
			
			boxBody = new Vector.<RigidBody>();
			for (i = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube({ material:this.materia, width:50, height:30, depth:40 });
				boxBody[i].moveTo(new Vector3D( -500+1000*Math.random(),100+500*Math.random(), -500+1000*Math.random()));
			}
		}
		
		private function onCarSuccess(event:Loader3DEvent):void
		{
			var carSkin:ObjectContainer3D = event.loader.handle as ObjectContainer3D;
			
			carBody = new JCar(new Away3dMesh(carSkin));
			carBody.setCar(40, 1, 400);
			carBody.chassis.moveTo(new Vector3D(0, 200, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(80, 40, 180);
			physics.addBody(carBody.chassis);
			
			carBody.setupWheel("WheelFL", new Vector3D(-40, -20, 45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelFR", new Vector3D(40, -20, 45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-40, -20, -45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBR", new Vector3D(40, -20, -45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			
			steerFL = carSkin.getChildByName("WheelFL-node") as ObjectContainer3D;
			steerFR = carSkin.getChildByName("WheelFR-node") as ObjectContainer3D;
			wheelFL = carSkin.getChildByName("WheelFL-node_PIVOT") as Mesh;
			wheelFR = carSkin.getChildByName("WheelFR-node_PIVOT") as Mesh;
			wheelBL = carSkin.getChildByName("WheelBL-node") as Mesh;
			wheelBR = carSkin.getChildByName("WheelBR-node") as Mesh;
		}
		
		private function keyDownHandler(event :KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					carBody.setAccelerate(1);
					break;
				case Keyboard.DOWN:
					carBody.setAccelerate(-1);
					break;
				case Keyboard.LEFT:
					carBody.setSteer(["WheelFL", "WheelFR"], -1);
					break;
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], 1);
					break;
				case Keyboard.SPACE:
					carBody.setHBrake(1);
					break;
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					carBody.setAccelerate(0);
					break;
				
				case Keyboard.DOWN:
					carBody.setAccelerate(0);
					break;
				
				case Keyboard.LEFT:
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				case Keyboard.SPACE:
					carBody.setHBrake(0);
			}
		}
		
		private function updateWheelSkin():void
		{
			if (!carBody)
				return;
			
			steerFL.rotationY = carBody.wheels["WheelFL"].getSteerAngle();
			steerFR.rotationY = carBody.wheels["WheelFR"].getSteerAngle();
			
			wheelFL.pitch(carBody.wheels["WheelFL"].getRollAngle());
			wheelFR.pitch(carBody.wheels["WheelFR"].getRollAngle());
			wheelBL.roll(carBody.wheels["WheelBL"].getRollAngle());
			wheelBR.roll(carBody.wheels["WheelBR"].getRollAngle());
			
			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
		}
		
		private function onEnterFrame(event:Event):void
		{
			view.render();
			updateWheelSkin();
			physics.engine.integrate(0.1);
		}
	}
	
}