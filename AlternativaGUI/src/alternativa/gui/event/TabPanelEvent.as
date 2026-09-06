package alternativa.gui.event {

    import flash.events.Event;

	/**
	 * События TabPanel. 
	 * 
	 */	
    public class TabPanelEvent extends Event {
		/**
		 * Выбор вкладки. 
		 */		
        public static const SELECTED:String = "SELECTED";
		
		/**
		 * Индекс вкладки. 
		 */		
        public var index:int;

		/**
		 * 
		 * @param type Тип события.
		 * @param index Индекс вкладки.
		 * @param bubbles Определяет, является ли событие событием восходящей цепочки.
		 * @param cancelable Указывает, можно ли предотвратить поведение, связанное с событием.
		 * 
		 */		
        public function TabPanelEvent(type:String, index:int,  bubbles:Boolean = false,cancelable:Boolean = false) {
            super(type, bubbles, cancelable);
            this.index = index;
        }
    }
}
