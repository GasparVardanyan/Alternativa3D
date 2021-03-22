package core
{
	import core.fs.tara.Data;
	import core.fs.tara.Folder;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class CopyCutPaste
	{
		public var buffer:Data;
		private var cuted:Boolean;
		
		public function CopyCutPaste()
		{
		}
		
		public function copy (from:Folder, path:String):void
		{
			if (path)
			{
				if (from.contains(path))
					buffer = from.getDataObject(path).clone();
			}
			else buffer = from.clone();
			MANAGER.GUI.g_btn_Paste.locked = false;
			cuted = false;
		}
		
		public function cut (from:Folder, path:String):void
		{
			copy(from, path);
			from.deletDataObject(path);
			cuted = true;
		}
		
		public function paste (to:Folder, pasteIfExist:Boolean = false, callIfPasteFailed:Function = null):void
		{
			var exist:Boolean = buffer && to.contains(buffer.name);
			if (buffer)
				if (pasteIfExist || !exist)
					if (exist)
						to.getDataObject(buffer.name).data = buffer.data;
					else
						to.addDataObject(buffer.clone());
				else if (callIfPasteFailed != null) callIfPasteFailed();
			if (cuted)
			{
				buffer = null;
				MANAGER.GUI.g_btn_Paste.locked = true;
			}
		}
	}
}