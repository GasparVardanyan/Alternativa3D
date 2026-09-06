package {
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.types.Point3D;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	import alternativa.utils.UnitsConverter;
	
	import engine.model.ClosingObjects;
	import engine.model.Piston;
	import engine.model.Propeller;
	import engine.model.Rod;
	import engine.model.Shaft;
	import engine.model.StaticObjects;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.geom.Point;
	
	[SWF(backgroundColor="#000000", frameRate="100")]
	public class Engine extends Sprite {
		// Область вывода камеры
		private var view:View;
		// 3D-сцена
		private var scene:Scene3D;
		// Камера
		private var camera:Camera3D;
		// Контейнер для камера
		private var cameraContainer:Object3D;
		// Контроллер контейнера
		private var controller:WalkController;
		// Поршень			
		private var piston:Piston;
		// Пропеллер
		private var propeller:Propeller;
		// Шатун
		private var rod:Rod;
		// Моховик
		private var shaft:Shaft;
		// Закрывающая часть детали
		private var closingObjects:ClosingObjects;
		// Индикатор закрытого состояния детали		
		private var closedState:Boolean = false;
		// Индикатор процесса "закрывания" детали
		private var close:Boolean = false;
		// Индикатор процесса "открывания" детали
		private var open:Boolean = false;
		// Вспомогательные переменные для расчетов
		private var coords:Point = new Point();
		private var vector:Point = new Point();
		private var angle:Number = MathUtils.DEG5*1.5;
		private var sin5:Number = Math.sin(angle);
		private var cos5:Number = Math.cos(angle);
		// Радиус моховика
		private var r:Number;
		// Длина шатуна
		private var d:Number;
		// Координаты нижнего конца шатуна
		private var rodDownPoint:Point;

		[Embed(source="images/bg.jpg")] private static var bgClass:Class;
		private static const backGround:Bitmap = new bgClass();
		[Embed(source="images/alternativa.png")] private static var logoClass:Class;
		private static const logo:Bitmap = new logoClass();
		[Embed(source="images/helppanel_engine.png")] private static var helpPanelClass:Class;
		private static const helpPanel:Bitmap = new helpPanelClass();
		
		private static const BACKGROUND_WIDTH:Number = backGround.width;
		private static const BACKGROUND_HEIGHT:Number = backGround.height;

		/**
		 * Конструктор приложения.
		 */
		public function Engine() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			// Фон
			addChild(backGround);
			// Логотип
			stage.addChild(logo);
			logo.x = 3;
			logo.y = 3;
			// Подсказка
			stage.addChild(helpPanel);
			// Инициализация сцены		
			initScene();
			// Статичная геометрия	
			var staticObjects:StaticObjects = new StaticObjects();
			// Закрывающая часть детали
			closingObjects = new ClosingObjects();	
			// Поршень
			piston = new Piston();
			// Пропеллер
			propeller = new Propeller();
			// Шатун
			rod = new Rod();
			// Моховик
			shaft = new Shaft();
			// Вся деталь
			var object:Object3D = new Object3D();			
			object.addChild(piston);
			object.addChild(propeller);
			object.addChild(rod);
			object.addChild(shaft);
			object.addChild(staticObjects);
			object.addChild(closingObjects);
			object.rotationZ = - MathUtils.DEG90;
			object.z += 2700;
			object.x += 1500;
			scene.root.addChild(object);
		
			// Нижний конец шатуна
			rodDownPoint = new Point(rod.x, UnitsConverter.convert(-142.63, UnitsConverter.INCHES, UnitsConverter.MILLIMETERS));

			var deltaX:Number = shaft.x - rodDownPoint.x;
			var deltaZ:Number = shaft.z - rodDownPoint.y;
			// Радиус моховика
			r = Math.sqrt(deltaX*deltaX + deltaZ*deltaZ);
			// Длина шатуна
			d = rod.z - rodDownPoint.y;
			
			// Установка необходимых обработчиков
			for (var c:* in closingObjects.children) {
				var child:Mesh = c as Mesh;
				child.addEventListener(MouseEvent3D.CLICK, onClick);
			}
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);	
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			
			onResize();
		}

		/**
		 * Обработка нажатия клавиш.
		 */
		private function onKey(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case KeyboardUtils.NUMPAD_ADD:
				case KeyboardUtils.EQUAL:
					camera.y = camera.y < -3600 ? camera.y + 200 : -3600;
					break;
				case KeyboardUtils.NUMPAD_SUBTRACT:
				case KeyboardUtils.MINUS:
					camera.y = camera.y > -10000 ? camera.y - 200 : -10000;
					break;	
			}
		}

		/**
		 * Создание сцены и настройка контроллера.
		 */
		private function initScene():void {
			scene = new Scene3D();
			scene.root = new Object3D();
			// Контейнер для камеры
			cameraContainer = new Object3D("cameraContainer");
			scene.root.addChild(cameraContainer);

			// Камера
			camera = new Camera3D();
			camera.rotationX = -MathUtils.DEG90;
			cameraContainer.addChild(camera);
			camera.y = -10000;

			// Контроллер
			controller = new WalkController(stage);
			controller.object = cameraContainer;
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_YAW_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_YAW_RIGHT);
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_PITCH_UP);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_PITCH_DOWN);
			
			controller.speed = 500;
			controller.lookAt(new Point3D());
			cameraContainer.rotationZ = 5.57;
			// Область вывода
			view = new View(camera);
			view.interactive = true;
			addChild(view);
		}
		
		/**
		 * Ежекадровая обработка.
		 */
		private function onEnterFrame(e:Event):void {
			// Вертим моховик
			shaft.rotationY += angle;
			// Вычисляем координаты нижнего конца шатуна
			vector.x = (rodDownPoint.x - shaft.x);
			vector.y = (rodDownPoint.y - shaft.z);
			coords.x = vector.x*cos5 - vector.y*sin5;
			coords.y = vector.x*sin5 + vector.y*cos5;
		
			rodDownPoint.x = coords.x + shaft.x;
			rodDownPoint.y = coords.y + shaft.z;
			// Поворачиваем шатун  						
			var sin:Number = Math.sin(MathUtils.DEG180 - shaft.rotationY);
			var rsin:Number = r*sin;
			rod.rotationY = Math.asin(rsin/d);
			// Поднимаем/опускаем шатун и поршень
			var deltaZ:Number = rod.z;
			rod.z = rodDownPoint.y + Math.sqrt(d*d - rsin*rsin);
			deltaZ -= rod.z;
			piston.z -= deltaZ;
			// Крутим пропеллер
			propeller.rotationY += angle;
		
			// Проверка на "закрывание" детали
			if (close) {
				if (closingObjects.y == 0) {
					close = false;
				} else {
					closingObjects.y -= 187.5;
				}
				
			}
			// Проверка на "открывание" детали 
			if (open) {
				if (closingObjects.y == 1875) {
					open = false;
				} else {
					closingObjects.y += 187.5;
				}
				
			}
			
			controller.processInput();
			scene.calculate();
			
		}

		/**
		 * Корректировка размеров и положения объектов при изменении окна плеера.
		 */
		private function onResize(e:Event = null):void {
			if (stage.stageWidth > BACKGROUND_WIDTH) {
				view.width = BACKGROUND_WIDTH;
			} else {
				view.width = stage.stageWidth;
			}
			
			if (stage.stageHeight > BACKGROUND_HEIGHT) {
				view.height = BACKGROUND_HEIGHT;
			} else {
				view.height = stage.stageHeight;	
				
			}
			
			view.x = stage.stageWidth/2 - view.width/2;
			view.y = stage.stageHeight/2 - view.height/2;
			backGround.scaleX = view.width/BACKGROUND_WIDTH;
			backGround.scaleY = view.height/BACKGROUND_HEIGHT;
			backGround.x = view.x;
			backGround.y = view.y;
			
			helpPanel.y = stage.stageHeight - helpPanel.height;
			
			scene.calculate();
		}
		
		/**
		 * Обработка клика на закрывающую часть детали.
		 */ 
		private function onClick(e:MouseEvent3D):void {
			// Проверка состояния детали
			if (closedState) {
				close = true;
				open = false;
			} else {
				close = false;
				open = true;
			}
			
			closedState = !closedState;
		}

	}
}
