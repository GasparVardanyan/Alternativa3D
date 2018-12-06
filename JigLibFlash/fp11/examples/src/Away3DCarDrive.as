package  
{
	import away3d.containers.View3D;
	import away3d.events.LoaderEvent;
	import away3d.lights.PointLight;
	import away3d.loaders.Loader3D;
	import away3d.loaders.parsers.Parsers;
	import away3d.materials.BitmapMaterial;
	import away3d.materials.ColorMaterial;
	import away3d.primitives.Cube;
	import away3d.entities.Mesh;
	import away3d.containers.ObjectContainer3D;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	
	import jiglib.cof.JConfig;
	import jiglib.debug.Stats;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.plugin.away3d4.*;
	import jiglib.vehicles.JCar;
	import jiglib.vehicles.JWheel;
		
	/**
	 * ...
	 * @author Muzer
	 */
	 [SWF(width="800", height="600", frameRate="60")]
	public class Away3DCarDrive extends Sprite
	{
		[Embed(source="../res/fskin.jpg")]
        private var CarSkin : Class;
		
		public var view:View3D;
		private var mylight:PointLight;
		
		private var container:ObjectContainer3D;
		private var steerFR:ObjectContainer3D;
		private var steerFL:ObjectContainer3D;
		private var wheelFR:Mesh;
		private var wheelFL:Mesh;
		private var wheelBR:Mesh;
		private var wheelBL:Mesh;
		
		private var carBody:JCar;
		private var physics:Away3D4Physics;
		private var boxBody:Vector.<RigidBody>;
		
		public function Away3DCarDrive() 
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			init3D();
			
			this.addChild(new Stats(view, physics));
		}
		
		private function init3D():void {
			
			view = new View3D();
            addChild(view);
			
			mylight = new PointLight();
			view.scene.addChild(mylight);
			mylight.color = 0xffffff;
			mylight.y = 1000;
			mylight.z= -1000;
			
			physics = new Away3D4Physics(view, 6);
			
			var materia:ColorMaterial = new ColorMaterial(0x77ee77);
			materia.lights = [mylight];
			var ground:RigidBody = physics.createGround(materia, 1000, 1000);
			
			materia = new ColorMaterial(0xeeee00);
			materia.lights = [mylight];
			boxBody = new Vector.<RigidBody>();
			for (var i:int = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube(materia, 60, 50, 80 );
				boxBody[i].moveTo(new Vector3D(0, 10 + (50 * i + 50), 0));
			}
			
			Parsers.enableAllBundled();
			
			var _loader:Loader3D = new Loader3D();
			_loader.load(new URLRequest('../res/car.obj'));
			_loader.addEventListener(LoaderEvent.RESOURCE_COMPLETE, onResourceComplete);
			
		}
		private function onResourceComplete(event : LoaderEvent) : void
		{
			container=ObjectContainer3D(event.target);
			view.scene.addChild(container);
			
			var carMaterial:BitmapMaterial = new BitmapMaterial(new CarSkin().bitmapData);
			carMaterial.lights = [mylight];
			
			var mesh : Mesh;
			for (var i : int = 0; i < container.numChildren; ++i) {
                mesh = Mesh(container.getChildAt(i));
                mesh.geometry.scale(40);
                mesh.material = carMaterial
            }
			
			carBody = new JCar(null);
			carBody.setCar(40, 1, 500);
			carBody.chassis.moveTo(new Vector3D(-200, 200, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 10;
			carBody.chassis.sideLengths = new Vector3D(105, 40, 220);
			physics.addBody(carBody.chassis);
			
			carBody.setupWheel("WheelFL", new Vector3D(-48, -20, 68), 1.3, 1.3, 6, 20, 0.5, 0.5, 2);
			carBody.setupWheel("WheelFR", new Vector3D(48, -20, 68), 1.3, 1.3, 6, 20, 0.5, 0.5, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-48, -20, -84), 1.3, 1.3, 6, 20, 0.5, 0.5, 2);
			carBody.setupWheel("WheelBR", new Vector3D(48, -20, -84), 1.3, 1.3, 6, 20, 0.5, 0.5, 2);
			
			wheelFL = Mesh(container.getChildAt(0));
			wheelFR = Mesh(container.getChildAt(3));
			wheelBL = Mesh(container.getChildAt(4));
			wheelBL.position = new Vector3D( -48, -20, -84);
			wheelBR = Mesh(container.getChildAt(2));
			wheelBR.position = new Vector3D(48, -20, -84);
			
			steerFL = new ObjectContainer3D();
			steerFL.position = new Vector3D(-48,-20,68);
			steerFL.addChild(wheelFL);
			container.addChild(steerFL);
			
			steerFR = new ObjectContainer3D();
			steerFR.position = new Vector3D(48,-20,68);
			steerFR.addChild(wheelFR);
			container.addChild(steerFR);
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
		
		private function updateCarSkin():void
		{
			if (!carBody)
				return;
				
			container.transform = JMatrix3D.getAppendMatrix3D(carBody.chassis.currentState.orientation, JMatrix3D.getTranslationMatrix(carBody.chassis.currentState.position.x, carBody.chassis.currentState.position.y, carBody.chassis.currentState.position.z));
			
			wheelFL.pitch(carBody.wheels["WheelFL"].getRollAngle());
			wheelFR.pitch(carBody.wheels["WheelFR"].getRollAngle());
			wheelBL.pitch(carBody.wheels["WheelBL"].getRollAngle());
			wheelBR.pitch(carBody.wheels["WheelBR"].getRollAngle());
			
			steerFL.rotationY = carBody.wheels["WheelFL"].getSteerAngle();
			steerFR.rotationY = carBody.wheels["WheelFR"].getSteerAngle();
			
			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
			
			view.camera.position=container.position.add(new Vector3D(0,500,-500));
			view.camera.lookAt(container.position);
		}
		
		private function onEnterFrame(event:Event):void
        {
			view.render();
			updateCarSkin();
			physics.step(0.1);
		}
	}

}