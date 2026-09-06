package alternativa.gui.controls.text {
	import alternativa.gui.mouse.CursorManager;
	
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.system.Capabilities;
	import flash.text.TextField;


	/**
	 * Решение проблемы кодировки в unix системах. 
	 * 
	 */	
	public class TextFieldUtf8 extends flash.text.TextField {
		private static const NOTHING:int=-1;
		private static const INVALID:int=-2;

		private var character:int=0;
		private var bits_left:int=0;
		private var utf32_char:int=NOTHING;

		public function TextFieldUtf8() {
			super();
            var version:Array = Capabilities.version.split(",");
			if (Boolean(Capabilities.os.search("Linux") != -1) && Capabilities.playerType != "StandAlone" && ((version[0]=="UNIX 10" && int(version[1]<1)) || version[0]=="UNIX 9" || version[0]=="UNIX 8")) {
				addEventListener(TextEvent.TEXT_INPUT, textInputHandler, false, 1);
				addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler, false, 1);
			}
			
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function addedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, addedToStage);
			addEventListener(Event.REMOVED_FROM_STAGE, removedToStage);
			addEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			addEventListener(MouseEvent.MOUSE_OUT, mouseOut);
		}
		
		private function removedToStage(e:Event):void {
			removeEventListener(MouseEvent.MOUSE_OVER, mouseOver);
			removeEventListener(MouseEvent.MOUSE_OUT, mouseOut);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedToStage);
			addEventListener(Event.ADDED_TO_STAGE, addedToStage);
		}
		
		private function mouseOver(e:Event):void {
			CursorManager.cursorType = CursorManager.IBEAM;
		}
		private function mouseOut(e:Event):void {
			CursorManager.reset();
		}

		private function utf8Decode(b:int):int {
			if (bits_left == 0) {
				if ((b & 0x80) == 0) {
					return (b & 0x7f);
				} else if ((b & 0xe0) == 0xc0) {
					character=(b & 0x1f) << 6;
					bits_left=6;
				} else if ((b & 0xf0) == 0xe0) {
					character=(b & 0x0f) << 12;
					bits_left=12;
				} else if ((b & 0xf8) == 0xf0) {
					character=(b & 0x07) << 18;
					bits_left=18;
				} else if ((b & 0xfc) == 0xf8) {
					character=(b & 0x03) << 24;
					bits_left=24;
				} else if ((b & 0xfe) == 0xfc) {
					character=(b & 0x01) << 30;
					bits_left=30;
				} else {
					return INVALID;
				}

				return NOTHING;
			}

			if ((b & 0xc0) != 0x80) {
				return INVALID;
			}

			bits_left-=6;
			character|=(b & 0x3f) << bits_left;

			if (bits_left == 0) {
				return character;
			} else if (bits_left > 30) {
				// paranoia check for robust behaviour
				// in case of memory corruption, avoids endless loops...
				bits_left=0;

				return INVALID;
			}

			return NOTHING;
		}

		private function keyDownHandler(event:KeyboardEvent):void {
			trace("keyDownHandler");
			utf32_char=utf8Decode(event.charCode);
		}

		private function textInputHandler(event:TextEvent):void {
			trace("textInputHandler");
			if (utf32_char == 10 && !this.multiline) {
				event.preventDefault();
				event.stopImmediatePropagation();
				return;
			}

			if (event.text.length == 1) {
				if (utf32_char != NOTHING && utf32_char != INVALID) {
					if (this.selectionBeginIndex == this.selectionEndIndex) {
						var t1:String=this.text.substr(0, this.caretIndex);
						var t2:String=this.text.substr(this.caretIndex);
						var c_idx:int=this.caretIndex + 1;
					} else {
						t1=this.text.substr(0, this.selectionBeginIndex);
						t2=this.text.substr(this.selectionEndIndex);
						c_idx=this.selectionBeginIndex + 1;
					}

					event.text=this.text=t1 + String.fromCharCode(utf32_char) + t2;

					this.setSelection(c_idx, c_idx);
					this.dispatchEvent(new Event(Event.CHANGE));
				} else {
					event.stopImmediatePropagation();
				}
				event.preventDefault();
			}
		}

	}
}