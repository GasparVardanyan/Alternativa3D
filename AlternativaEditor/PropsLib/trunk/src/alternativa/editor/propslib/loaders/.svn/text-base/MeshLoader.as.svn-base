package alternativa.editor.propslib.loaders {
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.loaders.Loader3DS;
	import alternativa.engine3d.loaders.TextureMapsBatchLoader;
	import alternativa.types.Map;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.system.LoaderContext;
	
	/**
	 * 
	 */
	public class MeshLoader extends ObjectLoader {
		
		private var url:String;
		private var objectName:String;
		// Map<textureName => TextureMapsInfo>
		private var textures:Map;
		
		private var loader3DS:Loader3DS;
		private var texturesLoader:TextureMapsBatchLoader;
		private var loaderContext:LoaderContext;
		
		public var object:Mesh;
		public var bitmaps:Map;
		
		/**
		 * 
		 * @param url
		 * @param objectName
		 * @param textures
		 */
		public function MeshLoader(url:String, objectName:String, textures:Map) {
			super();
			this.url = url;
			this.objectName = objectName;
			this.textures = textures;
		}
		
		/**
		 * 
		 */
		override public function load(loaderContext:LoaderContext):void {
			this.loaderContext = loaderContext;
			loader3DS = new Loader3DS();
			loader3DS.addEventListener(Event.COMPLETE, on3DSLoadingComplete);
			loader3DS.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			loader3DS.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
			loader3DS.smooth = true;
			loader3DS.repeat = false;
			loader3DS.load(url, loaderContext);
		}
		
		/**
		 * 
		 */
		private function on3DSLoadingComplete(e:Event):void {
			if (objectName != null) {
				object = loader3DS.content.getChildByName(objectName, true) as Mesh;
			} else {
				object = loader3DS.content.children.peek() as Mesh;
			}
			
			loader3DS.removeEventListener(Event.COMPLETE, on3DSLoadingComplete);
			loader3DS.removeEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			loader3DS.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
			loader3DS = null;
			
			if (textures != null) {
				texturesLoader = new TextureMapsBatchLoader();
				texturesLoader.addEventListener(Event.COMPLETE, onTexturesLoadingComplete);
				texturesLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
				texturesLoader.load("", textures, loaderContext);
			} else {
				complete();
			}
		}
		
		/**
		 * 
		 */
		private function onTexturesLoadingComplete(e:Event):void {
			bitmaps = texturesLoader.textures;
			
			texturesLoader.removeEventListener(Event.COMPLETE, onTexturesLoadingComplete);
			texturesLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			texturesLoader = null;
			
			complete();
		}
		
		/**
		 * 
		 */
		override public function toString():String {
			return "[MeshLoader url=" + url + ", objectName=" + objectName + ", textures=" + textures + "]";
		}
		
	}
}