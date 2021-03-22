package core.panels
{
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class LoadingInfoPanel extends PanelsBase
	{
		public var g_loaderLabel:Label = new Label();
		public var g_loaderLabelLoaded:uint = 0;
		public var g_loaderLabelEnd:String = "% loaded...";
		
		public function LoadingInfoPanel()
		{
			g_panel.addChild(g_loaderLabel);
			g_panel.closeButtonShow = false;
			g_panel.title = "Loading...";
			g_panel_setWidth = 150;
			g_panel_setHeight = 100;
		}
		
		public function g_loaderLabel_set(g_loaderLabelLoaded:uint):void
		{
			this.g_loaderLabelLoaded = g_loaderLabelLoaded;
			g_loaderLabel.text = g_loaderLabelLoaded + g_loaderLabelEnd;
			afterDraw();
		}
		
		override protected function addedToGUI(callback:Function = null):void
		{
			if (callback != null) callback();
		}
		
		override protected function afterDraw():void
		{
			g_loaderLabel.x = g_panel.width / 2 - g_loaderLabel.width / 2;;
			g_loaderLabel.y = g_panel.height / 2 - g_loaderLabel.height / 2;
		}
	}
}