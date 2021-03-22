package a3d_helper.maps
{
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import a3d_helper.utils.TARA;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	public class PropsLibs
	{
		public var tara:Array = [];
		public var data:Array = [];
		public var extension:String = ".tara";
		public var afterCompletePropsLibs:Function;
		
		public static const f_libraryXML:String = "library.xml";
		public static const f_imagesXML:String = "images.xml";
		public static const f_invisible:String = "invisible";
		public static const d_tara:String = "tara";
		public static const d_mesh:String = "mesh";
		public static const d_texd:String = "texd";
		public static const d_alpha:String = "alpha";
		public static const d_deftexd:String = "deftexd";
		public static const d_sprite:String = "sprite";
		public static const d_spritefile:String = "spritefile";
		public static const d_originy:String = "originy";
		public static const d_scale:String = "scale";
		public static const t_type:String = "type";
		public static const t_mesh:String = "mesh";
		public static const t_sprite:String = "sprite";
		public static const pos_x:String = "posx";
		public static const pos_y:String = "posy";
		public static const pos_z:String = "posz";
		public static const rot_x:String = "rotx";
		public static const rot_y:String = "roty";
		public static const rot_z:String = "rotz";
		public static const origin_y:String = "originy";
		
		public var baseURL:String;
		public var list:Array;
		
		public function PropsLibs(_baseURL:String, _list:Array)
		{
			baseURL = _baseURL;
			list = _list;
		}
		
		public function loadAndParsePropsLibs():void
		{
			for (var ind:int = 0; ind < list.length; ind++)
				loadAndParseTARA(list[ind]);
		}
		
		public function loadAndParseTARA(n:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				TARA.readTARA(tara, n, ByteArray(e.target.data));
				parsePropsLib(n);
			});
			loader.load(new URLRequest(baseURL+n+extension));
		}
		
		public function parsePropsLib(n:String):void
		{
			var library:XML = new XML(getFile(n, f_libraryXML));
			var libName:String = library["@name"].toString();
			data[libName] = [];
			for each (var group:XML in library.elements("prop-group"))
			{
				var groupName:String = group["@name"].toString();
				data[libName][groupName] = [];
				for each (var prop:XML in group.elements("prop"))
				{
					var propName:String = prop["@name"].toString();
					data[libName][groupName][propName] = [];
					data[libName][groupName][propName][d_tara] = n;
					for each (var propMesh:XML in prop["mesh"])
					{
						var propMeshFile:String = propMesh["@file"].toString().toLowerCase();
						getFile(n, propMeshFile).position = 0;
						var parser:Parser3DS = new Parser3DS();
						parser.parse(getFile(n, propMeshFile));
						
						/*var mesh:Mesh;
						for (var i:int = 0; i < parser.objects.length; i++)
						{
							var currObj:Object3D = parser.objects[i];
							var currObjName:String = currObj.name.toLowerCase();
							if (currObjName.indexOf("occl") == 0)
							   mesh = Mesh(currObj);
							else if (currObjName == getAttributeAsString(propMesh, "object"))
								mesh = Mesh(currObj);
						}
						data[libName][groupName][propName][d_mesh] = mesh!=null?mesh:parser.objects[0];
						
						function getAttributeAsString(element:XML, attrName:String, defValue:String = null):String
						{
							var attributes:XMLList = element.attribute(attrName);
							if (attributes.length() > 0)
								return attributes[0].toString();
							return defValue;
						}*/
						
						data[libName][groupName][propName][t_type] = t_mesh;
						data[libName][groupName][propName][d_mesh] = Mesh(parser.objects[0]);
						Mesh(data[libName][groupName][propName][d_mesh]).removeChildren();
						data[libName][groupName][propName][d_texd] = [];
						data[libName][groupName][propName][d_texd][d_alpha] = [];
						
						for each (var propTex:XML in propMesh["texture"])
							configureImage(libName, groupName, propName, n, propTex["@name"].toString(), propTex["@diffuse-map"].toString().toLowerCase());
						configureImage(libName, groupName, propName, n, d_deftexd, ExternalTextureResource(ParserMaterial(data[libName][groupName][propName][d_mesh].getSurface(0).material).textures["diffuse"]).url);
					}
					for each (var propSprite:XML in prop["sprite"])
					{
						var propSpriteFile:String = propSprite["@file"].toString();
						getFile(n, propSpriteFile).position = 0;
						var propSpriteOriginY:Number = Number(propSprite["@origin-y"]);
						var propSpriteScale:Number = Number(propSprite["@scale"]);
						data[libName][groupName][propName][t_type] = t_sprite;
						data[libName][groupName][propName][d_sprite] = new Sprite3D(propSprite["@scale"], propSprite["@scale"]);
						data[libName][groupName][propName][d_spritefile] = propSpriteFile;
						data[libName][groupName][propName][d_originy] = propSpriteOriginY;
						data[libName][groupName][propName][d_scale] = propSpriteScale;
					}
				}
			}
			var taraCount:int;
			for (var t:String in tara) taraCount++;
			if (taraCount == list.length && afterCompletePropsLibs != null) afterCompletePropsLibs();
		}
		
		public function getFile(_tara:String, _file:String):ByteArray
		{
			for (var file:String in tara[_tara])
				if (file.toLowerCase() == _file.toLowerCase())
					return tara[_tara][file];
			return null;
		}
		
		private function configureImage(libName:String, groupName:String, propName:String, n:String, dn:String, du:String):void
		{
			var alpha:String;
			if (getFile(n, f_imagesXML) != null)
				for each (var image:XML in XML(getFile(n, f_imagesXML))["image"])
					if (image["@name"].toString().toLowerCase() == du)
					{
						du = image["@new-name"].toString().toLowerCase();
						alpha = image["@alpha"].toString()!=""?image["@alpha"].toString().toLowerCase():null;
					}
			data[libName][groupName][propName][d_texd][dn] = [du];
			data[libName][groupName][propName][d_texd][d_alpha][dn] = alpha;
		}
	}
}
