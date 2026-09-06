package alternativa.gui.lod.auto {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.alternativagui;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	use namespace alternativagui;
	
	/**
	 * Лодируемый графический объект с поддержкой мышиных событий, выбирающий лод в зависимости от заданных ему размеров. 
	 * 
	 */	
	public class AutoLODactiveBitmap extends AutoLODactiveObject {
		
		protected var bitmaps:Vector.<BitmapData>;
		protected var bitmap:Bitmap;
		
		protected var ratio:Number;
		public var maxWidth:int;
		public var maxHeight:int;
		
		/**
		 * 
		 * @param bitmaps Лоды графики.
		 * 
		 */		
		public function AutoLODactiveBitmap(bitmaps:Vector.<BitmapData>) {
			this.bitmaps = bitmaps;
			
			maxWidth = bitmaps[0].width;
			maxHeight = bitmaps[0].height;
			ratio = maxHeight/maxWidth;
			
			bitmap = new Bitmap();
			addChild(bitmap);
			
			for (var i:int = 0; i < bitmaps.length; i++) {
				limitsV.push(bitmaps[i].height);
			}
			// Битмапа для диапазона [0; limitsH[length-1])
			this.bitmaps.push(bitmaps[bitmaps.length-1]);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			bitmap.bitmapData = bitmaps[indexV];
		}
		
		/**
		 * Ширина.
		 * 
		 */		
		override public function set width(value:Number):void {
			super.width = Math.min(value, maxWidth);
			super.height = ratio*_width;
			_width = bitmap.bitmapData.width;
			_height = bitmap.bitmapData.height;
			
			/*this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000, 1);
			this.graphics.drawRect(0, 0, _width, _height);*/
		}
		
		/**
		 * Высота.
		 * 
		 */		
		override public function set height(value:Number):void {
			super.height = Math.min(value, maxHeight);
			super.width = _height/ratio;
			_width = bitmap.bitmapData.width;
			_height = bitmap.bitmapData.height;
			
			/*this.graphics.clear();
			this.graphics.lineStyle(1, 0xff0000, 1);
			this.graphics.drawRect(0, 0, _width, _height);*/
		}

	}
}