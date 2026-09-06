package alternativaphysics.collision.shapes {

	/** 
	* Класс представляет из себя шейп имеющий форму конуса. 
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DConeShape extends A3DCollisionShape {
		
		private var _radius:Number;
		private var _height:Number;
		

		/** 
		* Конструктор. 
		* @public 
		* @param radius радиус конуса
		* @param height высота конуса
		*/
		public function A3DConeShape(radius : Number = 50, height : Number = 100) {
			
			_radius = radius;
			_height = height;
			
			pointer = bullet.createConeShapeMethod(radius / _scaling, height / _scaling);
			super(pointer, 4);
		}
		

		/** 
		* радиус конуса
		* @public (getter) 
		* @return Number 
		*/
		public function get radius():Number {
			return _radius * m_localScaling.x;
		}
		

		/** 
		* высота конуса
		* @public (getter) 
		* @return Number 
		*/
		public function get height():Number {
			return _height * m_localScaling.y;
		}
	}
}