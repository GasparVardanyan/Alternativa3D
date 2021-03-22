package core.fs.tara
{
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Folder extends Data
	{
		public function Folder(name:String = null, data:Vector.<Data> = null)
		{
			this.name = name;
			this.data = data?data:new Vector.<Data>();
		}
		
		public function addData(name:String, data:*):void
		{
			addDataObject((data is ByteArray ? new Data(name, data) : new Folder(name, data)));
		}
		
		public function addDataObject(data:Data):void
		{
			_addDataObject(data, this);
		}
		
		private function _addDataObject(data:Data, f:Folder, path:Array = null):void
		{
			if (!path) path = data.name.split("/");
			var curr:String = path.splice(0, 1);
			
			if (path.length)
			{
				if (!f.contains(curr)) f.addDataObject(new Folder(curr));
				if (f.getDataObject(curr) is Folder) _addDataObject(data, f.getDataObject(curr) as Folder, path);
			} else {
				var b:Boolean = true;
				for each (var d:Data in f.data)
					if (d.name == curr)
						b = false;
				var c:Data = data.clone();
				c.name = curr;
				if (b) f.data.push(c);
			}
		}
		
		public function getData(path:String):*
		{
			if (contains(path))
				return getDataObject(path).data;
			else return null;
		}
		
		public function getDataObject(path:String):Data
		{
			return _getDataObject(path.split("/"));
		}
		
		private function _getDataObject(path:Array, currData:Data = null):Data
		{
			if (!currData) currData = this;
			while (path.length && currData is Folder)
				currData = Folder(currData).findData(path.splice(0, 1));
			return currData;
		}
		
		public function deletDataObject(path:String):void
		{
			if (contains(path))
				for (var i:uint = 0; i < (path.lastIndexOf("/")!=-1?Folder(getDataObject(path.slice(0, path.lastIndexOf("/")))):this).data.length; i++)
					if (Data((path.lastIndexOf("/")!=-1?Folder(getDataObject(path.slice(0, path.lastIndexOf("/")))):this).data[i]).name == path.slice(path.lastIndexOf("/") + 1, path.length))
						(path.lastIndexOf("/")!=-1?Folder(getDataObject(path.slice(0, path.lastIndexOf("/")))):this).data.splice(i, 1);
		}
		
		public function contains(path:String):Boolean
		{
			return Boolean(getDataObject(path));
		}
		
		private function findData(name:String):Data
		{
			for (var i:uint = 0; i < data.length; i++)
				if (data[i].name.toLowerCase() == name.toLowerCase())
					return data[i];
			return null;
		}
		
		public function get foldersList():Vector.<String>
		{
			var folders:Vector.<String> = new Vector.<String>();
			for (var i:uint = 0; i < data.length; i++)
				if (data[i] is Folder)
					folders.push(data[i].name);
			return folders;
		}
		
		public function get filesList():Vector.<String>
		{
			var files:Vector.<String> = new Vector.<String>();
			for (var i:uint = 0; i < data.length; i++)
				if (!(data[i] is Folder))
					files.push(data[i].name);
			return files;
		}
		
		public function get subFolders():Vector.<String>
		{
			return getSubFoldersList(this);
		}
		
		public function get content():Vector.<String>
		{
			return getFilesList(this);
		}
		
		public function get emptyFolders():Vector.<String>
		{
			var folders:Vector.<String> = new Vector.<String>();
			for (var i:uint = 0; i < data.length; i++)
				if (data[i] is Folder && Folder(data[i]).data.length)
					folders.push(data[i].name);
			return folders;
		}
		
		public function get emptySubFolders():Vector.<String>
		{
			return getEmptySubFoldersList(this);
		}
		
		private function getEmptySubFoldersList(folder:Folder, path:String = "", folders:Vector.<String> = null):Vector.<String>
		{
			if (!folders) folders = new Vector.<String>();
			for (var i:uint = 0; i < folder.foldersList.length; i++)
			{
				if (!folder.getDataObject(folder.foldersList[i]).data.length)
					folders.push(path + "/" + folder.foldersList[i]);
				getEmptySubFoldersList(folder.getDataObject(folder.foldersList[i]) as Folder, path + "/" + folder.foldersList[i], folders);
			}
			return folders;
		}
		
		private function getSubFoldersList(folder:Folder, path:String = "", folders:Vector.<String> = null):Vector.<String>
		{
			if (!folders) folders = new Vector.<String>();
			for (var i:uint = 0; i < folder.foldersList.length; i++)
			{
				folders.push(path + "/" + folder.foldersList[i]);
				getSubFoldersList(folder.getDataObject(folder.foldersList[i]) as Folder, path + "/" + folder.foldersList[i], folders);
			}
			return folders;
		}
		
		private function getFilesList(folder:Folder, path:String = "", files:Vector.<String> = null):Vector.<String>
		{
			if (!files) files = new Vector.<String>();
			for (var i:uint = 0; i < folder.foldersList.length; i++)
				getFilesList(folder.getDataObject(folder.foldersList[i]) as Folder, path + "/" + folder.foldersList[i], files);
			for (i = 0; i < folder.filesList.length; i++)
				files.push((path + "/" + folder.filesList[i]).slice(1));
			return files;
		}
		
		public function get tara():ByteArray
		{
			return TARA.writeTARA(this);;
		}
		
		public function set tara(value:ByteArray):void
		{
			data = TARA.readTARA(value);
		}
		
		public function toTARA5(password:String):String
		{
			return TARA.writeTARA5(this, password);
		}
		
		public function fromTARA5(data:String, password:String, onError:Function = null):void
		{
			try 
			{
				this.data = TARA.readTARA5(data, password);
			} catch (err:Error) {
				if (onError != null) onError(err);
			}
		}
	}
}