package gui.events {
	
	import flash.events.Event;
	
	/**
	 * @author Michael
	 */
	public class PropListEvent extends Event {
		public static const SELECT:String = "select";
        private var _selectedIndex:int;
        private var _selectedItem:*;

		public function PropListEvent(index:int, item:*) {
			super(PropListEvent.SELECT, false, false);
			_selectedIndex = index;
			_selectedItem = item;
		}
		
		public function get selectedIndex():int {
			return _selectedIndex;
		}
		
		public function get selectedItem():* {
			return _selectedItem;
		}
		
		override public function toString():String {
			return formatToString("ListEvents", "type", "bubbles", "cancelable", "selectedIndex", "selectedItem");
		}

		override public function clone():Event {
			return new PropListEvent(_selectedIndex, _selectedItem);
		}
		
	}
}
