package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;


	public class SmallButtonSkin {
		
		[Embed(source="../resources/smallButton/stateUp.png")] 
		private static const stateUpImage:Class;
		public static const stateUpTexture:BitmapData = new stateUpImage().bitmapData;
		
		[Embed(source="../resources/smallButton/stateOver.png")] 
		private static const stateOverImage:Class;
		public static const stateOverTexture:BitmapData = new stateOverImage().bitmapData;
		
		[Embed(source="../resources/smallButton/stateDown.png")] 
		private static const stateDownImage:Class;
		public static const stateDownTexture:BitmapData = new stateDownImage().bitmapData;
		
		public static const offset:int = 1;
		
		public static const edgeH:int = 10;
		
		public static const edgeV:int = 5;
		
		public static const height:int = 14;
	}
}
