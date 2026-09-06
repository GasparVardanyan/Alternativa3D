package alternativa.gui.controls.button {
	
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.controls.button.TriggerButtonGroup;
	import alternativa.gui.controls.text.Label;
	
	import flash.display.Bitmap;
	
	use namespace alternativagui;
	
	/**
	 * Кнопка - переключатель.
	 * 
	 */	
	public class RadioButton extends CheckBox implements ITriggerButton {
		
		/**
		 * Флаг выделения. 
		 */		
		protected var _selected:Boolean = false;
		
		/**
		 * Группа к которой относится данная кнопка. 
		 */		
		protected var _group:RadioButtonGroup;
		
		public function RadioButton() {
			super();
			
		}
		
		/**
		 * Флаг выделения кнопки 
		 * 
		 */		
		public function set selected(value:Boolean):void {
			_selected = value;
			
			if (_group != null && _selected) {
				_group.buttonSelected(this);
			}
			checked = _selected;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		/**
		 * Задаем радиогруппу к которой относится данная кнопка. 
		 * 
		 */		
		public function set group(value:TriggerButtonGroup):void {
			_group = value as RadioButtonGroup;
		}
		
		public function get group():TriggerButtonGroup {
			return _group;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set pressed(value:Boolean):void {
			if (!_locked)
				_pressed = value;
			if (_pressed && !_selected) {
				selected = !_selected;
			}
		}
		
	}
}
