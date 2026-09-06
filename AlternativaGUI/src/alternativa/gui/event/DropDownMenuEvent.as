package alternativa.gui.event {
	import alternativa.gui.controls.dropDownMenu.IDropDownMenuItem;

	import flash.events.Event;
	
	/**
	 * События DropDownMenu. 
	 * 
	 */	
	public class DropDownMenuEvent extends Event {

		/**
		 * Событие выбора конечного элемента меню (у которого нет подпунктов). 
		 */		
		public static const SELECT:String = 'DropDownMenuEvent.SELECT';

		/**
		 * Промежуточное служебное событие при клике на item. 
		 */		
		public static const CHANGE_ITEM:String = 'DropDownMenuEvent.CHANGE_ITEM';

		/**
		 * Промежуточное служебное событие при rollover на item. 
		 */		
		public static const CREATE_CONTAINER:String = 'DropDownMenuEvent.CREATE_CONTAINER';

		/**
		 * Ссылка на кнопку. 
		 */		
		public var button:IDropDownMenuItem;

		/**
		 * Ссылка на данные кнопки. 
		 */		
		public var data:Object;
		
		/**
		 * 
		 * @param type Тип события.
		 * @param button Кнопка.
		 * @param data Данные кнопки.
		 * @param bubbles Определяет, является ли событие событием восходящей цепочки.
		 * @param cancelable Указывает, можно ли предотвратить поведение, связанное с событием.
		 * 
		 */		
		public function DropDownMenuEvent(type:String, button:IDropDownMenuItem = null, data : Object = null, bubbles:Boolean = false, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);
			this.button = button;
			this.data = data;
		}
		
		/**
		 * 
		 * Создает дубликат экземпляра подкласса DropDownMenuEvent.
		 * 
		 */		
		override public function clone():Event {
			return new DropDownMenuEvent(type, button,data, bubbles, cancelable);
		}
	}
}