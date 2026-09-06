package {

	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.StandardMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import alternativaphysics.collision.shapes.A3DSphereShape;
	import alternativaphysics.debug.A3DDebugDraw;
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	import alternativaphysics.dynamics.A3DRigidBody;
	import alternativaphysics.extend.A3DTerrain;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.events.Event;

	public class StressTest extends Sprite {
		private var container:Object3D = new Object3D();
		private var ground:Object3D = new Object3D();

		private var camera:Camera3D;
		private var stage3D:Stage3D;	
		private var simpleController:SimpleObjectController;
		
		private var mesh:Mesh;
		private var material:Material;
		
		private var ALTWorld:A3DDynamicsWorld;
		private var ALTRigidBody:A3DRigidBody;
		
		private var debugDraw:A3DDebugDraw;
		private var ALTShapeBox:A3DCollisionShape;
		private var sphereShape : A3DSphereShape;
		private var sphere : GeoSphere;
		private var skybox:SkyBox;
		
		private var _timeStep : Number = 0;
		private var preTimer:Number = 0;

		public function StressTest() {
			if (stage) preInit();
			else addEventListener(Event.ADDED_TO_STAGE, preInit);
		}
		
		private function  preInit(e:Event = null):void {	
			init();
			createWall();
			createPhysics();
		}
		
		private function  init():void {	
			camera = new Camera3D(1, 10000);
			camera.view = new View(800, 600);
			camera.rotationX = -100 * Math.PI / 180;
			camera.z = 10
			camera.y = -2300;
			camera.view.antiAlias = 8;
			addChild(camera.diagram);
			camera.diagram.x = 710;
			camera.diagram.y = 10;
			addChild(camera.view);
			
			var shapeDiagram:Shape = new Shape(); //подложка под диаграмму
			shapeDiagram.graphics.lineStyle(2, 0xFFFFFF,0.9);
			shapeDiagram.graphics.beginFill(0x1b1b1b,0.8);
			shapeDiagram.graphics.drawRoundRect(0, 0, 100, 105, 15, 15);
			addChildAt(shapeDiagram, 0);
			shapeDiagram.x = camera.diagram.x - 10;
			

			container.addChild(camera);
			container.addChild(ground);
			
			var skyTexture1:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyL().bitmapData);
			var skyTexture2:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyR().bitmapData);
			var skyTexture3:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyB().bitmapData);
			var skyTexture4:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyF().bitmapData);
			var skyTexture5:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyD().bitmapData);
			var skyTexture6:BitmapTextureResource = new BitmapTextureResource(new GFX.TextureSkyU().bitmapData);

			skybox = new SkyBox(8000, new TextureMaterial(skyTexture1), 
									  new TextureMaterial(skyTexture2), 
									  new TextureMaterial(skyTexture3), 
									  new TextureMaterial(skyTexture4), 
									  new TextureMaterial(skyTexture5), 
									  new TextureMaterial(skyTexture6), 0.001); //создаем скайбокс
			container.addChild(skybox);
			
			ALTWorld = A3DDynamicsWorld.getInstance();
			ALTWorld.initWithDbvtBroadphase();
			
			var ambient:AmbientLight = new AmbientLight(0xFFFFFF);
			ambient.intensity = 0.7;
			container.addChild(ambient);
			
			var direct:DirectionalLight = new DirectionalLight(0xFFFFFF);
			direct.z = 1600;
			direct.y = -300;
			direct.lookAt(0, 300, 0);
			container.addChild(direct);
		}
		
		private function createWall():void {
			var bitmapData:BitmapData = new BitmapData(2048, 2048, false, 0x0);
			var bitmap:BitmapData = Bitmap(new GFX.Brick()).bitmapData;
			var i:int;
			var j:int;
			
			for (i = 0; i < 4; i++) {
				for (j= 0; j < 4; j++) {
					bitmapData.copyPixels(bitmap, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			
			material = new VertexLightTextureMaterial(new BitmapTextureResource(bitmapData));
			mesh = new Box(20, 5000, 1800, 1, 1, 1, false, material);
			mesh.x = -1500;
			ground.addChild(mesh);
			
			ALTShapeBox = new A3DBoxShape(20, 5000, 1800);
			ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 0);
			ALTWorld.addRigidBody(ALTRigidBody);
			ALTRigidBody.position = new Vector3D(mesh.x, mesh.y , mesh.z);
			
			mesh = new Box(2, 5000, 1800, 1, 1, 1, false, material);
			mesh.x = 1500;
			ground.addChild(mesh);
			
			ALTShapeBox = new A3DBoxShape(20, 5000, 1800);
			ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 0);
			ALTWorld.addRigidBody(ALTRigidBody);
			ALTRigidBody.position = new Vector3D(mesh.x, mesh.y , mesh.z);
			
			bitmapData = new BitmapData(2048, 2048, false, 0x0);
			bitmap = Bitmap(new GFX.BrickFront).bitmapData;
			for (i = 0; i < 4; i++) {
				for (j= 0; j < 4; j++) {
					bitmapData.copyPixels(bitmap, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			
			material = new VertexLightTextureMaterial(new BitmapTextureResource(bitmapData));
			mesh = new Box(3000, 20, 1800, 1, 1, 1, false, material);
			mesh.y = 2500;
			ground.addChild(mesh);
			
			ALTShapeBox = new A3DBoxShape(3000, 20, 1800);
			ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 0);
			ALTWorld.addRigidBody(ALTRigidBody);
			ALTRigidBody.position = new Vector3D(mesh.x, mesh.y , mesh.z);
			
			material = new VertexLightTextureMaterial(new BitmapTextureResource(bitmapData));
			mesh = new Box(3000, 20, 1800, 1, 1, 1, false, material);
			mesh.y = -2500;
			ground.addChild(mesh);
			
			ALTShapeBox = new A3DBoxShape(30000, 20, 18000);
			ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 0);
			ALTWorld.addRigidBody(ALTRigidBody);
			ALTRigidBody.position = new Vector3D(mesh.x, mesh.y , mesh.z);
			
			bitmapData = new BitmapData(2048, 2048, false, 0x0);
			bitmap = Bitmap(new GFX.Floor()).bitmapData;
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					bitmapData.copyPixels(bitmap, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			
			material = new VertexLightTextureMaterial(new BitmapTextureResource(bitmapData));
			mesh = new Plane(3000, 5000, 1, 1, false, false, material, material);
			mesh.z = -900;
			ground.addChild(mesh);
			
			ALTShapeBox = new A3DBoxShape(3000, 5000, 20);
			ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 0);
			ALTWorld.addRigidBody(ALTRigidBody);
			ALTRigidBody.position = new Vector3D(mesh.x, mesh.y , mesh.z);
			
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			
			material = new VertexLightTextureMaterial(new BitmapTextureResource(Bitmap(new GFX.Brick()).bitmapData));
			
			//var terrain : A3DTerrain = new A3DTerrain(material, Bitmap(new GFX.Heightmap()).bitmapData, 5000, 120, 5000, 60, 60, 6200, 0, false);
			//container.addChild(terrain);
			//trace(terrain);
			
			sphereShape = new A3DSphereShape(40);
		}
		
		private function createPhysics():void {
			var bitmap:BitmapTextureResource = new BitmapTextureResource(new GFX.Box().bitmapData);
			material = new VertexLightTextureMaterial(bitmap);
			
			for (var i:int = 0; i < 10; i++) {
				for (var j:int = 0; j < 2; j++) {
					for (var k:int = 0; k < 10; k++) {
						mesh = new Box(150, 150, 150, 1, 1, 1, false, material);
						container.addChild(mesh);
					
						ALTShapeBox = new A3DBoxShape(150, 150, 150);
						ALTRigidBody = new A3DRigidBody(ALTShapeBox, mesh, 1);
						ALTWorld.addRigidBody(ALTRigidBody);
						ALTRigidBody.position = new Vector3D(-700 + i * 190, 300 + j * 200, -815 + k * 150);
				}	
			}
		}
			
			simpleController = new SimpleObjectController(stage, camera, 340);

			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}
		
		private function onMouseUp(event : MouseEvent3D) : void {
			var pos : Vector3D = new Vector3D(camera.x, camera.y, camera.z);
			var mpos : Vector3D = event.target.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ));

			var impulse : Vector3D = mpos.subtract(pos);
			impulse.normalize();
			impulse.scaleBy(800);
			
			//if (sphere) {
			//	for each (var resource:Resource in sphere.getResources(true)) {resource.dispose();}
			//	container.removeChild(sphere);
				
			//	ALTWorld.removeRigidBody(ALTRigidBody);
			//}
			
			var bitmap:BitmapTextureResource = new BitmapTextureResource(new GFX.Bullet().bitmapData);
			bitmap.upload(stage3D.context3D);
			material = new VertexLightTextureMaterial(bitmap);
			
			sphere = new GeoSphere(40, 5, false, material);
			container.addChild(sphere);
			sphere.geometry.upload(stage3D.context3D);

			ALTRigidBody = new A3DRigidBody(sphereShape, sphere, 1);
			ALTRigidBody.position = pos;
			ALTRigidBody.ccdSweptSphereRadius = 0.2;
			ALTRigidBody.ccdMotionThreshold = 1;
			ALTWorld.addRigidBody(ALTRigidBody);
			
			ALTRigidBody.applyCentralImpulse(impulse);
		}

		private function onContextCreate(e:Event):void {
			for each (var resource:Resource in container.getResources(true)){
				resource.upload(stage3D.context3D);
			}
			debugDraw = new A3DDebugDraw(stage3D, container, ALTWorld);
		    debugDraw.debugMode = 1;
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		

		private function onEnterFrame(e:Event):void {
			_timeStep = 1 / (getTimer() - preTimer);
			
			//debugDraw.debugDrawWorld();
			ALTWorld.step(_timeStep, 1);
			camera.render(stage3D);
			simpleController.update();
			
			skybox.x = camera.x;
			skybox.y = camera.y;
			skybox.z = camera.z;
			
			preTimer = getTimer();
		}
	}
}