package a3d_helper.loaders
{
	import alternativa.engine3d.core.Object3D;
	import a3d_helper.maps.Map;
	import a3d_helper.maps.PropsLibs;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class MapLoader
	{
		public var map:Map;
		public var mapData:XML;
		public var loader:URLLoader;
		public var propsLibsBaseURL:String;
		public var propsLibsList:Array = [];
		public var mapFileURL:String;
		public var scale:Number;
		public var afterComplete:Function;
		
		public function MapLoader(_propsLibsBaseURL:String, _mapFileURL:String, _scale:Number = 1)
		{
			propsLibsBaseURL = _propsLibsBaseURL;
			mapFileURL = _mapFileURL;
			scale = _scale;
		}
		
		public function loadAndParseMap(container:Object3D, context:Context3D):void
		{
			loader = new URLLoader();
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				mapData = XML(e.target.data);
				parseMap(container, context);
			});
			loader.load(new URLRequest(mapFileURL));
		}
		
		public function parseMap(container:Object3D, context:Context3D):void
		{
			var createMap:Boolean;
			
			if (mapData["@version"] == "1.0.Light")
			{
				createMap = true;
				
				for each (var prop:XML in mapData["static-geometry"]["prop"])
				{
					var newTara:Boolean = true;
					for (var i:int = 0; i < propsLibsList.length; i++)
						if (propsLibsList[i] == prop["@library-name"].toString()) newTara = false;
					if (newTara)
						propsLibsList.push(prop["@library-name"].toString());
				}
			}
			else if (mapData["@version"] == "3.0")
			{
				createMap = true;
				
				for each (var propV3:XML in mapData["prop"])
				{
					var newTaraV3:Boolean = true;
					for (var iV3:int = 0; iV3 < propsLibsList.length; iV3++)
						if (propsLibsList[iV3] == propV3["@library-name"].toString()) newTaraV3 = false;
					if (newTaraV3)
						propsLibsList.push(propV3["@library-name"].toString());
				}
			}
			
			if (createMap) buildMap(container, context);
			else trace("Unsupported map version " + mapData["@version"]);
		}
		
		public function buildMap(container:Object3D, context:Context3D):void
		{
			map = new Map(propsLibsBaseURL, propsLibsList, mapFileURL, scale);
			map.afterCompleteMap = function():void
			{
				for (var i:int = 0; i < map.body3d.numChildren; i++)
					container.addChild(map.body3d.getChildAt(i).clone());
				if (afterComplete != null) afterComplete();
			}
			map.mapData = mapData;
			map.library = new PropsLibs(map.propsLibsBaseURL, map.propsLibsList);
			map.library.afterCompletePropsLibs = function():void
			{
				map.parseMap(context);
			}
			map.library.loadAndParsePropsLibs();
		}
	}
}
