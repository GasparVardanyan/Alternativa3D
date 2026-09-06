package alternativa.gui.event {
	import alternativa.gui.controls.button.ITriggerButton;
	
	import flash.events.Event;
	
	/**
	 * Класс RadioButtonGroupEvent определяет события, при изменении группы.
	 * 
	 */	
	public class RadioButtonGroupEvent extends Event {
		
		/**
		 * Выбор кнопки. 
		 */		
		public static const SELECTED:String = "RadioButtonGroupEventSelected";
		
		public var button:ITriggerButton;
		
		/**
		 * 
		 * @param type Тип события.
		 * @param button Кнопка.
		 * 
		 */		
		public function RadioButtonGroupEvent(type:String, button:ITriggerButton) {
			super(type);
			this.button = button;
		}

	}
}