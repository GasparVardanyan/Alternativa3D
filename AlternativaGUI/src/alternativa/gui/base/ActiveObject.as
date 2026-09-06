package alternativa.gui.base {
	import alternativa.gui.keyboard.IKeyboardListener;
	import alternativa.gui.keyboard.KeyFiltersConfig;
	import alternativa.gui.mouse.ICursorActive;
	import alternativa.gui.mouse.ICursorActiveListener;
	import alternativa.gui.mouse.MouseManager;

    import flash.ui.MouseCursor;

    /**
	 * Базовый интерактивный объект.
	 */	
	public class ActiveObject extends GUIobject implements ICursorActive, ICursorActiveListener, IKeyboardListener {
		
		/**
		 * Подписчики на события курсора.	 
		 */		
		protected var _cursorListeners:Array;
		
		/**
		 * Флаг включения/выключения приема событий курсора. 
		 */		
		protected var _cursorActive:Boolean;
		
		/**
		 * Флаг наведения курсора. 
		 */		
		protected var _over:Boolean;
		
		/**
		 * Флаг нажатия. 
		 */		
		protected var _pressed:Boolean;
		
		/**
		 * Флаг блокировки.
		 */		
		protected var _locked:Boolean;
		
		/**
		 * Хинт. 
		 */		
		protected var _hint:String;

        /**
		 * Тип курсора.
		 */
		protected var _cursorType:String;

		/**
		 * Конфигурация фильтров клавиатуры. 
		 */		
		protected var _keyFiltersConfig:KeyFiltersConfig;

        /**
	     * Базовый интерактивный объект.
	     */
		public function ActiveObject() {
			super();

            _cursorType = MouseCursor.BUTTON;

			// Инициализация фокуса
			tabEnabled = true;
			
			// Инициализация событий курсора
			_cursorActive = true;
			_cursorListeners = new Array();
			addCursorListener(this);
			
			// Инициализация событий клавиатуры 
			_keyFiltersConfig = new KeyFiltersConfig();
			
			// Инициализация флагов состояний
			_over = false;
			_pressed = false;
			_locked = false;
		}
		
		//----- ICursorActive
		/**
		 * @inheritDoc
		 */		
		public function addCursorListener(listener:ICursorActiveListener):void {
			if (_cursorListeners.indexOf(listener) == -1) {
				_cursorListeners.push(listener);
			}
		}
		
		/**
		 * @inheritDoc
		 */			
		public function removeCursorListener(listener:ICursorActiveListener):void {
			var index:int = _cursorListeners.indexOf(listener);
			if (index != -1) {
				_cursorListeners.splice(index, 1);
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get cursorListeners():Array {
			return _cursorListeners;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get cursorActive():Boolean {
			return _cursorActive;
		}
		public function set cursorActive(value:Boolean):void {
			_cursorActive = value;
		}
		
		/**
		 * @inheritDoc
		 */		 
		public function get hint():String {
			return _hint;
		}
		public function set hint(value:String):void {
			_hint = value;
		}

		/**
		 * @inheritDoc
		 */	
        public function get cursorType():String {
            return _cursorType;
        }

        public function set cursorType(value:String):void {
            _cursorType = value;
        }
		
		//----- ICursorActiveListener
		
		/**
		 * @inheritDoc
		 */		
		public function click():void {}
		
		/**
		 * @inheritDoc
		 */		
		public function doubleClick():void {}		
		 
		/**
		 * @inheritDoc
		 */		
		public function get over():Boolean {
			return _over;
		}
		public function set over(value:Boolean):void {
			if (!_locked) _over = value;
		}
		
		/**
		 * @inheritDoc
		 */		
		public function get pressed():Boolean {
			return _pressed;
		}
		public function set pressed(value:Boolean):void {
			if (!_locked) _pressed = value;
		}
		
		/**
		 * @inheritDoc
		 */			
		public function get locked():Boolean {
			return _locked;
		}
		public function set locked(value:Boolean):void {
			_locked = value;
			cursorActive = !value;
			if (value)
				_over = false;
			
			MouseManager.update();
		}
		
		//----- IKeyboardListener
		/**
		 * @inheritDoc
		 */			
		public function get keyFiltersConfig():KeyFiltersConfig {
			return _keyFiltersConfig;
		}


    }
}