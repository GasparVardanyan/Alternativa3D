package alternativa.gui.mouse {
	
	/**
	 * Интерфейс объекта, видимого для курсора.
	 */
	public interface ICursorActive {
		
		/**
		 * Добавить слушателя событий курсора. 
		 * @param listener Слушатель событий курсора. 
		 */		
		function addCursorListener(listener:ICursorActiveListener):void;
		
		/**
		 * Удалить слушателя событий курсора. 
		 * @param listener Слушатель событий курсора. 
		 */		
		function removeCursorListener(listener:ICursorActiveListener):void;
		
		/**
		 * Список слушателей событий курсора.
		 */		
		function get cursorListeners():Array;
		
		/**
		 * Флаг получения событий курсора.
		 */		
		function get cursorActive():Boolean;
		function set cursorActive(value:Boolean):void;
		
		/**
		 * Текст всплывающей подсказки.
		 */		 
		function get hint():String;
		function set hint(value:String):void;

        /**
		 * Тип курсора.
		 * 
		 * @see CursorManager
		 */
		function get cursorType():String;
		function set cursorType(value:String):void;
	}
}