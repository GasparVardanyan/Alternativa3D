package alternativa.gui.container.list {

    import alternativa.gui.data.DataProvider;
    
    import flash.events.Event;
	
	/**
	 * Интерфейс компоненты List.
	 * 
	 */	
    public interface IList {
		
		/**
		 * Компонента находится в фокусе (активирована).
		 * <p>Вызывается при нажатии на компоненту.</p>
		 */		
        function focusIn(e:Event = null):void;
		
		/**
		 * Убрали фокус с компоненты.
		 * <p>Вызывается при нажатии на stage или другой объект.</p>
		 */		
        function focusOut(e:Event = null):void;
		
		/**
		 * Выбранный элемент. 
		 * 
		 */		
		function get selectedItem():Object;
		
		/**
		 * Индекс выбранного элемента. 
		 * 
		 */		
        function get selectedIndex():int;
        function set selectedIndex(value:int):void;

		/**
		 * Поставщик данных. 
		 * 
		 */		
        function get dataProvider():DataProvider;
        function set dataProvider(value:DataProvider):void;
		
		/**
		 * Класс визуального элемента.
		 * 
		 */		
        function set itemRenderer(object:Class):void;
    }
}
