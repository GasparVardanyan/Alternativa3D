package alternativa.editor.prop {
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Set;
	
	/**
	 * @author danilova
	 */		
	public class Bonus extends Prop {
		
		public var types:Set;	
		public function Bonus(object:Object3D, library:String, group:String, needCalculate:Boolean=true) {
			super(object, library, group, needCalculate);
			types = new Set();
			types.add("damageup");
		}
		
		
		
		override public function clone():Object3D {
			
			var copyObject:Mesh = _object.clone() as Mesh;
			copyObject.cloneMaterialToAllSurfaces(_material as TextureMaterial);
			 // Создаем проп
			var copy:Bonus =  new Bonus(copyObject, _library, _group, false);
			// Копируем свойства
			copy.distancesX = distancesX.clone();
			copy.distancesY = distancesY.clone();
			copy.distancesZ = distancesZ.clone();
			copy._multi = _multi;
			copy.name = name;
			copy.types = types.clone();
			return copy;
		}
		
	}
}