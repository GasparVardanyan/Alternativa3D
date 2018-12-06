package
{
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	import jiglib.geometry.JSphere;
	import jiglib.math.JNumber3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.papervision3d.Papervision3DPhysics;
	import jiglib.plugin.papervision3d.Pv3dMesh;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.cameras.SpringCamera3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.BitmapMaterial;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	/**
	 * Simple Papervision3D + JigLibFlash example 
	 * @author Reynaldo a.k.a. reyco1
	 * 
	 */	
	[SWF(width="900", height="700", backgroundColor="#000000", frameRate="60")]
	public class RollingEarth extends BasicView
	{
		[Embed(source="assets/earthTexture512x256.jpg")]
		public var EarthTexture:Class;
		
		private var physics:Papervision3DPhysics;
		private var sphereObject:Sphere;
		private var physicsObject:RigidBody;		
		private var keyRight:Boolean = false;
		private var keyLeft:Boolean = false;
		private var keyForward:Boolean = false;
		private var keyReverse:Boolean = false;
		private var keyUp:Boolean = false;		
		private var moveForce:Number = 10;		
		private var springCamera:SpringCamera3D;
		private var cameraTarget:DisplayObject3D;
		private var sceneLight:PointLight3D;
		
		public function RollingEarth()
		{
			
			// Initialize the Papervision3D BasicView
			super(stage.stageWidth, stage.stageHeight, true, false, CameraType.TARGET);
			
			// Initialize the Papervision3D physics plugin
			physics = new Papervision3DPhysics(scene, 1);
						
			addKeyboardListeners();
			setupLighting();
			createFloor();
			setCamera();
			createSphere();	
			createBoxes();		
			startRendering();
		}
		
		private function addKeyboardListeners():void
		{
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler );
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler );
		}
		
		private function setupLighting():void
		{
			sceneLight = new PointLight3D(true, true);
			sceneLight.x = 0;
			sceneLight.y = 400;
			sceneLight.z = -300;
		}
		
		private function setCamera():void
		{
			springCamera = new SpringCamera3D();
			springCamera.mass = 10;
			springCamera.damping = 10;
			springCamera.stiffness = 1;
				
			springCamera.lookOffset = new Number3D(0, 20, 30);
			springCamera.positionOffset = new Number3D(0, 100, -1500);
			
			springCamera.focus = 100;
			springCamera.zoom = 10;
		}
		
		private function createSphere():void
		{
			var earthMaterial:BitmapMaterial = new BitmapMaterial(Bitmap(new EarthTexture()).bitmapData, true);
			earthMaterial.tiled = true;
			earthMaterial.smooth = true;
			
			sphereObject = new Sphere(earthMaterial, 100, 13, 11);
			scene.addChild(sphereObject);
			
			physicsObject = new JSphere(new Pv3dMesh(sphereObject), 100);
			physicsObject.y = 200;
			physicsObject.restitution = 3;
			physicsObject.mass = 1
			physics.addBody(physicsObject);
			
			cameraTarget = new DisplayObject3D();
			cameraTarget.copyPosition(sphereObject);
			scene.addChild(cameraTarget);
			
			springCamera.target = cameraTarget;
		}
		
		private function createBoxes():void
		{
			var randomBox:RigidBody;
			var material:MaterialsList = new MaterialsList();
			material.addMaterial(new FlatShadeMaterial(sceneLight, 0x77ee77), "all");
			//material.addMaterial(new ColorMaterial(0x77ee77), "all");
			
			for(var a:Number = 0; a<10; a++)
			{
				randomBox = physics.createCube(material, 100, 100, 100);
				randomBox.z = 1000;
				randomBox.y = a*100 + 55;
				randomBox.mass = .2;
			}
		}
		
		private function createFloor():void
		{
			physics.createGround(new WireframeMaterial(0xFFFFFF, 0), 1800, 0);
			
			var floor:Plane = new Plane(new WireframeMaterial(0xFFFFFF), 10000, 10000, 10000*0.001, 10000*0.001);
            floor.rotationX = 90;
            floor.y = -150
            scene.addChild(floor);
            
           /*  var floorViewportLayer:ViewportLayer = new ViewportLayer(viewport, floor);
			floorViewportLayer.addDisplayObject3D(floor, true);
			floorViewportLayer.layerIndex = 1;
            
            viewport.containerSprite.addLayer(floorViewportLayer); */
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
		
		override protected function onRenderTick(event:Event = null):void
		{
			if(keyLeft)
			{
				physicsObject.addWorldForce(new JNumber3D(-moveForce, 0, 0), physicsObject.currentState.position);
			}
			if(keyRight)
			{
				physicsObject.addWorldForce(new JNumber3D(moveForce, 0, 0), physicsObject.currentState.position);
			}
			if(keyForward)
			{
				physicsObject.addWorldForce(new JNumber3D(0, 0, moveForce), physicsObject.currentState.position);
			}
			if(keyReverse)
			{
				physicsObject.addWorldForce(new JNumber3D(0, 0, -moveForce), physicsObject.currentState.position);
			}
			if(keyUp)
			{
				physicsObject.addWorldForce(new JNumber3D(0, moveForce, 0), physicsObject.currentState.position);
			}
			
			cameraTarget.copyPosition(sphereObject);
			
			physics.step();
			renderer.renderScene(scene, springCamera, viewport);
		}
		
	}
}