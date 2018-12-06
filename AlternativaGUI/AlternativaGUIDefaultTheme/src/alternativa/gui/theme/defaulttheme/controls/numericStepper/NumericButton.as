package alternativa.gui.theme.defaulttheme.controls.numericStepper {

	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	
	import flash.display.DisplayObject;

	use namespace alternativagui;
	
	
	/**
	 * RU: кнопка со стрелочкой для NumericStepper
     * EN: button with arrow for NumericStepper
	 * 
	 */
	public class NumericButton extends BaseButton {

		protected var _icon:DisplayObject;
		
		// RU: смещение иконки по вертикали
        // EN: vertical shift of an icon
		protected var offset:int;

		public function NumericButton(offset:int = 0) {
			super();
			this.offset = offset;
		}

		public function get icon():DisplayObject {
			return _icon;
		}

		public function set icon(value:DisplayObject):void {
			if (_icon != null) {
				if (contains(_icon))
					removeChild(_icon);
				_icon = null;
			}
			if (value != null) {
				_icon = value;
				addChild(_icon);
				draw();
			}
		}
		
		// RU: позиционирование иконки
        // EN: set the icon position
		override protected function draw():void {
			super.draw();
			if (_icon != null) {
				_icon.x = (_width - _icon.width) >> 1;
				_icon.y = ((_height - _icon.height) >> 1) + offset;
			}
		}

		override public function set locked(value:Boolean):void {
			super.locked = value;
			this.mouseEnabled = !_locked;
			this.mouseChildren = !_locked;
			if (_icon != null) {
				if (_locked) {
					_icon.alpha = NumericConst.lockedAlpha;
				} else {
					_icon.alpha = 1;
				}
			}
			if (_locked) {
				CursorManager.reset();				
			}
		}
	}
}
