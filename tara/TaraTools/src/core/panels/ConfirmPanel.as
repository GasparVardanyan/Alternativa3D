package core.panels
{
	import alternativa.gui.theme.defaulttheme.controls.buttons.Button;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import flash.events.MouseEvent;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class ConfirmPanel extends PanelsBase
	{
		public var g_lab_message:Label = new Label();
		public var g_btn_ok:Button;
		public var g_btn_cancel:Button;
		private var message:String;
		private var mw:Number;
		
		public function ConfirmPanel()
		{
			g_panel.addChild(g_lab_message);
		}
		
		override protected function addedToGUI(callback:Function = null):void
		{
			g_panel.closeButtonShow = false;
			if (g_btn_ok && g_panel.contains(g_btn_ok)) g_panel.removeChild(g_btn_ok);
			g_btn_ok = new Button();
			g_btn_ok.label = "OK";
			g_btn_ok.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				close();
				if (callback != null) callback(true);
			});
			g_panel.addChild(g_btn_ok);
			if (g_btn_cancel && g_panel.contains(g_btn_cancel)) g_panel.removeChild(g_btn_cancel);
			g_btn_cancel = new Button();
			g_btn_cancel.label = "Cancel";
			g_btn_cancel.addEventListener(MouseEvent.CLICK, function(e:MouseEvent):void
			{
				if (callback != null) callback(false);
				close();
			});
			g_panel.addChild(g_btn_cancel);
			message = g_lab_message.text;
			mw = g_lab_message.width;
		}
		
		override protected function beforeDraw():void
		{
			var w:Number = g_panel.width;
			var c:uint = parseInt(String(mw / w)) + 1;
			g_panel_setHeight = 25 + 2 * 8 + c * g_lab_message.size + 32;
		}
		
		override protected function afterDraw():void
		{
			var w:Number = g_panel.width;
			var h:Number = g_panel.height;
			var heightUsed:Number = 0;
			heightUsed += 25;
			heightUsed += 8;
			
			g_lab_message.y = heightUsed;
			
			var _new:String = "";
			var c:uint = parseInt(String(mw / w)) + 1;
			var step:uint = parseInt(String(message.length / c));
			
			for (var i:uint = 0; i < c; i++)
			{
				var s:uint = i * step;
				var e:uint = (i + 1) * step;
				if (e > message.length) e = message.length;
				_new += message.slice(s, e) + "\n";
			}
			
			g_lab_message.text = _new;
			g_lab_message.x = w / 2 - g_lab_message.width / 2;
			heightUsed += c * g_lab_message.size;
			
			g_btn_ok.width = g_btn_cancel.width = 100;
			g_btn_ok.y = g_btn_cancel.y = heightUsed + 4;
			g_btn_ok.x = w - 200;
			g_btn_cancel.x = 100;
		}
	}
}