package alternativa.gui.theme.defaulttheme.controls.buttons {
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.controls.button.TriggerButtonGroup;

	/**
	 * 
	 * RU: обsчная кнопка, которая ведёт себя как radiobutton
     * EN: big button -
	 * 
	 */	
	public class ToggleButton extends Button implements ITriggerButton {
		
		// RU: флаг выделения
        // EN: flag of selection
		protected var _selected:Boolean = false;
		
		// RU: группа, к которой принадлежит данная кнопка
        // EN: group of this button
		protected var _group:RadioButtonGroup;

		public function ToggleButton() {
			super();
		}
		
		// RU: при выделении кнопки, сообщаем радиогруппе. Меняем состояния
        // EN: inform radiogroup on button selection. Change the state
		public function set selected(value:Boolean):void {
			_selected = value;

			if (_group != null && _selected) {
				_group.buttonSelected(this);
			}
			if (_selected) {
				setState(_stateDOWN);
			} else {
				if (_over) {
					setState(_stateOVER);
				} else {
					setState(_stateUP);
				}
			}
		}

		public function get selected():Boolean {
			return _selected;
		}
		
		// RU: задаем радогруппу для данной кнопки
        // EN: Set the radiogroup to this button
		public function set group(value:TriggerButtonGroup):void {
			_group = value as RadioButtonGroup;
		}

		public function get group():TriggerButtonGroup {
			return _group;
		}

		override public function set pressed(value:Boolean):void {
			if (!_locked)
				_pressed = value;

			if (_pressed) {
				if (_group != null) {
					selected = true;
				} else {
					selected = !_selected;
				}
			}
		}

		override public function set over(value:Boolean):void {
			if (!_locked) {
				_over = value;
			}

			if (!_locked && !_pressed) {
				if (!_selected) {
					setState(value ? _stateOVER : _stateUP);
				}
			}
		}

	}
}
