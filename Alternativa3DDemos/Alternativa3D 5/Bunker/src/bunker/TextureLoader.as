package bunker {
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	import alternativa.utils.BitmapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	
	/**
	 * The base class for objects that can load high resolution textures.
	 */
	public class TextureLoader extends Mesh {
		// Bindings for textures and materials
		protected var bindings:Array;
		// Status message
		protected var loadingMessage:String;
		// Callback function which is called after all textures are loaded
		private var onLoadMethod:Function;
		// Index of the texture which is being loaded
		private var currentTextureIndex:int;
		// Transparency map loading flag
		private var loadingAlpha:Boolean;

		private var loader:Loader;
		private var request:URLRequest;
		private var loaderContext:LoaderContext;

		/**
		 * 
		 */
		public function TextureLoader(name:String = null) {
			super(name)
		}

		/**
		 * The method starts loading process.
		 * 
		 * @param onLoadMethod function which is called after all textures are loaded
		 */
		public function load(onLoadMethod:Function):String {
			if (bindings == null) {
				onLoadMethod.call();
			} else {
				this.onLoadMethod = onLoadMethod;
				request = new URLRequest();
				loaderContext = new LoaderContext(false, ApplicationDomain.currentDomain);
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
				currentTextureIndex = 0;
				loadNextTexture();
			}
			return loadingMessage;
		}
		
		/**
		 * The method is called after a texture is loaded.
		 */
		private function onLoadComplete(e:Event):void {
			var binding:TextureMaterialBinding = bindings[currentTextureIndex];
			if (loadingAlpha) {
				// A transparency map has been loaded, store it and load diffuse map.
				binding.alphaBitmapData = Bitmap(loader.content).bitmapData;
			} else {
				// A diffuse map has been loaded. If there's transparency map, fill alpha channel of the diffuse map.
				var bitmapData:BitmapData = Bitmap(loader.content).bitmapData;
				if (binding.alphaBitmapData != null) {
					bitmapData = BitmapUtils.mergeBitmapAlpha(bitmapData, binding.alphaBitmapData, true);
				}
				// Setting the texture to materials
				for each (var material:TextureMaterial in binding.materials) {
					material.texture = new Texture(bitmapData);
				}
				// Go to the next texture
				currentTextureIndex++;
			}
			loadNextTexture();
		}
		
		/**
		 * The method loads the next texture. If there's transparency map for the texture, it is loaded first.
		 */
		private function loadNextTexture():void {
			if (currentTextureIndex == bindings.length) {
				// All the textures are loaded, end of loading prcess
				complete();
			} else {
				var binding:TextureMaterialBinding = bindings[currentTextureIndex];
				if (loadingAlpha || binding.alphaUrl == null) {
					// Loading diffuse map
					request.url = binding.textureUrl;
					loadingAlpha = false;
				} else {
					// Loading transparency map
					request.url = binding.alphaUrl;
					loadingAlpha = true;
				}
				loader.load(request, loaderContext);
			}
		}
		
		/**
		 * Since it's a demo, the method simply discards the error and loads next texture.
		 */
		private function onLoadError(e:ErrorEvent):void {
			currentTextureIndex++;
			loadingAlpha = false;
			loadNextTexture();
		}
		
		/**
		 * The method is called after all the textures are loaded.
		 */
		private function complete():void {
			onLoadMethod.call();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			onLoadMethod = null;
			loader = null;
			bindings = null;
		}
	}
}