package strategy {
	import flash.utils.getTimer;

	/**
	 * Элемент карты. Состоит из фиксированной и переменной частей. 
	 */	
	public class DoubleMapSquarePoint {
		// Фиксированная часть
		protected var _fix:MapSquarePointFix;
		// Переменная часть
		protected var _variable:MapSquarePoint;
		
		public function DoubleMapSquarePoint(fix:MapSquarePointFix, variable:MapSquarePoint) {
			_fix = fix;
			_variable = variable;
		}
		
		public function set fix(value:MapSquarePointFix):void {
			_fix = value;
		}
		
		public function get fix():MapSquarePointFix {
			return _fix;
		}
			
		public function set variable(value:MapSquarePoint):void {
			_variable = value;
		}
		
		public function get variable():MapSquarePoint {
			return _variable;
		}
			
		/**
		 * Возвращает переменной части исходные значения. Чистит прошлое. 
		 */
		public function restore():void {
			_variable.cost = _fix.cost;
			_variable.direction = _fix.direction;
			_variable.distance = _fix.distance;
			_variable.state = _fix.state;
			_fix.clearPast();
		}	
		
		
	}
}