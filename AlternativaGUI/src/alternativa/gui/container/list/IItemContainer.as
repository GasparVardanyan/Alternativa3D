
package alternativa.gui.container.list {

    import alternativa.gui.data.DataProvider;
	
	/**
	 * Интерфейс контейнера элементов для List.
	 * 
	 */	
    public interface IItemContainer {

		/**
		 * Класс визуального элемента.
		 * 
		 */		
        function set itemRenderer(value:Class):void;

		/**
		 *  Поставщик данных.
		 * 
		 */		
        function get dataProvider():DataProvider;
		function set dataProvider(value:DataProvider):void;

		/** 
		 * Активация контейнера. 
		 * 
		 */		
        function get activate():Boolean;
        function set activate(value:Boolean):void;

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
		 * Высота всего контента: все элементы и зазоры между ними. 
		 * 
		 */        
        function get contentHeight():Number;
        
		/**
		 * Отображение скроллбара. 
		 * 
		 */		
		function get showScrollBar():Boolean;

		/**
		 * Количество скроллируемых строчек в пикселях. 
		 * 
		 */        
		function get mouseDelta():Number;

		/**
		 * Количество строчек в пикселях при нажатие кнопки скролла: вверх/вниз. 
		 * 
		 */        
		function get stepScroll():Number;

		/**
		 * Значение вертикального положения контента.
		 * 
		 */        
		function get vertValue():int;
		function set vertValue(value:int):void;
		
		/**
		 * Обновление контейнера. 
		 * 
		 */		
		function update():void;
    }
}
