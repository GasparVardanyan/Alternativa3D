package alternativa.gui.container.list {
	import flash.display.DisplayObject;
	
	/**
	 * Интерфейс визуального элемента.
	 * 
	 */	
	public interface IItemRenderer {
		
		/**
		 * Индекс элемента. 
		 * 
		 */		
		function get itemIndex():int;
		function set itemIndex(value:int):void;
		
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
		
		function get width():Number;
		function get height():Number;
		
	}
}