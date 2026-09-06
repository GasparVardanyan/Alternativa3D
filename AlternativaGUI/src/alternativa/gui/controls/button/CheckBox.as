package alternativa.gui.controls.button {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.text.Label;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Кнопка-переключатель. 
	 * <p>Содержит несколько состояний нажатия: stateUP, stateOVER, stateDOWN, stateOFF. Графика флага задается отдельно.
	 * Компонента может иметь текстовую метку</p>
	 * 
	 */	
	public class CheckBox extends BaseButton {
		
		/**
		 * Текстовая метка.
		 */		
		public var _label:Label;
		
		/**
		 * Изображение для флага.
		 */		
		protected var _checkSign:DisplayObject;
		
		/**
		 * Определяет или задает логическое значение, указывающее, включена или выключена кнопка-переключатель.
		 */		
		protected var _checked:Boolean = false;
		
		/**
		 * Ширина текстовой метки. 
		 */		
		protected var _labelWidth:int = 0;
		
		/**
		 * Зазор между текстовой меткой и кнопкой. 
		 */		
		protected var _space:int = 0;
		
		/**
		 * Размер фона кнопки. 
		 */		
		protected var boxSize:int = 0;
		
		/**
		 * Минимальный размер фона кнопки. 
		 */		
		protected var boxMinSize:int = 20;
		
		/**
		 * Максимальный размер фона кнопки. 
		 */		
		protected var boxMaxSize:int = 40;
		

		public function CheckBox() {
			super();
		}
		
		/**
		 * Изображение для флага.
		 * 
		 */		
		public function set checkSign(value:DisplayObject):void {
			_checkSign = value;
			addChild(_checkSign);
			draw();
		}
		
		/**
		 * Зазор между текстовой меткой и кнопкой.
		 * 
		 */		
		public function set space(value:int):void {
			_space = value;
			width = _width;
		}
		
		/**
		 * Определяет или задает логическое значение, указывающее, включена или выключена кнопка-переключатель.
		 * 
		 */		
		public function get checked():Boolean {
			return _checked;
		}
		public function set checked(value:Boolean):void {
			_checked = value;
			draw();
		}
		
		/**
		 * Текстовая метка.
		 * 
		 */		
        public function get label():String {
            return _label.text;
        }

		public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				addChild(_label);
			}
			_label.text = value;
			
			width = _width;
		}
		
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function calculateHeight(value:int):int {
			return boxSize;
		}
		
		override protected function calculateWidth(value:int):int {
			if (_label != null) {
				boxSize = Math.min(boxMaxSize, Math.max(value - _space - _label.width, boxMinSize));
			} else {
				boxSize = Math.min(boxMaxSize, Math.max(value, boxMinSize));
			}
			
			if (_label != null) {
				value = boxSize + _space + _label.width;
			} else {
				value = boxSize;
			}
			return value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();

			if (_stateOFF != null) {
				_stateOFF.width = _height;
				_stateOFF.height = _height;
			}

			if (_stateUP != null) {
				_stateUP.width = _height;
				_stateUP.height = _height;
			}

			if (_stateOVER != null) {
				_stateOVER.width = _height;
				_stateOVER.height = _height;
			}

			if (_stateDOWN != null) {
				_stateDOWN.width = _height;
				_stateDOWN.height = _height;
			}

			if (_checkSign != null) {
				_checkSign.x = int((_height - _checkSign.width) / 2);
				_checkSign.y = int((_height - _checkSign.height) / 2);
				_checkSign.visible = _checked;
			}

			if (_label != null) {
				_label.y = (_height - _label.height) >> 1;
				_label.x = boxSize + _space;
			}

			setState(_currentState);
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set pressed(value:Boolean):void {
			super.pressed = value;
			if (_pressed){
				checked = !_checked;
			}
		}

	}
}