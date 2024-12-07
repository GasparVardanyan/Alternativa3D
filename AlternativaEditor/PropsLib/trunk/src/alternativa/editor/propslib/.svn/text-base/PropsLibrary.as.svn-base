package alternativa.editor.propslib {
	import __AS3__.vec.Vector;
	
	import alternativa.editor.propslib.events.PropLibProgressEvent;
	import alternativa.editor.propslib.loaders.MeshLoader;
	import alternativa.editor.propslib.loaders.SpriteLoader;
	import alternativa.engine3d.loaders.TextureMapsInfo;
	import alternativa.types.Map;
	
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IOErrorEvent;
	import flash.events.SecurityErrorEvent;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	[Event (name="complete", type="flash.events.Event")]
	[Event (name="ioError", type="flash.events.IOErrorEvent")]
	[Event (name="securityError", type="flash.events.SecurityErrorEvent")]
	[Event (name="progress", type="alternativa.editor.propslib.events.PropLibProgressEvent")]
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
		
		private var url:String;
		private var configLoader:URLLoader;
		private var loaders:Vector.<ObjectLoaderPair>;
		private var currLoader:ObjectLoaderPair;
		
		private var propsLoaded:int;
		private var propsTotal:int;
		
		/**
		 * 
		 */
		public function PropsLibrary(url:String = null) {
			if (url != null) {
				load(url);
			}
		}
		
		/**
		 * 
		 * @param path
		 */
		public function load(url:String):void {
			if (url == null) {
				throw new ArgumentError();
			}
			this.url = (url.length > 0 && url.charAt(url.length - 1) != "/") ? url + "/" : url;
			configLoader = new URLLoader(new URLRequest(this.url + "library.xml"));
			configLoader.addEventListener(Event.COMPLETE, onXMLLoadingComplete);
			configLoader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			configLoader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
		}
		
		/**
		 * 
		 * @param e
		 */
		private function onErrorEvent(e:ErrorEvent):void {
			dispatchEvent(e);
		}
		
		/**
		 * 
		 */
		private function onXMLLoadingComplete(e:Event):void {
			var xml:XML = XML(configLoader.data);

			configLoader.removeEventListener(Event.COMPLETE, onXMLLoadingComplete);
			configLoader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			configLoader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
			configLoader = null;
			
			name = xml.@name;
			loaders = new Vector.<ObjectLoaderPair>();
			rootGroup = parseGroup(xml);
			propsLoaded = 0;
			propsTotal = loaders.length;
			loadPropObject();
		}
		
		/**
		 * 
		 */
		private function loadPropObject():void {
			currLoader = loaders.pop();
			currLoader.loader.addEventListener(Event.COMPLETE, onPropObjectLoadingComplete);
			currLoader.loader.addEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			currLoader.loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
			currLoader.loader.load(null);
		}
		
		/**
		 * 
		 * @param e
		 */
		private function onPropObjectLoadingComplete(e:Event):void {
			currLoader.loader.removeEventListener(Event.COMPLETE, onPropObjectLoadingComplete);
			currLoader.loader.removeEventListener(IOErrorEvent.IO_ERROR, onErrorEvent);
			currLoader.loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, onErrorEvent);
			if (currLoader.propObject is PropMesh) {
				var propMesh:PropMesh = currLoader.propObject as PropMesh;
				var meshLoader:MeshLoader = currLoader.loader as MeshLoader;
				propMesh.object3d = meshLoader.object;
				propMesh.bitmaps = meshLoader.bitmaps;
			} else {
				currLoader.propObject.object3d = (currLoader.loader as SpriteLoader).sprite;
			}
			propsLoaded++;
			if (hasEventListener(PropLibProgressEvent.PROGRESS))
				dispatchEvent(new PropLibProgressEvent(propsLoaded, propsTotal));
			
			if (loaders.length > 0) {
				loadPropObject();
			} else {
				currLoader = null;
				dispatchEvent(new Event(Event.COMPLETE));
			}
		}
		
		/**
		 * 
		 */
		private function parseGroup(groupXML:XML):PropGroup {
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
		private function parseStatelessData(xml:XML):StatelessData {
			var data:StatelessData = new StatelessData(null, null);
			var pol:ObjectLoaderPair;
			if (xml.lod.length() > 0) {
				// Указаны LOD'ы для пропа/состояния
				var lods:Vector.<PropLOD> = new Vector.<PropLOD>();
				for each (var lodXML:XML in xml.lod) {
					pol = createObjectLoaderPair(lodXML);
					loaders.push(pol);
					var lod:PropLOD = new PropLOD(Number(lodXML.@distance), pol.propObject);
					lods.push(lod);
				}
				data.lods = lods;
			} else {
				// LOD'ов нет, разбирается информация об объекте
				pol = createObjectLoaderPair(xml);
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
		private function createObjectLoaderPair(xml:XML):ObjectLoaderPair {
			var olPair:ObjectLoaderPair = new ObjectLoaderPair();
			if (xml.mesh.length() > 0) {
				// Объект -- mesh
				xml = xml.mesh[0];
				// В случае наличия альтернативных текстур составляется их список для загрузки
				var textures:Map = null;
				if (xml.texture.length() > 0) {
					textures = new Map();
					for each (var textureXML:XML in xml.texture) {
						var diffMap:String = textureXML.attribute("diffuse-map").toString();
						var opacityMap:String = xmlReadAttrString(textureXML, "opacity-map", null);
						if (opacityMap != null) {
							opacityMap = url + opacityMap;
						}
						textures.add(textureXML.@name.toString(), new TextureMapsInfo(url + diffMap, opacityMap));
					}
				}
				olPair.propObject = new PropMesh(null, null);
				olPair.loader = new MeshLoader(url + xml.@file, xmlReadAttrString(xml, "object", null), textures);
			} else if (xml.sprite.length() > 0) {
				// Объект -- sprite
				xml = xml.sprite[0];
				olPair.propObject = new PropObject(null);
				var alphaUrl:String = xmlReadAttrString(xml, "alpha", null);
				if (alphaUrl != null) {
					alphaUrl = url + alphaUrl;
				}
				var originX:Number = xmlReadAttrNumber(xml, "origin-x", 0.5);
				var originY:Number = xmlReadAttrNumber(xml, "origin-y", 1);
				var scale:Number = xmlReadAttrNumber(xml, "scale", 1);
				olPair.loader = new SpriteLoader(url + xml.@file, alphaUrl, originX, originY, scale);
			} else {
				return null; 
			}
			return olPair;
		}
		
		/**
		 * 
		 * @param stateXML
		 * @return 
		 */
		private function parseState(stateXML:XML):PropState {
			var data:StatelessData = parseStatelessData(stateXML);
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
	
	class ObjectLoaderPair {
		public var propObject:PropObject;
		public var loader:ObjectLoader;
	}
