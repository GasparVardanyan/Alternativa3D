package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class ListSkin {
		[Embed(source="../resources/list/mask.png")] 
		private static const mask:Class;
		public static const maskTexture:BitmapData = new mask().bitmapData;
		
		public static const edge:int = 5;
	}
}