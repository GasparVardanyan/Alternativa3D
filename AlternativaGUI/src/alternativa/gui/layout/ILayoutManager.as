package alternativa.gui.layout {
	
	/**
	 * Интерфейс ILayoutManager предоставляет методы, отвечающие за расположение и размеры панелей. 
	 * 
	 */	
	public interface ILayoutManager	{
		
		/**
		 * Инициализация.
		 */		
		function init():void;
		
		/**
		 * Изменился размер.
		 * @param w Новая ширина stage.
		 * @param h Новая высота stage.
		 */		
		function onResize(w:int, h:int):void;
        
        /**
		 * Добавление объекта на сцену.
		 * @param object Объект, который добавили на stage.
		 */
        function addedToStage(object:Object):void;
        
        /**
		 * Удаление объекта со сцены.
		 * @param object Объект, который удалили со stage.
		 */
        function removedFromStage(object:Object):void;
        
		/**
		 * Обновление. Вызывается из LayoutManager при вызове Event.ENTER_FRAME. 
		 * 
		 */		
        function update():void;
	}
}