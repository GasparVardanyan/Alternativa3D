package alternativa.editor.export {
	import alternativa.engine3d.core.Mesh;
	import alternativa.types.Matrix3D;
	
	/**
	 * Базовый класс для примитивов физической геометрии.
	 */
	public class CollisionPrimitive {
		// Трансформация примитива в системе координат пропа. Трансформация не должна содержать масштабирования. 
		public var transform:Matrix3D = new Matrix3D();
		
		/**
		 * @param mesh
		 */
		public function CollisionPrimitive(mesh:Mesh = null) {
			if (mesh != null) parse(mesh);
		}
		
		/**
		 * Строит примитив на основе полигонального объекта.
		 * @param mesh
		 */
		public function parse(mesh:Mesh):void {
		}
		
		/**
		 * Формирует представление примитива в формате XML с учётом трансформации родительского пропа.
		 * 
		 * @param parentTransform трансформация родительского пропа
		 * @return представление примитива в виде XML
		 */
		public function getXml(parentTransform:Matrix3D):XML {
			return new XML();
		}
		
	}
}