package alternativa.editor.propslib.loaders {
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.loaders.TextureMapsLoader;
	
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	public class SpriteLoader extends ObjectLoader {
		
		private var file:String;
		private var alpha:String;
		private var originX:Number;
		private var originY:Number;
		private var scale:Number;
		private var path:String;
		
		private var loader:TextureMapsLoader;
		
		public var sprite:Sprite3D;

		public function SpriteLoader(path:String, file:String, alpha:String, originX:Number, originY:Number, scale:Number) {
			super();
			this.path = path;
			this.file = file;
			this.alpha = alpha == "" ? null : alpha;
			this.originX = originX;
			this.originY = originY;
			this.scale = scale;
		}
		
		override public function load():void {
			loader = new TextureMapsLoader(path + file, alpha == null ? null : path + alpha);
			loader.addEventListener(Event.COMPLETE, onLoadingComplete);
		}
		
		private function onLoadingComplete(e:Event):void {
			sprite = new Sprite3D();
			sprite.texture = loader.bitmapData;
			sprite.originX = originX;
			sprite.originY = originY;
			sprite.matrix.prependScale(scale, scale, scale);
			loader.unload();
			loader = null;
			complete();
		}
		
	}
}