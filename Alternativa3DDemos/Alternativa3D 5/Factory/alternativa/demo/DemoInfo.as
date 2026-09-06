package alternativa.demo {

	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.text.*;

	/**
	 * Logo and text information.
	 */
	public class DemoInfo extends Sprite {

		// Logo image
		[Embed (source="logo.png")] private static var logoBmp:Class;
		private var logo:Bitmap = new logoBmp();

		private var textInfo:TextField = new TextField();

		/**
		 * Creates a new instance.
		 * 
		 * @param title title for text information
		 */
		public function DemoInfo(title:String) {
			addChild(logo);
			addChild(textInfo);
			textInfo.y = logo.height;
			textInfo.autoSize = TextFieldAutoSize.LEFT;
			textInfo.selectable = false;
			textInfo.text = title;
			// The format of the title
			textInfo.setTextFormat(new TextFormat("Tahoma", 10, 0xBB6633));
			// The format of text information
			textInfo.defaultTextFormat = new TextFormat("Tahoma", 10, 0x7F7F7F); 
		}

		/**
		 * The method adds a string to the text information.
		 *
		 * @param text a text string
		 */
		public function write(text:String):void {
			textInfo.appendText("\n" + text);
		}

	}
}
