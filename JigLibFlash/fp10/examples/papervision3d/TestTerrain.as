package {
	import flash.display.Bitmap;
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.stats.StatsView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	import jiglib.cof.JConfig;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.papervision3d.*;

	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="60")]
	public class TestTerrain extends BasicView
	{
		[Embed(source="res/hightmap1.jpg")]
        public var TERRIAN_MAP:Class;

		private var terrain:JTerrain;
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		private var capsuleBody:Vector.<RigidBody>;
		private var physics:Papervision3DPhysics;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
		
		public function TestTerrain()
		{
			super(800, 600, true, true, CameraType.TARGET);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
			
			init();
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
		}
		
		private function init():void
		{
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			physics = new Papervision3DPhysics(scene, 8);
			
			var mylight:PointLight3D = new PointLight3D(true, true);
			mylight.y = 600;
			mylight.z = -400;
			camera.y = mylight.y;
			camera.z = mylight.z;
			
			var terrainBMD:Bitmap = new TERRIAN_MAP;
			var shadeMateria:FlatShadeMaterial = new FlatShadeMaterial(mylight, 0x77ee77);
			
			//create terrain
			terrain = physics.createTerrain(terrainBMD.bitmapData, shadeMateria, 800, 800, 350, 10, 10);
			terrain.friction = 0.2;
			viewport.getChildLayer(DisplayObject3D(terrain.terrainMesh)).layerIndex = 1;
			
			
			var vplObjects:ViewportLayer = new ViewportLayer(viewport,null);
			vplObjects.layerIndex = 2;
			vplObjects.sortMode = ViewportLayerSortMode.Z_SORT;
			viewport.containerSprite.addLayer(vplObjects);
			
			ballBody = new Vector.<RigidBody>();
			var color:uint;
			for (var i:int = 0; i < 5; i++)
			{
				color = (i == 0)?0xff8888:0xeeee00;
				shadeMateria = new FlatShadeMaterial(mylight, color);
				ballBody[i] = physics.createSphere(shadeMateria, 25);
				ballBody[i].moveTo(new Vector3D( 0, 100 + (60 * i + 60), 200));
				vplObjects.addDisplayObject3D(physics.getMesh(ballBody[i]));
			}
			ballBody[0].mass = 10;
			
			shadeMateria = new FlatShadeMaterial(mylight,0xeeee00);
			var materiaList:MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria,"all");
			boxBody=new Vector.<RigidBody>();
			for (i = 0; i < 3; i++)
			{
				boxBody[i] = physics.createCube(materiaList, 50, 40, 30);
				boxBody[i].moveTo(new Vector3D(-200, 100 + (50 * i + 50), 0));
				vplObjects.addDisplayObject3D(physics.getMesh(boxBody[i]));
			}
		
			var capsuleSkin:Cylinder;
			capsuleBody = new Vector.<RigidBody>();
			for (i = 0; i < 3; i++)
			{
				capsuleSkin = new Cylinder(shadeMateria, 20, 50);
				scene.addChild(capsuleSkin);
				vplObjects.addDisplayObject3D(capsuleSkin);
				
				capsuleBody[i] = new JCapsule(new Pv3dMesh(capsuleSkin), 20, 30);
				capsuleBody[i].moveTo(new Vector3D(200, 100 + (80 * i + 80), 0));
				physics.addBody(capsuleBody[i]);
			}
			
			startRendering();
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = true;
					keyReverse = false;
					break;

				case Keyboard.DOWN:
					keyReverse = true;
					keyForward = false;
					break;

				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;

				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.SPACE:
					keyUp = true;
					break;
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = false;
					break;

				case Keyboard.DOWN:
					keyReverse = false;
					break;

				case Keyboard.LEFT:
					keyLeft = false;
					break;

				case Keyboard.RIGHT:
					keyRight = false;
					break;
				case Keyboard.SPACE:
					keyUp=false;
			}
		}
		
		override protected function onRenderTick(event:Event=null):void
		{
			if(keyLeft)
			{
				ballBody[0].addWorldForce(new Vector3D(-100,0,0),ballBody[0].currentState.position);
			}
			if(keyRight)
			{
				ballBody[0].addWorldForce(new Vector3D(100,0,0),ballBody[0].currentState.position);
			}
			if(keyForward)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,100),ballBody[0].currentState.position);
			}
			if(keyReverse)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,-100),ballBody[0].currentState.position);
			}
			if(keyUp)
			{
				ballBody[0].addWorldForce(new Vector3D(0, 100, 0), ballBody[0].currentState.position);
			}
			
			physics.engine.integrate(0.2);
			renderer.renderScene(scene, camera, viewport);
		}
	}
}
