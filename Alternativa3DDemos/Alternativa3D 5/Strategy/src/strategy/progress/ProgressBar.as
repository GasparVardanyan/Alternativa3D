package strategy.progress {

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class ProgressBar extends Sprite {

		[Embed (source="resources/progressbar_l.png")] private static const ProgressLeft:Class;
		[Embed (source="resources/progressbar_c.png")] private static const ProgressCenter:Class;
		[Embed (source="resources/progressbar_r.png")] private static const ProgressRight:Class;
		[Embed (source="resources/progressbar_fill.png")] private static const ProgressFill:Class;

		private var _width:Number;

		private var _progress:Number;
		private var _border:int;

		private var left:Bitmap = new Bitmap((new ProgressLeft).bitmapData);
		private var right:Bitmap = new Bitmap((new ProgressRight).bitmapData);
		private var center:Bitmap = new Bitmap((new ProgressCenter).bitmapData);
		private var fillBmp:BitmapData = (new ProgressFill).bitmapData;
		private var fill:Shape = new Shape();

		public function ProgressBar(width:int = 100, border:int = 2, progress:Number = 0) {
			mouseEnabled = false;

			addChild(left);
			addChild(right);
			addChild(center);
			addChild(fill);

			_progress = progress;
			_width = width;
			_border = border;
			center.x = left.width;
			right.x = _width - right.width;
			center.width = right.x - left.width;
			fill.x = border;
			fill.y = border;
			redrawProgress();
		}

		/**
		 * Ширина элемента.
		 */
		override public function get width():Number {
			return _width;
		}

		/**
		 * @private 
		 */
		override public function set width(value:Number):void {
			if (_width != value) {
				_width = value;
				center.x = left.width;
				right.x = _width - right.width;
				center.width = right.x - left.width;
				redrawProgress();
			}
		}

		/**
		 * Ширина границы.
		 */
		public function get border():int {
			return _border;
		}

		/**
		 * @private 
		 */
		public function set border(value:int):void {
			if (_border != value) {
				_border = value;
				fill.x = value;
				fill.y = value;
				redrawProgress();
			}
		}

		/**
		 * Значение прогресса элемента.
		 */
		public function get progress():Number {
			return _progress;
		}

		/**
		 * @private 
		 */
		public function set progress(value:Number):void {
			if (_progress != value) {
				_progress = value;
				redrawProgress();
			}
		}

		protected function redrawProgress():void {
			var state:Number = (_progress > 1) ? 1 : (_progress < 0) ? 0 : _progress;
			fill.graphics.clear();
			fill.graphics.beginBitmapFill(fillBmp, null, true);
			fill.graphics.drawRect(0, 0, (_width - 2*_border)*state, this.height - 2*border);
		}

	}
}
