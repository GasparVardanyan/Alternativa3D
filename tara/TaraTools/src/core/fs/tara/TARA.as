package core.fs.tara 
{
	import flash.utils.ByteArray;
	import mx.utils.Base64Decoder;
	import mx.utils.Base64Encoder;
	//import com.hurlant.util.Base64;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class TARA
	{
		private static const tara5:String = LOCKER.lockBase64("TARA5", "TARA5");
		private static const emptyT5:String = writeTARA5(new Folder(), "");
		public static function isEmptyTARA5(data:String):Boolean
		{ return data.length == emptyT5.length; }
		
		public static function readTARA(data:ByteArray):Vector.<Data>
		{
			var folder:Folder = new Folder();
			
			var numFiles:int = data.readInt();
			var files:Vector.<Object> = new Vector.<Object>(numFiles, true);
			for (var i:int = 0; i < numFiles; i++)
			{
				files[i] = {name: data.readUTF(), size: data.readInt()};
			}
			for (i = 0; i < numFiles; i++)
			{
				var fileData:ByteArray = new ByteArray();
				if (files[i].size)
					data.readBytes(fileData, 0, files[i].size);
				readFile(folder, fileData, files[i].name.split("/"));
			}
			var emptyFoldersCount:int, currEmp:String;
			if (data.position != data.length)
			{
				emptyFoldersCount = data.readInt();
				for (i = 0; i < emptyFoldersCount; i++)
				{
					currEmp = data.readUTF();
					folder.addDataObject(new Folder(currEmp.slice(1, currEmp.length)));
				}
			}
			
			return folder.data;
		}
		
		public static function writeTARA(folder:Folder):ByteArray
		{
			var data:ByteArray = new ByteArray();
			
			var files:Vector.<Object> = getFilesList(folder);
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
			data.writeInt(folder.emptySubFolders.length);
			for (i = 0; i < folder.emptySubFolders.length; i++)
				data.writeUTF(folder.emptySubFolders[i]);
			
			return data;
		}
		
		public static function readTARA5(data:String, password:String):Vector.<Data>
		{
			var decoder:Base64Decoder = new Base64Decoder();
			if (isTARA5(data))
			{
				decoder.decode(LOCKER.unlockBase64(data.replace(tara5+"\n", ""), password));
				return readTARA(decoder.toByteArray());
			} else return null;
			
			//if (isTARA5(data))
				//return readTARA(Base64.decodeToByteArray(LOCKER.unlockBase64(data.replace(tara5 + "\n", ""), password)));
			//else return null;
		}
		
		public static function writeTARA5(folder:Folder, password:String):String
		{
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(writeTARA(folder));
			return tara5+"\n"+LOCKER.lockBase64(encoder.toString(), password);
			
			//return tara5+"\n"+LOCKER.lockBase64(Base64.encodeByteArray(writeTARA(folder)), password);
		}
		
		public static function isTARA5(data:String):Boolean
		{
			return !data.indexOf(tara5+"\n");
		}
		
		private static function readFile(folder:Folder, data:ByteArray, folders:Array, cf:int = 0):void
		{
			var currentFolder:String = folders[cf];
			if (cf < folders.length-1)
			{
				if (!hasData(currentFolder, folder))
					folder.data.push(new Folder(currentFolder));
				readFile(folder.getDataObject(currentFolder) as Folder, data, folders, ++cf);
			} else {
				folder.data.push(new Data(currentFolder, data));
				cf = 0;
			}
		}
		
		private static function hasData(name:String, folder:Folder):Boolean
		{
			for (var i:uint = 0; i < folder.data.length; i++)
				if (folder.data[i].name == name) return true;
			return false;
		}
		
		private static function getFilesList(folder:Folder, path:String = "", files:Vector.<Object> = null):Vector.<Object>
		{
			if (!files) files = new Vector.<Object>();
			for (var i:uint = 0; i < folder.foldersList.length; i++)
				getFilesList(folder.getDataObject(folder.foldersList[i]) as Folder, path + "/" + folder.foldersList[i], files);
			for (i = 0; i < folder.filesList.length; i++)
				files.push({name:(path + "/" + folder.filesList[i]).slice(1), data:folder.getDataObject(folder.filesList[i]).data});
			return files;
		}
	}
}