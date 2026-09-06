package alternativa.gui.event {
	import flash.events.Event;
	
	/**
	 * Класс ListEvent определяет событие, которое отправляется при изменении List.
	 * 
	 */
	public class ListEvent extends Event {
		
		/**
		 * Объект списка. 
		 */		
        public var object:Object;
		
		/**
		 * Выбор элемента. 
		 */		
		public static const CLICK_ITEM:String = "CLICK_ITEM";
		
		/**
		 * Длина поставщика данных равно 0. 
		 */		
		public static const REMOVE_DATA:String = "REMOVE_DATA";
		
		/**
		 * Обновление данных. 
		 */		
		public static const DATA_UPDATE:String = "DATA_UPDATE";
		
		/**
		 * Позиция в списке эелементов изменилась.
		 */		
		public static const CHANGE_POSITION:String = "CHANGE_POSITION";
		
		/**
		 * Выбран элемент. 
		 */		
		public static const SELECT_ITEM:String = "SELECT_ITEM";
		
		/**
		 * Контейнер со списокм измениля. 
		 */		
		public static const LIST_CHANGE:String = "LIST_CHANGE";
		
		/**
		 * Перерисовка. 
		 */		
		public static const REDRAW:String = "REDRAW";
		
		/**
		 * 
		 * @param type Тип события.
		 * @param object Объект.
		 * @param bubbles Определяет, является ли событие событием восходящей цепочки.
		 * @param cancelable Указывает, можно ли предотвратить поведение, связанное с событием.
		 * 
		 */		
        public function ListEvent(type:String, object:Object = null, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.object = object;
		}

	}
}