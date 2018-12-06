package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class PanelSkin {
		
		[Embed(source="../resources/panel/bg.png")] 
		private static const panelBg:Class;
		public static const panelBgTexture:BitmapData = new panelBg().bitmapData;
		
		[Embed(source="../resources/panel/line.png")] 
		private static const panelLine:Class;
		public static const panelLineTexture:BitmapData = new panelLine().bitmapData;

        [Embed(source="../resources/panel/closeBtn.png")]
		private static const closeBtnImage:Class;
		public static const closeStateUp:BitmapData = new closeBtnImage().bitmapData;

        [Embed(source="../resources/panel/closeBtnOver.png")]
		private static const closeBtnOverImage:Class;
		public static const closeStateOver:BitmapData = new closeBtnOverImage().bitmapData;
		
		public static const panelEdgeH:int = 10;
		public static const panelEdgeV:int = 25;
		public static const offsetBgTop:int = 1;
		public static const offsetBgLeft:int = 2;
		public static const offsetBgRight:int = 2;
		public static const offsetBgBottom:int = 3;
		
		public static const offsetLine:int = 18;
		public static const edgeLine:int = 5;
	}
}
