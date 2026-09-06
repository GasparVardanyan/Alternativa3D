package alternativa.gui.controls.button {
	import alternativa.gui.mouse.ICursorActiveListener;
	
	import flash.events.EventDispatcher;
	
	/**
	 * Группа, которая объеденяет несколько кнопок с интерфейсом ITriggerButton в одну компоненту.
	 * 
	 */	
	public class TriggerButtonGroup extends EventDispatcher implements ICursorActiveListener {
		
		/**
	 	 * Список кнопок.
	 	 */
		public var buttonsList:Array;
		
		public function TriggerButtonGroup() {
			buttonsList = new Array();
		}
		
		/**
	 	 * Добавление кнопки в группу.
	 	 * @param button Кнопка.
	 	 */
		public function addButton(button:ITriggerButton):void {
			buttonsList.push(button);
			button.group = this;
			button.addCursorListener(this);
		}
		
		/**
		 * Удаление кнопки из группы .
		 * @param button Кнопка.
		 */		
		public function removeButton(button:ITriggerButton):void {
			button.removeCursorListener(this);
			button.group = null;
			buttonsList.splice(buttonsList.indexOf(button), 1);
		}
		
		/**
		 * @inheritDoc
		 */		
		public function click():void {}
		
		/**
		 * @inheritDoc
		 */		
		public function doubleClick():void {}
		
		/**
		 * @inheritDoc
		 */		
		public function get over():Boolean {
			return false;
		}
		public function set over(value:Boolean):void {}
		
		/**
		 * @inheritDoc
		 */	
		public function get pressed():Boolean {
			return false;
		}
		public function set pressed(value:Boolean):void {}
		
		/**
		 * @inheritDoc
		 */		
		public function get locked():Boolean {
			return false;
		}
		public function set locked(value:Boolean):void {}

	}
}