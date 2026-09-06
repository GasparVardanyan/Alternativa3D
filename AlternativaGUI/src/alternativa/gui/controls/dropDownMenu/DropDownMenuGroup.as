package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.event.RadioButtonGroupEvent;
	
	/**
	 * Группа кнопок верхнего уровня в DropDownMenu.
 	 * Отличие от RadioButtonGroup  - добавление функции buttonOvered.
	 * 
	 */	
	public class DropDownMenuGroup extends RadioButtonGroup {
		
		/**
		 * Флаг нажатия. 
		 */		
		protected var _pressed:Boolean;

		public function DropDownMenuGroup() {
			  super();
		}
		
		/**
		 * Уничтожение группы. 
		 * 
		 */		
		public function destroy():void{
			for each (var button:ITriggerButton in buttonsList) {
				button.group = null;
			}
			buttonsList = null;
			selectedButton = null;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function buttonSelected(button:ITriggerButton):void {
			super.buttonSelected(button);
			if(button) _pressed = true;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function resetSelectedButton():void {
			super.resetSelectedButton();
			_pressed = false;
			//	диспатчим с button=null, тем самым показывая что произошел сброс
			dispatchEvent(new RadioButtonGroupEvent(RadioButtonGroupEvent.SELECTED, null));
		}

		/**
		 * При наведении кнопка отмечается (selected = true)
		 * @param button Кнопка
		 */
		public function buttonOvered(button:ITriggerButton):void{
			if(_pressed && button != selectedButton){
				buttonSelected(button);
				if(button) button.selected = true;
			}
		}
	}
}