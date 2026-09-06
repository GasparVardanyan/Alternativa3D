package alternativa.gui.controls.button {
	import alternativa.gui.event.RadioButtonGroupEvent;
	
	
	/**
	 * Группа, которая объеденяет несколько кнопок с интерфейсом ITriggerButton в одну компоненту.
	 * Данная компонента позволяет выбрать только одну кнопку.
	 * 
	 */
	public class RadioButtonGroup extends TriggerButtonGroup {
		
		/**
		 * Выбранная кнопка.
		 */		
		protected var selectedButton:ITriggerButton;
		
		
		public function RadioButtonGroup() {
			super();
		}
		
		/**
		 * Кнопка выбрана.
		 * @param button Кнопка.
		 */		
		public function buttonSelected(button:ITriggerButton):void {
			if (button != selectedButton) {
				// Сброс старой выбранной кнопки
				if (selectedButton != null) {
					ITriggerButton(selectedButton).selected = false;
				}
				// Сохранение выбранной кнопки
				selectedButton = button;

				// Рассылка события
				dispatchEvent(new RadioButtonGroupEvent(RadioButtonGroupEvent.SELECTED, button));
			}
		}
		
		/**
		 * Сброс выбранной кнопки.
		 * 
		 */		
		public function resetSelectedButton():void {
			if (selectedButton != null) {
				ITriggerButton(selectedButton).selected = false;
				selectedButton = null;
			}
		}

	}
}