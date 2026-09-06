package {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DConvexHullShape;
	import alternativaphysics.collision.shapes.A3DSphereShape;
	import alternativaphysics.collision.shapes.A3DStaticPlaneShape;
	import alternativaphysics.debug.A3DDebugDraw;
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	import alternativaphysics.dynamics.A3DRigidBody;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.net.URLRequest;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class ConvexHullShapeTest extends Sprite {
		private var container:Object3D = new Object3D();
		private var groundContainer:Object3D = new Object3D();
		
		private var stage3D:Stage3D;	
		private var simpleController:SimpleObjectController;
		private var camera:Camera3D;
		private var ambientLight:AmbientLight;
		private var directionalLight:DirectionalLight;
		
		private var textureResource:BitmapTextureResource;
		private var material :Material;
		
		private var _physicsWorld : A3DDynamicsWorld;
		private var _sphereShape : A3DSphereShape;
		private var _preTimer:Number = 0;
		private var _timeStep : Number = 0;
		
		private var debugDraw:A3DDebugDraw;

		public function ConvexHullShapeTest() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			camera = new Camera3D(1, 10000);
			camera.view = new View (stage.stageWidth, stage.stageHeight);
			camera.rotationX = -1.91;
			camera.rotationY = 0;
			camera.rotationZ = 0;
			camera.x = 131;
			camera.y = -4169;
			camera.z = 1970;
			camera.view.antiAlias = 8;
			addChild(camera.diagram);
			camera.diagram.x = stage.stageWidth - camera.diagram.width - 10;
			camera.diagram.y = 20;
			addChild(camera.view);
			
			var shapeDiagram:Shape = new Shape(); //подложка под диаграмму
			shapeDiagram.graphics.lineStyle(2, 0xFFFFFF,0.9);
			shapeDiagram.graphics.beginFill(0x1b1b1b,0.8);
			shapeDiagram.graphics.drawRoundRect(0, 0, 100, 105, 15, 15);
			addChildAt(shapeDiagram, 0);
			shapeDiagram.x = camera.diagram.x - 10;
			shapeDiagram.y = 10; 
			
			container.addChild(camera);
			container.addChild(groundContainer);

			ambientLight = new AmbientLight(0x878787);
			ambientLight.intensity = 0.8;
			container.addChild(ambientLight);
			
			directionalLight = new DirectionalLight(0xFFFFFF);
			directionalLight.intensity = 0.9;
			directionalLight.z = 2000;
			directionalLight.y = -2000;
			directionalLight.lookAt(0, 0, -200);
			container.addChild(directionalLight);

			// init the physics world
			_physicsWorld = A3DDynamicsWorld.getInstance();
			_physicsWorld.initWithDbvtBroadphase();

			// create ground mesh
			
			var bitmapData:BitmapData = new BitmapData(2048, 2048, false, 0x0);
			var texture:BitmapData = Bitmap(new GFX.Floor()).bitmapData;
			
			var i:int;
			var j:int;
			
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					bitmapData.copyPixels(texture, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			textureResource = new BitmapTextureResource(bitmapData);
			
			material = new VertexLightTextureMaterial (textureResource);
			var ground : Plane = new Plane(9000, 9000, 1, 1, true, false, material, material);
			groundContainer.addChild(ground);

			// create ground shape and rigidbody
			var groundShape : A3DStaticPlaneShape = new A3DStaticPlaneShape(new Vector3D(0, 0, 1));
			var groundRigidbody : A3DRigidBody = new A3DRigidBody(groundShape, ground, 0);
			_physicsWorld.addRigidBody(groundRigidbody);

			// create a wall
			bitmapData = new BitmapData(2048, 2048, false, 0x0);
			texture = Bitmap(new GFX.BrickFront()).bitmapData;
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					bitmapData.copyPixels(texture, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			textureResource = new BitmapTextureResource(bitmapData);
			
			material = new VertexLightTextureMaterial (textureResource);
			var wall : Box = new Box(9000, 100, 3500, 1, 1, 1, false, material);
			groundContainer.addChild(wall);

			var wallShape : A3DBoxShape = new A3DBoxShape(9000, 100, 3500);
			var wallRigidbody : A3DRigidBody = new A3DRigidBody(wallShape, wall, 0);
			_physicsWorld.addRigidBody(wallRigidbody);			
			
			wallRigidbody.position = new Vector3D(0, 1000, 1500);
			
			groundContainer.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp);
			
			_sphereShape = new A3DSphereShape(100);
			
			createConvexPolygon();
		}
		
		private function createConvexPolygon() : void{
			var parserA3D:ParserA3D = new ParserA3D();
			parserA3D.parse(new GFX.Convex());
			
			textureResource = new BitmapTextureResource(Bitmap(new GFX.Brick()).bitmapData);
			material = new TextureMaterial (textureResource);
			
			var model:Mesh = parserA3D.objects[0] as Mesh;
			model.setMaterialToAllSurfaces(material);
			
			var shape:A3DConvexHullShape = new A3DConvexHullShape(model.geometry);
			shape.localScaling = new Vector3D(300, 300, 300);
			
			var skin:Mesh;
			var body:A3DRigidBody;
			for (var i:int = 0; i < 20; i++ ) {
				skin = Mesh(model.clone());
				container.addChild(skin);
		
				body = new A3DRigidBody(shape, skin, 4);
				body.friction = 0.9;
				body.ccdSweptSphereRadius = 1;
				body.ccdMotionThreshold = 1;
				body.position = new Vector3D(0, 0, 500 + 400 * i);
				_physicsWorld.addRigidBody(body);
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
			impulse.scaleBy(1000);

			// shoot a sphere
			var bitmap:BitmapTextureResource = new BitmapTextureResource(new GFX.Bullet().bitmapData);
			bitmap.upload(stage3D.context3D);
			var material:VertexLightTextureMaterial = new VertexLightTextureMaterial(bitmap);		
			
			var sphere : GeoSphere = new GeoSphere(100, 10, false, material);
			container.addChild(sphere);
			sphere.geometry.upload(stage3D.context3D);

			var body : A3DRigidBody = new A3DRigidBody(_sphereShape, sphere, 2);
			body.position = pos;
			body.ccdSweptSphereRadius = 1;
			body.ccdMotionThreshold = 1;
			_physicsWorld.addRigidBody(body);
			
			body.applyCentralImpulse(impulse);
		}

		private function onContextCreate(e:Event):void {
			for each (var resource:Resource in container.getResources(true)){
				resource.upload(stage3D.context3D);
			}
			debugDraw = new A3DDebugDraw(stage3D, container, _physicsWorld);
		    debugDraw.debugMode |= A3DDebugDraw.DBG_DrawTransform;
			//debugDraw.debugDrawWorld();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e : Event) : void {
			_timeStep = 1/ (getTimer() - _preTimer);
			_physicsWorld.step(_timeStep, 1);
			
			//debugDraw.debugDrawWorld();
			//simpleController.update();
			camera.render(stage3D);
			
			_preTimer = getTimer();
		}
	}
}