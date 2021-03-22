package a3d_helper.maps
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.GeometryMesh;
	import a3d_helper.maps.PropsLibs;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display3D.Context3D;
	import flash.events.Event;
	import flash.net.URLLoader;
	import flash.net.URLRequest;
	
	public class Map
	{
		public var library:PropsLibs;
		public var mapData:XML;
		public var propsLibsBaseURL:String;
		public var propsLibsList:Array;
		public var mapFileURL:String;
		public var scale:Number;
		public var afterCompleteMap:Function;
		public var body3d:Object3D = new Object3D();
		public var physicsGeometry:GeometryMesh = new GeometryMesh();
		
		private var propsTotal:int;
		private var meshes:Array = [];
		private var texResInited:int;
		private var texResLoaded:int;
		private var texResData:Array = [];
		private var texResDataAlpha:Array = [];
		private var texRes:Array = [];
		private var texResAlpha:Array = [];
		private var texResTotal:int;
		private var props:Vector.<Prop> = new Vector.<Prop>();
		private var propsDataV3:Vector.<PropDataV3> = new Vector.<PropDataV3>();
		
		public function Map(_propsLibsBaseURL:String, _propsLibsList:Array, _mapFileURL:String, _scale:Number = 1)
		{
			propsLibsBaseURL = _propsLibsBaseURL;
			propsLibsList = _propsLibsList;
			mapFileURL = _mapFileURL;
			scale = _scale;
		}
		
		public function loadAndParseMap(context:Context3D):void
		{
			library = new PropsLibs(propsLibsBaseURL, propsLibsList);
			library.afterCompletePropsLibs = function():void
			{
				var loader:URLLoader = new URLLoader();
				loader.addEventListener(Event.COMPLETE, function(e:Event):void
				{
					mapData = XML(e.target.data);
					parseMap(context);
				});
				loader.load(new URLRequest(mapFileURL));
			}
			library.loadAndParsePropsLibs();
		}
		
		public function parseMap(context:Context3D):void
		{
			if (mapData["@version"] == "1.0.Light")
			{
				var staticGeom:XMLList = mapData["static-geometry"];
				propsTotal = staticGeom["prop"].length();
				for each (var prop:XML in staticGeom["prop"])
				{
					var libName:String = prop["@library-name"].toString();
					var groupName:String = prop["@group-name"].toString();
					var propName:String = prop["@name"].toString();
					
					var posX:Number = Number(prop["position"]["x"]);
					var posY:Number = Number(prop["position"]["y"]);
					var posZ:Number = Number(prop["position"]["z"]);
					var rotZ:Number = Number(prop["rotation"]["z"]);
					var texN:String = prop["texture-name"].toString() ? prop["texture-name"].toString() : PropsLibs.d_deftexd;
					
					initProp(libName, groupName, propName, posX, posY, posZ, rotZ, texN, context);
				}
			}
			else if (mapData["@version"] == "3.0")
			{
				propsTotal = mapData["mesh"].length() + mapData["sprite"].length();
				
				for each (var propV3:XML in mapData["prop"])
				{
					var libNameV3:String = propV3["@library-name"].toString();
					var groupNameV3:String = propV3["@group-name"].toString();
					var propNameV3:String = propV3["@name"].toString();
					
					var propDataV3:PropDataV3 = new PropDataV3(libNameV3, groupNameV3, propNameV3);
					for each (var textureV3:XML in propV3["texture-name"])
						propDataV3.textures.push(textureV3.toString());
					propsDataV3.push(propDataV3);
				}
				
				var posXV3:Number, posYV3:Number, posZV3:Number;
				
				for each (var meshV3:XML in mapData["mesh"])
				{
					var meshPropV3:PropDataV3 = propsDataV3[Number(meshV3["@prop-index"])];
					posXV3 = Number(meshV3["position"]["@x"]);
					posYV3 = Number(meshV3["position"]["@y"]);
					posZV3 = Number(meshV3["position"]["@z"]);
					var rotZV3:Number = Number(meshV3["rotation-z"]);
					var texNV3:String = meshV3["texture-index"].toString() ? meshPropV3.textures[Number(meshV3["texture-index"])] : PropsLibs.d_deftexd;
					
					initProp(meshPropV3.library, meshPropV3.group, meshPropV3.prop, posXV3, posYV3, posZV3, rotZV3, texNV3, context);
				}
				
				for each (var spriteV3:XML in mapData["sprite"])
				{
					var spritePropV3:PropDataV3 = propsDataV3[Number(spriteV3["@prop-index"])];
					posXV3 = Number(spriteV3["position"]["@x"]);
					posYV3 = Number(spriteV3["position"]["@y"]);
					posZV3 = Number(spriteV3["position"]["@z"]);
					
					initProp(spritePropV3.library, spritePropV3.group, spritePropV3.prop, posXV3, posYV3, posZV3, 0, "", context);
				}
			}
			else trace("Unsupported map version " + mapData["@version"]);
		}
		
		private function initProp(libName:String, groupName:String, propName:String, posX:Number, posY:Number, posZ:Number, rotZ:Number, texN:String, context:Context3D):void
		{
			if (library.data[libName][groupName][propName][PropsLibs.t_type] == PropsLibs.t_mesh)
			{
				if (meshes[libName] == undefined) meshes[libName] = [];
				if (meshes[libName][groupName] == undefined) meshes[libName][groupName] = [];
				if (meshes[libName][groupName][propName] == undefined)
				{
					meshes[libName][groupName][propName] = library.data[libName][groupName][propName][PropsLibs.d_mesh].clone();
					meshes[libName][groupName][propName].geometry.upload(context);
				}
				var mesh:Mesh = meshes[libName][groupName][propName].clone();
				mesh.x = posX * scale;
				mesh.y = posY * scale;
				mesh.z = posZ * scale;
				mesh.rotationZ = rotZ;
				mesh.scaleX = mesh.scaleY = mesh.scaleZ = scale;
				
				props.push(new Prop(PropsLibs.t_mesh, mesh, library.data[libName][groupName][propName][PropsLibs.d_tara], library.data[libName][groupName][propName][PropsLibs.d_texd][texN]));
				initTexRes(library.data[libName][groupName][propName][PropsLibs.d_tara], texN != PropsLibs.f_invisible ? library.data[libName][groupName][propName][PropsLibs.d_texd][texN] : texN, library.data[libName][groupName][propName][PropsLibs.d_texd][PropsLibs.d_alpha][texN], context);
			}
			if (library.data[libName][groupName][propName][PropsLibs.t_type] == PropsLibs.t_sprite)
			{
				var propSprite:Prop = new Prop(PropsLibs.t_sprite, null, library.data[libName][groupName][propName][PropsLibs.d_tara], library.data[libName][groupName][propName][PropsLibs.d_spritefile]);
				propSprite[PropsLibs.pos_x] = posX * scale;
				propSprite[PropsLibs.pos_y] = posY * scale;
				propSprite[PropsLibs.pos_z] = (posZ + .1) * scale;
				propSprite[PropsLibs.rot_z] = rotZ;
				propSprite[PropsLibs.d_originy] = library.data[libName][groupName][propName][PropsLibs.d_originy];
				propSprite[PropsLibs.d_scale] = library.data[libName][groupName][propName][PropsLibs.d_scale];
				props.push(propSprite);
				initTexRes(library.data[libName][groupName][propName][PropsLibs.d_tara], library.data[libName][groupName][propName][PropsLibs.d_spritefile], null, context);
			}
		}
		
		private function initTexRes(t:String, d:String, a:String, context:Context3D):void
		{
			if (texResData[t] == undefined) texResData[t] = [];
			if (texResDataAlpha[t] == undefined) texResDataAlpha[t] = [];
			if (texRes[t] == undefined) texRes[t] = [];
			if (texResAlpha[t] == undefined) texResAlpha[t] = [];
			texResData[t][d] = d;
			if (a != null) texResDataAlpha[t][d] = a;
			texResAlpha[t][d] = [];
			texResInited++;
			if (texResInited == propsTotal)
			{
				for (var i:String in texResData)
					for (var j:String in texResData[i])
						if (texResData[i][j]) texResTotal++;
				for (i in texResDataAlpha)
					for (j in texResDataAlpha[i])
						texResTotal++;
				for (i in texResData)
					for (j in texResData[i])
						loadTexture(i, j, false, null, context);
				for (i in texResDataAlpha)
					for (j in texResDataAlpha[i])
						loadTexture(i, texResDataAlpha[i][j], true, j, context);
			}
		}
		
		private function loadTexture(i:String, j:String, a:Boolean, diffofalpha:String = null, context:Context3D = null):void
		{
			var loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.INIT, function(e:Event):void
			{
				var bmp:BitmapData = new BitmapData(loader.content.width, loader.content.height, true, 0);
				bmp.draw(loader);
				if (a)
				{
					texResAlpha[i][diffofalpha] = new BitmapTextureResource(bmp, true);
					texResAlpha[i][diffofalpha].upload(context);
				}
				else
				{
					texRes[i][j] = new BitmapTextureResource(bmp, true);
					texResData[i][j] = {width: bmp.width, height: bmp.height};
					texRes[i][j].upload(context);
				}
				
				if (++texResLoaded == texResTotal) addProps();
			});
			if (j != PropsLibs.f_invisible)
				loader.loadBytes(library.getFile(i, j));
			else if (++texResLoaded == texResTotal)
				addProps();
		}
		
		private function addProps():void
		{
			for each (var prop:Prop in props)
			{
				var material:TextureMaterial = new TextureMaterial(texRes[prop.tara][prop.diff], texResAlpha[prop.tara][prop.diff] is BitmapTextureResource ? texResAlpha[prop.tara][prop.diff] : null);
				material.alphaThreshold = .5;
				
				if (prop.type == PropsLibs.t_mesh)
				{
					Mesh(prop.data).setMaterialToAllSurfaces(material);
					physicsGeometry.addMesh(MeshUtils.createGeometryMeshFromMesh3d(Mesh(prop.data)));
					body3d.addChild(Mesh(prop.data));
				}
				
				if (prop.type == PropsLibs.t_sprite)
				{
					var sprite:Sprite3D = new Sprite3D(texResData[prop.tara][prop.diff].width * prop[PropsLibs.d_scale] * scale, texResData[prop.tara][prop.diff].height * prop[PropsLibs.d_scale] * scale, material);
					sprite.x = prop[PropsLibs.pos_x];
					sprite.y = prop[PropsLibs.pos_y];
					sprite.z = prop[PropsLibs.pos_z];
					sprite.rotationZ = prop[PropsLibs.rot_z];
					sprite.originY = prop[PropsLibs.d_originy];
					prop.data = sprite;
					body3d.addChild(Sprite3D(prop.data));
				}
			}
			if (afterCompleteMap != null) afterCompleteMap();
		}
	}
}

dynamic class PropDataV3
{
	public var library:String;
	public var group:String;
	public var prop:String;
	public var tara:String;
	public var textures:Array = [];
	
	public function PropDataV3(_library:String, _group:String, _prop:String)
	{
		library = _library;
		group = _group;
		prop = _prop;
	}
}

import alternativa.engine3d.core.Object3D;

dynamic class Prop
{
	public var type:String;
	public var data:Object3D;
	public var tara:String;
	public var diff:String;
	
	public function Prop(_type:String, _data:Object3D, _tara:String, _diff:String)
	{
		type = _type;
		data = _data;
		tara = _tara;
		diff = _diff;
	}
}
