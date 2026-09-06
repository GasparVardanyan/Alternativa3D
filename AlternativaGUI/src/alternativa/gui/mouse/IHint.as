package alternativa.gui.mouse {
	
	
	/**
	 * Интерфейс хинта. 
	 * 
	 */	
	public interface IHint {
		
		/**
		 * Отображаемый текст. 
		 * 
		 */		
		function set text(value:String):void;
		
		/**
		 * Видимость 
		 * 
		 */		
		function get visible():Boolean;
		function set visible(value:Boolean):void;
		
		/**
		 * Координата по оси X.
		 * 
		 */		
		function set x(value:Number):void;
		
		/**
		 * Координата по оси Y.
		 * 
		 */		
		function set y(value:Number):void;
		
		/**
		 * Ширина. 
		 * 
		 */		
		function get width():Number;
		
		/**
		 * Высота. 
		 * 
		 */		
		function get height():Number;
		
	}
}