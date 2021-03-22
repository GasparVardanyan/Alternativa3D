package a3d_helper.utils
{
	import flash.utils.ByteArray;
	
	public class TARA
	{
		public function TARA() {}
		
		public static function readTARA(library:Array, name:String, data:ByteArray):void
		{
			library[name] = [];
			
			var numFiles:int = data.readInt();
			var files:Vector.<Object> = new Vector.<Object>(numFiles, true);
			for (var i:int = 0; i < numFiles; i++)
			{
				files[i] = {name: data.readUTF(), size: data.readInt()};
			}
			for (i = 0; i < numFiles; i++)
			{
				var fileData:ByteArray = new ByteArray();
				data.readBytes(fileData, 0, files[i].size);
				readFile(library[name], fileData, files[i].name.split("/"));
			}
		}
		
		private static function readFile(library:Array, data:ByteArray, folders:Array, cf:int = 0):void
		{
			var currentFolder:String = folders[cf];
			if (cf < folders.length-1)
			{
				if (!library[currentFolder])
					library[currentFolder] = [];
				readFile(library[currentFolder], data, folders, ++cf);
			} else {
				library[currentFolder] = data;
				cf = 0;
			}
		}
		
		public static function writeTARA(library:Array):ByteArray
		{
			var data:ByteArray = new ByteArray();
			var files:Vector.<Object> = getFilesList(library);
			data.writeInt(files.length);
			for (var i:int = 0; i < files.length; i++)
			{
				data.writeUTF(files[i].name);
				data.writeInt(files[i].data.length);
			}
			for (i = 0; i < files.length; i++)
			{
				data.writeBytes(files[i].data, 0, files[i].data.length);
			}
			return data;
		}
		
		private static function getFilesList(library:Array, path:String = "", files:Vector.<Object> = null):Vector.<Object>
		{
			if (!files) files = new Vector.<Object>();
			for (var file:String in library)
				if (library[file] is Array)
					getFilesList(library[file], path + "/" + file, files);
				else
					files.push({name:(path + "/" + file).slice(1), data:library[file]});
			return files;
		}
	}
}
