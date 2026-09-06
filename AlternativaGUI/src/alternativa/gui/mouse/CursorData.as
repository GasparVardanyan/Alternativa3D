package alternativa.gui.mouse {

    import flash.ui.MouseCursorData;

	/**
	 * Класс формирования данных для CursorManager.
	 * 
	 * @see CursorManager
	 */	
    public class CursorData {
		
		/**
		 * Уникальное название курсора. 
		 */		
        public var cursorName:String;
		
		/**
		 * Данные курсора. 
		 */		
        public var cursorData:MouseCursorData;
		
		/**
		 * 
		 * @param _name Название курсора.
		 * @param _cursor Данные курсора.
		 * 
		 */		
        public function CursorData(_name:String, _cursor:MouseCursorData) {
            this.cursorName = _name;
            this.cursorData = _cursor;
        }
    }
}
