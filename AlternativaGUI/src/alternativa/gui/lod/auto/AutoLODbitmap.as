package alternativa.gui.lod.auto {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.auto.AutoLODobject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	use namespace alternativagui;
	
	/**
	 * Лодируемый графический объект, выбирающий лод в зависимости от заданных ему размеров.
	 * 
	 */	
	public class AutoLODbitmap extends AutoLODobject {
		
		/**
		 * Лоды графики. 
		 */		
		protected var bitmaps:Vector.<BitmapData>;
		
		/**
		 * Вывод графики. 
		 */		
		protected var bitmap:Bitmap;
		
		/**
		 * Соотношение. 
		 */		
		protected var ratio:Number;
		
		/**
		 * Максимальная ширина. 
		 */		
		public var maxWidth:int;
		
		/**
		 * Максимальная высота. 
		 */		
		public var maxHeight:int;
		
		/**
		 * 
		 * @param bitmaps Лоды графики.
		 * 
		 */		
		public function AutoLODbitmap(bitmaps:Vector.<BitmapData>) {
			bitmap = new Bitmap();
			addChild(bitmap);
			
			states = bitmaps;
		}
		
		/**
		 * Лоды графики. 
		 * 
		 */		
		public function get states():Vector.<BitmapData> {
			return bitmaps;
		}
		public function set states(bitmaps:Vector.<BitmapData>):void {
			this.bitmaps = bitmaps;
			
			bitmap.bitmapData = bitmaps[0];
			
			maxWidth = bitmaps[0].width;
			maxHeight = bitmaps[0].height;
			ratio = maxHeight/maxWidth;
			
			limitsV = new Vector.<int>();
			
			for (var i:int = 0; i < bitmaps.length; i++) {
				limitsV.push(bitmaps[i].height);
			}
			
			// Битмапа для диапазона [0; limitsH[length-1])
			this.bitmaps.push(bitmaps[bitmaps.length-1]);
			
			width = _width;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			bitmap.bitmapData = bitmaps[indexV];
		}
		
		/**
		 * Обновление размеров. 
		 * 
		 */		
		private function updateSize():void {
			_width = bitmap.bitmapData.width;
			_height = bitmap.bitmapData.height;
		}
		
		/**
		 * Ширина. После вызывается updateSize().  
		 * 
		 */		
		override public function set width(value:Number):void {
			super.width = Math.min(value, maxWidth);
			super.height = ratio*_width;
			
			updateSize();
		}
		
		/**
		 * Высота. После вызывается updateSize().  
		 * 
		 */		
		override public function set height(value:Number):void {
			super.height = Math.min(value, maxHeight);
			super.width = _height/ratio;
			
			updateSize();
		}
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		override public function set LODindexV(index:int):void {
			super.LODindexV = index;
			
			draw();
			
			updateSize();
		}

	}
}