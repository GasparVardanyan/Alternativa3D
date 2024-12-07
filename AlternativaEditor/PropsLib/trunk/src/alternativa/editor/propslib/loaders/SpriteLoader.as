package alternativa.editor.propslib.loaders {
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.loaders.TextureMapsLoader;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.system.LoaderContext;
	
	/**
	 * 
	 */
	public class SpriteLoader extends ObjectLoader {
		
		private var file:String;
		private var alpha:String;
		private var originX:Number;
		private var originY:Number;
		private var scale:Number;
		
		private var loader:TextureMapsLoader;
		
		public var sprite:Sprite3D;

		/**
		 * 
		 * @param file
		 * @param alpha
		 * @param originX
		 * @param originY
		 * @param scale
		 */
		public function SpriteLoader(file:String, alpha:String, originX:Number, originY:Number, scale:Number) {
			super();
			this.file = file;
			this.alpha = alpha;
			this.originX = originX;
			this.originY = originY;
			this.scale = scale;
		}
		
		/**
		 * 
		 */
		override public function load(loaderContext:LoaderContext):void {
//			trace("[SpriteLoader::load] file=" + file + ", alpha=" + alpha);
			loader = new TextureMapsLoader(file, alpha, loaderContext);
			loader.addEventListener(Event.COMPLETE, onLoadingComplete);
			loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
		}
		
		/**
		 * 
		 */
		private function onLoadingComplete(e:Event):void {
			sprite = new Sprite3D();
			sprite.material = new SpriteTextureMaterial(new Texture(loader.bitmapData), 1, true, BlendMode.NORMAL, originX, originY);
			sprite.scaleX = scale;
			sprite.scaleY = scale;
			sprite.scaleZ = scale;
			loader.unload();
			loader.removeEventListener(Event.COMPLETE, onLoadingComplete);
			loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			loader = null;
			complete();
		}
		
	}
}