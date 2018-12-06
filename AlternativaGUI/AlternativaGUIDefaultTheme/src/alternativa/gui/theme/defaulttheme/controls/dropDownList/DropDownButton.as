package alternativa.gui.theme.defaulttheme.controls.dropDownList {

	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	
	/**
	 * 
	 * RU: кнопка для DropDownList
     * EN: Button for DropDownList
	 * 
	 */	
	public class DropDownButton extends Button {
		
		// RU: иконка стрелочки
        // EN: arrow icon
		[Embed(source = "../../resources/dropDownList/iconDown.png")]
		private static const iconDownImage:Class;
		public static const iconDownTexture:BitmapData = new iconDownImage().bitmapData;

		public function DropDownButton() {
			cursorActive = false;
			mouseEnabled = false;
			
			// RU: создаем прозрачный спрайт, отдаем его в качестве stateUP, чтобы мышь реагировала на кнопку
            // EN: create a transparent sprite, and set it for stateUP for mouse actions
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(0, 0);
			sp.graphics.drawRect(0, 0, 10, 10);
			sp.mouseEnabled = false;

			
			iconPadding = 0;
			padding = 0;
			stateUP = sp;
			icon = new Bitmap(iconDownTexture);
		}

		override protected function draw():void {
			super.draw();
			
			// RU: выравниваем иконку
            // EN: align icon
			if (_icon != null) {
				_icon.y++;
			}
		}
	}
}
