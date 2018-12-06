package alternativa.gui.theme.defaulttheme.primitives.base {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.StretchBitmap;


	import flash.display.BitmapData;

	use namespace alternativagui;
	
	/**
	 * RU: 
	 * Отдаем текстуру и смещение. Отдает правильные размеры(только визуал, то что смещается - не учитывается размерами)
     * EN:
     * pass the texture and shift. Pass a correct sizes (only visual part, anything that moves isn't taken into account by the sizes)
	 * 
	 */	
	public class StretchBitmapOffset extends GUIobject {
		
		public var stretch:StretchBitmap;
		
		// RU: смещение вверху
        // EN: offset top
		protected var offsetTop:int;
		
		// RU: смещение справо
        // EN: offset right
		protected var offsetRight:int;

		// RU: смещение слево
        // EN: offset left
		protected var offsetLeft:int;

		// RU: смещение снизу
        // EN: offset bottom
		protected var offsetBottom:int;

		public function StretchBitmapOffset(texture:BitmapData, leftEdgeWidth:int, rightEdgeWidth:int, topEdgeHeight:int, bottomEdgeHeight:int, drawMiddleCenter:Boolean, offsetTop:int = 0, offsetRight:int = 0, offsetLeft:int = 0, offsetBottom:int = 0) {
			stretch = new StretchBitmap(texture, leftEdgeWidth, rightEdgeWidth, topEdgeHeight, bottomEdgeHeight, drawMiddleCenter);
			addChild(stretch);
			this.offsetTop = offsetTop;
			this.offsetRight = offsetRight;
			this.offsetLeft = offsetLeft;
			this.offsetBottom = offsetBottom;
		}

		override protected function draw():void {
			super.draw();
			stretch.x = -offsetLeft;
			stretch.y = -offsetTop;
			stretch.width = _width + offsetLeft + offsetRight;
			stretch.height = _height + offsetBottom + offsetTop;
		}
	}
}
