package alternativaphysics.collision.shapes {

	/** 
	* Класс представляет из себя шейп имеющий форму сферы. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DSphereShape extends A3DCollisionShape {
		
		private var _radius:Number;
		

		/** 
		* Конструктор
		* @public 
		* @param radius радиус сферы
		*/
		public function A3DSphereShape(radius : Number = 50) {
			_radius = radius;
			
			pointer = bullet.createSphereShapeMethod(radius / _scaling);
			super(pointer, 1);
		}
		

		/** 
		* радиус сферы
		* @public (getter) 
		* @return Number 
		*/
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
	}
}