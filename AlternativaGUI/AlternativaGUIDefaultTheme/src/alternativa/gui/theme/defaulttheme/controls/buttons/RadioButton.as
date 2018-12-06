package alternativa.gui.theme.defaulttheme.controls.buttons {

	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.controls.button.TriggerButtonGroup;
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.RadioButtonSkin;
	
	import flash.display.Bitmap;

	use namespace alternativagui;

	/**
	 * RU: Кнопка - переключатель
     * EN: Radiobutton
	 * 
	 */	
	public class RadioButton extends alternativa.gui.controls.button.RadioButton {

		public function RadioButton() {
			super();
			
			// RU: задаем размеры квадрату - фон под галкой
			// EN: set sizes to square - background over the check
			boxMinSize = 16;
			boxMaxSize = 16;
			
			// RU: зазор между иконкой и текстовой меткой
            // EN: distance between an icon and a text label
			_space = NumericConst.baseIconPadding;
			
			// RU: задаем состояния кнопки
            // EN: set the button states
			stateUP = new Bitmap(RadioButtonSkin.upStateTexture);
			_stateUP.width = RadioButtonSkin.upStateTexture.width;
			_stateUP.height = RadioButtonSkin.upStateTexture.height;
			stateOVER = new Bitmap(RadioButtonSkin.overStateTexture);
			stateDOWN = new Bitmap(RadioButtonSkin.upStateTexture);
			stateOFF = new Bitmap(RadioButtonSkin.upStateTexture);
			
			// RU: кружок для кнопки
            // EN: circle for the button
			checkSign = new Bitmap(RadioButtonSkin.iconBD);
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
