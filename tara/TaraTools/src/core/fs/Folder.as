package core.fs
{
	import alternativa.gui.data.DataProvider;
	import core.MANAGER;
	import core.fs.tara.Data;
	import core.fs.tara.Folder;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Folder extends core.fs.tara.Folder
	{
		public var foldersOpened:Boolean;
		public var openedPath:String = "";
		
		public function Folder(name:String = null, data:Vector.<Data> = null)
		{
			this.name = name;
			this.data = data?data:new Vector.<Data>();
		}
		
		public function get dataProvider():DataProvider
		{
			return _getDataProvider((openedPath ? getDataObject(openedPath) as core.fs.tara.Folder : this), new DataProvider());
		}
		
		private function _getDataProvider(folder:core.fs.tara.Folder, dp:DataProvider, parentId:String = null, level:uint = 0):DataProvider
		{
			dp.addItem({
				label: "..",
				parentId: parentId,
				path: openedPath.indexOf("/")!=-1?openedPath.slice(0, openedPath.lastIndexOf("/")):"",
				level: level,
				opened: false,
				hasChildren: false,
				canExpand: true
			});
			for (var i:uint = 0; i < folder.data.length; i++)
			{
				var d:String = folder.data[i].name;
				if (folder.data[i] is core.fs.tara.Folder)
				{
					dp.addItem({
						label: d,
						parentId: parentId,
						path: (openedPath?(openedPath + "/" + d):d),
						level: level,
						opened: false,
						hasChildren: false,
						canExpand: true
					});
				}
				else
				{
					dp.addItem({
						label: d,
						parentId: parentId,
						path: (openedPath?(openedPath + "/" + d):d),
						level: level,
						hasChildren: false,
						canExpand: false
					});
				}
			}
			
			return dp;
		}
	}
}