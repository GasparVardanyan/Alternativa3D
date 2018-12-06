package alternativa.gui.theme.defaulttheme.skin {
	
	import flash.display.BitmapData;
	
	public class BorderContainerSkin {
		
		[Embed(source="../resources/borderContainer/border.png")]
		private static const borderImage:Class;
		public static const borderTexture:BitmapData = new borderImage().bitmapData;
		
		[Embed(source="../resources/borderContainer/borderTopLine.png")]
		private static const lineImage:Class;
		public static const lineTexture:BitmapData = new lineImage().bitmapData;
		
		public static const edge:int = 5;
		
	}
}
