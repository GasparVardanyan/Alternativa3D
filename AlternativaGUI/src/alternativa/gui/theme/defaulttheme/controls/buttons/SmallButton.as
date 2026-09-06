package alternativa.gui.theme.defaulttheme.controls.buttons {
	import alternativa.gui.alternativagui;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.primitives.base.StretchBitmapOffset;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.SmallButtonSkin;

	use namespace alternativagui;
	
	/**
	 * 
	 * RU: малая кнопка с текстовой меткой
     * EN: small button with a text label
	 * 
	 */	
	public class SmallButton extends Button {
		public function SmallButton() {
			super();
			
			// RU: задаем состояния
            // EN: set states
			stateUP = new StretchBitmapOffset(SmallButtonSkin.stateUpTexture, SmallButtonSkin.edgeH, SmallButtonSkin.edgeH, SmallButtonSkin.edgeV, SmallButtonSkin.edgeV, true, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset);
			stateDOWN = new StretchBitmapOffset(SmallButtonSkin.stateDownTexture, SmallButtonSkin.edgeH, SmallButtonSkin.edgeH, SmallButtonSkin.edgeV, SmallButtonSkin.edgeV, true, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset);
			stateOVER = new StretchBitmapOffset(SmallButtonSkin.stateOverTexture, SmallButtonSkin.edgeH, SmallButtonSkin.edgeH, SmallButtonSkin.edgeV, SmallButtonSkin.edgeV, true, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset);
			stateOFF = new StretchBitmapOffset(SmallButtonSkin.stateUpTexture, SmallButtonSkin.edgeH, SmallButtonSkin.edgeH, SmallButtonSkin.edgeV, SmallButtonSkin.edgeV, true, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset, SmallButtonSkin.offset);
			
			// RU: задаем высоту кнопки
            // EN: set the button height
			_height = SmallButtonSkin.height;
		}
		
		// RU: высота кнопки фикисированная
        // EN: button height is fixed
		override protected function calculateHeight(value:int):int {
			return _height;
		}

		override public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				_label.size = NumericConst.textSizeSmallButton;
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
	}
}
