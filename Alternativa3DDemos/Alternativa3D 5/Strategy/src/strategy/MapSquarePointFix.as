package strategy {
	import alternativa.types.Map;
	
	import flash.utils.getTimer;

	/**
	 * Фиксированная часть элемента карты. 
	 */	
	public class MapSquarePointFix extends MapSquarePoint {	
		// Индикатор препятствия
		protected var _impassable:Boolean;
		// Map герой -> занятые им моменты времени
		public var heroBusyMoments:Map = new Map();
		
		public function MapSquarePointFix(direction:int = -1, cost:Number=0, distance:Number=-1, state:int=0, impassable:Boolean=false) {
			super(direction, cost, distance, state);
			_impassable = impassable;
		}
		
		public function get impassable():Boolean {
			return _impassable;
		}
		public function set impassable(value:Boolean):void {
			_impassable = value;
		}
		
		/**
		 * Чистит прошлое. 
		 */
		public function clearPast():void {
			
			var time:Number = getTimer();
			
			for (var key:* in heroBusyMoments) {
				var busyMoments:Array = heroBusyMoments[key];
				var len:int = busyMoments.length;
				for (var i:int = 0; i < len; i++) {
					var moment:Number = busyMoments[i];
					if (time - moment > 10000) {
						busyMoments.splice(i, 1);
					}
				}
			}
		}
		
		/**
		 * Удаляет все моменты времени, связанные с героем.
		 * @param hero герой
		 */				
		public function clearTime(hero:SoldierHero):void {
			
			var busyMoments:Array;
			if ((busyMoments = heroBusyMoments[hero])!= null) {
				busyMoments.length = 0;
			}
		}
		
		
		/**
		 * Проверяет, занят ли момент времени. 
		 * @param time момент времени
		 * @param hero герой, для которого осуществляется проверка
		 * @return true, если момент времени уже кем-то занят
		 */
		public function busyMoment(time:Number, hero:MovingHero):Boolean {
			
			for (var key:* in heroBusyMoments) {
				if (key != hero) {
					var busyMoments:Array = heroBusyMoments[key];
					var len:int = busyMoments.length;
					for (var i:int = 0; i < len; i++) {
						var deltaTime:Number = time - busyMoments[i];
						if ((deltaTime < 0 ? -deltaTime : deltaTime) < MovingHero.STEP_TIME) {
							return  true;
						}
					}
				}
			
			}
			return false;
			
		}
	}
}