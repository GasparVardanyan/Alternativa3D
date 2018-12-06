package  
{
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Loader3D;
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Vector3D;
	
	import away3d.debug.AwayStats;
    import away3d.containers.*;
    import away3d.primitives.*;
	import away3d.lights.PointLight3D;
	import away3d.core.base.Mesh;
	import away3d.containers.ObjectContainer3D;
	import away3d.core.render.Renderer;
	import away3d.materials.ShadingColorMaterial;
	import away3d.loaders.Collada;
	
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.vehicles.JCar;
	import jiglib.vehicles.JWheel;
	import jiglib.geometry.JTerrain;
	import jiglib.plugin.away3d.*;
	
	/**
	 * ...
	 * @author Muzer
	 */
	[SWF(width="800", height="600", backgroundColor="#222266", frameRate="60")]
	public class Away3DCarDriveOnTerrain extends Sprite
	{
		[Embed(source = "res/hightmap2.jpg")]
		public var TERRIAN_MAP:Class;
		
		public var view:View3D;
		private var materia:ShadingColorMaterial;
		private var mylight:PointLight3D;
		
		private var carSkin:ObjectContainer3D;
		private var steerFR :ObjectContainer3D;
		private var steerFL :ObjectContainer3D;
		private var wheelFR :Mesh;
		private var wheelFL :Mesh;
		private var wheelBR :Mesh;
		private var wheelBL :Mesh;
		
		private var terrain:JTerrain;
		private var carBody:JCar;
		private var physics:Away3DPhysics;
		
		public function Away3DCarDriveOnTerrain() 
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
            view.x = stage.stageWidth / 2;
            view.y = stage.stageHeight / 2;
            addChild(view);
						
			mylight = new PointLight3D();
			view.scene.addLight(mylight);
			mylight.ambient = 0.5;
			mylight.brightness = 50;
			mylight.y = 5000;
			mylight.z = -8000;
			
			physics = new Away3DPhysics(view, 8);
			
			//view.renderer = Renderer.CORRECT_Z_ORDER;
			materia = new ShadingColorMaterial(0x77ee77);
			//create terrain
			var terrainBMD:Bitmap = new TERRIAN_MAP;
			terrain = physics.createTerrain(terrainBMD.bitmapData, { material:materia, width:10000, height:10000, segmentsW:30, segmentsH:30, maxHeight:800 } );
			
			materia = new ShadingColorMaterial(0xeeeeff);
			var collada:Collada = new Collada({material:materia});
			collada.scaling = 2;
			var loader:Loader3D = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader.loadGeometry("res/car.dae", collada);
			view.scene.addChild(loader);
			
		}
		private function onSuccess(event:Loader3DEvent):void
		{
			carSkin = event.loader.handle as ObjectContainer3D;

			carBody = new JCar(new Away3dMesh(carSkin));
			carBody.setCar(40, 1, 350);
			carBody.chassis.moveTo(new Vector3D( 4300, 200, -2800));
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
			if (carSkin) {
				var dir:Vector3D = carBody.chassis.currentState.getOrientationCols()[2].add(new Vector3D(0, -0.2, 0));
				dir.scaleBy(-600);
				view.camera.position = carSkin.position.add(dir);
				view.camera.lookAt(carSkin.position);
			}
			view.render();
			updateWheelSkin();
			physics.engine.integrate(0.1);
		}
	}

}