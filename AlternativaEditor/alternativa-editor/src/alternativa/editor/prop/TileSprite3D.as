package alternativa.editor.prop {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Map;
	import alternativa.types.Texture;
	
	import flash.geom.Point;

	public class TileSprite3D extends Tile {
		private var spriteTextureMaterial:SpriteTextureMaterial;
		
		public function TileSprite3D(object:Sprite3D, library:String, group:String, needCalculate:Boolean=true) {
			super(object, library, group, needCalculate);
		}
		
		public function get scale():Number {
			return (_object as Sprite3D).scaleX;
		} 
		
		override public function calculate():void {
			distancesX = new Point();
			distancesY = new Point();
			distancesZ = new Point();
			_multi = false;
		}
		
		override public function setMaterial(material:Material):void {
			var spriteMaterial:SpriteTextureMaterial = material as SpriteTextureMaterial;
			if (spriteMaterial) {
				spriteMaterial.originX = spriteTextureMaterial.originX;
				spriteMaterial.originY = spriteTextureMaterial.originY;
			}
			(_object as Sprite3D).material = spriteMaterial;
			
		}
		
		override protected function initBitmapData():void {
			_material = (_object as Sprite3D).material; 
			spriteTextureMaterial = _material as SpriteTextureMaterial;
			bitmapData = spriteTextureMaterial.texture.bitmapData;
		}
		
		override public function get vertices():Map {
			var vertex:Vertex = new Vertex(0, 0, 0);
			var map:Map = new Map();
			map.add("1", vertex);
			return map;
		}
		
		override protected function get newSelectedMaterial():Material {
			var material:SpriteTextureMaterial = new SpriteTextureMaterial(new Texture(_selectBitmapData));
			return  material;
		}
		
		override public function clone():Object3D {
			
			var copyObject:Sprite3D = _object.clone() as Sprite3D;
			copyObject.material = _material.clone() as SpriteTextureMaterial;
			// Создаем проп
			var copy:TileSprite3D =  new TileSprite3D(copyObject, _library, _group, false);
			// Копируем свойства
			copy.distancesX = distancesX.clone();
			copy.distancesY = distancesY.clone();
			copy.distancesZ = distancesZ.clone();
			copy._multi = _multi;
			copy.name = name;
			copy.bitmaps = bitmaps;
			return copy;
		}
	}
}