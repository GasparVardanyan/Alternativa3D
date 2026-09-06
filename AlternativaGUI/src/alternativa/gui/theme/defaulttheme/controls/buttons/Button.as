package alternativa.gui.theme.defaulttheme.controls.buttons {

	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.primitives.base.ButtonSkinState;
	import alternativa.gui.theme.defaulttheme.skin.ButtonSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	/**
	 *  RU: Заскинованная кнопка с текстовой мекой и иконкой.
     *  EN: Skin button with a text label and an icon
	 * 
	 */	
	public class Button extends BaseButton {
		
		// RU: минимальная высота кнопки
        // EN: minimal button height
		protected var _minHeight:int;

		// RU: внутренний отступ
        // EN: padding
		protected var _padding:int;
		
		// RU: зазор между иконкой и текстовой меткой
        // EN: distance between an icon and a text label
		protected var _iconPadding:int;
		
		// RU: текстовая метка
        // EN: text label
		protected var _label:Label;
		
		// RU: иконка
        // EN: icon
		protected var _icon:DisplayObject;

		public function Button() {
			super();
			
			_minHeight = NumericConst.buttonMinHeight;
			_height = _minHeight;
			_padding = NumericConst.basePadding;
			_iconPadding = NumericConst.baseIconPadding;
			
			// RU: задаем состояния кнопки
            // EN: set the button states
			stateUP = new ButtonSkinState(ButtonSkin.stateUpBgTexture, ButtonSkin.stateUpBottomGradientTexture);
			stateDOWN = new ButtonSkinState(ButtonSkin.stateDownBgTexture, ButtonSkin.stateDownBottomGradientTexture, ButtonSkin.stateDownBorderTexture);
			stateOVER = new ButtonSkinState(ButtonSkin.stateOverBgTexture, ButtonSkin.stateOverBottomGradientTexture);
		}

		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
		}

		public function get iconPadding():int {
			return _iconPadding;
		}

		public function set iconPadding(value:int):void {
			_iconPadding = value;
		}

		public function get label():String {
			if (_label != null) {
				return _label.text;
			} else {
				return "";
			}
		}

		public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				addChild(_label);
			}
			if (value != null || value != "") {
				_label.text = value;
			} else {
				if (_label != null) {
					if (contains(_label)) {
						removeChild(_label);
					}
					_label = null;
				}
			}
			draw();
		}

		public function get icon():DisplayObject {
			return _icon;
		}

		public function set icon(object:DisplayObject):void {
			if (_icon != null) {
				removeChild(_icon);
			}
			if (object != null) {
				_icon = object;
				addChild(_icon);
			}
			draw();
		}
		
		// RU: если кнопка неактивна(залоченна), тогда меняем прозрачность у икноки и текстовой метки
        // EN: if button is inactive (lock), then change icon transparency and text label transparency
		override public function set locked(value:Boolean):void {
			super.locked = value;
			if (_locked) {
				if (_label != null) {
					_label.alpha = NumericConst.lockedAlpha;
				}
				if (_icon != null) {
					_icon.alpha = NumericConst.lockedAlpha;
				}
			} else {
				if (_label != null) {
					_label.alpha = 1;
				}
				if (_icon != null) {
					_icon.alpha = 1;
				}
			}
		}
		
		// RU: различное поведение при наведении: просто навели, отвели. Навели и отвели когда кнопка была зажатой.
        // EN: different behavior on mouse on: mouse on -> mouse out, mouse on->mouse out when mouse button is pressed
		override public function set over(value:Boolean):void {
			if (!_locked)
				_over = value;
			if (!_locked && !_pressed) {
				setState(value ? _stateOVER : _stateUP);
			} else if (!_locked && _pressed) {
				if (_over && _pressed) {
					if (_label != null) {
						_label.y = ((_height - int(_label.height)) >> 1) + 1;
					}
					if (_icon != null) {
						_icon.y = ((_height - _icon.height) >> 1) + 1;
					}
					setState(_stateDOWN);
				} else if (!_over && _pressed) {
					if (_label != null) {
						_label.y = ((_height - int(_label.height)) >> 1);
					}
					if (_icon != null) {
						_icon.y = ((_height - _icon.height) >> 1);
					}
					setState(_stateUP);
				}
			}
		}

		override public function set pressed(value:Boolean):void {
			super.pressed = value;

			if (_label != null) {
				if (_pressed) {
					_label.y = ((_height - int(_label.height)) >> 1) + 1;
				} else {
					_label.y = (_height - int(_label.height)) >> 1;
				}

			}

			if (_icon != null) {
				if (_pressed) {
					_icon.y = ((_height - _icon.height) >> 1) + 1;
				} else {
					_icon.y = (_height - _icon.height) >> 1;
				}
			}
		}
		
		// RU: позиционирование иконки и текстовой метки
        // EN: set position to a icon and a text label
		override protected function draw():void {
			super.draw();

			if (_label != null) {
				_label.x = (_width - int(_label.width)) >> 1;
				_label.y = (_height - int(_label.height)) >> 1;
			}

			if (_icon != null) {
				if (_label != null) {
					_icon.x = (_width - _icon.width - _label.width - _iconPadding) >> 1;
					_label.x = _icon.x + int(_icon.width) + _iconPadding;
				} else {
					_icon.x = (_width - _icon.width) >> 1;
				}
				_icon.y = (_height - _icon.height) >> 1;

			}
		}
		
		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			var w:int = (_label != null ? _label.width : 0) + (_icon != null ? (_icon.width + _iconPadding) : 0) + _padding * 2;
			if (value < w) {
				return w;
			} else {
				return value;
			}
		}
		
		// RU: смотрим значение высоты, если меньше заданного, отдаем минимальную высоту
        // EN: if height value is less than the specified value, then return minimal height value
		override protected function calculateHeight(value:int):int {
			if (value < _minHeight) {
				return _minHeight;
			} else {
				return value;
			}
		}

	}
}
