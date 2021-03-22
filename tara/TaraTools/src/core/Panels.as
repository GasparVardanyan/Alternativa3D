package core
{
	import core.panels.AlertPanel;
	import core.panels.ConfirmPanel;
	import core.panels.ExportPanel;
	import core.panels.LoadingInfoPanel;
	import core.panels.PromptPanel;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Panels
	{
		public var alertPanel:AlertPanel = new AlertPanel();
		public var confirmPanel:ConfirmPanel = new ConfirmPanel();
		public var promptPanel:PromptPanel = new PromptPanel();
		public var exportPanel:ExportPanel = new ExportPanel();
		public var loadingInfoPanel:LoadingInfoPanel = new LoadingInfoPanel();
		
		public function Panels()
		{
		}
		
		public function export(e:MouseEvent = null):void
		{
			if (MANAGER.D_SELECTED_ISFOLDER) exportPanel.addToGUI();
			else MANAGER.FUNCTIONS.exportSelected(e);
		}
		
		public function alert(message:String, title:String = "", onClose:Function = null):void
		{
			alertPanel.g_lab_message.text = message;
			alertPanel.g_panel.title = title?title:"";
			alertPanel.addToGUI(onClose);
		}
		
		public function confirm(message:String, title:String = "", onConfirm:Function = null):void
		{
			confirmPanel.g_lab_message.text = message;
			confirmPanel.g_panel.title = title?title:"";
			confirmPanel.addToGUI(onConfirm);
		}
		
		public function prompt(message:String, title:String = "", onPrompt:Function = null):void
		{
			promptPanel.g_lab_message.text = message;
			promptPanel.g_panel.title = title?title:"";
			promptPanel.addToGUI(onPrompt);
		}
		
		public function loadingInfo(onOpen:Function = null):void
		{
			loadingInfoPanel.addToGUI(onOpen);
		}
	}
}