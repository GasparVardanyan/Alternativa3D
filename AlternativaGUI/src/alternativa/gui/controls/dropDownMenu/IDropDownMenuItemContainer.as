package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.data.DataProvider;

	import flash.display.DisplayObject;
	
	/**
	 * Интерфейс для контейнера панелек DropDownMenu. Основная цель - подмена рендера панелек.
	 * 
	 */	
	public interface IDropDownMenuItemContainer {
		
		/**
		 * Класс визуального элемента для кнопки.
		 */
        function set itemRenderer(value:Class):void;
		
		/**
		 *  Значение контейнера по оси X.  
		 * 
		 */		
		function get x():Number;
		function set x(value:Number):void;

		/**
		 *  Значение контейнера по оси Y.  
		 * 
		 */		
		function get y():Number;
		function set y(value:Number):void;

		/**
		 * Общая ширина компоненты (включая все отступы).
		 */
		function get backgroundWidth():int;

		/**
		 * Ссылка на родительскую кнопку.
		 */
		function get parentItem():IDropDownMenuItem;

		/**
		 * Класс фона, т.к. панельки генерируются динамически, необходимо создавать также динамически фон.
		 */
		function set background(value : Class):void;

		/**
		 * Внутренние отступы бокса с кнопками.
		 */
		function get padding():int;
		function set padding(value:int):void;

		/**
		 * Зазор между внутренними кнопками по вертикали.
 		 */
		function get space():int;
		function set space(value:int):void;

		/**
		 * Очистка компоненты.
		 */
		function clear():void;

		/**
		 * Полное уничтожение компоненты.
		 */
		function destroy():void;

		/**
		 * Обновление компоненты. <p>Используется как правило после изменения данных</p>.
		 */
		function update():void;

		/**
		 * Данные:
		 * <listing>
		 * <ul><code>label:String</code></ul>
		 * <ul><code>items:DataProvider</code></ul>
		 * </listing>
		 */
        function get data():Object;
		function set data(value:Object):void;
	}
}
