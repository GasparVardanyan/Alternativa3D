package alternativa.gui.controls.button {
	import alternativa.gui.mouse.ICursorActive;
	
	/**
	 * Интерфейс для кнопки RadioButton.
	 * 
	 */	
	public interface ITriggerButton extends ICursorActive {
		
		/**
		 * Логическое значение: выбран или нет.
		 * 
		 */		
		function get selected():Boolean;
		function set selected(value:Boolean):void;
		
		/**
		 * К какой группе принадлежит элемент. 
		 * 
		 */		
		function get group():TriggerButtonGroup;
		function set group(value:TriggerButtonGroup):void;
	}
}