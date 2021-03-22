package core
{
	import alternativa.gui.theme.defaulttheme.primitives.base.Hint;
	import core.fs.ExternalFolders;
	import core.fs.Folder;
	import flash.display.Sprite;
	import Main;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class MANAGER
	{
		public static var MAIN:Main;
		
		public static var GUI:GUIComponents;
		public static var GUI_OBJCON:Sprite;
		public static var GUI_HINT:Hint;
		public static var GUI_HINTCON:Sprite;
		public static var GUI_PANELS:Panels;
		
		public static var FUNCTIONS:Functions = new Functions();
		
		//public static var D_RES:Folder = new Folder("D_RES");
		public static var D_TARA:Folder;
		public static var D_SELECTED_PATH:String;
		public static var D_SELECTED_NAME:String;
		public static var D_SELECTED_ISFOLDER:Boolean;
		public static var D_EXPORT:ExportType = new ExportType();
		public static var D_EXPORT_TARA5_PASSWORD:String;
		public static var D_COPY_CUT_PASTE:CopyCutPaste = new CopyCutPaste();
		public static var D_EXTERNALFOLDERS:ExternalFolders = new ExternalFolders();
	}
}