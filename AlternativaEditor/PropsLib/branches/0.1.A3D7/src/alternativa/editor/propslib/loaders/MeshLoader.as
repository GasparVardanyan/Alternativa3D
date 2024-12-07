package alternativa.editor.propslib.loaders {
	import __AS3__.vec.Vector;
	
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.TextureMapsBatchLoader;
	
	import flash.events.Event;
	import flash.system.LoaderContext;
	
	
	public class MeshLoader extends ObjectLoader {
		
		private var path:String;
		private var fileName:String;
		private var objectName:String;
		// textureName => TextureMapsInfo
		private var textures:Object;
		private var splittedImages:Object;
		
		private var loader3DS:AdvancedLoader3DS;
		private var texturesLoader:TextureMapsBatchLoader;
		private var loaderContext:LoaderContext;
		
		public var object:Mesh;
		public var bitmaps:Object;
		
		public function MeshLoader(path:String, fileName:String, objectName:String, textures:Object, splittedImages:Object) {
			super();
			this.path = path;
			this.fileName = fileName;
			this.objectName = objectName;
			this.textures = textures;
			this.splittedImages = splittedImages;
		}
		
		override public function load():void {
			this.loaderContext = loaderContext;
			loader3DS = new AdvancedLoader3DS();
			loader3DS.addEventListener(Event.COMPLETE, on3DSLoadingComplete);
			loader3DS.load(path + fileName, false, splittedImages);
		}
		
		private function on3DSLoadingComplete(e:Event):void {
			var objects:Vector.<Object3D> = loader3DS.parsedData.objects;
			var objectIdx:int = -1;
			object = null;
			if (objectName != null) {
				for (var i:int = 0; i < objects.length; i++) {
					if (objects[i].name == objectName) {
						objectIdx = i;
						break;
					}
				}
			}
			
			if (objectIdx == -1) {
				objectIdx = 0;
			}
			object = objects[objectIdx] as Mesh;
			
			object.perspectiveCorrection = true;
			object.clipping = 2;
			
			object.texture = loader3DS.textures[loader3DS.parsedData.objectMaterials[objectIdx][0]];
			
			if (textures != null) {
				texturesLoader = new TextureMapsBatchLoader();
				texturesLoader.addEventListener(Event.COMPLETE, onTexturesLoadingComplete);
				texturesLoader.load(path, textures, loaderContext);
			} else {
				complete();
			}
		}
		
		private function onTexturesLoadingComplete(e:Event):void {
			bitmaps = texturesLoader.textures;
			complete();
		}
		
		override public function toString():String {
			return "[MeshLoader path=" + path + ", objectName=" + objectName + ", textures=" + textures + "]";
		}
		
	}
}