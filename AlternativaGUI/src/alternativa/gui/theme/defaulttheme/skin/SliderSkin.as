package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	public class SliderSkin {
		
		[Embed(source="../resources/slider/bg.png")] 
		private static const trackImage:Class;
		public static const trackBD:BitmapData = new trackImage().bitmapData;
		
		[Embed(source="../resources/slider/bgFull.png")] 
		private static const trackFullImage:Class;
		public static const trackFullBD:BitmapData = new trackFullImage().bitmapData;
		
		[Embed(source="../resources/slider/runner.png")] 
		private static const runnerImage:Class;
		public static const runnerBD:BitmapData = new runnerImage().bitmapData;
		
		[Embed(source="../resources/slider/runner_over.png")] 
		private static const runnerOverImage:Class;
		public static const runnerOverBD:BitmapData = new runnerOverImage().bitmapData;
		
		[Embed(source="../resources/slider/tick.png")] 
		private static const tickImage:Class;
		public static const tickBD:BitmapData = new tickImage().bitmapData;
		
		public static const edge:int = 5;
		
	}
}