package flat.gui.progress {

	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class Window extends Sprite {

		[Embed (source="resources/window_tl.png")] private static const WindowTopLeft:Class;
		[Embed (source="resources/window_tc.png")] private static const WindowTopCenter:Class;
		[Embed (source="resources/window_tr.png")] private static const WindowTopRight:Class;
		[Embed (source="resources/window_ml.png")] private static const WindowMiddleLeft:Class;
		[Embed (source="resources/window_mc.png")] private static const WindowMiddleCenter:Class;
		[Embed (source="resources/window_mr.png")] private static const WindowMiddleRight:Class;
		[Embed (source="resources/window_bl.png")] private static const WindowBottomLeft:Class;
		[Embed (source="resources/window_bc.png")] private static const WindowBottomCenter:Class;
		[Embed (source="resources/window_br.png")] private static const WindowBottomRight:Class;

		protected var _width:Number; 
		protected var _height:Number;
 
		protected var innerContainer:Sprite = new Sprite();

		private var topLeft:Bitmap = new Bitmap((new WindowTopLeft).bitmapData);
		private var topCenter:Bitmap = new Bitmap((new WindowTopCenter).bitmapData);
		private var topRight:Bitmap = new Bitmap((new WindowTopRight).bitmapData);
		private var middleLeft:Bitmap = new Bitmap((new WindowMiddleLeft).bitmapData);
		private var middleCenter:Bitmap = new Bitmap((new WindowMiddleCenter).bitmapData);
		private var middleRight:Bitmap = new Bitmap((new WindowMiddleRight).bitmapData);
		private var bottomLeft:Bitmap = new Bitmap((new WindowBottomLeft).bitmapData);
		private var bottomCenter:Bitmap = new Bitmap((new WindowBottomCenter).bitmapData);
		private var bottomRight:Bitmap = new Bitmap((new WindowBottomRight).bitmapData);

		public function Window(width:int = 100, height:int = 100) {
			addChild(topLeft);
			addChild(topCenter);
			addChild(topRight);
			addChild(middleLeft);
			addChild(middleCenter);
			addChild(middleRight);
			addChild(bottomLeft);
			addChild(bottomCenter);
			addChild(bottomRight);
			addChild(innerContainer);
			_width = width;
			_height = height;
			calculateWidth();
			calculateHeight();
		}

		/**
		 * Ширина. 
		 */
		override public function get width():Number {
			return _width
		}

		/**
		 * @private 
		 */
		override public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				calculateWidth();
			}
		}

		/**
		 * Высота. 
		 */
		override public function get height():Number {
			return _height
		}

		/**
		 * @private 
		 */
		override public function set height(value:Number):void {
			if (_height != value) {
				_height = value;
				calculateHeight();
			}
		}
		
		private function calculateHeight():void {
			var top:int = topRight.height;
			middleLeft.y = top;
			middleCenter.y = top;
			middleRight.y = top;

			var bottom:int = _height - bottomRight.height;
			bottomLeft.y = bottom;				
			bottomCenter.y = bottom;				
			bottomRight.y = bottom;

			var newHeight:int = bottom - top; 
			middleLeft.height = newHeight;
			middleCenter.height = newHeight;
			middleRight.height = newHeight;
		}

		private function calculateWidth():void {
			var left:int = topLeft.width;
			topCenter.x = left;
			middleCenter.x = left;
			bottomCenter.x = left;

			var right:int = _width - topRight.width;
			topRight.x = right;
			middleRight.x = right;
			bottomRight.x = right;

			var newWidth:int = right - left;
			topCenter.width = newWidth;
			middleCenter.width = newWidth;
			bottomCenter.width = newWidth;
		}

	}
}
