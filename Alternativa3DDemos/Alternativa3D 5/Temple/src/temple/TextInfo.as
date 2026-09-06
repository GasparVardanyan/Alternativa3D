package temple {
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	/**
	 * Text field to show various text information.
	 */
	public class TextInfo extends TextField {
		
		public function TextInfo() {
			autoSize = TextFieldAutoSize.LEFT;
			selectable = false;
			text = "Alternativa3D 5.0\nDemo \"Temple\"" + "\n";
			setTextFormat(new TextFormat("Tahoma", 10, 0xBB6633));
			defaultTextFormat = new TextFormat("Tahoma", 10, 0x333333); 
		}
		
		public function write(value:String):void {
			appendText("\n" + value);
		}
	}
}