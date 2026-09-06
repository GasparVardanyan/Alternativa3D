package alternativa.gui.lod {
	
	import __AS3__.vec.Vector;
	
	import alternativa.gui.base.GUIobject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.filters.ConvolutionFilter;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 * Объект, представляющий текстуру в виде последовательности её уменьшенных копий.
	 * Каждая следующая в два раза меньше предыдущей. Последняя имеет размер 1х1 пиксел.
	 * Чем меньше ширина отрисовываемого объект, тем меньшая текстура выбирается.
	 * Это позволяет получить лучший визуальный результат и большую производительность.
	 */
	public class ResizeableBitmap extends GUIobject {
		
		static protected const filter:ConvolutionFilter = new ConvolutionFilter(2, 2, [1, 1, 1, 1], 4, 0, false, true);
		static protected const point:Point = new Point();
		static protected const matrix:Matrix = new Matrix();
		static protected const rect:Rectangle = new Rectangle();
		
		/**
		 * Мип-текстуры.
		 */
		public var textures:Vector.<BitmapData> = new Vector.<BitmapData>();
		
		/**
		 * Количество мип-текстур.
		 */
		public var num:int;
		
		/**
		 * Количество лодов изображения. 
		 */		
		protected var maxTextureNum:int;
		
		/**
		 * Соотношение. 
		 */		
		public var ratio:Number;
		
		/**
		 * Максимальная ширина объекта. 
		 */		
		public var maxWidth:int = int.MAX_VALUE;
		
		/**
		 * Максимальная высота объекта. 
		 */		
		public var maxHeight:int = int.MAX_VALUE;
		
		/**
		 * Растягивать текстуру больше чем оригинальный размер или нет.
		 */		
		protected var zoomIn:Boolean;
		
		protected var bitmap:Bitmap;
		
		/**
		 * 
		 * @param texture Текстура.
		 * @param zoomIn Растягивать текстуру больше чем оригинальный размер или нет.
		 * @param maxTextureNum Количество лодов.
		 * 
		 */		
		public function ResizeableBitmap(texture:BitmapData, zoomIn:Boolean = true, maxTextureNum:int = int.MAX_VALUE) {
			this.zoomIn = zoomIn;
			this.maxTextureNum = maxTextureNum;
			
			bitmap = new Bitmap(texture, PixelSnapping.AUTO, true);
			textures = new Vector.<BitmapData>();
			addChild(bitmap);
			
			if (texture != null) {
				bitmapData = texture;
			}
		}
		
		/**
		 * Исходное изображние. 
		 * 
		 */		
		public function set bitmapData(texture:BitmapData):void {
			num = 0;
			//textures = new Vector.<BitmapData>();
			textures.length = 0;
			
			_width = texture.width;
			_height = texture.height;
			
			ratio = _height/_width;
			
			if (!zoomIn) {
				maxWidth = _width;
				maxHeight = _height;
			}
			var bmp:BitmapData = new BitmapData(_width, _height, texture.transparent);
			var current:BitmapData = textures[num++] = texture;
			filter.preserveAlpha = !texture.transparent;
			var w:Number = rect.width = _width, h:Number = rect.height = _height;
			while (num < maxTextureNum && w > 1 && h > 1 && rect.width > 1 && rect.height > 1) {
				bmp.applyFilter(current, rect, point, filter);
				rect.width = w >> 1;
				rect.height = h >> 1;
				matrix.a = rect.width/w;
				matrix.d = rect.height/h;
				w *= 0.5;
				h *= 0.5;
				current = new BitmapData(rect.width, rect.height, texture.transparent, 0);
				current.draw(bmp, matrix, null, null, null, false);					
				textures[num++] = current;
			}
			bmp.dispose();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			bitmap.bitmapData = textures[getLevel(_width)];
			bitmap.smoothing = true;
			bitmap.width = _width;
			bitmap.height = _height;
		}
		
		/**
		 * Получение мип-уровня в зависимости от новой ширины битмапа.
		 * @param newWidth Новая ширина битмапа.
		 * @return Индекс в списке мип-текстур textures.
		 */
		protected function getLevel(newWidth:int):int {
			if (newWidth >= BitmapData(textures[0]).width) {
				var level:int = 0;
			} else if (newWidth <= BitmapData(textures[num-1]).width) {
				level = num-1;
			} else {
				for (var i:int = 0; i < textures.length; i++) {
				var limit:int = (BitmapData(textures[i]).width + BitmapData(textures[i+1]).width)*0.35;
					if (newWidth >= limit) {
						level = i;
						break;
					} else if (newWidth >= BitmapData(textures[i+1]).width) {
						level = i+1;
						break;
					}				
				}
			}
			
			//trace("level: " + level);
			return level;
		}
		
		/**
		 * Ширина. 
		 * 
		 */		
		override public function set width(value:Number):void {
			_width = (zoomIn) ? value : Math.min(value, maxWidth);
			_height = _width*ratio;
			draw();
		}
		
		/**
		 * Высота.
		 * 
		 */		
		override public function set height(value:Number):void {
			_height = (zoomIn) ? value : Math.min(value, maxHeight);
			_width = _height/ratio;
			draw();
		}
		
	}
}
