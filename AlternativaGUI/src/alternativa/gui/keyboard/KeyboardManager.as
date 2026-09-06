package alternativa.gui.keyboard {
	import alternativa.init.GUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.KeyboardEvent;
	
	/**
	 * Менеджер клавиатуры.
	 */	
	public class KeyboardManager {
		
		// Единственный экземпляр
		//private static var instance:KeyboardManager;
		
		/**
		 * Подписчики на события клавиатуры.
		 */		
		private static var keyboardListeners:Array;
		
		/**
		 * @private 
		 */		
		private static var created:Boolean = false;
		
		/**
		 * Список кодов нажатых клавиш.
		 */		
		public static var pressedKeys:Array;
		
		public static var ctrlKey:Boolean;
		public static var altKey:Boolean;
		public static var shiftKey:Boolean;
		
		protected static var _enabled:Boolean = true;
		protected static var _container:DisplayObjectContainer;
		
		/*public function KeyboardManager(container:DisplayObjectContainer) {
			container.addChild(this);
			
			pressedKeys = new Array();
			keyboardListeners = new Array();
			
			container.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
			container.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
		}*/
		
		/**
		 * Инициализация.
		 */		
		public static function init(container:DisplayObjectContainer):void {
			/*if (instance == null) {
				// Создаём экземпляр
				instance = new KeyboardManager(container);
			}*/
			if (!created) {
				_container = container;
				pressedKeys = new Array();
				keyboardListeners = new Array();
			
				_container.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
				_container.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				
				created = true;
			}
		}
		
		/**
		 * Добавить слушателя событий клавиатуры.
		 * @param listener Слушатель.
		 */		
		public static function addKeyboardListener(listener:IKeyboardListener):void {
//			trace("addKeyboardListener");
			keyboardListeners.push(listener);
		}
		/**
		 * Удалить слушателя событий клавиатуры.
		 * @param listener Слушатель.
		 */		
		public static function removeKeyboardListener(listener:IKeyboardListener):void {
//			trace("removeKeyboardListener");
			keyboardListeners.splice(keyboardListeners.indexOf(listener), 1);
		}
		
		/**
		 * Проверка фильтров заданного объекта и его фильтров его детей.
		 * @return Список детей, для которых надо тоже проверить фильтры.
		 */			
		private static function checkFilters(testObject:DisplayObject, e:KeyboardEvent):Array {
//			trace("checkFilters");
			var children:Array = new Array();
			// Проверяем горячие клавиши самого объекта
			if (testObject is IKeyboardListener && keyboardListeners.indexOf(IKeyboardListener(testObject)) == -1) {
				var listener:IKeyboardListener = IKeyboardListener(testObject);
				var filters:Array;
				var functions:Array;
				if (e.type == KeyboardEvent.KEY_DOWN) {
					filters = listener.keyFiltersConfig.keyDownFilters;
					for (var j:int = 0; j < filters.length; j++) {
						var filter:IKeyFilter = IKeyFilter(filters[j]);
						if (filter.filter(e)) {
							functions = listener.keyFiltersConfig.getKeyDownFunctions(e.keyCode, filter);
							for (var k:int = 0; k < functions.length; k++) {
								var f:BindedFunction = BindedFunction(functions[k]);
								f.func.apply(f.object, f.args);
							}
							return null;
						}
					}
				} else {
					filters = listener.keyFiltersConfig.keyUpFilters;
					for (j = 0; j < filters.length; j++) {
						filter = IKeyFilter(filters[j]);
						if (filter.filter(e)) {
							functions = listener.keyFiltersConfig.getKeyUpFunctions(e.keyCode, filter);
							for (k = 0; k < functions.length; k++) {
								f = BindedFunction(functions[k]);
								f.func.apply(f.object, f.args);
							}
							return null;
						}
					}
				}
				// Составляем список детей объекта для проверки
				if (listener.keyFiltersConfig.childrenKeysAvailable) {
					children = listener.keyFiltersConfig.activeChildren;
				}
			} else {
				
			}
			return children;
		}
		
		/**
		 * Обработка события клавиатуры.
		 * @param e Событие клавиатуры.
		 */		
		private static function onKeyEvent(e:KeyboardEvent):void {
//			trace("onKeyEvent");
			//trace("keyCode: " + e.keyCode);
			// Сохранение клавиш 
			if (e.type == KeyboardEvent.KEY_DOWN) {
				ctrlKey = e.ctrlKey;
				shiftKey = e.shiftKey;
				altKey = e.altKey;
				
				if (pressedKeys.indexOf(e.keyCode) == -1) {
					pressedKeys.push(e.keyCode);
				}
			} else {
				ctrlKey = e.ctrlKey;
				shiftKey = e.shiftKey;
				altKey = e.altKey;
				
				pressedKeys.splice(pressedKeys.indexOf(e.keyCode), 1);
			}
			
			// Рассылка события подписчикам
			for (var i:int = 0; i < keyboardListeners.length; i++) {
				var listener:IKeyboardListener = IKeyboardListener(keyboardListeners[i]);
				var filters:Array;
				var functions:Array;
				if (e.type == KeyboardEvent.KEY_DOWN) {
					filters = listener.keyFiltersConfig.keyDownFilters;
					for (var j:int = 0; j < filters.length; j++) {
						var filter:IKeyFilter = IKeyFilter(filters[j]);
						if (filter.filter(e)) {
							functions = listener.keyFiltersConfig.getKeyDownFunctions(e.keyCode, filter);
							for (var k:int = 0; k < functions.length; k++) {
								var f:BindedFunction = BindedFunction(functions[k]);
								f.func.apply(f.object, f.args);
							}
						}
					}
				} else {
					filters = listener.keyFiltersConfig.keyUpFilters;
					for (j = 0; j < filters.length; j++) {
						filter = IKeyFilter(filters[j]);
						if (filter.filter(e)) {
							functions = listener.keyFiltersConfig.getKeyUpFunctions(e.keyCode, filter);
							for (k = 0; k < functions.length; k++) {
								f = BindedFunction(functions[k]);
								f.func.apply(f.object, f.args);
							}
						}
					}
				}
			}
			
			// Объект, на котором установлен фокус
			var focused:InteractiveObject = GUI.stage.focus;
			// Проверка фильтров горячих клавиш
			if (focused != null) {
				var testObject:DisplayObject = DisplayObject(focused);
				var excludeObject:DisplayObject;
				var testList:Array = new Array();
				var children:Array = new Array();
				
				while (testObject != null) {
					// Перебираем детей
					testList = checkFilters(testObject, e);
					// Проверка на завершение фильтрации (нашли сработавший объект)
					if (testList == null) return;
					
					// Тестовые объекты - дети текущего тестового объекта
					while (testList.length > 0) {
						// Проверяем детей и составляем следующий список тестовых объектов
						for (i = 0; i < testList.length; i++) {
							if (DisplayObject(testList[i]) != excludeObject) {
								var tempArr:Array = checkFilters(testList[i], e);
								// Проверка на завершение фильтрации (нашли сработавший объект)
								if (tempArr == null) return;
								// Сохраняем детей для которых надо провести проверку
								for (j = 0; j < tempArr.length; j++) {
									children.push(tempArr[j]);
								}
							}
						}
						// Теперь дети - тестовые объекты
						testList = new Array();
						for (i = 0; i < children.length; i++) {
							testList.push(children[i]);
						}
						children = new Array();
					}
					// Поднимаемся на уровень по иерархии
					excludeObject = testObject;
					/*if (testObject is WindowBase)
						testObject = null;
					else
						testObject = testObject.parent;*/
					testObject = testObject.parent;
				}
			}
		}
		
		/**
		 * Включение/отключение KeyboardManager. 
		 * 
		 */
		public static function get enabled():Boolean {
			return _enabled;
		}
		public static function set enabled(value:Boolean):void {
			if (value != _enabled) {
				if (_enabled) {
					_container.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
					_container.removeEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				} else {
					_container.addEventListener(KeyboardEvent.KEY_DOWN, onKeyEvent);
					_container.addEventListener(KeyboardEvent.KEY_UP, onKeyEvent);
				}
				_enabled = value;
			}
		}
		
	}
}