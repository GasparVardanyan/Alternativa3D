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
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	/*********** ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ BULLET *********/
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DConeShape;
	import alternativaphysics.collision.shapes.A3DCylinderShape;
	import alternativaphysics.collision.shapes.A3DStaticPlaneShape;
	import alternativaphysics.debug.A3DDebugDraw;
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	import alternativaphysics.dynamics.A3DRigidBody;
	
	/*********** ИМПОРТ НЕОБХОДИМЫХ КЛАССОВ FLASH *********/
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display.Stage3D;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.geom.Vector3D;
	import flash.utils.getTimer;

	[SWF(backgroundColor="#000000", frameRate="60", width="1024", height="768")]
	public class GravityTest extends Sprite {
		private var container:Object3D = new Object3D();
		
		private var stage3D:Stage3D;	
		private var simpleController:SimpleObjectController;
		private var camera:Camera3D;
		private var ambientLight:AmbientLight;
		private var directionalLight:DirectionalLight;
		
		private var _physicsWorld : A3DDynamicsWorld; // мир
		private var _preTimer:Number = 0; //сюда будем записывать время предыдущего вызова метода Step()
		private var _timeStep : Number = 0; //время шага
		
		private var debugDraw:A3DDebugDraw; //для debug отрисовки тел
		
		private var isMouseDown : Boolean;
		private var currMousePos : Vector3D; //сюда будем записывать координаты мыши

		public function GravityTest() {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e : Event = null) : void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			camera = new Camera3D(1, 10000);
			camera.view = new View (stage.stageWidth, stage.stageHeight);
			camera.rotationX = -1.56;
			camera.rotationY = 0;
			camera.rotationZ = -0.00000000000006;
			camera.x = 35;
			camera.y = -5065;
			camera.z = -650;
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
			_physicsWorld.gravity = new Vector3D(0, 20, 0); //устанавливаем гравитацию в мире
			

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
			container.addChild(ground);

			var groundShape : A3DStaticPlaneShape = new A3DStaticPlaneShape(new Vector3D(0, 0, -1)); //создаем шейп - поверхность
			var groundRigidbody : A3DRigidBody = new A3DRigidBody(groundShape, ground, 0); //создаем твердое тело с этим шейпом. Это будет у нас пол
			_physicsWorld.addRigidBody(groundRigidbody); //добавляем в мир
			
			groundRigidbody.rotation = new Vector3D( -90, 0, 0);
			
			ground.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown); //слушатель нажатия кнопки мыши над ground
			ground.addEventListener(MouseEvent3D.MOUSE_UP, onMouseUp); //слушатель отпускания кнопки мыши над ground
			ground.addEventListener(MouseEvent3D.MOUSE_MOVE, onMouseMove); //слушатель перемещения мыши над ground

		
			// создаем необходимые шейпы
			var boxShape : A3DBoxShape = new A3DBoxShape(300, 300, 300);
			var cylinderShape : A3DCylinderShape = new A3DCylinderShape(150, 300);
			var coneShape : A3DConeShape = new A3DConeShape(150, 300);

			// создаем твердые тела
			var mesh : Mesh;
			var body : A3DRigidBody;
			for (i = 0; i < 20; i++ ) {
				
				textureResource = new BitmapTextureResource(Bitmap(new GFX.Box()).bitmapData);
				material = new VertexLightTextureMaterial (textureResource);
			
				// создаем кубики
				mesh = new Box (300, 300, 300, 1, 1, 1, false, material); //скин для тела имеющего форму куба
				container.addChild(mesh);
				body = new A3DRigidBody(boxShape, mesh, 1); //создаем динамическое твердое тело. Форму тела определяем как куб
				body.friction = .9; //трение тела
				body.linearDamping = .5; //линейное затухание скорости тела
				body.position = new Vector3D(-2500 + 5000 * Math.random(), -1000 - 3000 * Math.random(), -1200 + 1800 * Math.random()); //позиционируем тело на сцене
				_physicsWorld.addRigidBody(body); //добавляем в мир
				
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
				body.linearDamping = .5; //линейное затухание скорости тела
				body.position = new Vector3D(-2500 + 5000 * Math.random(), -1000 - 3000 * Math.random(), -1200 + 1800 * Math.random()); //позиционируем тело на сцене
				_physicsWorld.addRigidBody(body); //добавляем в мир
				
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
				body.linearDamping = .5;//линейное затухание скорости тела
				body.position = new Vector3D( -2500 + 5000 * Math.random(), -1000 - 3000 * Math.random(), -1200 + 1800 * Math.random()); //позиционируем тело на сцене
				_physicsWorld.addRigidBody(body); //добавляем в мир
			}
			
			//simpleController = new SimpleObjectController(stage, camera, 340);

			stage3D = stage.stage3Ds[0];
			stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate);
			stage3D.requestContext3D();
		}

		private function onMouseDown(event : MouseEvent3D) : void { //функция выполняется при нажатии кнопки мыши над ground
			isMouseDown = true; //сигнализируем что кнопка мыши нажата
			currMousePos = event.target.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ)); //записываем координаты клика мыши
			this.addEventListener(Event.ENTER_FRAME, handleGravity); //вешаем слушатель на ENTER_FRAME
		}

		private function onMouseUp(event : MouseEvent3D) : void { //функция выполняется при отпускании кнопки мыши над ground
			isMouseDown = false; //сигнализируем что кнопка мыши была отпущена

			var pos : Vector3D = new Vector3D();
			for each (var body:A3DRigidBody in _physicsWorld.nonStaticRigidBodies) { //проходимся по всем нестатическим телам в мире
				pos = pos.add(body.position); //
			}
			pos.scaleBy(1 / _physicsWorld.nonStaticRigidBodies.length);

			var impulse : Vector3D;
			for each (body in _physicsWorld.nonStaticRigidBodies) { //проходимся по всем нестатическим телам в мире
				impulse = body.position.subtract(pos); //из координат мыши вычитаем координаты тела. Получаем вектор длиной от курсора мыши до тела
				impulse.scaleBy(25000 / impulse.lengthSquared);
				body.applyCentralImpulse(impulse); //применяем импульс к телу
			}

			_physicsWorld.gravity = new Vector3D(0, 20, 0);
			this.removeEventListener(Event.ENTER_FRAME, handleGravity); //удаляем слушатель ENTER_FRAME
		}

		private function onMouseMove(event : MouseEvent3D) : void { //функция выполняется при перемещении мыши над ground
			if (isMouseDown) { //если кнопка мыши нажата
				currMousePos = event.target.localToGlobal(new Vector3D(event.localX, event.localY, event.localZ)); //обновляем текущие координаты мыши
			}
		}

		private function handleGravity(e : Event) : void { //функция притягивает все тела к курсору мыши
			var gravity : Vector3D;
			for each (var body:A3DRigidBody in _physicsWorld.nonStaticRigidBodies) { //проходимся по всем нестатическим телам в мире
				gravity = currMousePos.subtract(body.position); //из координат мыши вычитаем координаты тела. Получаем вектор длиной от курсора мыши до тела
				gravity.normalize(); //убираем длину вектора, оставляя лишь направление
				gravity.scaleBy(300); //увеличиваем длину вектора. Чем больше длина тем быстрее тела будут притягиваться к курсору мыши

				body.gravity = gravity; //переопределяем вектор гравитации для тела
			}
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
			//trace (camera.rotationX + "   " + camera.rotationY + "   " + camera.rotationZ);
			//trace (camera.x + "   " + camera.y + "   " + camera.z);
			
			_timeStep = 1/ (getTimer() - _preTimer); //расчитываем время шага
			_physicsWorld.step(_timeStep, 1); //обновляем мир
			
			//debugDraw.debugDrawWorld(); //раскомментите если захотите отрисовывать debug тела
			//simpleController.update();
			camera.render(stage3D);
			
			_preTimer = getTimer();
		}
	}
}