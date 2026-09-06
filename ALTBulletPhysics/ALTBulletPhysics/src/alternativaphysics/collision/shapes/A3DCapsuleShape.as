package alternativaphysics.collision.shapes {

	/** 
	* Класс представляет из себя шейп имеющий форму капсулы. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DCapsuleShape extends A3DCollisionShape {
		
		private var _radius:Number;
		private var _height:Number;
		

		/** 
		* Конструктор.
		* @public 
		* @param radius радиус капсулы
		* @param height высота капсулы
		*/
		public function A3DCapsuleShape(radius : Number = 50, height : Number = 100) {
			
			_radius = radius;
			_height = height;
			
			pointer = bullet.createCapsuleShapeMethod(radius / _scaling, height / _scaling);
			super(pointer, 3);
		}
		

		/** 
		* радиус капсулы
		* @public (getter) 
		* @return Number 
		*/
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
		

		/** 
		* высота капсулы
		* @public (getter) 
		* @return Number 
		*/
		public function get height():Number {
			return _height * m_localScaling.y;
		}
	}
}