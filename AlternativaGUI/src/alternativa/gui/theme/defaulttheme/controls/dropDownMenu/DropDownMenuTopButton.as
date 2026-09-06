package alternativa.gui.theme.defaulttheme.controls.dropDownMenu {
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.primitives.base.ButtonSkinState;
	import alternativa.gui.theme.defaulttheme.skin.ButtonSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.dropDownMenu.DropDownMenuTopButton;
	import alternativa.gui.enum.Align;

	import flash.display.DisplayObject;

	use namespace alternativagui


	public class DropDownMenuTopButton extends alternativa.gui.controls.dropDownMenu.DropDownMenuTopButton {

		protected var _minHeight:int;

		protected var _padding:int;

		protected var _iconPadding:int;

		protected var _label:Label;

		protected var _icon:DisplayObject;

		public function DropDownMenuTopButton() {
			super();
		}


		override protected function init():void {
			super.init();
			_minHeight = NumericConst.buttonMinHeight;
			_height = _minHeight;
			_padding = NumericConst.basePadding;
			_iconPadding = NumericConst.baseIconPadding;

			stateUP = new ButtonSkinState(ButtonSkin.stateUpBgTexture, ButtonSkin.stateUpBottomGradientTexture);
			_stateUP.alpha = 0;
			stateDOWN = new ButtonSkinState(ButtonSkin.stateDownBgTexture, ButtonSkin.stateDownBottomGradientTexture, ButtonSkin.stateDownBorderTexture);
			stateOVER = new ButtonSkinState(ButtonSkin.stateOverBgTexture, ButtonSkin.stateOverBottomGradientTexture);

			_label = new Label();
			_label.align = Align.LEFT;
			addChild(_label);
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

		override public function set data(value:Object):void {
			super.data = value;
			if (value) {
				_label.text = value.label;
				locked = value.locked;
			}
		}

		override protected function calculateWidth(value:int):int {
			var w:int = (_label != null ? _label.width : 0) + (_icon != null ? (_icon.width + _iconPadding) : 0) + _padding * 2;
			if (value < w) {
				return w;
			} else {
				return value;
			}
		}

		override protected function calculateHeight(value:int):int {
			if (value < _minHeight) {
				return _minHeight;
			} else {
				return value;
			}
		}
	}
}
