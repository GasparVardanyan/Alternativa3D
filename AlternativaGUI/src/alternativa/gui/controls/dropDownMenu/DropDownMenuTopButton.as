package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.button.TriggerButtonGroup;
	import alternativa.gui.controls.text.Label;

	use namespace alternativagui;
	
	/**
	 * Кнопка верхнего уровня. 
	 * 
	 */	
	public class DropDownMenuTopButton extends BaseButton implements IDropDownMenuTopButton {
		
		/**
		 * Флаг выделения. 
		 */		
		protected var _selected:Boolean;
		
		/**
		 * Группа, к которой принадлежит кнопка. 
		 */		
		protected var _group:TriggerButtonGroup;
		
		/**
		 * Контейнер данных. 
		 */		
		protected var _data:Object;

		public function DropDownMenuTopButton() {
			super();
			init();
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function update():void {
			data = _data;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override public function set pressed(value:Boolean):void {
			_pressed = value;
			//mouseDown
			if (value) {
				selected = !selected;
				//установка/сброс выделения в группе по клику
				if (_group != null) {
					if (_selected) {
						(group as DropDownMenuGroup).buttonSelected(this);
					} else {
						(group as DropDownMenuGroup).resetSelectedButton();
					}
				}
			}
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}
		public function set selected(value:Boolean):void {
			_selected = value;
			super.pressed = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override public function set over(value:Boolean):void {
			if (!_selected) {
				super.over = value;
			}
			_over = value;
			//установка выделения по ролловеру
			if ((group as DropDownMenuGroup) != null && _over) {
				(group as DropDownMenuGroup).buttonOvered(this);
			}
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get group():TriggerButtonGroup {
			return _group;
		}
		public function set group(value:TriggerButtonGroup):void {
			_group = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get data():Object {
			return _data;
		}
		public function set data(value:Object):void {
			_data = value;
		}

		protected function init():void {

		}
	}
}
