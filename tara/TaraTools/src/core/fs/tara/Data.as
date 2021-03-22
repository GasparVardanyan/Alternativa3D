package core.fs.tara
{
	import flash.utils.ByteArray;
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Data
	{
		public var name:String;
		public var data:*;
		
		public function Data(name:String = null, data:* = null)
		{
			this.name = name;
			this.data = data?data:new ByteArray();
		}
		
		public function clone():Data
		{
			var b:ByteArray;
			if (this is Folder)
			{
				b = Folder(this).tara;
				b.position = 0;
				var f:Folder = new Folder(name);
				f.tara = b;
				return f;
			} else {
				b = new ByteArray();
				b.writeBytes(ByteArray(data), 0, ByteArray(data).length);
				return new Data(name, b);
			}
		}
	}
}