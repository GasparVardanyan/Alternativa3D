package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class RadioButtonSkin {
		
		[Embed(source="../resources/radioButton/dot.png")] 
		private static const icon:Class;
		public static const iconBD:BitmapData = new icon().bitmapData;
		
		[Embed(source="../resources/radioButton/up.png")] 
		private static const upState:Class;
		public static const upStateTexture:BitmapData = new upState().bitmapData;
		
		[Embed(source="../resources/radioButton/over.png")] 
		private static const overState:Class;
		public static const overStateTexture:BitmapData = new overState().bitmapData;
	}
}