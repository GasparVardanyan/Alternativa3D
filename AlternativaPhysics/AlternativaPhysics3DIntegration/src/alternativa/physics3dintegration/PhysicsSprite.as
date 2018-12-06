package alternativa.physics3dintegration {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.physicsengine.configurations.PhysicsConfiguration;
	import alternativa.physicsengine.physics.PhysicsScene;

	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;

	/**
     * EN:
     * Physical simulation. Class for <code>SimulationObject</code> display.
     *
     * RU:
	 * Симуляция физики. Класс для отображения <code>SimulationObject</code>.
	 */
	public class PhysicsSprite extends Sprite {
		/**
         * EN:
         * Number of miliseconds in one simulation step.
         *
         * RU:
		 * Количество милисекунд в одном шаге симуляции.
		 */
		public var physicsStep:int = 33;

		/**
         * EN:
         * Container of all graphics objects.
         *
         * RU:
		 * Контейнер всех объектов графики.
		 */
		public var rootContainer:Object3D;
		/**
         * EN:
         * View.
         *
         * RU:
		 * Представление.
		 */
		public var view:View;
		/**
         * EN:
         * Camera.
         *
         * RU:
		 * Камера
		 */
		public var camera:Camera3D;
		/**
         * EN:
         * Camera controller.
         *
         * RU:
		 * Контроллер камеры.
		 */
		public var cameraController:SimpleObjectController;
		/**
         * EN:
         * Physical scene.
         *
		 * RU:
         * Физическая сцена.
		 */
		public var physicsScene:PhysicsScene;
		/**
         * EN:
         * List of simulation objects.
         *
         * RU:
		 * Список объектов симуляции.
		 */
		public var objects:Vector.<Appearance>;

		/**
         * EN:
         * Sets scale mode.
         *
         * RU:
		 * Задает режим маштабирования.
		 */
		public function set stageScaleMode(value:String):void {
			stage.scaleMode = value;
		}

		/**
         * EN:
         * Sets stage align mode.
         *
         * RU:
		 * Задает режим выравнивания рабочей области.
		 */
		public function set stageAlign(value:String):void {
			stage.align = value;
		}

		/**
         * EN:
         * Display area.
         *
         * RU:
		 * Область отображения.
		 */
		public var stage3d:Stage3D;
		/**
         * EN:
         * Context.
         *
         * RU:
		 * Контекст.
		 */
		public var context:Context3D;

		/**
         * EN:
         * Pause of physical simulation flag.
         *
         * RU:
		 * Указывает, находится ли физическая симуляция на паузе.
		 */
		protected var _pause:Boolean = false;

		/**
         * EN:
         * Creates class of physics simulation.
         *
         * RU:
		 * Создает класс симуляции физики.
		 */
		public function PhysicsSprite() {
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3dCreate);
			stage3d.requestContext3D(Context3DRenderMode.AUTO);
			stageScaleMode = StageScaleMode.NO_SCALE;
			stageAlign = StageAlign.TOP_LEFT;
			initEnvironment();
			load();
		}

		/**
		 * EN:
		 * Loads required resources.
		 *
		 * RU:
		 * Загружает необходимые ресурсы.
		 */
		protected function load():void {
			onLoadComplete();
		}

		/**
		 * EN:
		 * Handles load completion.
		 *
		 * RU:
		 * Обрабатывает завершение загрузки.
		 */
		protected function onLoadComplete():void {
			createScene();
			setScene();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
         * EN:
         * Initializes camera.
         *
         * RU:
		 * Инициализирует камеры.
		 */
		protected function initCamera():void {
			cameraController = new SimpleObjectController(stage, camera = new Camera3D(1, 10000), 10);
			cameraController.setObjectPosXYZ(-10, 5, 10);
			cameraController.lookAtXYZ(0, 0, 0);
		}

		/**
         * EN:
         * Initializes environment.
         * Initializes A3D and scene.
         *
         * RU:
		 * Инициализирует окружения.<br>
		 * Инициализирует A3D и сцену.
		 */
		protected function initEnvironment():void {
			objects = new Vector.<Appearance>();
			initA3D();
		}

		/**
         * EN:
         * Creates a physical scene.
         *
         * RU:
		 * Создает физическую сцену.
		 */
		protected function createScene():void {
			physicsScene = PhysicsConfiguration.DEFAULT.getPhysicsScene();
		}

		/**
         * EN:
         * Arranges objects in the scene.
         *
         * RU:
		 * Устанавливает объекты на сцену.
		 */
		protected function setScene():void {
			addChild(camera.diagram);
		}

		/**
         * EN:
         * Handles the context create event.
         * @param e event data
         *
         * RU:
		 * Обрабатывает событие создания контекста.
		 * @param e данные события
		 */
		protected function onContext3dCreate(e:Event):void {
			context = stage3d.context3D;
			context.enableErrorChecking = true;
			var r:Resource;
			for (var i:int = rootContainer.numChildren - 1; i >= 0; --i) {
				for each (r in rootContainer.getChildAt(i).getResources()) {
					r.upload(context);
				}
			}
		}

		/**
         * EN:
         * Handles the add object event.
         * @param e event data
         *
         * RU:
		 * Обрабатывает событие добавления объекта.
		 * @param e данные события
		 */
		protected function addedObject3d(e:Event):void {
			if (context != null) {
				var obj:Object3D = e.target as Object3D;
				for each (var r:Resource in obj.getResources()) {
					r.upload(context);
				}
			}
		}

		/**
         * EN:
         * Handles the object remove event.
         * @param e Event data
         *
         * RU:
		 * Обрабатывает событие удаления объекта.
		 * @param e данные события
		 */
		protected function removedObject3d(e:Event):void {
			var obj:Object3D = e.target as Object3D;
			for each (var r:Resource in obj.getResources()) {
				r.dispose();
			}
		}

		/**
         * Initializes A3D. Also creates and initializes the view.
		 * Инициализирует A3D. Также создает и инициализирует представление.
		 */
		protected function initA3D():void {
			rootContainer = new Object3D();
			rootContainer.addEventListener(Event3D.ADDED, addedObject3d);
			rootContainer.addEventListener(Event3D.REMOVED, removedObject3d);

			//View
			view = new View(stage.stageWidth, stage.stageHeight);
			view.antiAlias = 4;
			view.backgroundColor = 0x224466;

			initCamera();
			camera.view = view;
			camera.view.logoHorizontalMargin = 20;
			camera.view.logoVerticalMargin = 10;

			addChild(view);
			rootContainer.addChild(camera);
			stage.addEventListener(Event.RESIZE, onResize);
		}

		/**
         * EN:
         * Handles the stage resize event.
         * @param e event data
         *
         * RU:
		 * Обрабатывает событие изменения размера.
		 * @param event данные события
		 */
		protected function onResize(event:Event):void {
			view.height = stage.stageHeight;
			view.width = stage.stageWidth;
		}

		/**
         * EN:
         * Handles the enter frame event.
         * @param e event data
         *
         * RU:
		 * Обрабатывает событие начала фрейма.
		 * @param event данные события
		 */
		protected function onEnterFrame(event:Event):void {
			var t:Number;
			if (!_pause) {
				var now:int = getTimer();
				while (physicsScene.time < now) {
					physicsScene.update(physicsStep);
				}
				t = 1 + (now - physicsScene.time)/physicsStep;
			} else {
				t = 1;
			}
			update3D(t);
			cameraController.update();
			camera.startTimer();
			camera.render(stage3d);
			camera.stopTimer();
		}

		protected function update3D(t:Number):void {
			for each (var simObject:Appearance in objects) {
				simObject.interpolate(t);
			}
		}

		/**
         * EN:
         * Adds simulation object.
         * @param object simulation object
         *
         * RU:
		 * Добавляет объект симулации.
		 * @param object объект симуляции
		 */
		public function addSimObject(object:SimulationObject):void {
			physicsScene.add(object.sceneObject);
			addAppearance(object);
		}

		/**
         * EN:
         * Removes simulation object.
         * @param object simulation object
         *
         * RU:
		 * Удаляет объект симулации.
		 * @param object объект симуляции
		 */
		public function removeSimObject(object:SimulationObject):void {
			physicsScene.remove(object.sceneObject);
			removeAppearance(object);
		}

		/**
         * EN:
         * Adds 3D object.
         * @param object 3D object
         *
         * RU:
		 * Добавляет трехмерный объект.
		 * @param object трехмерный объект
		 */
		public function addObject3D(object:Object3D):void {
			rootContainer.addChild(object);
		}

		/**
		 * EN:
		 * Adds graphical object.
		 * @param appearance object's appearance
		 *
		 * RU:
		 * Добавляет графический объект.
		 * @param appearance внешний вид объекта
		 */
		public function addAppearance(appearance:Appearance):void {
			objects.push(appearance);
			for each (var component:AppearanceComponent in appearance.appearanceComponents) {
				rootContainer.addChild(component.appearanceObject);
			}
		}

		/**
		 * EN:
		 * Removes graphical object.
		 * @param appearance внешний вид объекта
		 *
		 * RU:
		 * Удаляет графический объект.
		 * @param appearance внешний вид объекта
		 */
		public function removeAppearance(appearance:Appearance):void {
			var index:int = objects.indexOf(appearance);
			if (index == -1) return;
			objects.splice(index, 1);
			for each (var component:AppearanceComponent in appearance.appearanceComponents) {
				rootContainer.removeChild(component.appearanceObject);
			}
		}

		/**
         * EN:
         * Removes 3D object.
         * @param object 3D object
         *
         * RU:
		 * Удаляет трехмерный объект.
		 * @param object трехмерный объект
		 */
		public function removeObject3D(object:Object3D):void {
			rootContainer.removeChild(object);
		}

		/**
         * EN:
         * Performs one physical simulation step.
         *
         * RU:
		 * Выполяет один шаг физической симуляции.
		 */
		public function nextPhysicsStep():void {
			physicsScene.time = getTimer() - physicsStep;
			physicsScene.update(physicsStep);
		}

		/**
         * EN:
         * Sets pause of physical simulation flag.
         * @param value true - simulation is paused, false simulation is performed
         *
         * RU:
		 * Устанавливает флаг паузы физической симуляции.
		 * @param value true - если физическая симуляция на паузе, иначе false
		 */
		public function set pause(value:Boolean):void {
		    if (value) {
				_pause = true;
			} else {
				physicsScene.time = getTimer();
				_pause = false;
			}
		}

		/**
         * EN:
         * Returns true if simulation is paused, otherwise returns false.
         *
         * RU:
		 * Возвращает true - если симуляци на паузе, иначе false.
		 */
		public function get pause():Boolean {
			return _pause;
		}

	}
}
