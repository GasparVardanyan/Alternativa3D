package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.controls.button.ITriggerButton;
	
	/**
	 * Интерфейс для рендера в DropDownMenuItemContainer. Основная цель - подмена рендера панелек.
	 * 
	 */	
	public interface IDropDownMenuItem extends IDropDownMenuTopButton {

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
		 * Cсылка на родительский контейнер (надо для расчета выравнивания контейнеров).
		 */
		function get parentContainer():IDropDownMenuItemContainer;

		function get width():Number;

		/**
		 * Наличие дочерних объектов на уровне данных.
		 */
		function hasDataChildren():Boolean;

		/**
		 * Полное уничтожение компонента.
		 */
		function destroy():void;
	}
}
