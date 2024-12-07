package alternativa.editor.propslib.loaders {
	import alternativa.engine3d.loaders.MaterialParams;
	import alternativa.engine3d.loaders.Parsed3DSData;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.TextureMapsBatchLoader;
	import alternativa.engine3d.loaders.TextureMapsInfo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.LoaderContext;

	[Event (name="complete", type="flash.events.Event")]
	/**
	 * Класс реализует загрузку данных из 3DS-файла, создание объектов, загрузку файлов тестур.
	 */	
	public class AdvancedLoader3DS extends EventDispatcher {

		// Список текстур, разбитых на составляющие textureFileName => TextureMapsInfo
		private var splittedImages:Object;
		// Пакетный загрузчик текстур
		private var textureBatchLoader:TextureMapsBatchLoader;
		
		private var loader:URLLoader;
		private var path:String;
		private var url:String;

		/**
		 * 3DS-данные ресурса
		 */		
		public var parsedData:Parsed3DSData;
		/**
		 * Загруженные битмапы текстур (materialName => BitmapData)
		 */		
		public var textures:Object;
		
		/**
		 * Создаёт новый экземпляр загрузчика.
		 * 
		 * @param url
		 * @param loadSplittedImages
		 * @param splittedImages
		 */
		public function AdvancedLoader3DS(url:String = null, loadSplittedImages:Boolean = false, splittedImages:Object = null) {
			super();
			if (url != null) {
				load(url, loadSplittedImages, splittedImages);
			}
		}

		/**
		 * Загружает данные.
		 * 
		 * @param url URL загружаемого 3DS-файла
		 * @param loadSplittedImages
		 * @param splittedImages
		 */
		public function load(url:String, loadSplittedImages:Boolean = false, splittedImages:Object = null):void {
			var idx:int = url.lastIndexOf("/");
			if (idx == -1) {
				path = "";
			} else {
				path = url.substring(0, idx + 1);
			}
			this.url = url;
			
			if (loader == null) {
				loader = new URLLoader();
			}
			this.splittedImages = splittedImages;
			loadSplittedImages ? loadSplittedImagesXML() : loadModel();
		}
		
		/**
		 * 
		 */
		private function loadSplittedImagesXML():void {
			if (splittedImages == null) {
				splittedImages = {};
			}
			loader.addEventListener(Event.COMPLETE, onSplittedImagesLoadingComplete);
			loader.dataFormat = URLLoaderDataFormat.TEXT;
			loader.load(new URLRequest(path + "images.xml"));
		}
		
		/**
		 * 
		 */
		private function loadModel():void {
			loader.addEventListener(Event.COMPLETE, onModelLoadingComplete);
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.load(new URLRequest(url));
		}
		
		/**
		 * 
		 */
		private function onSplittedImagesLoadingComplete(e:Event):void {
			parseImagesXML(XML(loader.data));
			loader.removeEventListener(Event.COMPLETE, onSplittedImagesLoadingComplete);
			loadModel();
		}
		
		/**
		 * 
		 */
		private function onModelLoadingComplete(e:Event):void {
			var parser:Parser3DS = new Parser3DS();
			parsedData = parser.parse(loader.data);
			
			// Подготавливаем пакет файлов текстур для загрузки, учитывая splittedImages
			var batch:Object = {};
			var textureMapsInfo:TextureMapsInfo;
			for (var materialName:String in parsedData.materials) {
				var mp:MaterialParams = parsedData.materials[materialName];
				if (mp.diffuseMap != null) {
					if (splittedImages != null) {
						batch[materialName] = splittedImages[mp.diffuseMap];
					} else {
						batch[materialName] = new TextureMapsInfo(mp.diffuseMap, mp.opacityMap);
					}
				}
			}
			
			textureBatchLoader = new TextureMapsBatchLoader();
			textureBatchLoader.addEventListener(Event.COMPLETE, onBatchLoadingComplete);
			textureBatchLoader.load(path, batch, null);
		}
		
		/**
		 * Разбирает файл описания разбитых текстур и формирует мапу splittedImages.
		 * 
		 * @param xml
		 */
		private function parseImagesXML(xml:XML):void {
			for each (var image:XML in xml.image) {
				var original:String = image.@name;
				splittedImages[original] = new TextureMapsInfo(image.attribute("new-name"), image.@alpha);
			}
		}
		
		/**
		 * 
		 */
		private function onBatchLoadingComplete(e:Event):void {
			textures = textureBatchLoader.textures;
			splittedImages = null;
			completeLoading();
		}
		
		/**
		 * 
		 */
		private function completeLoading():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
	}
}