package
{
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.theme.defaulttheme.init.DefaultTheme;
	import alternativa.gui.theme.defaulttheme.primitives.base.Hint;
	import alternativa.gui.theme.defaulttheme.skin.Cursors;
	import alternativa.init.GUI;
	import core.GUIComponents;
	import core.MANAGER;
	import core.Panels;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	
	[SWF(backgroundColor = "#999999", frameRate = "40")]
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Main extends Sprite
	{
		public function Main()
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.quality = StageQuality.HIGH;
			
			this.mouseEnabled = false;
			this.tabEnabled = false;
			
            // Container with objects
			MANAGER.GUI_OBJCON = new Sprite();
			MANAGER.GUI_OBJCON.mouseEnabled = false;
			MANAGER.GUI_OBJCON.tabEnabled = false;
			addChild(MANAGER.GUI_OBJCON);
			
            // Hint container
			MANAGER.GUI_HINTCON = new Sprite();
			MANAGER.GUI_HINTCON.mouseEnabled = false;
			MANAGER.GUI_HINTCON.tabEnabled = false;
			addChild(MANAGER.GUI_HINTCON);
			
            // AlternativaGUIDefaultTheme initialization
			DefaultTheme.init();
			
            // AlternativaGUI initialization
			GUI.init(stage, false);
			
            // LayoutManager initialization
			LayoutManager.init(stage, [MANAGER.GUI_OBJCON, MANAGER.GUI_HINTCON]);
			
            // Add hint class to the MouseManager
			MANAGER.GUI_HINT = new Hint();
			MouseManager.setHintImaging(MANAGER.GUI_HINTCON, MANAGER.GUI_HINT);
			
            // CursorManager initialization
			CursorManager.init(Cursors.createCursors());
			
			// Main initialization
			MANAGER.MAIN = this;
			
			// GUI initialization
			MANAGER.GUI = new GUIComponents();
			MANAGER.GUI_OBJCON.addChild(MANAGER.GUI);
			
			// Panels initialization
			MANAGER.GUI_PANELS = new Panels();
			
			// Functions initialization
			MANAGER.FUNCTIONS.init();
		}
	}
}