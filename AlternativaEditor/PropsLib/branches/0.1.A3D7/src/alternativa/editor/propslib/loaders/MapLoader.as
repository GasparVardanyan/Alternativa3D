package alternativa.editor.propslib.loaders {
	import __AS3__.vec.Vector;
	
	import alternativa.editor.propslib.PropGroup;
	import alternativa.editor.propslib.PropsLibrary;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Reference;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Vector3D;
	import flash.net.URLLoader;
	import flash.net.URLRequest;

	[Event (name="complete", type="flash.events.Event")]
	/**
	 * 
	 */
	public class MapLoader extends EventDispatcher {

		private var loader:URLLoader;
		private var libs:Object;
		
		public var staticGeometry:Vector.<Reference>;
		
		/**
		 * 
		 * @param url
		 * @param libs
		 */
		public function MapLoader(url:String = null, libs:Object = null) {
			super();
			
			if (libs != null) {
				load(url, libs);
			}
		}
		
		/**
		 * 
		 * @param url
		 * @param libs
		 */
		public function load(url:String, libs:Object):void {
			this.libs = libs;
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, onLoadingComplete);
			loader.load(new URLRequest(url + "map.xml")); 
		}
		
		/**
		 * 
		 */
		private function onLoadingComplete(e:Event):void {
			parseStaticGeometry(XML(loader.data));
			
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 */
		private function parseStaticGeometry(mapXML:XML):void {
			staticGeometry = new Vector.<Reference>();
			var components:Vector.<Vector3D> = new Vector.<Vector3D>(3, true);
			components[2] = new Vector3D(1, 1, 1);
			for each (var propXML:XML in mapXML.elements("static-geometry").prop) {
				var lib:PropsLibrary = libs[propXML.attribute("library-name")];
				var group:PropGroup = lib.rootGroup.getGroupByName(propXML.attribute("group-name"));
				var object:Object3D = group.getPropByName(propXML.@name).statelessData.object.object3d;
//				trace("lib:", lib.name, "group:", group.name, "object:", object);
				var ref:Reference = new Reference(object);
				var pos:Vector3D = readVector3D(propXML.position);
				var rot:Vector3D = readVector3D(propXML.rotation);
//				trace("pos", pos, "rot", rot);
				components[0] = pos;
				components[1] = rot;
//				var v:Vector3D = object.matrix.decompose()[2];
//				components[2] = v;
				ref.matrix.recompose(components);
				ref.referenceObject.boundBox = ref.referenceObject.calculateBoundBox();
				staticGeometry.push(ref);
			}
		}
		
		/**
		 * 
		 * @param xml
		 * @return 
		 */
		private function readVector3D(xml:XMLList):Vector3D {
			if (xml.length() > 0) {
				return new Vector3D(Number(xml[0].x), Number(xml[0].y), Number(xml[0].z)); 
			} else {
				return new Vector3D();
			}
		}
		
	}
}