package away3dlite.ui
{
	import away3dlite.events.Keyboard3DEvent;

	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	/**
	 * @author katopz
	 */
	public class Keyboard3D extends EventDispatcher
	{
		public static var isKeyRight:Boolean = false;
		public static var isKeyLeft:Boolean = false;
		public static var isKeyForward:Boolean = false;
		public static var isKeyBackward:Boolean = false;
		public static var isKeyUp:Boolean = false;
		public static var isKeyDown:Boolean = false;

		public static var isKeyPeekLeft:Boolean = false;
		public static var isKeyPeekRight:Boolean = false;

		public static var isCTRL:Boolean = false;
		public static var isALT:Boolean = false;
		public static var isSHIFT:Boolean = false;
		public static var isSPACE:Boolean = false;

		public static var keyType:String = KeyboardEvent.KEY_UP;
		public static var keyCode:uint = 0;

		public static var position:Vector3D;

		private var _target:InteractiveObject;
		public var yUp:Boolean = true;
		public var _eventHandler:Function;

		private var _keys:Array = [];

		public function Keyboard3D(target:InteractiveObject, eventHandler:Function = null)
		{
			_target = target;
			_eventHandler = eventHandler;

			_target.addEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_target.addEventListener(KeyboardEvent.KEY_UP, keyHandler);

			if (_eventHandler is Function)
			{
				_target.addEventListener(KeyboardEvent.KEY_DOWN, _eventHandler);
				_target.addEventListener(KeyboardEvent.KEY_UP, _eventHandler);
			}

			position = new Vector3D();
		}

		private function onKey(event:Event):void
		{
			var _dx:int, _dy:int, _dz:int, _dw:int = 0;

			//up, down
			if (isKeyForward)
				_dz = 1;
			else if (isKeyBackward)
				_dz = -1;

			//left, right
			if (isKeyRight)
				_dx = 1;
			else if (isKeyLeft)
				_dx = -1;

			//up, down
			if (isKeyUp)
				_dy = 1;
			else if (isKeyDown)
				_dy = -1;

			//peek left, peek right
			if (isKeyPeekLeft)
				_dw = -1;
			else if (isKeyPeekRight)
				_dw = 1;

			position.x = _dx;
			position.y = yUp ? _dy : -_dy;
			position.z = _dz;
			position.w = _dw;

			dispatchEvent(new Keyboard3DEvent(Keyboard3DEvent.KEY_PRESS, position));
		}

		private function addKey(keyCode:int):void
		{
			if (_keys.indexOf(keyCode) == -1)
				_keys.push(keyCode);
		}

		private function removeKey(keyCode:int):void
		{
			var i:int = _keys.indexOf(keyCode);
			if (i != -1)
				_keys.splice(i, 1);
		}

		private function keyHandler(event:KeyboardEvent):void
		{
			isCTRL = event.ctrlKey;
			isALT = event.altKey;
			isSHIFT = event.shiftKey;

			keyType = event.type;

			switch (event.type)
			{
				case KeyboardEvent.KEY_DOWN:
					keyCode = event.keyCode;
					isSPACE = (event.keyCode == Keyboard.SPACE);

					switch (event.keyCode)
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							isKeyForward = true;
							isKeyBackward = false;
							addKey(event.keyCode);
							break;

						case "S".charCodeAt():
						case Keyboard.DOWN:
							isKeyBackward = true;
							isKeyForward = false;
							addKey(event.keyCode);
							break;

						case "A".charCodeAt():
						case Keyboard.LEFT:
							isKeyLeft = true;
							isKeyRight = false;
							addKey(event.keyCode);
							break;

						case "D".charCodeAt():
						case Keyboard.RIGHT:
							isKeyRight = true;
							isKeyLeft = false;
							addKey(event.keyCode);
							break;

						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							isKeyDown = true;
							isKeyUp = false;
							addKey(event.keyCode);
							break;

						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							isKeyUp = true;
							isKeyDown = false;
							addKey(event.keyCode);
							break;

						case "Q".charCodeAt():
						case "[".charCodeAt():
							isKeyPeekLeft = true;
							isKeyPeekRight = false;
							addKey(event.keyCode);
							break;

						case "E".charCodeAt():
						case "]".charCodeAt():
							isKeyPeekRight = true;
							isKeyPeekLeft = false;
							addKey(event.keyCode);
							break;
					}

					if (_keys.length > 0 && !_target.hasEventListener(Event.ENTER_FRAME))
						_target.addEventListener(Event.ENTER_FRAME, onKey, false, 0, true);
					break;
				case KeyboardEvent.KEY_UP:

					if (event.keyCode == Keyboard.SPACE)
						isSPACE = false;

					switch (event.keyCode)
					{
						case "W".charCodeAt():
						case Keyboard.UP:
							isKeyForward = false;
							removeKey(event.keyCode);
							;
							break;

						case "S".charCodeAt():
						case Keyboard.DOWN:
							isKeyBackward = false;
							removeKey(event.keyCode);
							;
							break;

						case "A".charCodeAt():
						case Keyboard.LEFT:
							isKeyLeft = false;
							removeKey(event.keyCode);
							;
							break;

						case "D".charCodeAt():
						case Keyboard.RIGHT:
							isKeyRight = false;
							removeKey(event.keyCode);
							;
							break;

						case "C".charCodeAt():
						case Keyboard.PAGE_UP:
							isKeyDown = false;
							removeKey(event.keyCode);
							;
							break;

						case "V".charCodeAt():
						case Keyboard.PAGE_DOWN:
							isKeyUp = false;
							removeKey(event.keyCode);
							;
							break;

						case "Q".charCodeAt():
						case "[".charCodeAt():
							isKeyPeekLeft = false;
							isKeyPeekRight = false;
							removeKey(event.keyCode);
							;
							break;

						case "E".charCodeAt():
						case "]".charCodeAt():
							isKeyPeekRight = false;
							isKeyPeekLeft = false;
							removeKey(event.keyCode);
							;
							break;
					}
					if (_keys.length == 0)
					{
						_target.removeEventListener(Event.ENTER_FRAME, onKey);
						keyCode = 0;
						position = new Vector3D();
					}
					break;
			}
		}

		public function destroy():void
		{
			_target.removeEventListener(KeyboardEvent.KEY_DOWN, keyHandler);
			_target.removeEventListener(KeyboardEvent.KEY_UP, keyHandler);
			_target.removeEventListener(Event.ENTER_FRAME, onKey);

			if (_eventHandler is Function)
			{
				_target.removeEventListener(KeyboardEvent.KEY_DOWN, _eventHandler);
				_target.removeEventListener(KeyboardEvent.KEY_UP, _eventHandler);
			}
		}
	}
}