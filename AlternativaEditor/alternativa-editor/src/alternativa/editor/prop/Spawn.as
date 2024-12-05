package alternativa.editor.prop {
	import alternativa.editor.scene.EditorScene;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.utils.MathUtils;
	
	import flash.geom.Point;

	public class Spawn extends Prop {
		
		public function Spawn(object:Object3D, library:String, group:String, needCalculate:Boolean=true) {
			super(object, library, group, needCalculate);
			type = Prop.SPAWN;
		}
		
		override public function calculate():void {
			
			distancesX = new Point(-EditorScene.hBase, EditorScene.hBase);
			distancesY = new Point(-EditorScene.hBase, EditorScene.hBase);
			distancesZ = new Point(0, EditorScene.vBase);
		}
		
		override public function rotate(plus:Boolean):void {
			if (plus) {
				rotationZ += MathUtils.DEG5;
			} else {
				rotationZ -= MathUtils.DEG5;
			}
		}
		
		override public function clone():Object3D {
			
			var copyObject:Mesh = _object.clone() as Mesh;
			copyObject.cloneMaterialToAllSurfaces(_material as TextureMaterial);
			 // Создаем проп
			var copy:Spawn =  new Spawn(copyObject, _library, _group, false);
			// Копируем свойства
			copy.distancesX = distancesX.clone();
			copy.distancesY = distancesY.clone();
			copy.distancesZ = distancesZ.clone();
			copy._multi = _multi;
			copy.name = name;
			return copy;
		}
		
	}
}