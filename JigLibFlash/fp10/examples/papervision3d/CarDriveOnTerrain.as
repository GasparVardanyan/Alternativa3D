package  
{
	import flash.display.*;
	import flash.events.*;
	import flash.ui.Keyboard;
	import flash.geom.Vector3D;
	
	import org.papervision3d.cameras.SpringCamera3D;
	import org.papervision3d.core.clipping.FrustumClipping;
	import org.papervision3d.core.math.Number3D;
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

	import jiglib.cof.JConfig;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.geometry.*;
	import jiglib.vehicles.JCar;
	import jiglib.vehicles.JWheel;
	import jiglib.plugin.papervision3d.*;

	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="60")]
	public class CarDriveOnTerrain extends BasicView
	{
		
		[Embed(source="res/hightmap2.jpg")]
        public var TERRIAN_MAP:Class;
		
		private var springCamera:SpringCamera3D;
		private var mylight:PointLight3D;
		
		private var terrain:JTerrain;
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
		
		public function CarDriveOnTerrain() 
		{
			super(800, 600, true, true);
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
			
			init3D();
		}
		
		private function init3D():void
		{
			physics = new Papervision3DPhysics(scene, 8);

			renderer.clipping = new FrustumClipping(FrustumClipping.NEAR);
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			 
			springCamera = new SpringCamera3D();
			springCamera.y = 5000;
			springCamera.mass = 10;
			springCamera.damping = 10;
			springCamera.stiffness = 1;
			springCamera.positionOffset = new Number3D(0, 150, -200);
			
			mylight = new PointLight3D(true, true);
			mylight.y = 5000;
			 
			var terrainBMD:Bitmap = new TERRIAN_MAP;
			var shadeMateria:FlatShadeMaterial = new FlatShadeMaterial(mylight, 0x77ee77);
			
			//create terrain
			terrain = physics.createTerrain(terrainBMD.bitmapData, shadeMateria, 10000, 10000, 800, 30, 30);
			viewport.getChildLayer(DisplayObject3D(terrain.terrainMesh)).layerIndex = 0;
			
			
			//init car skin
			shadeMateria = new FlatShadeMaterial(mylight,0xeeeeff);
			var materiaList:MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria,"all");
			carSkin = new Collada("res/car.DAE", materiaList, 0.02);
			carSkin.addEventListener(FileLoadEvent.LOAD_COMPLETE,onCarLoaded);
			 
			springCamera.target = carSkin;
			
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
		}
		
		private function onCarLoaded(e:FileLoadEvent):void
		{
			scene.addChild(carSkin);
			 
			//init car physics
			carBody = new JCar(new Pv3dMesh(carSkin));
			carBody.setCar(40,1,400);
			carBody.chassis.moveTo(new Vector3D( 4000, 100, -3000));
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(80, 40, 180);
			physics.addBody(carBody.chassis);
			 
			carBody.setupWheel("WheelFL", new Vector3D(-40, -20, 45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelFR", new Vector3D(40, -20, 45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBL", new Vector3D( -40, -20, -45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			carBody.setupWheel("WheelBR", new Vector3D(40, -20, -45), 1.4, 1.4, 5, 20, 0.4, 0.5, 2);
			 
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
			
			renderer.renderScene(scene, springCamera, viewport);
		}
	}
}