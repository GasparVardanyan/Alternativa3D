package alternativa.gui.container.tileList {
	
	/**
	 * Интерфейс визуального элемента.
	 * 
	 */	
	public interface ICellRenderer {		
		
		/**
		 * Данные элемента. 
		 * 
		 */	
		function get data():Object;
		function set data(value:Object):void;

		/**
		 * Флаг выделения элемента. 
		 * 
		 */	
		function get selected():Boolean;
		function set selected(value:Boolean):void;
	}
}
