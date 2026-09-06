package {
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.types.Texture;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.text.Font;
	import flash.ui.Keyboard;
	import flash.utils.getTimer;
	
	import strategy.DoubleMapSquarePoint;
	import strategy.InverseView;
	import strategy.MapSquarePoint;
	import strategy.MapSquarePointFix;
	import strategy.SoldierHero;
	import strategy.model.GroundObject;
	import strategy.model.InverseObjects;
	import strategy.model.Objects;
	import strategy.progress.ProgressWindow;
	
	[SWF(backgroundColor="#000000")]
	public class Strategy extends Sprite {
		// 3D-сцена
		private var scene:Scene3D;
		// Отраженная сцена
		private var inverseScene:Scene3D;
		// Камера
		private var camera:Camera3D;
		// Контейнер для камеры
		private var cameraContainer:Object3D;
		// Контроллер
		private var controller:WalkController;
		// Камера для отраженной сцены
		private var inverseCamera:Camera3D;
		// Контейнер для отраженной камеры
		private var inverseContainer:Object3D;
		// Область вывода камеры
		private var view:View;
		// Область вывода камеры для отраженной сцены с наложенным фильтром для имитации воды
		private var inverseView:InverseView;
		// Список всех героев
		private var heroes:Array;
		// Объекты на сцене
		private var objects:Objects;
		// Земля
		private var ground:GroundObject;
		// Время, прошедшее с предыдущего кадра, в котором герои делали шаг
		private var time:Number;
		// Ширина квадрата, ограничивающего область вывода камеры отраженной сцены
		private const rectWidht:Number = 500;
		// Прямоугольник, ограничивающий отраженную область вывода
		private var rect:Rectangle = new Rectangle(0, 0, rectWidht, rectWidht);
		private const halfWidht:Number = rectWidht/2;
		// Последовательность загрузки ресурсов
		private var loadingSequence:Array;
		private var progressWindow:ProgressWindow;
		private var loadingCounter:int = -1;
		// Спрайт, на котором рисуется прямоугольник выделения
		private var sprite:Sprite = new Sprite();
		// Карта координат
		public static var mapCoords:Array;
		// Полная карта для вычислений
		public static var mapSquare:Array;
		// Множество выделенных героев
		public static var selectedHeroes:Set = new Set();
		// Индикатор нажатия шифта
		public static var shiftDown:Boolean = false;
		// Ширина карты в клеточках
		public static const COUNT_SQUARE:int = 38;
		// Ширина земли
		public static const LAND_WIDTH:int = 10160;
		// Ширина клеточки
		public static var cellWidht:Number = LAND_WIDTH/COUNT_SQUARE;
		// Количество героев
		private var heroCount:int; 
	
		[Embed(source="helppanel_strategy.png")] private static var helpPanelClass:Class;
		private static const helpPanel:Bitmap = new helpPanelClass();
		[Embed (source="alternativa.png")] private static var logoBmp:Class;
		private var logo:Bitmap = new logoBmp();
		[Embed(source="AlternativaNormal.ttf", fontName="Alternativa", mimeType='application/x-font')]
        private static const ttfNormal:Class;
		[Embed(source="textures/woods/pine.png")] private static var pineBitmap:Class;
		private static const pineTexture:Texture = new Texture(new pineBitmap().bitmapData);
		[Embed(source="textures/woods/pine_in.png")] private static var pineInverseBitmap:Class;
		private static const pineInverseTexture:Texture = new Texture(new pineInverseBitmap().bitmapData);
		[Embed(source="textures/woods/tree1.png")] private static var tree1Bitmap:Class;
		private static const tree1Texture:Texture = new Texture(new tree1Bitmap().bitmapData);
		[Embed(source="textures/woods/tree2.png")] private static var tree2Bitmap:Class;
		private static const tree2Texture:Texture = new Texture(new tree2Bitmap().bitmapData);
	
		/**
		 * Конструктор приложения. 
		 */			
		public function Strategy() {
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
		
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 100;
			Font.registerFont(ttfNormal);
			// Логотип
			logo.x = 3;
			logo.y = 3;
			stage.addChild(logo);
			// Подсказка
			stage.addChild(helpPanel);
			// Инициализация сцены		
			initScene();
			// Геометрия на сцене
			objects = new Objects();
			scene.root.addChild(objects);
			// Отраженная геометрия
			var inverseObjects:InverseObjects = new InverseObjects(); 
			inverseScene.root.addChild(inverseObjects);
			// Земля
			ground = new GroundObject();
			scene.root.addChild(ground);
			ground.getChildByName("ground").addEventListener(MouseEvent3D.CLICK, squareClick);
			// Инициализация карты
			initSquareMap();
			// Герои
			initHeroes();
			// Установка необходимых обработчиков
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.CLICK, onClick);
			// Загрузка текстур	
			loadingSequence = [objects, ground];	
			progressWindow = new ProgressWindow("Загрузка текстур", 200);
			progressWindow.y = 10;
			stage.addChild(progressWindow);
			loadNextResource();

			time = getTimer();
			onResize();
		}
		
		
		/**
		 * Создание сцен и настройка контроллера.
		 */		
		private function initScene():void {
			// Сцена
			scene = new Scene3D();
			scene.root = new Object3D();
			// Контейнер для камеры
			cameraContainer = new Object3D("cameraContainer");
			cameraContainer.rotationZ = MathUtils.DEG45;
			scene.root.addChild(cameraContainer);
			// Камера
			camera = new Camera3D();
			camera.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
			cameraContainer.addChild(camera);
			camera.y = -1000;
			camera.orthographic = true;
			camera.zoom = 0.15;
			// Контроллер
			controller = new WalkController(stage);
			controller.object = cameraContainer;
			
			controller.bindKey(KeyboardUtils.A, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.D, ObjectController.ACTION_RIGHT);
			controller.bindKey(KeyboardUtils.W, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.S, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_RIGHT);
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.CONTROL, ObjectController.ACTION_YAW_LEFT);
			controller.bindKey(KeyboardUtils.SPACE, ObjectController.ACTION_YAW_RIGHT);
			
			controller.mouseEnabled = false;			
			controller.speed = 2000;
			controller.coords = new Point3D(0, 0, 50);
			// Область вывода
			view = new View(camera);
			view.interactive = true;
			view.addChild(sprite);
			sprite.graphics.lineStyle(2, 0x000000); 
		
			// Отраженная сцена			
			inverseScene = new Scene3D();
			inverseScene.root = new Object3D();
			inverseContainer = new Object3D("inverseContainer");
			inverseContainer.rotationZ = cameraContainer.rotationZ;
			inverseCamera = camera.clone() as Camera3D;
			inverseContainer.addChild(inverseCamera);
			inverseScene.root.addChild(inverseContainer);
			inverseView = new InverseView(inverseCamera);
			addChild(inverseView);
			// 
			addChild(view);
		}
	
		/**
		 * Инициализация героев.
		 */ 
		private function  initHeroes():void {
			
			heroes = new Array();
			var hero:SoldierHero = new SoldierHero(new Point(19, 19), new Point(0, -1));
			ground.addChild(hero);
			hero.deltaSilenceTime = 5000;
			heroes.push(hero);
			
			hero = new SoldierHero(new Point(21, 21), new Point(0, -1));
			ground.addChild(hero);
			hero.deltaSilenceTime = 7717;
			heroes.push(hero);
			
			hero = new SoldierHero(new Point(23, 23), new Point(0, -1));
			ground.addChild(hero);
			hero.deltaSilenceTime = 9998;
			heroes.push(hero);
			
			
			heroCount = heroes.length;
		}	 
		
		/**
		 * Добавление дерева на карту.
		 * @param i номер строки на сетке карты
		 * @param j номер столбца на сетке карты
		 * @param texture текстура дерева
		 * @param originY относительное смещение начала ствола в текстуре по оси Y.
		 */ 
		private function addWood(i:int, j:int, texture:Texture, originY:Number):void {
		
			mapSquare[i][j].fix.impassable = true;
			var wood:Sprite3D = new Sprite3D();
			wood.scaleX = wood.scaleY = wood.scaleZ = 7;
			var woodMaterial:SpriteTextureMaterial = new SpriteTextureMaterial(texture);
			woodMaterial.originY = originY;
			wood.material = woodMaterial;
			var coords:Point = mapCoords[i][j];
			wood.x = coords.x;
			wood.y = coords.y;
			wood.z = 0.1;
			wood.mouseEnabled = false;
			ground.addChild(wood);
		}
	
		/**
		 * Инициализация препятствий на карте.
		 */ 
		private function initObstacles():void {
			
			var i:int;
			var j:int;
			var mapSquarePoint:MapSquarePointFix;
			for (i = 6; i < 10; i++) 
			for (j = 6; j < 15; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
				
			}
			for (i = 10; i < 13; i++) 
			for (j = 6; j < 10; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
		
			for (i = 15; i < 19; i++) 
			for (j = 13; j < 18; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
		
			for (i = 21; i < 26; i++) 
			for (j = 30; j < 35; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
		
			for (i = 25; i < 29; i++) 
			for (j = 22; j < 25; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			
			for (i = 29; i < 33; i++) 
			for (j = 21; j < 26; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			for (i = 30; i < 33; i++) 
			for (j = 26; j < 28; j++){
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			for (i = 23; i < 30; i++) { 
				mapSquarePoint = mapSquare[i][17].fix;
				mapSquarePoint.impassable = true;
			}
			
			for (i = 22; i < 31; i++) 
			for (j = 10; j < 17; j++) {
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			mapSquare[23][9].fix.impassable = true;	
			mapSquare[31][15].fix.impassable = true;	
			mapSquare[33][10].fix.impassable = true;	
			mapSquare[33][11].fix.impassable = true;	
			mapSquare[33][12].fix.impassable = true;	
			
			for (i = 24; i < 33; i++) 
			for (j = 8; j < 10; j++) {
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			for (i = 26; i < 32; i++) {
				mapSquarePoint = mapSquare[i][7].fix;
				mapSquarePoint.impassable = true;
			}
			
			for (i = 31; i < 33; i++) 
			for (j = 10; j < 15; j++) {
				mapSquarePoint = mapSquare[i][j].fix;
				mapSquarePoint.impassable = true;
			}
			
			
			addWood(36, 3, pineTexture, 0.87589);
			addWood(25, 6, pineTexture, 0.87589);		
			addWood(17, 7, pineTexture, 0.87589);
			addWood(18, 22, pineTexture, 0.87589);		
			addWood(4, 12, pineTexture, 0.87589);
			addWood(4, 36, pineTexture, 0.87589);		
			addWood(8, 24, pineTexture, 0.87589);		
			addWood(8, 32, pineTexture, 0.87589);	
			addWood(23, 24, pineTexture, 0.87589);	
			
			addWood(5, 32, tree2Texture, 0.86063);
			addWood(12, 24, tree2Texture, 0.86063); 	
			addWood(21, 4, tree2Texture, 0.86063); 		
			addWood(13, 31, tree2Texture, 0.86063); 	
			addWood(34, 19, tree2Texture, 0.86063); 		
			addWood(6, 28, tree2Texture, 0.86063); 
			addWood(35, 34, tree2Texture, 0.86063); 
			addWood(26, 27, tree2Texture, 0.86063); 
			addWood(18, 11, tree2Texture, 0.86063); 
			
			addWood(16, 25, tree1Texture, 0.83333); 
			addWood(15, 28, tree1Texture, 0.83333); 
			addWood(17, 34, tree1Texture, 0.83333); 
			addWood(7, 20, tree1Texture, 0.83333); 
			addWood(4, 24, tree1Texture, 0.83333); 
			addWood(2, 19, tree1Texture, 0.83333); 
			addWood(9, 34, tree1Texture, 0.83333); 
			addWood(19, 9, tree1Texture, 0.83333); 
			addWood(27, 2, tree1Texture, 0.83333); 
			addWood(36, 26, tree1Texture, 0.83333); 
			addWood(10, 2, tree1Texture, 0.83333); 
			addWood(34, 6, tree1Texture, 0.83333); 
			addWood(27, 31, tree1Texture, 0.83333); 
			addWood(27, 33, tree1Texture, 0.83333); 
			
			// Перевернутое дерево в отраженной сцене		
			var coords:Point = mapCoords[25][6];
			var inversePine:Sprite3D = new Sprite3D();
			var inverseMaterial:SpriteTextureMaterial = new SpriteTextureMaterial(pineInverseTexture);
			inverseMaterial.originY = 0.2;
			inversePine.material = inverseMaterial;
			inverseScene.root.addChild(inversePine);
			inversePine.x = coords.x;
			inversePine.y = coords.y;
			inversePine.z = -0.1;
			inversePine.scaleX = inversePine.scaleY = inversePine.scaleZ = 7;
						
		}

		/**
		 * Инициализация карты. 
		 */		
		private function initSquareMap():void {

			//Карта для расчетов в виде двумерного массива
			mapSquare = new Array();
			//Карта координат
			mapCoords = new Array();
			for (var i:int = 0; i < COUNT_SQUARE; i++) {
				mapSquare[i] = new Array();
				mapCoords[i] = new Array();
			}
			
			// Заполняем карты		
			var start:Number = cellWidht/2 - LAND_WIDTH/2;
			
			for (i = 0; i < COUNT_SQUARE; i++)
			for (var j:int = 0; j < COUNT_SQUARE; j++) {
			
				var coords:Point = new Point(start + i*cellWidht, start + j*cellWidht);
				mapCoords[i][j] = coords;
				
				mapSquare[i][j] = new DoubleMapSquarePoint(new MapSquarePointFix(), new MapSquarePoint());
	
			}
			
			//Инициализации препятствий
			initObstacles();
			
		}
		
		// Координаты предыдущей клетки, на которую был клик
		private var prevPoint:Point = new Point(-1, -1);
	
		/**
		 *  Обработка клика на землю.
		 */
		private function squareClick(e:MouseEvent3D):void {
			
			if (!selectedClick) {
				// Координаты клетки, на которую был клик 
				var point:Point = new Point(Math.floor((e.localX + LAND_WIDTH/2)/cellWidht), Math.floor((e.localY + LAND_WIDTH/2)/cellWidht));
			
				if (!point.equals(prevPoint)) {
					prevPoint = point;
					// Отсортированный массив расстояний от героя до "кликнутой" клетки
					var sortDistances:Array = new Array();
					// Map расстояние -> герой
					var distanceHero:Map = new Map();
					// Проверка на выход за границы сетки
					if (point.x >= 0 && point.x < COUNT_SQUARE && point.y >= 0 && point.y < COUNT_SQUARE) {
						
						var selHero:SoldierHero;
						// Сортируем героев по расстоянию до пункта назначения
						for (var h:* in selectedHeroes) {
							selHero = h;
							var distance:Number = Point.distance(selHero.currentPosition, point);
							while (distanceHero.hasKey(distance)) {
								distance +=0.01;
							}
							sortDistances.push(distance);
							distanceHero.add(distance, selHero);
							selHero.clearTime();
						}
						sortDistances.sort(Array.NUMERIC);
						// Отправляем героев в путь по мере их близости к точке назначения
						var len:int = sortDistances.length;
						for (var i:int = 0; i < len; i++) {
							selHero = distanceHero[sortDistances[i]];
							selHero.moveTo(point);
							
						}	
					}
					
				}
			}
			
		}
		
		/**
		 * Обработка нажатия клавиш. 
		 */		
		private function onKeyDown(event:KeyboardEvent):void {
			
			switch (event.keyCode) {
				case KeyboardUtils.EQUAL: 
				case KeyboardUtils.NUMPAD_ADD: 
					camera.zoom = camera.zoom < 0.18 ? camera.zoom + 0.01 : 0.18;
					break;
				case KeyboardUtils.MINUS:	
				case KeyboardUtils.NUMPAD_SUBTRACT:
					camera.zoom = camera.zoom > 0.11 ? camera.zoom - 0.01 : 0.11;
					break; 
				case Keyboard.SHIFT:
					shiftDown = true;
					break;	
			}
		}
		
		private function onKeyUp(event:KeyboardEvent):void {
			
			switch (event.keyCode) {
				case Keyboard.SHIFT:
					shiftDown = false;
					break;		
			}
		}
		
		// Координаты центра озера
		private var coordsLake:Point3D = new Point3D(2300, -1700, 0);
	
		/**
		 * Ежекадровая обработка. 
		 */		
		private function onEnterFrame(e:Event):void {
			
			var frameTime:Number = getTimer();
			
			if (frameTime - time >= 50) {
				for (var i:int = 0; i < heroCount; i++) {
					var hero:SoldierHero = heroes[i] as SoldierHero;
						hero.nextStep();
				}
				time = frameTime;
			}
			
			heroes[0].speak();
			heroes[1].speak();
			heroes[2].speak();
			
			controller.processInput();
			
			// Синхронизируем камеры нормальной и отраженной сцен
			inverseContainer.coords = cameraContainer.coords;
			inverseContainer.rotationX = cameraContainer.rotationX;
			inverseContainer.rotationY = cameraContainer.rotationY;
			inverseContainer.rotationZ = cameraContainer.rotationZ;
			inverseCamera.zoom = camera.zoom;
			
			// Подкладываем view обратной сцены под озеро
			var point:Point3D = view.projectPoint(coordsLake);
			rect.x = point.x - halfWidht;
			rect.y = point.y - halfWidht;
			inverseView.scrollRect = rect;
			inverseView.x = rect.x;
			inverseView.y = rect.y; 
			inverseView.changeChildCoords();
			
			inverseScene.calculate();
			scene.calculate();
			
		}
	
		/**
		 * Корректировка размеров и положения объектов при изменении окна плеера.
		 */
		private function onResize(e:Event = null):void {
			
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			inverseView.width = view.width;
			inverseView.height = view.height;
			progressWindow.x = (stage.stageWidth - progressWindow.width) >> 1;
			helpPanel.y = stage.stageHeight - helpPanel.height;
			
		}
		
		
		/**
		 * Загрузка следующего ресурса.
		 */
		private function loadNextResource():void {

			loadingCounter++;
			if (loadingCounter < loadingSequence.length) {
				progressWindow.progress = (loadingCounter + 1)/loadingSequence.length; 
				loadingSequence[loadingCounter].load(loadNextResource);
				
			} else {
				progressWindow.hide();
			}
		}
		
		
		private var mouseDown:Boolean = false;
		// Начальные координаты выделения
		private var startCoords:Point = new Point();
		// Индикатор выделения
		private var selectedClick:Boolean = false;
		
		/**
		 * Обработка выделения мышью.
		 */		
		private function onMouseMove(e:MouseEvent):void {
			
			if (mouseDown) {
				
				var dx:Number = startCoords.x - e.localX;
				dx = dx > 0 ? dx : -dx;
				var dy:Number = startCoords.y - e.localY;
				dy = dy > 0 ? dy : -dy;
				if (dx > 5 && dy > 5) {
					// Отрисовка прямоугольника выделения
					var point:Point = new Point(Math.min(e.localX, startCoords.x), Math.min(e.localY, startCoords.y));
					var gfx:Graphics = sprite.graphics; 
					gfx.clear();
					gfx.lineStyle(0, 0x000000);
					gfx.moveTo(point.x, point.y);
					
					gfx.lineTo(point.x + dx, point.y);
					gfx.lineTo(point.x + dx, point.y + dy);
					gfx.lineTo(point.x, point.y + dy);
					gfx.lineTo(point.x, point.y);
					
					// Снимаем выделение со всех героев
					for (var h:* in selectedHeroes) {
						(h as SoldierHero).deselect();
					}
					// Выделяем героев, попавших под прямоугольник
					var len:int = heroes.length;
					for (var i:int = 0; i < len; i++) {
						var view_coords:Point3D = view.projectPoint(heroes[i].coords);
						if (view_coords.x >= point.x && view_coords.x <= point.x + dx 
							&& view_coords.y >= point.y && view_coords.y <= point.y + dy) {
								heroes[i].select();							
							} 
					}
					
					selectedClick = true;
				}
			}
		}
		
		private function onClick(e:MouseEvent):void {
			
			sprite.graphics.clear();
			mouseDown = false;
			selectedClick = false;
		}
		
		private function onMouseDown(e:MouseEvent):void {
			mouseDown = true;
			startCoords.x = e.localX;
			startCoords.y = e.localY;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			mouseDown = false;
			sprite.graphics.clear();
			selectedClick = false;
		}
		

	}
}
