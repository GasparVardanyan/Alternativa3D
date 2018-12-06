package alternativaphysics.collision.shapes {
	import flash.geom.Vector3D;

	/** 
	* Класс представляет из себя шейп, имеющий бесконечную поверхность.При создании указываем нормаль, относительно которой будет построен шейп. 
	* Можно использовать только для статических тел.
	* @public 
	* @author redefy 
	*/
	public class A3DStaticPlaneShape extends A3DCollisionShape {

		private var _normal:Vector3D;
		private var _constant:Number;
		
		/** 
		* Конструктор
		* @public 
		* @param normal нормаль
		* @param constant толщина шейпа
		*/
		public function A3DStaticPlaneShape(normal : Vector3D = null, constant : Number = 0) {
			if (!normal) {
				normal = new Vector3D(0, 0, 1);
			}
			_normal = normal;
			_constant = constant;
			
			pointer = bullet.createStaticPlaneShapeMethod(normal.x, normal.y, normal.z, constant / _scaling);
			super(pointer, 8);
		}
		
		/** 
		* нормаль
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get normal():Vector3D {
			return _normal;
		}
		
		/** 
		* толщина шейпа
		* @public (getter) 
		* @return Number 
		*/
		public function get constant():Number {
			return _constant;
		}
	}
}