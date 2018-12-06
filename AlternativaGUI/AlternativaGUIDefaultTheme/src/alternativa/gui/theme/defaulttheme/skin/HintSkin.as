package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class HintSkin {
		
		[Embed(source="../resources/hint/bg.png")] 
		private static const bgImage:Class;
		public static const bgBD:BitmapData = new bgImage().bitmapData;
			
		public static const edge:int = 5;	
			
	}
}