package alternativa.gui.lod.simple {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.alternativagui;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	use namespace alternativagui;

	/**
	 * Лодируемый графический объект, выбирающий лод в зависимости от индекса лода. Индекс состояния задается только снаружи. 
	 * 
	 */	
	public class SimpleLODbitmap extends SimpleLODobject implements ISimpleLODobject {
		
		/**
		 * Вектор изображений. 
		 */		
		protected var bitmaps:Vector.<BitmapData>;
		
		/**
		 * Контейнер для изображения. 
		 */		
		protected var bitmap:Bitmap;
		
		/**
		 * Соотношение. 
		 */		
		protected var ratio:Number;
		
		/**
		 *  Максимальная ширина.
		 */		
		public var maxWidth:int;
		
		/**
		 * Маскимальная высота. 
		 */		
		public var maxHeight:int;
		
		/**
		 * Минимальная ширина. 
		 */		
		public var minWidth:int;
		
		/**
		 * Минимальная высота. 
		 */		
		public var minHeight:int;
		
		/**
		 * 
		 * @param bitmaps Лоды графики.
		 * 
		 */		
		public function SimpleLODbitmap(bitmaps:Vector.<BitmapData>) {
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
			
			maxWidth = bitmaps[0].width;
			maxHeight = bitmaps[0].height;
			
			minWidth = bitmaps[bitmaps.length-1].width;
			minHeight = bitmaps[bitmaps.length-1].height;
			
			ratio = maxHeight/maxWidth;
			
			LODindex = index;
		}
		
		/**
		 * Обновление размера. 
		 * 
		 */		
		protected function updateSize():void {
			_width = bitmap.bitmapData.width;
			_height = bitmap.bitmapData.height;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function calculateWidth(value:int):int {
			return _width;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function calculateHeight(value:int):int {
			return _height;
		}
		
		//----- ISimpleLODobject
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set LODindex(value:int):void {
			index = value;
			bitmap.bitmapData = bitmaps[index];
			
			updateSize();
		}

	}
}