package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	
	/**
	 * Группа для элементов в вертикальной панельке DropDownMenu.
	 * 
	 */	
	public class DropDownItemGroup extends RadioButtonGroup {
		public function DropDownItemGroup() {
			super();
		}
		
		/**
		 * Уничтожение элементов, сброс выделенной кнопки, обнуление списка кнопок.
		 * 
		 */		
		public function destroy():void {
			for each (var button:ITriggerButton in buttonsList) {
				removeButton(button);
			}
			resetSelectedButton();
			buttonsList = null;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function buttonSelected(button:ITriggerButton):void {
			super.buttonSelected(button);
			if (selectedButton) {
				selectedButton.selected = true;
			}
		}
	}
}
