package alternativa.gui.controls.numericStepper {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.text.TextInput;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextFieldType;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	use namespace alternativagui;

	public class NumericStepper extends GUIobject {

		/**
		 * Поле ввода.
		 */
		protected var textInput:TextInput;

		/**
		 * Фон.
		 */
		protected var _background:DisplayObject;

		/**
		 * Кнопка увеличения значения.
		 */
		protected var _increaseButton:BaseButton;

		/**
		 * Кнопка уменьшения значения.
		 */
		protected var _decreaseButton:BaseButton;

		/**
		 * Внутренний отступ.
		 */
		protected var _padding:int = 1;

		/**
		 * Зазор между текстовым полем и кнопками.
		 */
		protected var _space:int = 5;

		/**
		 * Шаг изменения кнопками.
		 */
		protected var _step:Number;

		/**
		 * Коэффициент увеличения шага при зажатом Crtl и драге.
		 */
		protected var _fasterIncrement:Number = 5;

		/**
		 * Коэффициент уменьшения шага при зажатом Shift и драге.  Дробное значение от 0 до 1.
		 */
		protected var _slowerIncrement:Number = 0.1;

		/**
		 * Минимальное значение.
		 */
		protected var _minValue:Number;

		/**
		 * Максимальное значение.
		 */
		protected var _maxValue:Number;

		/**
		 * Флаг блокировки.
		 */
		protected var _locked:Boolean;

		/**
		 * Значение.
		 */
		protected var _value:Number = 0;

		/**
		 * Старое значение.
		 */
		protected var oldValue:Number = 0;

		/**
		 * Количество знаков после запятой.
		 */
		protected var _sign:int;


		/**
		 * Точка захвата мыши по оси Y.
		 */
		protected var mousePointY:Number;

		/**
		 * Флаг активности движения мыши.
		 */
		protected var mouseMoveActive:Boolean = false;

		/**
		 * Ссылка на stage.
		 */
		protected var _stage:Stage;
		
		protected var _dragEnabled:Boolean = true;

		/**
		 *
		 * @param minValue Минимальное значение.
		 * @param maxValue Максимальное значение.
		 * @param step Шаг.
		 * @param sign Количество знаков после запятой.
		 *
		 */
		public function NumericStepper(minValue:Number = 0, maxValue:Number = 10, step:Number = 1, sign:int = 5) {
			super();

			this._sign = sign;
			this._step = step;
			this._minValue = minValue;
			this._maxValue = maxValue;

			_stage = LayoutManager.stage;

			textInput = new TextInput();
			// RU: данные, которые можно ввести
			// EN: data, which you can enter
			textInput.tf.restrict = "0-9 . ,";
			addChild(textInput);

			value = minValue;
			textInput.text = String(_value);
			textInput.addEventListener(KeyboardEvent.KEY_DOWN, keyboardHandler);
			textInput.addEventListener(FocusEvent.FOCUS_OUT, keyboardHandler);
		}

		/**
		 * При вводе значения с клавиатуры клавишей ENTER сохраняем результат.
		 *
		 */
		protected function keyboardHandler(e:Event):void {
			if (e is KeyboardEvent) {
				if ((e as KeyboardEvent).keyCode == Keyboard.ENTER) {
					value = Number(textInput.text);
				}
			} else if (!mouseMoveActive) {
				value = Number(textInput.text);
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		override protected function draw():void {
			super.draw();
			if (_background != null) {
				_background.width = _width;
				_background.height = _height;
			}

			if (_increaseButton != null) {
				_increaseButton.x = _width - _increaseButton.width;
				_increaseButton.y = 0;
			}
			if (_decreaseButton != null) {
				_decreaseButton.x = _width - _decreaseButton.width;
				_decreaseButton.y = _height - _decreaseButton.height;
			}

			textInput.x = _padding;
			textInput.y = int((_height - textInput.tf.height) >> 1) + 4;
			textInput.width = _width - _padding - _space - (_increaseButton != null ? increaseButton.width : 0);
			textInput.height = _height - textInput.y;
		}

		/**
		 *
		 * Увеличиваем значение на величину _step.
		 *
		 */
		protected function increaseButtonClick(event:MouseEvent):void {
			value = _value + _step;
			oldValue = _value;
			mousePointY = _stage.mouseY;
			if (_dragEnabled) {
				_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}
		
		/**
		 * 
		 * Отпустили кнопку мыши.
		 * 
		 */		
		protected function mouseUp(e:MouseEvent):void {
			if (mouseMoveActive) {
				CursorManager.hideCursor();
				//CursorManager.reset();
				_increaseButton.pressed = false;
				_decreaseButton.pressed = false;
				_increaseButton.over = false;
				_decreaseButton.over = false;
				if (!_increaseButton.locked) {
					_increaseButton.cursorActive = true;
				}
				if (!_decreaseButton.locked) {
					_decreaseButton.cursorActive = true;
				}
			}
			mouseMoveActive = false;

			_stage.removeEventListener(MouseEvent.MOUSE_UP, mouseUp);
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
		}
		
		/**
		 * Движение мыши.
		 * 
		 */		
		protected function mouseMove(e:MouseEvent):void {

			if (!mouseMoveActive) {
				mouseMoveActive = true;
				_increaseButton.pressed = true;
				_decreaseButton.pressed = true;
				_increaseButton.cursorActive = false;
				_decreaseButton.cursorActive = false;
				CursorManager.showCursor(CursorManager.SIZE_NS);
			}

			var increment:Number = 1;

			if (e.ctrlKey) {
				increment = _fasterIncrement;
			}
			if (e.shiftKey) {
				increment = _slowerIncrement;
			}

			if (_step == int(_step)) {
				value = oldValue + (_step) * int((increment * (mousePointY - e.stageY)));
			} else {
				value = oldValue + (_step) * (increment * (mousePointY - e.stageY));
			}
		}

		/**
		 *
		 * Уменьшаем значение на величину _step.
		 *
		 */
		protected function decreaseButtonClick(event:MouseEvent):void {
			value = _value - _step;
			oldValue = _value;
			mousePointY = _stage.mouseY;
			if (_dragEnabled) {
				_stage.addEventListener(MouseEvent.MOUSE_UP, mouseUp);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, mouseMove);
			}
		}

		/**
		 * Округление после запятой.
		 * @param number Значение.
		 * @param sign Количество знаков после запятой.
		 * @return Новое значение.
		 *
		 */
		protected function roundTo(number:Number , sign:Number):Number {
			if (sign >= 0) {
				var n:Number = Math.pow(10, sign);
				return Math.round(number * n) / n;
			} else {
				return number;
			}
		}

		/**
		 * Cоздание и добавление кнопки увеличения значения.
		 *
		 */
		public function get increaseButton():BaseButton {
			return _increaseButton;
		}

		public function set increaseButton(object:BaseButton):void {
			if (_increaseButton != null) {
				_increaseButton.removeEventListener(MouseEvent.MOUSE_DOWN, increaseButtonClick);
				if (contains(_increaseButton)) {
					removeChild(_increaseButton);
				}
				_increaseButton = null;
			}
			if (object != null) {
				_increaseButton = object;
				_increaseButton.mouseEnabled = true;
				addChild(_increaseButton);
				_increaseButton.addEventListener(MouseEvent.MOUSE_DOWN, increaseButtonClick);

			}
		}

		/**
		 * Cоздание и добавление кнопки уменьшения значения.
		 *
		 */
		public function get decreaseButton():BaseButton {
			return _decreaseButton;
		}

		public function set decreaseButton(object:BaseButton):void {
			if (_decreaseButton != null) {
				_decreaseButton.removeEventListener(MouseEvent.MOUSE_DOWN, decreaseButtonClick);
				if (contains(_decreaseButton)) {
					removeChild(_decreaseButton);
				}
				_decreaseButton = null;
			}
			if (object != null) {
				_decreaseButton = object;
				_decreaseButton.mouseEnabled = true;
				addChild(_decreaseButton);
				_decreaseButton.addEventListener(MouseEvent.MOUSE_DOWN, decreaseButtonClick);
			}
		}

		/**
		 *
		 * Значение.
		 *
		 */
		public function get value():Number {
			return _value;
		}

		public function set value(value:Number):void {
			// RU: округление после запятой у полученного значения
			// EN: round values
			value = roundTo(value, _sign);
			var tempValue:Number = value;
			if (tempValue <= _minValue) {
				_value = _minValue;
				if (_decreaseButton != null && !_locked) {
//					_decreaseButton.locked = true;
				}
			} else if (tempValue >= _maxValue) {
				_value = _maxValue;
				if (_increaseButton != null && !_locked) {
//					_increaseButton.locked = true;
				}
			} else if (tempValue >= _minValue && tempValue <= _maxValue) {
				_value = tempValue;
				if (_decreaseButton != null && _decreaseButton.locked && !_locked) {
//					_decreaseButton.locked = false;
					if (mouseMoveActive) {
						_decreaseButton.pressed = true;
					}
				}
				if (_increaseButton != null && _increaseButton.locked && !_locked) {
//					_increaseButton.locked = false;
					if (mouseMoveActive) {
						_increaseButton.pressed = true;
					}
				}
			}
			textInput.text = String(_value);
			dispatchEvent(new Event(Event.CHANGE));
		}


		/**
		 * Шаг изменения кнопками.
		 */
		public function get step():Number {
			return _step;
		}

		public function set step(value:Number):void {
			_step = value;
		}

		/**
		 * Минимальное значение.
		 */
		public function get minValue():Number {
			return _minValue;
		}

		public function set minValue(value:Number):void {
			_minValue = value;
			this.value = _value;
		}

		/**
		 * Максимальное значение.
		 */
		public function get maxValue():Number {
			return _maxValue;
		}

		public function set maxValue(value:Number):void {
			_maxValue = value;
			this.value = _value;
		}

		/**
		 * Флаг блокировки.
		 */
		public function get locked():Boolean {
			return _locked;
		}

		public function set locked(value:Boolean):void {
			_locked = value;
			textInput.selectable = !_locked;
			if (_locked) {
				textInput.mouseEnabled = !textInput.mouseEnabled;
				textInput.mouseChildren = !textInput.mouseChildren;
				textInput.tf.type = TextFieldType.DYNAMIC;
			} else {
				textInput.mouseEnabled = !textInput.mouseEnabled;
				textInput.mouseChildren = !textInput.mouseChildren;
				textInput.tf.type = TextFieldType.INPUT;
			}
			if (_increaseButton != null) {
				_increaseButton.locked = _locked;
			}
			if (_decreaseButton != null) {
				_decreaseButton.locked = _locked;
			}
		}


		/**
		 * Количество знаков после запятой.
		 *
		 */
		public function get sign():int {
			return _sign;
		}

		public function set sign(value:int):void {
			_sign = value;
		}

		/**
		 * Внутренний отступ.
		 */
		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
		}

		/**
		 * Зазор между текстовым полем и кнопками.
		 */
		public function get space():int {
			return _space;
		}

		public function set space(value:int):void {
			_space = value;
		}

		/**
		 * Фон.
		 */
		public function get background():DisplayObject {
			return _background;
		}

		public function set background(value:DisplayObject):void {
			if (_background != null) {
				if (contains(_background)) {
					removeChild(_background);
				}
				_background = null;
			}
			if (value != null) {
				_background = value;
				addChildAt(_background, 0);
			}
		}

		/**
		 * Коэффициент увеличения шага при зажатом Crtl и драге.
		 */
		public function get fasterIncrement():Number {
			return _fasterIncrement;
		}

		/**
		 * @private
		 */
		public function set fasterIncrement(value:Number):void {
			if (value < 1) {
				value = 1;
			}
			_fasterIncrement = value;
		}

		/**
		 * Коэффициент уменьшения шага при зажатом Shift и драге.  Дробное значение от 0 до 1.
		 */
		public function get slowerIncrement():Number {
			return _slowerIncrement;
		}

		/**
		 * @private
		 */
		public function set slowerIncrement(value:Number):void {
			if (value < 0) {
				value = 0;
			} else if (value > 1) {
				value = 1;
			}
			_slowerIncrement = value;
		}

		/**
		 * Флаг изменения значения с помощью драга мышки. 
		 */
		public function get dragEnabled():Boolean
		{
			return _dragEnabled;
		}

		/**
		 * @private
		 */
		public function set dragEnabled(value:Boolean):void
		{
			_dragEnabled = value;
		}


	}
}
