package alternativa.gui.theme.defaulttheme.controls.buttons {

	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.CheckBox;
	import alternativa.gui.theme.defaulttheme.skin.CheckBoxSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;

	import flash.display.Bitmap;

	use namespace alternativagui;

	public class CheckBox extends alternativa.gui.controls.button.CheckBox {

		public function CheckBox() {
			super();

			// RU: задаем размеры квадрату - фон под галкой
            // EN: set sizes to square - background over the check
			boxMinSize = 16;
			boxMaxSize = 16;

			_space = NumericConst.baseIconPadding;

			// RU: задаем состояния
            // EN: set states
			stateUP = new Bitmap(CheckBoxSkin.upStateTexture);
			_stateUP.width = CheckBoxSkin.upStateTexture.width;
			_stateUP.height = CheckBoxSkin.upStateTexture.height;
			stateOVER = new Bitmap(CheckBoxSkin.overStateTexture);
			stateDOWN = new Bitmap(CheckBoxSkin.upStateTexture);
			stateOFF = new Bitmap(CheckBoxSkin.upStateTexture);

			// RU: задаем галку
            // EN: set the check
			checkSign = new Bitmap(CheckBoxSkin.iconBD);
			
			resize(1,1);
		}
		
		// RU: при неактивности компоненты изменяется прозрачность
        // EN: on component inactivity transparency is changed
		override public function set locked(value:Boolean):void {
			super.locked = value;
			if (locked) {
				this.alpha = NumericConst.lockedAlpha;
			} else {
				this.alpha = 1;
			}
		}

		override public function get label():String {
			return _label.text;
		}

		override public function set label(value:String):void {
			super.label = value;
			if (_label != null) {
				_label.size = NumericConst.textSize;
				_label.color = NumericConst.textColor;
				width = _width;
			}
		}
	}
}
