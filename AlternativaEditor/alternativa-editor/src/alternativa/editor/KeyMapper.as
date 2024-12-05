package alternativa.editor {
	import __AS3__.vec.Vector;
	
	import flash.events.IEventDispatcher;
	import flash.events.KeyboardEvent;
	
	/**
	 * 
	 */
	public class KeyMapper {
		
		private const MAX_KEYS:int = 31;
		private var keys:int;
		private var map:Vector.<int> = new Vector.<int>(MAX_KEYS);
		private var _dispatcher:IEventDispatcher;
		
		/**
		 * 
		 */
		public function KeyMapper(dispatcher:IEventDispatcher = null) {
			if (dispatcher != null)	startListening(dispatcher);
		}
		
		/**
		 * @param keyNum
		 */
		private function checkKey(keyNum:int):void {
			if (keyNum < 0 || keyNum > MAX_KEYS - 1) throw new ArgumentError("keyNum is out of range");
		}

		/**
		 * @param keyNum
		 * @param keyCode
		 */
		public function mapKey(keyNum:int, keyCode:int):void {
			checkKey(keyNum);
			map[keyNum] = keyCode;
		}
		
		/**
		 * @param keyNum
		 */
		public function unmapKey(keyNum:int):void {
			checkKey(keyNum);
			map[keyNum] = 0;
			keys &= ~(1 << keyNum);
		}
		
		/**
		 * @param e
		 */
		public function checkEvent(e:KeyboardEvent):void {
			var idx:int = map.indexOf(e.keyCode);
			if (idx > -1) e.type == KeyboardEvent.KEY_DOWN ? keys |= (0x1 << idx): keys &= ~(0x1 << idx);
		}
		
		/**
		 * @param keyNum
		 * @return 
		 */
		public function getKeyState(keyNum:int):int {
			return (keys >> keyNum) & 0x1;
		}
		
		/**
		 * @param keyNum
		 * @return 
		 */
		public function keyPressed(keyNum:int):Boolean {
			return getKeyState(keyNum) == 1;
		}
		
		/**
		 * @param dispatcher
		 */
		public function startListening(dispatcher:IEventDispatcher):void {
			if (_dispatcher == dispatcher) return;
			if (_dispatcher != null) unregisterListeners();
			_dispatcher = dispatcher;
			if (_dispatcher != null) registerListeners();
		}

		/**
		 * 
		 */
		public function stopListening():void {
			if (_dispatcher != null) unregisterListeners();
			_dispatcher = null;
			keys = 0;
		}
		
		/**
		 * 
		 */
		private function registerListeners():void {
			_dispatcher.addEventListener(KeyboardEvent.KEY_DOWN, onKey);
			_dispatcher.addEventListener(KeyboardEvent.KEY_UP, onKey);
		}

		/**
		 * 
		 */
		private function unregisterListeners():void {
			_dispatcher.removeEventListener(KeyboardEvent.KEY_DOWN, onKey);
			_dispatcher.removeEventListener(KeyboardEvent.KEY_UP, onKey);
		}
		
		/**
		 * 
		 */
		private function onKey(e:KeyboardEvent):void {
			checkEvent(e);
		}

	}
}