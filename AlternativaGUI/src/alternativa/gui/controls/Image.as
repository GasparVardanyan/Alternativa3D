package alternativa.gui.controls {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	use namespace alternativagui;
	
	/**
	 * Примитивный объект изображения. Ширина и высота берется у bitmapData.
	 * 
	 */	
	public class Image extends GUIobject {
		
		/**
		 * Экранный объект, представляющий растровое изображение.
		 */		
		protected var bitmap:Bitmap;
		
		public function Image(bitmapData:BitmapData=null) {
			super();
			bitmap = new Bitmap();
			addChild(bitmap);
			
			this.bitmapData = bitmapData;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function resize(width:int, height:int):void {}
		
		/**
		 * Ширина не изменяется. 
		 * 
		 */		
		override public function set width(value:Number):void {}
	    
		/**
		 * Высота не изменяется.
		 * 
		 */		
	    override public function set height(value:Number):void {}
	    
		/**
		 * Изображение. 
		 * 
		 */		
	    public function get bitmapData():BitmapData {
	    	return bitmap.bitmapData;
	    }
	    public function set bitmapData(value:BitmapData):void {
			this.bitmap.bitmapData = value;
			
			if (value != null){
				_width = value.width;
				_height = value.height;
			}
		}

	}
}