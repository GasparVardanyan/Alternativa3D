package alternativa.gui.event {
	import flash.events.Event;
	
	/**
	 * События SliderEvent. 
	 * 
	 */	
	public class SliderEvent extends Event {
		
		/**
		 * Начало перетаскивания. 
		 */		
		public static const START_DRAG:String = "SliderEventStartDrag";
		
		/**
		 * Завершение перетаскивания. 
		 */		
		public static const STOP_DRAG:String = "SliderEventStopDrag";
		
		/**
		 * Изменение данных. 
		 */		
		public static const CHANGE_POSITION:String = "SliderEventChangePos";
		
		/**
		 * Текущая позиция бегунка. 
		 */		
		public var pos:int;
		
		/**
		 * 
		 * @param type Тип события.
		 * @param pos Позиция бегунка.
		 * 
		 */		
		public function SliderEvent(type:String, pos:int) {
			super(type, true, true);
			this.pos = pos;
		}
	
	}
}