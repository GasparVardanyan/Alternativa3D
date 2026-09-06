package strategy {
	
	/**
	 * Подчасть элемента карты. Используется для вычислений в A*. 
	 */	
	public class MapSquarePoint {
		// Направление
		protected var _direction:int;
		// Цена
		protected var _cost:Number;
		// Расстояние до финиша
		protected var _distance:Number;
		// Состояние 0 - undefined, 1 - opened, 2 - closed
		protected var _state:int;  
		
		public function MapSquarePoint(direction:int = -1, cost:Number = 0, distance:Number = -1, state:int = 0) {
			_direction = direction;
			_cost = cost;
			_distance = distance;
			_state = state;
		}
		
		public function get state():int {
			return _state;
		}
		public function set state(value:int):void {
			_state = value;
		}
		
		public function get cost():Number {
			return _cost;
		}
		public function set cost(value:Number):void {
			_cost = value;
		}
		public function get direction():int {
			return _direction;
		}
		public function set direction(value:int):void {
			_direction = value;
		}
		public function get distance():Number {
			return _distance;
		}
		public function set distance(value:Number):void {
			_distance = value;
		}
		
		

	}
}