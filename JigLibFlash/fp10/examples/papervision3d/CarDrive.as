package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Vector3D;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.parsers.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.events.FileLoadEvent;
	import org.papervision3d.objects.parsers.Collada;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.stats.StatsView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;

	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.vehicles.JCar;
	import jiglib.vehicles.JWheel;
	import jiglib.plugin.papervision3d.*;

	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="60")]
	public class CarDrive extends BasicView
	{
		private var mylight:PointLight3D;
		
		private var carBody:JCar;
		private var carSkin:Collada;
		private var steerFR :DisplayObject3D;
		private var steerFL :DisplayObject3D;
		private var wheelFR :DisplayObject3D;
		private var wheelFL :DisplayObject3D;
		private var wheelBR :DisplayObject3D;
		private var wheelBL :DisplayObject3D;
		private var vplObjects:ViewportLayer;
		
		private var physics:Papervision3DPhysics;
		
		public function CarDrive() 
		{
			super(800, 600, true, true, CameraType.TARGET);
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			
			init3D();
		}
		
		private function init3D():void
		{
			physics = new Papervision3DPhysics(scene, 6);
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			 
			mylight = new PointLight3D(true, true);
			mylight.y = 300;
			mylight.z = -400;
			 
			var shadeMateria:FlatShadeMaterial = new FlatShadeMaterial(mylight, 0x77ee77);
			var ground:RigidBody = physics.createGround(shadeMateria, 500, 0);
			viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 0;
			
			
			//init car skin
			shadeMateria = new FlatShadeMaterial(mylight,0xeeeeff);
			var materiaList:MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria,"all");
			carSkin = new Collada("res/car.dae", materiaList, 0.01);
			carSkin.addEventListener(FileLoadEvent.LOAD_COMPLETE,onCarLoaded);
			 
			camera.y = mylight.y;
			camera.z = mylight.z;
			 
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
		}
		
		private function onCarLoaded(e:FileLoadEvent):void
		{
			scene.addChild(carSkin);
			 
			//init car physics
			carBody = new JCar(new Pv3dMesh(carSkin));
			carBody.setCar(40,1,400);
			carBody.chassis.moveTo(new Vector3D( 0, 100, 0));
			carBody.chassis.rotationY = -90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(40, 20, 90);
			physics.addBody(carBody.chassis);
			 
			carBody.setupWheel("WheelFL", new Vector3D( -20, -10, 25), 1.2, 1.2, 3, 8, 0.5, 0.6, 2);
			carBody.setupWheel("WheelFR", new Vector3D(20, -10, 25), 1.2, 1.2, 3, 8, 0.5, 0.6, 2);
			carBody.setupWheel("WheelBL", new Vector3D( -20, -10, -25), 1.2, 1.2, 3, 8, 0.5, 0.6, 2);
			carBody.setupWheel("WheelBR", new Vector3D(20, -10, -25), 1.2, 1.2, 3, 8, 0.5, 0.6, 2);
			 
			var shadeMateria:FlatShadeMaterial = new FlatShadeMaterial(mylight, 0x777777);
			steerFL = carSkin.getChildByName( "WheelFL", true );
			steerFR = carSkin.getChildByName( "WheelFR", true );
			wheelFL = carSkin.getChildByName( "WheelFL_PIVOT", true );
			wheelFL.material = shadeMateria;
			wheelFR = carSkin.getChildByName( "WheelFR_PIVOT", true );
			wheelFR.material = shadeMateria;
			wheelBL = carSkin.getChildByName( "WheelBL", true );
			wheelBL.material = shadeMateria;
			wheelBR = carSkin.getChildByName( "WheelBR", true );
			wheelBR.material = shadeMateria;
			 
			var vplCar:ViewportLayer = viewport.getChildLayer(carSkin.getChildByName("Chassis",true));
			vplCar.addDisplayObject3D(wheelFR);
			vplCar.addDisplayObject3D(wheelFL);
			vplCar.addDisplayObject3D(wheelBR);
			vplCar.addDisplayObject3D(wheelBL);
			vplCar.layerIndex = 2;
			
			shadeMateria = new FlatShadeMaterial(mylight, 0x77ee77);
			var materiaList :MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria, "all");
			var ramp1:RigidBody = physics.createCube(materiaList, 400, 200, 10);
			ramp1.movable = false;
			ramp1.moveTo(new Vector3D(0, 33, 250));
			ramp1.rotationX = -20;
			vplCar.addDisplayObject3D(physics.getMesh(ramp1));
			
			var ramp2:RigidBody = physics.createCube(materiaList, 400, 200, 10);
			ramp2.movable = false;
			ramp2.moveTo(new Vector3D(0, 33, 440));
			ramp2.rotationX = 20;
			vplCar.addDisplayObject3D(physics.getMesh(ramp2));
			
			shadeMateria = new FlatShadeMaterial(mylight, 0xeeee00);
			materiaList = new MaterialsList();
			materiaList.addMaterial(shadeMateria, "all");
			var boxBody:Array = new Array();
			for (var i:int = 0; i < 2; i++)
			{
				boxBody[i] = physics.createCube(materiaList, 40, 40, 40);
				boxBody[i].moveTo(new Vector3D(-100, 30 + (50 * i + 50), 0));
				vplCar.addDisplayObject3D(boxBody[i].skin.mesh);
			}
			
			startRendering();
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
		 
		protected override function onRenderTick(event:Event = null):void {
			//physics.step();
			physics.engine.integrate(0.1);
			updateWheelSkin();
			super.onRenderTick(event);
		}
	}
}