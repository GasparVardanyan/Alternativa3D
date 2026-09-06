package alternativa.gui.mouse {
	import flash.geom.Point;
	
	/**
	 * Интерфейс слушателя координат мыши.
	 */	
	public interface IMouseCoordListener {
		
		/**
		 * Рассылка изменения координат мыши. 
		 * @param mouseCoord Координаты мыши.
		 */		
		function mouseMove(mouseCoord:Point):void;
			
	}
}