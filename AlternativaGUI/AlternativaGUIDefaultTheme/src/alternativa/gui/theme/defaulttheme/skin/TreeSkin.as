package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;
	
	
	public class TreeSkin {
		
		[Embed(source="../resources/tree/folder_open.png")] 
		private static const folderOpenImage:Class;
		public static const folderOpen:BitmapData = new folderOpenImage().bitmapData;
		
		[Embed(source="../resources/tree/folder_close.png")] 
		private static const folderCloseImage:Class;
		public static const folderClose:BitmapData = new folderCloseImage().bitmapData;
		
		[Embed(source="../resources/tree/arrow_open.png")] 
		private static const arrowOpenImage:Class;
		public static const arrowOpen:BitmapData = new arrowOpenImage().bitmapData;
		
		[Embed(source="../resources/tree/arrow_close.png")] 
		private static const arrowCloseImage:Class;
		public static const arrowClose:BitmapData = new arrowCloseImage().bitmapData;
		
		[Embed(source="../resources/tree/document.png")] 
		private static const fileImage:Class;
		public static const file:BitmapData = new fileImage().bitmapData;
	}
}