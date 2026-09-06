package alternativa.gui.mouse.resizableObject {	
	import flash.display.DisplayObject;
	
	/**
	 * Интерфейс резинового объекта, который можно расширять/сжимать.
	 * 
	 */	
	public interface IResizableObject {
		
		/**
		 * Толщина рамки объекта.
		 * @param value Толщина.
		 * 
		 */		
		function get border():int;
		function set border(value:int):void;
		
		/**
		 * Объект, которому будут задавать размеры и позицию. 
		 * 
		 */		
		function get resizableContainer():DisplayObject;
		function set resizableContainer(object:DisplayObject):void;
		
	}
}