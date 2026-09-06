package alternativa.gui.event {
	import flash.events.Event;
	
	/**
	 * Класс событий хинта. 
	 * 
	 */	
	public class HintEvent extends Event {
		
		/**
		 * Вызывается при скрытии хинта. 
		 */		
		public static const HIDE:String = "HintEventHide";
		
		/**
		 *  
		 * @param type Тип события.
		 * 
		 */		
		public function HintEvent(type:String) {
			super(type, false, false);
		}

	}
}