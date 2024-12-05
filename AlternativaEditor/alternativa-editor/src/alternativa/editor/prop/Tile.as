package alternativa.editor.prop {
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.types.Texture;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	
	use namespace alternativa3d;
	
	/**
	 * @author danilova
	 */	
	public class Tile extends Prop {
		
		private var collisionMaterial:CustomFillMaterial;
		
		private var _isMirror:Boolean = false;
		
		private var collisionBoxes:Set;
		//
		public var bitmaps:Map;
		//
		protected var _textureName:String = "";
		
		public function Tile(object:Object3D, library:String, group:String, needCalculate:Boolean = true) {
			super(object, library, group, needCalculate);
			type = Prop.TILE;
			collisionBoxes = new Set();
			// Collision boxes
			for (var child:* in object.children) {
				var box:Mesh = child as Mesh;
				box.cloneMaterialToAllSurfaces(null);
				if (box.name.substr(0, 3) != "occ") {
					collisionBoxes.add(box);
				}		
			}
			collisionMaterial = new CustomFillMaterial(new Point3D(-1e10, -0.7e10, 0.4e10), 0xFF7F7F);		
		}
		
	
		/**
		 * Показать коллижн-боксы. 
		 */		
		public function showCollisionBoxes():void {
			
			for (var child:* in collisionBoxes) {
				var box:Mesh = child as Mesh;
				box.cloneMaterialToAllSurfaces(collisionMaterial);	
			}
			
			setMaterial(null);
			
		}
		
		/**
		 * Скрыть коллижн-боксы. 
		 */				
		public function hideCollisionBoxes():void {
			
			for (var child:* in collisionBoxes) {
				var box:Mesh = child as Mesh;
				box.cloneMaterialToAllSurfaces(null);	
			}
			
			setMaterial(_material);
			
		}
		
		public function get collisionGeometry():Set {
			return collisionBoxes;
		}
		
		public function get textureName():String {
			return _textureName;
		}
		
		public function set textureName(value:String):void {
			_textureName = value; 
			
			bitmapData = _isMirror ? getMirrorBitmapData(bitmaps[value]) : bitmaps[value];
			_material = new TextureMaterial(new Texture(bitmapData));
			if (_selected) {
				_selectBitmapData.dispose();	
				select();
			} else {
				setMaterial(_material);
			}
		}
		
		
		private function getMirrorBitmapData(bmd:BitmapData):BitmapData {
			
			var mirrorBmd:BitmapData = new BitmapData(bmd.width, bmd.height);
			mirrorBmd.draw(bmd, new Matrix(-1, 0, 0, 1, bmd.width, 0 ));	
			return mirrorBmd;
		}
	
		public function mirrorTexture():void {
	
			_isMirror = !_isMirror;
			
			bitmapData = getMirrorBitmapData(bitmapData);
			(_material as TextureMaterial).texture = new Texture(bitmapData);
			if (selected) {
				_selectBitmapData.dispose();
				select();
			} else {
				setMaterial(_material);
			}
		}
		
		public function get isMirror():Boolean {
			return _isMirror;
		}
		
		override public function clone():Object3D {
			
			var copyObject:Mesh = _object.clone() as Mesh;
			copyObject.cloneMaterialToAllSurfaces(_material as TextureMaterial);
			 // Создаем проп
			var copy:Tile =  new Tile(copyObject, _library, _group, false);
			// Копируем свойства
			copy.distancesX = distancesX.clone();
			copy.distancesY = distancesY.clone();
			copy.distancesZ = distancesZ.clone();
			copy._multi = _multi;
			copy.name = name;
			copy.bitmaps = bitmaps;
			copy._textureName = _textureName;
			return copy;
		}
		
		
	}
}