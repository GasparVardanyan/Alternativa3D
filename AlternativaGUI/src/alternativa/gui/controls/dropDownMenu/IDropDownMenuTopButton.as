package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.controls.button.ITriggerButton;
	
	/**
	 * Интерфейс кнопки меню.
	 * 
	 */	
	public interface IDropDownMenuTopButton extends ITriggerButton {
		/**
		 * Данные:
		 * <listing>
		 * <ul><code>label:String</code></ul>
		 * <ul><code>items:DataProvider</code></ul>
		 * </listing>
		 */
		function get data():Object;

		function set data(value:Object):void;

		/**
		 * Обновление состояние компонента, вызывается после изменения данных data.
		 */
		function update():void;
	}
}
