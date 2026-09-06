package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class CheckBoxSkin {
		
		[Embed(source="../resources/checkBox/icon.png")] 
		private static const icon:Class;
		public static const iconBD:BitmapData = new icon().bitmapData;
		
		[Embed(source="../resources/checkBox/up.png")] 
		private static const upState:Class;
		public static const upStateTexture:BitmapData = new upState().bitmapData;
		
		[Embed(source="../resources/checkBox/over.png")] 
		private static const overState:Class;
		public static const overStateTexture:BitmapData = new overState().bitmapData;
	}
}