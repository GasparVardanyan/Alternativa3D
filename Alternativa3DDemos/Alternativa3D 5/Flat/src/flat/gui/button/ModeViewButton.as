package flat.gui.button {
	import flash.display.Bitmap;
	import flash.display.SimpleButton;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	/**
	 * Кнопка смены режимов просмотра.
	 */ 
	public class ModeViewButton extends Sprite {
		[Embed(source="resources/button_inside_n.png")] private static const bmpInsideN:Class;
		private var insideNBitmap:Bitmap = new bmpInsideN();
		[Embed(source="resources/button_inside_p.png")] private static const bmpInsideP:Class;
		private var insidePBitmap:Bitmap = new bmpInsideP();
		[Embed(source="resources/button_outside_n.png")] private static const bmpOutsideN:Class;
		private var outsideNBitmap:Bitmap = new bmpOutsideN();
		[Embed(source="resources/button_outside_p.png")] private static const bmpOutsideP:Class;
		private var outsidePBitmap:Bitmap = new bmpOutsideP();
		// Кнопка для просмотра изнутри
		private var buttonInside:SimpleButton;
		// Кнопка для просмотра снаружи
		private var buttonOutside:SimpleButton;
		// Индикатор внешнего режима просмотра
		private var _out:Boolean = false;
			
		public function ModeViewButton() {
			
			super();
							
			useHandCursor = true;
			buttonInside = new SimpleButton(insideNBitmap, insideNBitmap, insidePBitmap, insidePBitmap);
			buttonOutside = new SimpleButton(outsideNBitmap, outsideNBitmap, outsidePBitmap, outsidePBitmap);		
			addChild(buttonInside);
			addChild(buttonOutside);
			buttonOutside.visible = false;

			addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		}
		
		public function get out():Boolean {
			return _out;
		}
		
		
		/**
		 * Смена режима просмотра. Настройка вида кнопки
		 */
		private function onMouseUp(event:Event):void {
			
			if (_out) {
				
				buttonInside.visible = true;
				buttonOutside.visible = false;
				_out = false;								
			}
			else {
				
				buttonInside.visible = false;
				buttonOutside.visible = true;
				_out = true;				
			}
		}
		
		
	}
}