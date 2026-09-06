package alternativa.gui.event {
	import flash.events.Event;
	
	/**
	 * События ScrollBar.
	 * 
	 */	
	public class ScrollBarEvent extends Event {
		
		/**
		 * Начало скролирования. 
		 */		
		public static const SCROLL_START:String = "SCROLL_START";
		
		/**
		 * Завершение скролирования. 
		 */		
		public static const SCROLL_STOP:String = "SCROLL_STOP";
		
		/**
		 * Изменения данных в ScrollBar. 
		 */		
		public static const SCROLL_CHANGE:String = "SCROLL_CHANGE";
		
		/**
		 * 
		 * @param type Тип события.
		 * @param bubbles Определяет, является ли событие событием восходящей цепочки.
		 * @param cancelable Указывает, можно ли предотвратить поведение, связанное с событием.
		 * 
		 */		
		public function ScrollBarEvent(type:String, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
		}

	}
}