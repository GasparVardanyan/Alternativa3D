package core.panels
{
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.IStageSizeListener;
	import alternativa.gui.theme.defaulttheme.container.panel.Panel;
	import alternativa.gui.theme.defaulttheme.event.PanelEvent;
	import core.MANAGER;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class PanelsBase extends GUIobject implements IStageSizeListener
	{
		public var g_panel:Panel = new Panel();
		
		protected var g_panel_setWidth:Number = 0;
		protected var g_panel_setHeight:Number = 0;
		
		public function PanelsBase()
		{
			g_panel.closeButtonShow = true;
			g_panel.addEventListener(PanelEvent.CLOSE, close);
			addChild(g_panel);
		}
		
		public function close(e:PanelEvent = null):void
		{
			MANAGER.GUI_OBJCON.removeChildren();
			MANAGER.GUI_OBJCON.addChild(MANAGER.GUI);
			removedFromGUI();
		}
		
		public function addToGUI(callback:Function = null):void
		{
			MANAGER.GUI_OBJCON.removeChildren();
			MANAGER.GUI_OBJCON.addChild(this);
			addedToGUI(callback);
		}
		
		protected function addedToGUI(callback:Function = null):void {}
		protected function removedFromGUI():void {}
		
		override protected function draw():void
		{
			var w:Number = MANAGER.MAIN.stage.stageWidth;
			var h:Number = MANAGER.MAIN.stage.stageHeight;
			g_panel.width = 3 * w / 4;
			g_panel.height = 3 * h / 4;
			var heightUsed:Number = 0;
			beforeDraw();
			
			if (g_panel_setWidth) g_panel.width = g_panel_setWidth;
			if (g_panel_setHeight) g_panel.height = g_panel_setHeight;
			g_panel.x = w / 2 - g_panel.width / 2;
			g_panel.y = h / 2 - g_panel.height / 2;
			
			afterDraw();
		}
		
		protected function afterDraw():void {}
		protected function beforeDraw():void {}
		
		public function Draw():void
		{
			draw();
		}
	}
}