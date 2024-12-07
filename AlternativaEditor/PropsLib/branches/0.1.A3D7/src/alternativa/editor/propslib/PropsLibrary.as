package alternativa.editor.propslib {
	import alternativa.editor.propslib.loaders.MeshLoader;
	import alternativa.editor.propslib.loaders.SpriteLoader;
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.loaders.TextureMapsInfo;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event (name="complete", type="flash.events.Event")]
	/**
	 * 
	 */
	public class PropsLibrary extends EventDispatcher {
		/**
		 * Наименование библиотеки.
		 */		
		public var name:String;
		/**
		 * Корневая группа библиотеки.
		 */
		public var rootGroup:PropGroup;
		
		private var loaders:Array;
		private var currPropObjectLoader:PropObjectLoader;
		private var configLoader:URLLoader;
		private var path:String;
		private var splittedImages:Object;
		
		/**
		 * 
		 */
		public function PropsLibrary(path:String = null, useSplittedImages:Boolean = false) {
			if (path != null) {
				load(path, useSplittedImages);
			}
		}
		
		/**
		 * 
		 * @param path
		 */
		public function load(path:String, useSplittedImages:Boolean = false):void {
			if (path.length > 0 && path.charAt(path.length - 1) != "/") {
				path += "/";
			}
			this.path = path;
			configLoader = new URLLoader();
			splittedImages = null;
			if (useSplittedImages) {
				loadXML("images.xml", onSplittedImagesXMLLoadingComplete);
			} else {
				loadXML("library.xml", onLibraryXMLLoadingComplete);
			}
		}
		
		/**
		 * 
		 */
		private function loadXML(fileName:String, callback:Function):void {
			configLoader.addEventListener(Event.COMPLETE, callback);
			configLoader.load(new URLRequest(path + fileName));
		}
		
		/**
		 * 
		 */
		private function onSplittedImagesXMLLoadingComplete(e:Event):void {
			splittedImages = {};
			parseImagesXML(XML(configLoader.data));
			configLoader.removeEventListener(Event.COMPLETE, onSplittedImagesXMLLoadingComplete);
			loadXML("library.xml", onLibraryXMLLoadingComplete);
		}
		
		/**
		 * Разбирает файл описания разбитых текстур и формирует мапу splittedImages.
		 * 
		 * @param xml
		 */
		private function parseImagesXML(xml:XML):void {
			splittedImages = {};
			for each (var image:XML in xml.image) {
				var original:String = image.@name;
				splittedImages[original] = new TextureMapsInfo(image.attribute("new-name"), image.@alpha);
			}
		}
		
		/**
		 * 
		 */
		private function onLibraryXMLLoadingComplete(e:Event):void {
			var xml:XML = XML(configLoader.data);
			var propXML:XML;
			name = xml.@name;
			
			loaders = [];
			rootGroup = parseGroup(xml);
			
//			trace("[PropsLibrary] parsing complete. Loaders created:", loaders.length);
			
			loadPropObject();
		}
		
		private function loadPropObject():void {
			currPropObjectLoader = loaders.pop();
			currPropObjectLoader.loader.addEventListener(Event.COMPLETE, onPropObjectLoadingComplete);
			currPropObjectLoader.loader.load();
		}
		
		private function onPropObjectLoadingComplete(e:Event):void {
			currPropObjectLoader.loader.removeEventListener(Event.COMPLETE, onPropObjectLoadingComplete);
			if (currPropObjectLoader.propObject is PropMesh) {
				var propMesh:PropMesh = currPropObjectLoader.propObject as PropMesh;
				var meshLoader:MeshLoader = currPropObjectLoader.loader as MeshLoader;
				propMesh.object3d = meshLoader.object;
				propMesh.object3d.boundBox = propMesh.object3d.calculateBoundBox();
				propMesh.bitmaps = meshLoader.bitmaps;
			} else {
				var sprite:Sprite3D = (currPropObjectLoader.loader as SpriteLoader).sprite;
				currPropObjectLoader.propObject.object3d = sprite;
				sprite.boundBox = sprite.calculateBoundBox();
			}
			
			if (loaders.length > 0) {
				loadPropObject();
			} else {
				currPropObjectLoader = null;
				dispatchEvent(new Event(Event.COMPLETE));
//				trace("[PropsLibrary] Library loaded");
				
//				trace("[PropsLibrary] Checking...\n");
//				checkLibrary(rootGroup);
			}
		}
		
		private function checkLibrary(group:PropGroup):void {
//			trace("Group:", group.name);
			if (group.props != null) {
				for each (var prop:PropData in group.props) {
					trace(prop);
				}
			}
			
			if (group.groups != null) {
				for each (group in group.groups) {
					checkLibrary(group);
				}
			}
		}
		
		/**
		 * 
		 */
		private function parseGroup(groupXML:XML):PropGroup {
//			trace("[PropsLibrary::parseGroup]", groupXML.@name);
			var group:PropGroup = new PropGroup(groupXML.@name);
			
			var element:XML;
			for each (element in groupXML.prop) {
				group.addProp(parseProp(element));
			}
			
			for each (element in groupXML.elements("prop-group")) {
				group.addGroup(parseGroup(element));
			}
			
			return group;
		}
		
		/**
		 * 
		 */
		private function parseProp(propXML:XML):PropData {
//			trace("[PropsLibrary::parseProp]", propXML.@name);
			var prop:PropData = new PropData(propXML.@name);
			var xmlList:XMLList;
			if ((xmlList = propXML.state).length() > 0) {
				for each (var stateXML:XML in xmlList) {
					prop.addState(parseState(stateXML));
				}
			} else {
				prop.statelessData = parseStatelessData(propXML);
			}
			return prop;
		}
		
		/**
		 * Создаёт объект, описывающий состояние пропа, которое может быть представлено в виде единственного трёхмерного оьъекта или набора LOD'ов.
		 * 
		 * @param xml элемент prop или state
		 */
		private function parseStatelessData(xml:XML):StatelessObject {
			var data:StatelessObject = new StatelessObject(null, null);
			var pol:PropObjectLoader;
			if (xml.lod.length() > 0) {
				// Указаны LOD'ы для пропа/состояния
				var lods:Array = [];
				for each (var lodXML:XML in xml.lod) {
					pol = createPropObjectLoader(lodXML);
					loaders.push(pol);
					var lod:PropLOD = new PropLOD(Number(lodXML.@distance), pol.propObject);
					lods.push(lod);
				}
				data.lods = lods;
			} else {
				// LOD'ов нет, разбирается информация об объекте
				pol = createPropObjectLoader(xml);
				loaders.push(pol);
				data.object = pol.propObject;
			}
			return data;
		}
		
		/**
		 * Создаёт связку объекта пропа и его загрузчика.
		 * 
		 * @param xml XML-элемент prop, lod или state
		 * @return 
		 */
		private function createPropObjectLoader(xml:XML):PropObjectLoader {
//			trace("[PropsLibrary::createPropObjectLoader]");
			var pol:PropObjectLoader = new PropObjectLoader();
			if (xml.mesh.length() > 0) {
				// Объект -- mesh
//				trace("pasing mesh");
				xml = xml.mesh[0];
				// В случае наличия альтернативных текстур составляется их список для загрузки
				var textures:Object = null;
				if (xml.texture.length() > 0) {
					textures = {};
					for each (var textureXML:XML in xml.texture) {
						var diffMap:String = textureXML.attribute("diffuse-map").toString();
						if (splittedImages != null) {
							textures[textureXML.@name.toString()] = splittedImages[diffMap];
						} else {
							textures[textureXML.@name.toString()] = new TextureMapsInfo(diffMap, xmlReadAttrString(textureXML, "opacity-map", null));
						}
//						trace("texture:", textureXML.@name, "diff map:", diffMap, "opacity map", opacityMap);
					}
				}
				pol.propObject = new PropMesh(null, null);
				pol.loader = new MeshLoader(path, xml.@file, xmlReadAttrString(xml, "object", null), textures, splittedImages);
//				trace(pol.loader);
			} else if (xml.sprite.length() > 0) {
				// Объект -- sprite
//				trace("pasing sprite");
				xml = xml.sprite[0];
				pol.propObject = new PropObject(null);
				var diffuseUrl:String = xml.@file;
				var alphaUrl:String;
				if (splittedImages != null) {
					var tmi:TextureMapsInfo = splittedImages[diffuseUrl];
					diffuseUrl = tmi.diffuseMapFileName;
					alphaUrl = tmi.opacityMapFileName;
				} else {
 					alphaUrl = xmlReadAttrString(xml, "alpha", null)					
				}
				
				var originX:Number = xmlReadAttrNumber(xml, "origin-x", 0.5);
				var originY:Number = xmlReadAttrNumber(xml, "origin-y", 1);
				var scale:Number = xmlReadAttrNumber(xml, "scale", 1);
//				trace("spite data: file:", xml.@file, "alpha:", alphaUrl, "originX:", originX, "originY:", originY, "scale:", scale);
				pol.loader = new SpriteLoader(path, diffuseUrl, alphaUrl, originX, originY, scale);
			} else {
				return null; 
			}
			return pol;
		}
		
		/**
		 * 
		 * @param stateXML
		 * @return 
		 */
		private function parseState(stateXML:XML):PropState {
			var data:StatelessObject = parseStatelessData(stateXML);
			return new PropState(stateXML.@name, data.object, data.lods);
		}
		
		/**
		 * 
		 * @param element
		 * @param attrName
		 * @param defValue
		 * @return 
		 */
		private function xmlReadAttrString(element:XML, attrName:String, defValue:String):String {
			var attr:XMLList;
			if ((attr = element.attribute(attrName)).length() > 0) {
				return attr[0].toString();
			}
			return defValue;
		}
		
		/**
		 * 
		 * @param element
		 * @param attrName
		 * @param defValue
		 * @return 
		 */
		private function xmlReadAttrNumber(element:XML, attrName:String, defValue:Number):Number {
			var attr:XMLList;
			if ((attr = element.attribute(attrName)).length() > 0) {
				return Number(attr[0]);
			}
			return defValue;
		}
		
	}
}
	import alternativa.editor.propslib.PropObject;
	import alternativa.editor.propslib.loaders.ObjectLoader;
	
	class PropObjectLoader {
		public var propObject:PropObject;
		public var loader:ObjectLoader;
	}
