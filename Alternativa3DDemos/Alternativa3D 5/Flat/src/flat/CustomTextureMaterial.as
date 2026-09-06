package flat {
	import alternativa.types.Texture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Shape;
	import flash.geom.Matrix;
	
	import flat.listbox.TextureListBox;
	
	/**
	 * Класс материала со сменной дифузной текстурой и постоянной картой освещенности. 
	 */ 
	public class CustomTextureMaterial extends LoaderTextureMaterial {
		// Текстура
		private var _diffuse:BitmapData;
		// Свет
		private var _light:BitmapData;
		// Ccылка на листбокс с текстурами
		private var _textureListBox:TextureListBox;
		private var shape:Shape = new Shape();
		
		[Embed(source="listbox/textures/concrete.jpg")] private static const bmpDefault:Class;
		private static const defaultDiffuse:Bitmap = new bmpDefault();
		
		public function CustomTextureMaterial(listBox:TextureListBox, lightMap:Bitmap, texture:Texture, alpha:Number=1, repeat:Boolean=false, smooth:Boolean=false, blendMode:String=BlendMode.NORMAL, wireThickness:Number=-1, wireColor:uint=0, precision:Number=10) {
			super(texture, alpha, repeat, smooth, blendMode, wireThickness, wireColor, precision);
			this.precision = 3;
			this.smooth = true;
			_textureListBox = listBox;
			_light = lightMap.bitmapData;
			updateDiffuse(defaultDiffuse.bitmapData);			
		}
		
		/**
		 * Обновление текстуры материала после загрузки лайтмап с высоким разрешением.
		 */ 
		override public function updateAfterLoad(bitmapNew:BitmapData):void {
			
			_light = bitmapNew;
			this.updateDiffuse(this.diffuse);
		} 
		
		public function get diffuse():BitmapData {
			return _diffuse;
		}
		
		public function set diffuse(value:BitmapData):void {
			_diffuse = value;
		}
		
		public function get light():BitmapData {
			return _light;
		}
		
		public function set light(value:BitmapData):void {
			_light = value;
		}
		
		public function get textureListBox():TextureListBox {
			return _textureListBox;
		}
		
		public function set textureListBox(value:TextureListBox):void {
			_textureListBox = value;
		}
		
		/**
		 * Смена дифузы.
		 */ 
		public function updateDiffuse(diffuseNew:BitmapData):void {
			
			_diffuse = diffuseNew;
			update();
		}
		/**
		 * Обновление текстуры материала после смены дифузы.
		 */ 
		private function update():void {
			
			var coef:Number = texture.width/light.width;
			if (diffuse != null) {
				// Отрисовываем дифузу в shape
				shape.graphics.clear();			
				shape.graphics.beginBitmapFill(diffuse, null, true, true);
				shape.graphics.drawRect(0, 0, texture.width, texture.height);
				shape.graphics.endFill();
				// Отрисовываем shape в текстуру				
				texture.bitmapData.draw(shape, null, null, BlendMode.NORMAL, null, true);
			}
			// Прижигаем свет
			texture.bitmapData.draw(light, new Matrix(coef, 0, 0, coef), null, BlendMode.MULTIPLY);
				
		}
		
	}
}