package core 
{
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.IStageSizeListener;
	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;
	import alternativa.gui.theme.defaulttheme.controls.text.TextInput;
	import alternativa.gui.theme.defaulttheme.controls.tree.Tree;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class GUIComponents extends GUIobject implements IStageSizeListener
	{
		public var g_btnCon:Sprite = new Sprite();
		public var g_btn_New:Button = new Button();
		public var g_btn_OpenFolder:Button = new Button();
		public var g_btn_OpenTARA:Button = new Button();
		public var g_btn_Export:Button = new Button();
		public var g_btn_AddFolder:Button = new Button();
		public var g_btn_AddFile:Button = new Button();
		public var g_btn_Delete:Button = new Button();
		public var g_btn_Copy:Button = new Button();
		public var g_btn_Cut:Button = new Button();
		public var g_btn_Paste:Button = new Button();
		public var g_btn_Rename:Button = new Button();
		public var g_btn_About:Button = new Button();
		public var g_inp_path:TextInput = new TextInput();
		public var g_btn_Find:Button = new Button();
		public var g_explorer:Tree = new Tree();
		
		public function GUIComponents()
		{
			g_btn_New.label = "New";
			g_btnCon.addChild(g_btn_New);
			g_btn_OpenFolder.label = "Open Folder";
			g_btnCon.addChild(g_btn_OpenFolder);
			g_btn_OpenTARA.label = "Open TARA";
			g_btnCon.addChild(g_btn_OpenTARA);
			g_btn_Export.label = "Export";
			g_btnCon.addChild(g_btn_Export);
			g_btn_AddFolder.label = "Add Folder";
			g_btnCon.addChild(g_btn_AddFolder);
			g_btn_AddFile.label = "Add File";
			g_btnCon.addChild(g_btn_AddFile);
			g_btn_Delete.label = "Delete";
			g_btnCon.addChild(g_btn_Delete);
			g_btn_Copy.label = "Copy";
			g_btnCon.addChild(g_btn_Copy);
			g_btn_Cut.label = "Cut";
			g_btn_Cut.locked = true;
			g_btnCon.addChild(g_btn_Cut);
			g_btn_Paste.label = "Paste";
			g_btn_Paste.locked = true;
			g_btnCon.addChild(g_btn_Paste);
			g_btn_Rename.label = "Rename";
			g_btnCon.addChild(g_btn_Rename);
			g_btn_About.label = "About";
			g_btnCon.addChild(g_btn_About);
			addChild(g_btnCon);
			
			g_inp_path.locked = true;
			addChild(g_inp_path);
			g_btn_Find.label = "FIND";
			g_btn_Find.locked = true;
			//addChild(g_btn_Find);
			
			addChild(g_explorer);
		}
		
		override protected function draw():void
		{
			var w:Number = MANAGER.MAIN.stage.stageWidth;
			var h:Number = MANAGER.MAIN.stage.stageHeight;
			var heightUsed:Number = 0;
			
			var s:Number = 640 / 13;
			
			for (var i:uint = 0; i < 12; i++)
			{
				g_btnCon.getChildAt(i).width = 2 * s;
				g_btnCon.getChildAt(i).height = s;
				g_btnCon.getChildAt(i).x = heightUsed +  s / 2 + (i % 6) * s * 2;
				g_btnCon.getChildAt(i).y = heightUsed + (i < 6 ? s / 4 : 1.25 * s);
			} heightUsed += 2.25 * s + s / 10;
			
			g_inp_path.width = 12 * s;
			g_inp_path.x = s / 2;
			g_inp_path.y = heightUsed;
			g_btn_Find.x = g_inp_path.x + g_inp_path.width;
			g_btn_Find.y = g_inp_path.y;
			g_btn_Find.height = s / 2;
			g_btn_Find.width = s * 2;
			heightUsed += g_inp_path.height + s / 10;
			
			if (g_explorer)
			{
				g_explorer.x = s / 2;
				g_explorer.y = heightUsed;
				g_explorer.height = h - heightUsed - s / 2;
				g_explorer.width = 12 * s;
			}
		}
		
		public function Draw():void
		{
			draw();
		}
	}
}