package alternativa.gui.controls.button {

	import alternativa.gui.keyboard.keyfilter.FocusKeyFilter;
	import alternativa.gui.keyboard.keyfilter.SimpleKeyFilter;
	import alternativa.gui.base.ActiveObject;
	
	import flash.display.DisplayObject;
	
	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 * Базовый класс кнопки.
	 * <p>Имеющая несколько состояний нажатия: stateUP, stateOVER, stateDOWN, stateOFF.</p>
	 * 
	 */	
	public class BaseButton extends ActiveObject {
		
		/**
         * @private
         * Действие "НАЖАТИЕ"
         */
        private const KEY_ACTION_PRESS:String = "BaseButtonPress";
        /**
         * @private
         * Действие "ОТЖАТИЕ"
         */
        private const KEY_ACTION_UNPRESS:String = "BaseButtonUnpress";

		/*public static const BUTTON_STATE_UP:int = 0;
		public static const BUTTON_STATE_OVER:int = 1;
		public static const BUTTON_STATE_DOWN:int = 2;
		public static const BUTTON_STATE_OFF:int = 3;*/
		
		/**
		 * Изображение кнопки в состоянии по умолчанию.
		 */		
		protected var _stateUP:DisplayObject;
		
		/**
		 * Изображение кнопки в состоянии наведения.
		 */
		protected var _stateOVER:DisplayObject;
		
		/**
		 * Изображение кнопки в состоянии нажатия.
		 */
		protected var _stateDOWN:DisplayObject;
		
		/**
		 * Изображение залоченной кнопки.
		 */
		protected var _stateOFF:DisplayObject;
		
		/**
		 * Текущее состояние. 
		 */		
		protected var _currentState:DisplayObject;
		
		public function BaseButton() {
			super();
			 // Фильтры горячих клавиш
            var pressFilter:FocusKeyFilter = new FocusKeyFilter(this, new SimpleKeyFilter(new Array(13, 32)));
            keyFiltersConfig.addKeyDownFilter(pressFilter, KEY_ACTION_PRESS);
            keyFiltersConfig.addKeyUpFilter(pressFilter, KEY_ACTION_UNPRESS);
            keyFiltersConfig.bindKeyDownAction(KEY_ACTION_PRESS, this, keyDown);
            keyFiltersConfig.bindKeyUpAction(KEY_ACTION_UNPRESS, this, keyUp);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function draw():void {
			super.draw();
			if (_stateOFF != null) {
				_stateOFF.width = _width;
				_stateOFF.height = _height;
			}
			if (_stateUP != null) {
				_stateUP.width = _width;
				_stateUP.height = _height;
			}
			if (_stateOVER != null) {
				_stateOVER.width = _width;
				_stateOVER.height = _height;
			}
			if (_stateDOWN != null) {
				_stateDOWN.width = _width;
				_stateDOWN.height = _height;
			}
			if (_currentState != null) {
				setState(_currentState);
			}
		}
		
		/**
		 * Смена состояния кнопки. 
		 * @param state Изображение состояния.
		 * 
		 */	
		protected function setState(state:DisplayObject):void {
			if (state != null) {
				//trace("\nBaseButton setState = " + state.name);
				if (_currentState != null) {
					_currentState.visible = false;
				}
				_currentState = state;
				_currentState.visible = true;
				//trace("BaseButton     currentState = " + _currentState.name + "\n");
			}
		}
		
		/**
		 * Клавишу клавиатуры нажали. 
		 * 
		 */
		public function keyDown():void{
			pressed = true;
		}
		
		/**
		 * Клавишу клавиатуры отжали. 
		 * 
		 */
		public function keyUp():void{
			pressed = false;
		}
		
		/**
		 * Изображение кнопки в состоянии по умолчанию.
		 * 
		 */	
		public function set stateUP(value:DisplayObject):void {
			//trace("BaseButton stateUP = " + value);
			value.name = "stateUP";
			var visible:Boolean = (_currentState == null || _currentState == _stateUP);
			
			if (_stateUP != null) {
				removeChild(_stateUP);
			}
			_stateUP = value;
			addChildAt(_stateUP, 0);
			
			if (visible) {
				setState(_stateUP);
			}
		}
		
		/**
		 *  Изображение кнопки в состоянии наведения.
		 * 
		 */	
		public function set stateOVER(value:DisplayObject):void {
			//trace("BaseButton stateOVER = " + value);
			value.name = "stateOVER";
			var visible:Boolean = (_currentState == _stateOVER);
			
			if (_stateOVER != null) {
				removeChild(_stateOVER);
			}
			_stateOVER = value;
			addChildAt(_stateOVER, 0);
			_stateOVER.visible = visible;
		}
		
		/**
		 * Изображение кнопки в состоянии нажатия.
		 * 
		 */	
		public function set stateDOWN(value:DisplayObject):void {
			//trace("BaseButton stateDOWN = " + value);
			value.name = "stateDOWN";
			var visible:Boolean = (_currentState == _stateDOWN);
			
			if (_stateDOWN != null) {
				removeChild(_stateDOWN);
			}
			_stateDOWN = value;
			addChildAt(_stateDOWN, 0);
			_stateDOWN.visible = visible;
		}
		
		/**
		 * Изображение залоченной кнопки.
		 * 
		 */	
		public function set stateOFF(value:DisplayObject):void {
			//trace("BaseButton stateOFF = " + value);
			value.name = "stateOFF";
			
			var visible:Boolean = (_currentState == _stateOFF);
			
			if (_stateOFF != null) {
				removeChild(_stateOFF);
			}
			_stateOFF = value;
			addChildAt(_stateOFF, 0);
			_stateOFF.visible = visible;
		}
		
		//----- ICursorActiveListener
		/**
		 * @inheritDoc 
		 * 
		 */			
		override public function set over(value:Boolean):void {
			//trace("BaseButton over = " + value);
			super.over = value;
			
			if (!_locked && !pressed) {
				setState(value ? _stateOVER : _stateUP);
			}
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */	
		override public function set pressed(value:Boolean):void {
			//trace("BaseButton pressed = " + value);
			super.pressed = value;
			
			if (!_locked) {
				if (value) {
					setState(_stateDOWN);
				} else {
					setState(_over ? _stateOVER : _stateUP);
				}
			} 
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set locked(value:Boolean):void {
			//trace("BaseButton locked = " + value);
			
			super.locked = value;
			
			setState(value ? _stateOFF : _stateUP);
		}

	}
}