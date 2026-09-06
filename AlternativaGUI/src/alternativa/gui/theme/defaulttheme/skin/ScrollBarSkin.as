package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	public class ScrollBarSkin {
		
		[Embed(source="../resources/scrollBar/iconDown.png")] 
		private static const iconDown:Class;
		public static const iconDownBD:BitmapData = new iconDown().bitmapData;
		
		[Embed(source="../resources/scrollBar/iconLine.png")] 
		private static const iconLine:Class;
		public static const iconLineBD:BitmapData = new iconLine().bitmapData;
		
		[Embed(source="../resources/scrollBar/iconUp.png")] 
		private static const iconUp:Class;
		public static const iconUpBD:BitmapData = new iconUp().bitmapData;
		
		[Embed(source="../resources/scrollBar/runnerDown.png")] 
		private static const runnerDown:Class;
		public static const runnerDownBD:BitmapData = new runnerDown().bitmapData;
		
		[Embed(source="../resources/scrollBar/runnerOver.png")] 
		private static const runnerOver:Class;
		public static const runnerOverBD:BitmapData = new runnerOver().bitmapData;
		
		[Embed(source="../resources/scrollBar/runnerUp.png")] 
		private static const runnerUp:Class;
		public static const runnerUpBD:BitmapData = new runnerUp().bitmapData;
		
		public static const edge:int = 5;
	}
}