package {
	/*********** ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ ALTERNATIVA3D *********/
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
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	/*********** ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ BULLET *********/
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DSphereShape;
	import alternativaphysics.collision.shapes.A3DConeShape;
	import alternativaphysics.collision.shapes.A3DCylinderShape;
	import alternativaphysics.collision.shapes.A3DStaticPlaneShape;
	import alternativaphysics.debug.A3DDebugDraw;
	import alternativaphysics.dynamics.A3DRigidBody;
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	
	/*********** ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ FLASH *********/
	import flash.display.Shape;
	import flash.display.Stage3D;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class BasicStressTest extends Sprite {
		private var container:Object3D = new Object3D();
		private var groundContainer:Object3D = new Object3D();
		
		private var stage3D:Stage3D;	
		private var simpleController:SimpleObjectController;
		private var camera:Camera3D;
		private var ambientLight:AmbientLight;
		private var directionalLight:DirectionalLight;
		
		private var _physicsWorld : A3DDynamicsWorld; // мир
		private var _sphereShape : A3DSphereShape; //шейп - сфера. Будет играть роль пули. Ею мы будем стрелять по другим телам
		private var _preTimer:Number = 0; //сюда будем записывать время предыдущего вызова метода Step()
		private var _timeStep : Number = 0; //время шага
		
		private var debugDraw:A3DDebugDraw; //для debug отрисовки тел

		public function BasicStressTest() {
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

			// инициализируем мир, и определяемся с алгоритмом для BroadPhase
			_physicsWorld = A3DDynamicsWorld.getInstance();
			_physicsWorld.initWithDbvtBroadphase();

			var bitmapData:BitmapData = new BitmapData(2048, 2048, false, 0x0);
			var texture:BitmapData = Bitmap(new GFX.Floor()).bitmapData;
			
			var i:int;
			var j:int;
			
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					bitmapData.copyPixels(texture, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			var textureResource:BitmapTextureResource = new BitmapTextureResource(bitmapData);
			
			var material :VertexLightTextureMaterial = new VertexLightTextureMaterial (textureResource);
			var ground : Plane = new Plane(9000, 9000, 1, 1, true, false, material, material); // скин для пола
			groundContainer.addChild(ground);

			var groundShape : A3DStaticPlaneShape = new A3DStaticPlaneShape(new Vector3D(0, 0, 1)); //создаем шейп - поверхность
			var groundRigidbody : A3DRigidBody = new A3DRigidBody(groundShape, ground, 0); //создаем твердое тело с этим шейпом. Это будет у нас пол
			_physicsWorld.addRigidBody(groundRigidbody); //добавляем в мир

			bitmapData = new BitmapData(2048, 2048, false, 0x0);
			texture = Bitmap(new GFX.BrickFront()).bitmapData;
			for (i = 0; i < 4; i++) {
				for (j = 0; j < 4; j++) {
					bitmapData.copyPixels(texture, new Rectangle(0, 0, 512, 512), new Point(j * 512, i * 512));
				}
			}
			textureResource = new BitmapTextureResource(bitmapData);
			
			material = new VertexLightTextureMaterial (textureResource);
			var wall : Box = new Box(9000, 100, 3500, 1, 1, 1, false, material); //скин для задней стенки
			groundContainer.addChild(wall);

			var wallShape : A3DBoxShape = new A3DBoxShape(9000, 100, 3500); // создаем шейп - куб
			var wallRigidbody : A3DRigidBody = new A3DRigidBody(wallShape, wall, 0); //создаем статическое твердое тело с этим шейпом. Это задняя стенка
			_physicsWorld.addRigidBody(wallRigidbody); //добавляем в мир	
			
			wallRigidbody.position = new Vector3D(0, 1000, 1500); //позиционируем тело на сцене. Вместе с телом обновляется и скин назначенный для этого тела
			
			groundContainer.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp); //вешаем слушатель на клик по контейнеру, который содержит 3D-объекты пола и задней стенки

			//Далее в цикле мы будем создавать много одинаковых тел. Смысла каждый раз создавать новый шейп нет. Поэтому их создание вынесено сюда, перед циклом
			_sphereShape = new A3DSphereShape(100); //создаем шейп для пули
			var boxShape : A3DBoxShape = new A3DBoxShape(300, 300, 300); //создаем шейп для кубов
			var cylinderShape : A3DCylinderShape = new A3DCylinderShape(150, 300); //создаем шейп для цилиндров
			var coneShape : A3DConeShape = new A3DConeShape(150, 300); //создаем шейп для конусов

			// создаем тела
			var mesh : Mesh;
			var body : A3DRigidBody;
			var numx : int = 10; //количество тел по оси X
			var numy : int = 1; //количество тел по оси Y
			var numz : int = 8; //количество тел по оси Z
			for (i = 0; i < numx; i++ ) { //в трех циклах создаются и позиционируются динамические твердые тела 
				for (j = 0; j < numy; j++ ) {
					for (var k : int = 0; k < numz; k++ ) {
						
						textureResource = new BitmapTextureResource(Bitmap(new GFX.Box()).bitmapData);
						material = new VertexLightTextureMaterial (textureResource);
			
						// создаем кубики
						mesh = new Box (300, 300, 300, 1, 1, 1, false, material); //скин для тела имеющего форму куба
						container.addChild(mesh);
						body = new A3DRigidBody(boxShape, mesh, 1); //создаем динамическое твердое тело. Форму тела определяем как куб
						body.friction = .9; //трение тела
						body.ccdSweptSphereRadius = 1; //предотвращаем тунелирование тел
						body.ccdMotionThreshold = 1;
						body.position = new Vector3D(-1500 + i * 350, j * 200, 150 + k * 300); //позиционируем тело на сцене
						_physicsWorld.addRigidBody(body); //добавляем в мир
						
		
						textureResource = new BitmapTextureResource(Bitmap(new GFX.Box()).bitmapData);
						material = new VertexLightTextureMaterial (textureResource);
						
						// создаем цилиндры
						var parser:ParserA3D = new ParserA3D();
						parser.parse(new GFX.Cylinder());
						var localMesh:Mesh = parser.objects[0] as Mesh;
						localMesh.scaleX = localMesh.scaleY = 7;
						localMesh.scaleZ = 5;
						localMesh.rotationX = -90 * Math.PI / 180;
						localMesh.y = -150;
						localMesh.x = 0;
						localMesh.setMaterialToAllSurfaces(material);
						
						mesh = new Mesh(); //скин для тела имеющего форму цилиндра
						mesh.addChild(localMesh);
						container.addChild(mesh);
						
						body = new A3DRigidBody(cylinderShape, mesh, 1); //создаем твердое тело. Форму тела определяем как цилиндр
						body.friction = .9; //трение тела
						body.ccdSweptSphereRadius = 1; //предотвращаем тунелирование тел
						body.ccdMotionThreshold = 1;
						body.position = new Vector3D(-1500 + i * 350, -1500 + j * 200, 150 + k * 300); //позиционируем тело на сцене
						body.rotationX = 90; //поворачиваем как надо
						_physicsWorld.addRigidBody(body); //добавляем в мир
						
						textureResource = new BitmapTextureResource(Bitmap(new GFX.Box()).bitmapData);
						material = new VertexLightTextureMaterial (textureResource);
						
						//создаем конусы
						parser.parse(new GFX.Cone());
						localMesh = parser.objects[0] as Mesh;
						localMesh.scaleX = localMesh.scaleY = localMesh.scaleZ = 8;
						localMesh.rotationX = -90 * Math.PI / 180;
						localMesh.y = -150;
						localMesh.x = 0;
						localMesh.setMaterialToAllSurfaces(material);
						
						mesh = new Mesh(); //скин для тела имеющего форму конуса
						mesh.addChild(localMesh);
						container.addChild(mesh);
						
						body = new A3DRigidBody(coneShape, mesh, 1); //создаем твердое тело. Форму тела определяем как конус
						body.friction = .9; //трение тела
						body.ccdSweptSphereRadius = 1; //предотвращаем тунелирование тел
						body.ccdMotionThreshold = 1;
						body.position = new Vector3D(-1500 + i * 400, -1000 + j * 230, 150 + k * 300); //позиционируем тело на сцене
						body.rotationX = 90; //поворачиваем как надо
						_physicsWorld.addRigidBody(body); //добавляем в мир
					}
				}
			}
			
			//simpleController = new SimpleObjectController(stage, camera, 340);

			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}

		private function onMouseUp(event : MouseEvent3D) : void {
			var pos : Vector3D = new Vector3D(camera.x, camera.y, camera.z); //получаем координаты камеры
			var mpos : Vector3D = event.target.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ)); //получаем координаты клика мыши

			var impulse : Vector3D = mpos.subtract(pos); //из координаты клика вычитаем координаты камеры, получаем вектор - длиной от координат камеры до координат клика
			impulse.normalize(); //убираем из вектора его длину, оставляя только направление
			impulse.scaleBy(1000); //увеличиваем длину вектора во много раз, чем больше значение, тем выше скорость выстрела пули

			var bitmap:BitmapTextureResource = new BitmapTextureResource(new GFX.Bullet().bitmapData);
			bitmap.upload(stage3D.context3D);
			var material:VertexLightTextureMaterial = new VertexLightTextureMaterial(bitmap);		
			
			var sphere : GeoSphere = new GeoSphere(100, 10, false, material); //скин для пули
			container.addChild(sphere);
			sphere.geometry.upload(stage3D.context3D);

			var body : A3DRigidBody = new A3DRigidBody(_sphereShape, sphere, 2); //создаем твердое тело. Форму тела определяем как сфера
			body.position = pos; //начальная позиция пули находится в координатах камеры
			body.ccdSweptSphereRadius = 0.5; //предотвращаем тунелирование тел
			body.ccdMotionThreshold = 1;
			_physicsWorld.addRigidBody(body); //добавляем в мир
			
			body.applyCentralImpulse(impulse); //применяем к телу импульс
		}

		private function onContextCreate(e:Event):void {
			for each (var resource:Resource in container.getResources(true)){
				resource.upload(stage3D.context3D);
			}
			debugDraw = new A3DDebugDraw(stage3D, container, _physicsWorld); //инициализируем debug отрисовку тел
		    debugDraw.debugMode |= A3DDebugDraw.DBG_DrawTransform;
			//debugDraw.debugDrawWorld();
			
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		private function onEnterFrame(e : Event) : void {
			_timeStep = 1/ (getTimer() - _preTimer); //расчитываем время шага
			_physicsWorld.step(_timeStep, 1); //обновляем мир
			
			//debugDraw.debugDrawWorld(); //раскомментите если захотите отрисовывать debug тела
			//simpleController.update();
			camera.render(stage3D);
			
			_preTimer = getTimer();
		}
	}
}