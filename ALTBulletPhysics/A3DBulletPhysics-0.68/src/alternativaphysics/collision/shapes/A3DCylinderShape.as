package alternativaphysics.collision.shapes {

	/** 
	* Класс представляет из себя шейп имеющий форму цилиндра. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DCylinderShape extends A3DCollisionShape {
		
		private var _radius:Number;
		private var _height:Number;
		

		/** 
		* Конструктор
		* @public 
		* @param radius радиус цилиндра 
		* @param height высота цилиндра
		*/
		public function A3DCylinderShape(radius : Number = 50, height : Number = 100) {
			
			_radius = radius;
			_height = height;
			
			pointer = bullet.createCylinderShapeMethod(radius * 2 / _scaling, height / _scaling, radius * 2 / _scaling);
			super(pointer, 2);
		}
		

		/** 
		* радиус цилиндра 
		* @public (getter) 
		* @return Number 
		*/
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
		

		/** 
		* высота цилиндра
		* @public (getter) 
		* @return Number 
		*/
		public function get height():Number {
			return _height * m_localScaling.y;
		}
	}
}