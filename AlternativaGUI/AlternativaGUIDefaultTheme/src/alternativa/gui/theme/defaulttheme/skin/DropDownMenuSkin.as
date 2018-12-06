package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;

	public class DropDownMenuSkin {
		[Embed(source="../resources/dropDownMenu/panelBackground.png")]
		private static const itemsBackground:Class;
		public static const itemsBackgroundTexture:BitmapData = new itemsBackground().bitmapData;

		[Embed(source="../resources/dropDownMenu/topBackground.png")]
		private static const topBackground:Class;
		public static const topBackgroundTexture:BitmapData = new topBackground().bitmapData;

		[Embed(source="../resources/listObject/stateDown.png")]
		private static const itemStateDown:Class;
		public static const itemStateDownTexture:BitmapData = new itemStateDown().bitmapData;

		[Embed(source="../resources/listObject/stateOver.png")]
		private static const itemStateOver:Class;
		public static const itemStateOverTexture:BitmapData = new itemStateOver().bitmapData;

		public static const itemStateEdge:int = 2;
	}
}
