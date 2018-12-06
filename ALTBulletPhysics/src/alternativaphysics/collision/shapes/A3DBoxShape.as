package alternativaphysics.collision.shapes {
	import flash.geom.Vector3D;
	
	/** 
	* Класс представляет из себя шейп имеющий форму куба. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DBoxShape extends A3DCollisionShape {
		

		private var _dimensions:Vector3D;
	

		/** 
		* Конструктор
		* @public 
		* @param width ширина куба
		* @param depth длина куба
		* @param height высота куба
		*/
		public function A3DBoxShape(width : Number = 100, depth : Number = 100, height : Number = 100) {
			_dimensions = new Vector3D(width, depth, height);
			pointer = bullet.createBoxShapeMethod(width / _scaling, depth / _scaling, height / _scaling);
			
			super(pointer, 0);
		}
		

		/** 
		*  Возвращает вектор с шириной, высотой и длиной куба.
		* @public (getter)
		* @return Vector3D 
		*/
		public function get dimensions():Vector3D {
			return new Vector3D(_dimensions.x * m_localScaling.x, _dimensions.y * m_localScaling.y, _dimensions.z * m_localScaling.z);
		}
	}
}