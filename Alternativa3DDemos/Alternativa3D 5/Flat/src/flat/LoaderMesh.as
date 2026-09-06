package flat {
	import alternativa.engine3d.core.Mesh;
	
	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.net.URLRequest;
	
	/**
	 * Базовый класс для объектов с фоновой загрузкой текстур высокого разрешения.
	 */
	public class LoaderMesh extends Mesh {
		// Список материалов, для которых загружаются текстуры
		protected var materials:Array;
		// Индекс текущей загружаемой текстуры
		private var currentTextureIndex:int = -1;
		// Индикатор загрузки карты прозрачности
		private var loadingAlpha:Boolean = false;
		private var onLoadMethod:Function;
		private var request:URLRequest;
		private var loader:Loader;
		
		/**
		 * 
		 */		
		public function LoaderMesh(name:String=null) {
			super(name);
		}
	
		/**
		 * Метод запускает загрузку текстур.
		 * @param onLoadMethod функция, которая будет вызвана по окончании загрузки всех текстур объекта
		 */	
		public function load(onLoadMethod:Function):String {
			
			if (materials.length == 0) {
				onLoadMethod.call();
			} else {
			
				this.onLoadMethod = onLoadMethod;
				request = new URLRequest();
				loader = new Loader();
				loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onLoadComplete);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				loader.contentLoaderInfo.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
				currentTextureIndex = 0;
				loadNextTexture();
				
			}
			return "";
	
		}
		
		/**
		 * Загрузка очередной текстуры. 
		 */
		private function loadNextTexture():void {
			if (currentTextureIndex == materials.length) {
				// Все текстуры получены, завершаем процесс загрузки
				complete();
			} 
			else {
				var object:* = materials[currentTextureIndex];
				if (object.url != null) {
					if ((object.urlAlpha != "")&&(!loadingAlpha)) {
						loadingAlpha = true;
						request.url = object.urlAlpha; 
						loader.load(request);
					}
					else {
						// Загрузка самой текстуры
						request.url = object.url;
						loader.load(request);
						loadingAlpha = false;
					}
				}
				else {
					currentTextureIndex++;
					loadNextTexture();
				}
			}
		}
		
		/**
		 * Обработка окончания загрузки файла текстуры.
		 */
		private function onLoadComplete(e:Event):void {
			
			if (loadingAlpha) {
				materials[currentTextureIndex].alphaBitmapData = (loader.content as Bitmap).bitmapData;
			} else {	
				materials[currentTextureIndex].updateAfterLoad((loader.content as Bitmap).bitmapData);
				currentTextureIndex++;	
			}
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
		
	}
}