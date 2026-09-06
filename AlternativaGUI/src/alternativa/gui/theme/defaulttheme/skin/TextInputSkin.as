package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	public class TextInputSkin {
		
		[Embed(source="../resources/inputText/bg.png")] 
		private static const bg:Class;
		public static const bgTexture:BitmapData = new bg().bitmapData;
		
		public static const offset:int = 1;
		public static const edge:int = 6;
	}
}