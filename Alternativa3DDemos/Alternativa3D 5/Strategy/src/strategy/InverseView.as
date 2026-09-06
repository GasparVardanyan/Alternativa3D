package strategy {
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.display.View;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BitmapDataChannel;
	import flash.events.Event;
	import flash.filters.BitmapFilter;
	import flash.filters.DisplacementMapFilter;
	import flash.filters.DisplacementMapFilterMode;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	import flash.utils.getTimer;
	
	/**
	 *  View отраженной сцены с эффектом движения воды.
	 */ 
	public class InverseView extends View {	
		// Фильтр
		private var filter:BitmapFilter;
		// Карта для фильтра
		private var mapBitmapData:BitmapData;
		private var rect:Rectangle;
		// Смещение карты
		private var dx:int = 1;	
		private var time:Number;
		
		[Embed(source="water_52.jpg")] private static var mapBitmap:Class;
		private static const mapBmp:Bitmap = new Bitmap(new mapBitmap().bitmapData);
		[Embed(source="water.jpg")] private static var waterBitmap:Class;
		private static const waterBmp:Bitmap = new Bitmap(new waterBitmap().bitmapData);
		
		public function InverseView(camera:Camera3D=null, width:Number=0, height:Number=0)
		{
			super(camera, width, height);
			// Фоновый рисунок воды
			waterBmp.alpha = 0.5;
			addChild(waterBmp);
			createFilter();
			// Карта для фильтра
            mapBitmapData = mapBmp.bitmapData;
            rect = new Rectangle(0, 0, dx, mapBmp.height);
            time = getTimer();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		/**
		 * Создание фильтра.  
		 */		
		private function createFilter():void {
            filter = getBitmapFilter();
            filters = new Array(filter);
        }
		
	
		/**
		 * Инициализация фильтра.
		 */		
		private function getBitmapFilter():BitmapFilter {
            var mapBitmap:BitmapData = mapBmp.bitmapData;
            var mapPoint:Point       = new Point(0, 0);
            var componentX:uint      = BitmapDataChannel.GREEN;
            var componentY:uint      = BitmapDataChannel.RED;
            var scaleX:Number        = 20;
            var scaleY:Number        = 20;
            var mode:String          = DisplacementMapFilterMode.CLAMP;
            var color:uint           = 0;
            var alpha:Number         = 0;
            return new DisplacementMapFilter(mapBitmap,
                                             mapPoint,
                                             componentX,
                                             componentY,
                                             scaleX,
                                             scaleY,
                                             mode,
                                             color,
                                             alpha);
        }
		
        /**
         * Ежекадровая обработка. 
         */		        
        private function onEnterFrame(e:Event):void {
			
			var frameTime:Number = getTimer();
			
			if (frameTime - time > 30) {
				// Циклически смещаем карту. Обновляем фильтр.
				rect.x = mapBitmapData.width - dx;
	        	var byteArray:ByteArray  = mapBitmapData.getPixels(rect);
	        	mapBitmapData.scroll(dx, 0);
				byteArray.position = 0;  
				rect.x = 0;        	
	        	mapBitmapData.setPixels(rect, byteArray);
	   			filters = new Array(filter);
	   			time = frameTime;
   			}
		}
        
        /**
         * Корректирует положение фонового рисунка воды. 
         */        
        public function changeChildCoords():void {
        	waterBmp.x = this.x;
			waterBmp.y = this.y;
        }
        
        
		
	}
}