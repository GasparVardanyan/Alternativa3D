package core.panels
{
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class AlertPanel extends PanelsBase
	{
		public var g_lab_message:Label = new Label();
		private var message:String;
		private var mw:Number;
		private var closed:Function = null;
		
		public function AlertPanel()
		{
			g_panel.addChild(g_lab_message);
		}
		
		override protected function addedToGUI(callback:Function = null):void
		{
			message = g_lab_message.text;
			mw = g_lab_message.width;
			if (callback != null) closed = callback;
			else closed = null;
		}
		
		override protected function removedFromGUI():void
		{
			if (closed != null) closed();
		}
		
		override protected function beforeDraw():void
		{
			var w:Number = g_panel.width;
			var c:uint = parseInt(String(mw / w)) + 1;
			g_panel_setHeight = 25 + 2 * 8 + c * g_lab_message.size;
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
		}
	}
}