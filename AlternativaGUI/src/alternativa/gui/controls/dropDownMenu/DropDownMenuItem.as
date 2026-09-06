package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.button.TriggerButtonGroup;
	import alternativa.gui.event.DropDownMenuEvent;

	use namespace alternativagui;
	
	/**
	 * Кнопка в DropDownMenuItemContainer, основная особенность - при наведении состояние нажатия.
	 * 
	 */	
	public class DropDownMenuItem extends BaseButton implements IDropDownMenuItem {
		/**
		 * Данные по кнопке. 
		 */		
		protected var _data:Object;
		
		/**
		 * Флаг выделения. 
		 */		
		protected var _selected:Boolean;
		
		/**
		 * Флаг уничтожения (для избежания повторного). 
		 */		
		protected var _destroyed:Boolean;
		
		/**
		 * Ссылка на родительский контейнер. 
		 */		
		protected var _parentContainer:IDropDownMenuItemContainer;
		
		/**
		 * Группа.
		 */		
		protected var _group:DropDownItemGroup;

		/**
		 * Конструктор.
		 * @param parentContainer Ссылка на родительскую панельку.
		 */
		public function DropDownMenuItem(parentContainer:IDropDownMenuItemContainer = null) {
			_parentContainer = parentContainer;
			super();
			init();
		}


		/**
		 * Обновление состояние компоненты, вызывается при измненении data.
		 */
		public function update():void {
			data = _data;
		}

		/**
		 * Абстрактный метод очистки компоненты.
		 */
		public function clear():void {

		}

		/**
		 * Данные имеют дочерние элементы (поле items в data).
		 */
		public function hasDataChildren():Boolean {
			var result:Boolean;
			if (_data &&
					_data.items &&
					_data.items.length > 0) {
				result = true;
			}
			return result;
		}

		/**
		 * @inheritDoc 
		 * 
		 */		
		public function destroy():void {
			if (_destroyed) {
				return;
			}
			clear();
			removeCursorListener(this)
			_group.removeButton(this);
			_group = null;
			_destroyed = true;
			_data = null;
			if (parent) {
				parent.removeChild(this);
			}
			_parentContainer = null;
		}

		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set over(value:Boolean):void {
			_over = value;
			var hasChildren:Boolean = hasDataChildren();
			if (value) {
				// ROLL OVER
				if (_selected) {
					if (!hasChildren) {
						_group.buttonSelected(this);
					}
				} else {
					_group.buttonSelected(this);
				}
			} else {
				// ROLL OUT
				if (!hasChildren) {
					_group.resetSelectedButton();
				}
			}
		}

		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set pressed(value:Boolean):void {
			_pressed = value;
			if(_pressed && !hasDataChildren()){
				dispatchEvent(new DropDownMenuEvent(DropDownMenuEvent.CHANGE_ITEM, this, _data, true));
			}
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
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get selected():Boolean {
			return _selected;
		}

		public function set selected(value:Boolean):void {
			if (value) {
				dispatchEvent(new DropDownMenuEvent(DropDownMenuEvent.CREATE_CONTAINER, this, _data, true));
			}
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		public function get parentContainer():IDropDownMenuItemContainer {
			return _parentContainer;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get group():TriggerButtonGroup {
			return _group;
		}
		public function set group(value:TriggerButtonGroup):void {
			_group = value as DropDownItemGroup;
		}

		/**
		 * Инициализация.
		 */
		protected function init():void {

		}
	}
}
