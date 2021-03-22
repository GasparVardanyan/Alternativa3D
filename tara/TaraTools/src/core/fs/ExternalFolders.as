package core.fs
{
	import core.MANAGER;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class ExternalFolders
	{
		private var processes:Vector.<uint> = new Vector.<uint>();
		
		public function loadFolder(path:String, callback:Function = null, callInLoading:Function = null):Folder
		{
			var folder:Folder = new Folder(path.split("\\")[path.split("\\").length - 1]);
			var content:Array = getContent(path);
			var loadings:Vector.<String> = content[0];
			var emptyFolders:Vector.<String> = content[1];
			processes.push(0);
			var l:uint = processes.length - 1;
			
			for (var i:uint = 0; i < emptyFolders.length; i++)
				folder.addDataObject(new Folder(emptyFolders[i].replace(path+"\\", "").split("\\").join("/")));
			for (i = 0; i < loadings.length; i++)
				load(folder, path, loadings[i], loadings.length, l, callback, callInLoading);
			
			return folder;
		}
		
		private function clear():void
		{
			processes = new Vector.<uint>();
		}
		
		private function load(folder:Folder, path:String, current:String, count:uint, currProcess:uint, callback:Function = null, callInLoading:Function = null):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				folder.addData(current.replace(path + "\\", "").split("\\").join("/"), e.target.data as ByteArray);
				if (callInLoading != null) callInLoading(processes[currProcess]+1, count);
				if (++processes[currProcess] == count)
				{
					processes[currProcess] = 0;
					if (callback != null) callback(folder);
				}
			});
			loader.load(new URLRequest(current));
		}
		
		private function getContent(path:String, r:String = null, files:Vector.<String> = null, emptyFolders:Vector.<String> = null):Array
		{
			if (!files) files = new Vector.<String>();
			if (!emptyFolders) emptyFolders = new Vector.<String>();
			
			var f:File = new File(path);
			
			if (!f.getDirectoryListing().length)
				emptyFolders.push(f.nativePath);
			else for each(var file:File in f.getDirectoryListing())
				if (!file.isDirectory) files.push(file.nativePath);
				else getContent(file.nativePath, r, files, emptyFolders);
			
			return [files, emptyFolders];
		}
		
		public function exportFolder(path:String, callback:Function = null, callInLoading:Function = null):void
		{
			var to:String = path + "\\" + MANAGER.D_TARA.name;
			var ref:File;
			var str:FileStream;
			var f:Folder = (MANAGER.D_TARA.openedPath?Folder(MANAGER.D_TARA.getDataObject(MANAGER.D_TARA.openedPath)):MANAGER.D_TARA);
			var i:uint = 0;
			var l:uint = f.content.length;
			for each (var folder:String in f.subFolders.concat(f.emptySubFolders))
			{
				ref = new File(to + "\\" + folder)
				ref.createDirectory();
			}
			for each (var file:String in f.content)
			{
				str = new FileStream();
				str.open(new File(to + "\\" + file), FileMode.WRITE);
				str.writeBytes(f.getData(file) as ByteArray);
				str.close();
				if (callInLoading != null) callInLoading(++i, l);
				if (i == l && callback != null) callback();
			}
		}
	}
}