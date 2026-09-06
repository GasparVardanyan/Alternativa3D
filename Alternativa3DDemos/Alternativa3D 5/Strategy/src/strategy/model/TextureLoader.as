package strategy.model {
	import alternativa.engine3d.core.Object3D;
	import alternativa.types.Texture;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * Базовый класс для объектов с фоновой загрузкой текстур высокого разрешения.
	 */
	public class TextureLoader extends Object3D {	
		protected var urls:Array;
		protected var materials:Array;
		private var onLoadMethod:Function;
		private var request:URLRequest;
		private var loader:Loader;
		private var currentTextureIndex:int = -1;
		
		public function TextureLoader(name:String=null) {
			super(name);
		}
				
		/**
		 * Метод запускает загрузку текстур.
		 * @param onLoadMethod функция, которая будет вызвана по окончании загрузки всех текстур объекта
		 */	
		public function load(onLoadMethod:Function):String {
			
			if (urls.length == 0) {
				onLoadMethod.call();
			}
			else {
			
				this.onLoadMethod = onLoadMethod;
				request = new URLRequest();
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.DISK_ERROR, onLoadError);
				currentTextureIndex = 0;
				loadNextTexture();
				
			}
			return "";
	
		}
	
		/**
		 * Загрузка очередной текстуры. 
		 */
		private function loadNextTexture():void {
			if (currentTextureIndex == urls.length) {
				// Все текстуры получены, завершаем процесс загрузки
				complete();
			} 
			else {
								
				// Загрузка самой текстуры
				request.url = urls[currentTextureIndex];
				loader.load(request);
			}
		}
		
		/**
		 * Обработка окончания загрузки файла текстуры.
		 */
		private function onLoadComplete(e:Event):void {
			
			updateAfterLoad((loader.content as Bitmap).bitmapData);
			currentTextureIndex++;	
			loadNextTexture();
		}
		
		/**
		 * Обработка ошибки при загрузке. Выполняется простой переход к загрузке следующей текстуры.
		 */
		private function onLoadError(e:ErrorEvent):void {
			currentTextureIndex++;
			loadNextTexture();
		}
		
		/**
		 * Завершение загрузки всех текстур.
		 */
		private function complete():void {
			onLoadMethod.call();
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, onLoadComplete);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			loader.contentLoaderInfo.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			onLoadMethod = null;
			loader = null;
		}
		
		/**
		 * Обновляет текстуру материалов после загрузки. 
		 * @param bitmapData
		 */		
		public function updateAfterLoad(newBitmapData:BitmapData):void {
			
			var texture:Texture = new Texture(newBitmapData);
			var list:Array = materials[currentTextureIndex];
			var len:int = list.length;
			for (var i:int = 0; i < len; i++) {
				list[i].texture = texture;				
			}
				
				
		}
	}
		
	
}