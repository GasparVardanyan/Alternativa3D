package flat {
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	import alternativa.utils.BitmapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	
	/**
	 * Класс материала с фоновой загрузкой текстуры высокого разрешения.	 
	 */ 
	public class LoaderTextureMaterial extends TextureMaterial {
		// URL карты прозрачности
		private var _urlAlpha:String = "";
		// URL диффузной текстуры
		private var _url:String; 
		// Временное хранилище для карты прозрачности
		private var _alphaBitmapData:BitmapData;
		
		public function LoaderTextureMaterial(texture:Texture, alpha:Number=1, repeat:Boolean=false, smooth:Boolean=false, blendMode:String=BlendMode.NORMAL, wireThickness:Number=-1, wireColor:uint=0, precision:Number=10) {
			super(texture, alpha, repeat, smooth, blendMode, wireThickness, wireColor, precision);
		}
		
		public function get url():String {
			return _url;
		} 	
		
		public function set url(value:String):void {
			_url = value;
		}
		
		public function get urlAlpha():String {
			return _urlAlpha;
		}
		
		public function set urlAlpha(value:String):void {
			_urlAlpha = value;
		}
		
		public function set alphaBitmapData(value:BitmapData):void {
			_alphaBitmapData = value;
		}
		
		/**
		 * Обновление текстуры материала после загрузки текстуры с высоким разрешением.
		 * @param bitmapNew текстура с высоким разрешением
		 */ 
		public function updateAfterLoad(bitmapNew:BitmapData):void {
			
			if (_alphaBitmapData != null) { 
				var bitmapData:BitmapData = BitmapUtils.mergeBitmapAlpha(bitmapNew, _alphaBitmapData, true);
				this.texture.bitmapData.draw(bitmapData, null, null, BlendMode.NORMAL, null, true);
			}
			else {
				this.surface.material = new TextureMaterial(new Texture(bitmapNew), 1, false, true);
			}
		}
		
	}
}