package core
{
	import alternativa.gui.event.ListEvent;
	import alternativa.gui.theme.defaulttheme.controls.tree.Tree;
	import core.fs.Folder;
	import core.fs.tara.Data;
	import core.fs.tara.Folder;
	import core.fs.tara.TARA;
	import flash.desktop.NativeApplication;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.InvokeEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.filesystem.File;
	import flash.net.FileFilter;
	import flash.net.FileReference;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.ui.Keyboard;
	import flash.utils.ByteArray;
	
	/**
	 * ...
	 * @author Gaspar
	 */
	public class Functions
	{
		public function Functions() {}
		
		private var keyboardListenerObject:InteractiveObject;
		
		public function init():void
		{
			initTARA("Untitled");
			NativeApplication.nativeApplication.addEventListener(InvokeEvent.INVOKE, function(e:InvokeEvent):void
			{
				if (e.arguments.length)
				{
					if (new File(e.arguments[0]).isDirectory)
						loadAndInitFolder(e.arguments[0], true);
					else
						loadTARA(e.arguments[0], e.arguments[0].split("\\")[e.arguments[0].split("\\").length-1]);
				}
			});
			MANAGER.GUI.g_explorer.addEventListener(ListEvent.SELECT_ITEM, regSelectedData);
			MANAGER.GUI.g_btn_OpenTARA.addEventListener(MouseEvent.CLICK, openTARA);
			MANAGER.GUI.g_btn_Export.addEventListener(MouseEvent.CLICK, MANAGER.GUI_PANELS.export);
			MANAGER.GUI.g_btn_New.addEventListener(MouseEvent.CLICK, create);
			MANAGER.GUI.g_btn_Copy.addEventListener(MouseEvent.CLICK, copy);
			MANAGER.GUI.g_btn_Cut.addEventListener(MouseEvent.CLICK, cut);
			MANAGER.GUI.g_btn_Paste.addEventListener(MouseEvent.CLICK, paste);
			MANAGER.GUI.g_btn_Delete.addEventListener(MouseEvent.CLICK, del);
			MANAGER.GUI.g_btn_Rename.addEventListener(MouseEvent.CLICK, ren);
			MANAGER.GUI.g_btn_OpenFolder.addEventListener(MouseEvent.CLICK, openFolder);
			MANAGER.GUI.g_btn_AddFolder.addEventListener(MouseEvent.CLICK, addFolder);
			MANAGER.GUI.g_btn_AddFile.addEventListener(MouseEvent.CLICK, addFile);
			//addKeyboardListeners(MANAGER.MAIN.stage);
		}
		
		public function addKeyboardListeners(object:InteractiveObject):void
		{
			keyboardListenerObject = object;
			object.addEventListener(KeyboardEvent.KEY_UP, keyboardListeners);
		}
		
		public function removeKeyboardListeners():void
		{
			if (keyboardListenerObject)
			{
				keyboardListenerObject.removeEventListener(KeyboardEvent.KEY_UP, keyboardListeners);
				keyboardListenerObject = null;
			}
		}
		
		private function keyboardListeners(e:KeyboardEvent):void
		{
			if (e.ctrlKey)
			{
				if (e.keyCode == Keyboard.O) openTARA();
				if (e.keyCode == Keyboard.S) MANAGER.GUI_PANELS.export();
			}
			if (e.altKey)
			{
				if (e.keyCode == Keyboard.C) copy();
				if (e.keyCode == Keyboard.V) paste();
				if (e.keyCode == Keyboard.X) cut();
			}
			if (e.keyCode == Keyboard.DELETE) del();
		}
		
		public function openTARA(e:MouseEvent = null, callback:Function = null):void
		{
			var file:File = new File();
			file.browse([new FileFilter("TARA / TARA5 (*.tara, *.tara5)", "*.tara;*.tara5"), new FileFilter("*.*", "*.*")]);
			
			file.addEventListener(Event.SELECT, function(e1:Event):void
			{
				loadTARA(file.nativePath, file.nativePath.split("\\")[file.nativePath.split("\\").length-1], callback);
			});
		}
		
		public function loadTARA(url:String, name:String, callback:Function = null):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				if (TARA.isTARA5(e.target.data))
				{
					initTARA5(name, String(e.target.data), callback);
				} else initTARA(name, ByteArray(e.target.data), callback);
			});
			loader.load(new URLRequest(url));
		}
		
		public function initTARA5(name:String, data:String, callback:Function = null):void
		{
			MANAGER.GUI_PANELS.promptPanel.g_inp_input.text = "";
			MANAGER.GUI_PANELS.promptPanel.g_inp_input.tf.displayAsPassword = true;
			MANAGER.GUI_PANELS.prompt("Please enter password for " + name + ".", name, function(input:String):void
			{
				MANAGER.D_SELECTED_ISFOLDER = false;
				MANAGER.D_SELECTED_PATH = "";
				MANAGER.D_SELECTED_NAME = "";
				MANAGER.D_EXPORT.type = ExportType.TARA;
				MANAGER.D_EXPORT_TARA5_PASSWORD = null;
				MANAGER.D_TARA = new core.fs.Folder(name.indexOf(".")!=-1?name.slice(0, name.lastIndexOf(".")):name);
				if (!TARA.isEmptyTARA5(data))
				{
					MANAGER.D_TARA.fromTARA5(data, input, function(err:Error):void
					{
						MANAGER.GUI_PANELS.alert("Invalid password for " + name + ".", "Invalid password", function():void
						{
							initTARA5(name, data, callback);
						});
					});
					if (MANAGER.D_TARA.data.length == 0)
					{
						MANAGER.GUI_PANELS.alert("Invalid password for " + name + ".", "Invalid password", function():void
						{
							initTARA5(name, data, callback);
						});
					}
				}
				regTARA();
				if (callback != null) callback(MANAGER.D_TARA.getDataObject(name) as core.fs.Folder);
			});
		}
		
		public function initTARA(name:String, data:ByteArray = null, callback:Function = null):void
		{
			MANAGER.D_TARA = new core.fs.Folder(name.indexOf(".")!=-1?name.slice(0, name.lastIndexOf(".")):name);
			if (data) MANAGER.D_TARA.tara = data;
			regTARA();
			if (callback != null) callback(MANAGER.D_TARA.getDataObject(name) as core.fs.Folder);
		}
		
		public function regTARA():void
		{
			MANAGER.D_SELECTED_ISFOLDER = false;
			MANAGER.D_SELECTED_PATH = "";
			MANAGER.D_SELECTED_NAME = "";
			MANAGER.D_EXPORT.type = ExportType.TARA;
			MANAGER.D_EXPORT_TARA5_PASSWORD = null;
			MANAGER.D_SELECTED_ISFOLDER = true;
			_regSelectedData("", true);
			updateTARAExplorer();
		}
		
		public function updateTARAExplorer():void
		{
			MANAGER.GUI.removeChild(MANAGER.GUI.g_explorer);
			MANAGER.GUI.g_inp_path.text = "";
			MANAGER.GUI.g_explorer.removeEventListener(ListEvent.CLICK_ITEM, regSelectedData);
			MANAGER.GUI.g_explorer = new Tree();
			MANAGER.GUI.g_explorer.dataProvider = MANAGER.D_TARA.dataProvider;
			MANAGER.GUI.g_explorer.addEventListener(ListEvent.CLICK_ITEM, regSelectedData);
			MANAGER.GUI.addChild(MANAGER.GUI.g_explorer);
			MANAGER.GUI.Draw();
		}
		
		public function exportSelected(e:MouseEvent = null):void
		{
			try
			{
				if (MANAGER.D_TARA)
				{
					if (MANAGER.D_SELECTED_ISFOLDER)
					{
						if (MANAGER.D_EXPORT.type == ExportType.TARA)
							new File().save(core.fs.tara.Folder(MANAGER.D_SELECTED_PATH?MANAGER.D_TARA.getDataObject(MANAGER.D_SELECTED_PATH):MANAGER.D_TARA).tara, (MANAGER.D_SELECTED_NAME?MANAGER.D_SELECTED_NAME:MANAGER.D_TARA.name) + ".tara");
						else if (MANAGER.D_EXPORT.type == ExportType.FOLDER)
						{
							var file:File = new File();
							MANAGER.GUI_PANELS.loadingInfo();
							file.addEventListener(Event.SELECT, function(e:Event):void
							{
								MANAGER.D_EXTERNALFOLDERS.exportFolder(file.nativePath, function():void
								{
									MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(0);
									MANAGER.GUI_PANELS.loadingInfoPanel.close();
								}, function(loaded:uint, loadings:uint):void
								{
									MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(Math.floor(loaded / loadings * 100));
								});
							});
							file.addEventListener(Event.CANCEL, function(e:Event):void
							{
								MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(0);
								MANAGER.GUI_PANELS.loadingInfoPanel.close();
							});
							file.browseForDirectory("Please select folder to export.");
						}
						else if (MANAGER.D_EXPORT.type == ExportType.TARA5)
							new File().save(core.fs.tara.Folder(MANAGER.D_SELECTED_PATH?MANAGER.D_TARA.getDataObject(MANAGER.D_SELECTED_PATH):MANAGER.D_TARA).toTARA5(MANAGER.D_EXPORT_TARA5_PASSWORD), (MANAGER.D_SELECTED_NAME?MANAGER.D_SELECTED_NAME:MANAGER.D_TARA.name) + ".tara5");
					}
					else
						new File().save(MANAGER.D_TARA.getData(MANAGER.D_SELECTED_PATH) as ByteArray, MANAGER.D_SELECTED_NAME);
				}
			} catch (err:Error) {
				MANAGER.GUI_PANELS.alert(err.message, err.name + " #" + err.errorID);
			}
			MANAGER.D_EXPORT.type = ExportType.TARA;
		}
		
		public function regSelectedData(e:ListEvent):void
		{
			if (MANAGER.D_SELECTED_ISFOLDER && MANAGER.D_SELECTED_PATH == e.object.path)
			{
				MANAGER.D_TARA.openedPath = MANAGER.D_SELECTED_PATH;
				updateTARAExplorer();
			}
			_regSelectedData(e.object.path, e.object.canExpand);
		}
		
		private function _regSelectedData(path:String, isFolder:Boolean):void
		{
			MANAGER.D_SELECTED_PATH = path;
			MANAGER.D_SELECTED_NAME = path.split("/")[path.split("/").length - 1];
			MANAGER.D_SELECTED_ISFOLDER = isFolder;
			MANAGER.GUI.g_inp_path.text = MANAGER.D_SELECTED_PATH;
			MANAGER.GUI.g_btn_Cut.locked = !MANAGER.D_SELECTED_PATH;
			MANAGER.GUI_PANELS.exportPanel.g_panel.title = "Export: " + (path?MANAGER.D_SELECTED_NAME:MANAGER.D_TARA.name);
		}
		
		public function copy(e:MouseEvent = null):void
		{
			MANAGER.D_COPY_CUT_PASTE.copy(MANAGER.D_TARA, MANAGER.D_SELECTED_PATH);
		}
		
		public function cut(e:MouseEvent = null):void
		{
			MANAGER.D_COPY_CUT_PASTE.cut(MANAGER.D_TARA, MANAGER.D_SELECTED_PATH);
			_regSelectedData(MANAGER.D_SELECTED_PATH.lastIndexOf("/")!=-1?MANAGER.D_SELECTED_PATH.slice(0, MANAGER.D_SELECTED_PATH.lastIndexOf("/")):"", true);
			updateTARAExplorer();
		}
		
		public function del(e:MouseEvent = null):void
		{
			MANAGER.D_SELECTED_PATH
				? MANAGER.D_TARA.deletDataObject(MANAGER.D_SELECTED_PATH)
				: MANAGER.D_TARA = new core.fs.Folder("Untitled");
			_regSelectedData(MANAGER.D_SELECTED_PATH.lastIndexOf("/")!=-1?MANAGER.D_SELECTED_PATH.slice(0, MANAGER.D_SELECTED_PATH.lastIndexOf("/")):"", true);
			updateTARAExplorer();
		}
		
		public function ren(e:MouseEvent = null):void
		{
			var data:Data = MANAGER.D_SELECTED_PATH?MANAGER.D_TARA.getDataObject(MANAGER.D_SELECTED_PATH):MANAGER.D_TARA;
			MANAGER.GUI_PANELS.promptPanel.g_inp_input.text = MANAGER.D_SELECTED_PATH?MANAGER.D_SELECTED_PATH:MANAGER.D_TARA.name;
			MANAGER.GUI_PANELS.prompt("Please enter a new name for " + data.name + ".", "Rename " + data.name, function(input:String):void
			{
				MANAGER.GUI_PANELS.promptPanel.g_inp_input.text = "";
				if (MANAGER.D_TARA.contains(input))
				{
					MANAGER.GUI_PANELS.confirm(((data is core.fs.tara.Folder)?"Folder":"File") + " already exist. Replace?", "Replace", function(checked:Boolean):void
					{
						if (checked)
						{
							del();
							MANAGER.D_TARA.getDataObject(input).data = data.data;
							updateTARAExplorer();
						}
						else ren();
					});
				} else {
					var clone:Data;
					if (MANAGER.D_SELECTED_PATH)
					{
						clone = data.clone();
						clone.name = input;
						del();
						MANAGER.D_TARA.addDataObject(clone);
					} else {
						MANAGER.D_TARA.name = input;
					}
					updateTARAExplorer();
				}
			});
		}
		
		public function paste(e:MouseEvent = null, copyCutPaste:CopyCutPaste = null):void
		{
			(copyCutPaste?copyCutPaste:MANAGER.D_COPY_CUT_PASTE).paste(MANAGER.D_TARA.openedPath?core.fs.tara.Folder(MANAGER.D_TARA.getDataObject(MANAGER.D_TARA.openedPath)):MANAGER.D_TARA, false, function():void
			{
				MANAGER.GUI_PANELS.promptPanel.g_inp_input.text = MANAGER.D_COPY_CUT_PASTE.buffer.name;
				MANAGER.GUI_PANELS.prompt(((MANAGER.D_COPY_CUT_PASTE.buffer is core.fs.tara.Folder)?"Folder":"File") + " already exist. Rename new "+((MANAGER.D_COPY_CUT_PASTE.buffer is core.fs.tara.Folder)?"folder":"file")+"?", "Rename new "+((MANAGER.D_COPY_CUT_PASTE.buffer is core.fs.tara.Folder)?"folder":"file"), function(input:String):void
				{
					MANAGER.GUI_PANELS.promptPanel.g_inp_input.text = "";
					if (!(MANAGER.D_TARA.openedPath?core.fs.tara.Folder(MANAGER.D_TARA.getDataObject(MANAGER.D_TARA.openedPath)):MANAGER.D_TARA).contains(input))
					{
						MANAGER.D_COPY_CUT_PASTE.buffer.name = input;
						(copyCutPaste?copyCutPaste:MANAGER.D_COPY_CUT_PASTE).paste(MANAGER.D_TARA.openedPath?core.fs.tara.Folder(MANAGER.D_TARA.getDataObject(MANAGER.D_TARA.openedPath)):MANAGER.D_TARA);
						updateTARAExplorer();
					} else {
						MANAGER.GUI_PANELS.confirm(((MANAGER.D_COPY_CUT_PASTE.buffer is core.fs.tara.Folder)?"Folder":"File") + " already exist. Replace?", "Replace", function(checked:Boolean):void
						{
							if (checked)
								(copyCutPaste?copyCutPaste:MANAGER.D_COPY_CUT_PASTE).paste(MANAGER.D_TARA.openedPath?core.fs.tara.Folder(MANAGER.D_TARA.getDataObject(MANAGER.D_TARA.openedPath)):MANAGER.D_TARA, true);
						});
					}
				});
			});
			updateTARAExplorer();
		}
		
		public function create(e:MouseEvent = null):void
		{
			MANAGER.D_TARA = new core.fs.Folder("Untitled");
			updateTARAExplorer();
		}
		
		public function openFolder(e:MouseEvent = null):void
		{
			var file:File = new File();
			MANAGER.GUI_PANELS.loadingInfo();
			file.addEventListener(Event.SELECT, function(e1:Event):void
			{
				loadAndInitFolder(file.nativePath, true);
			});
			file.addEventListener(Event.CANCEL, function(e:Event):void
			{
				MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(0);
				MANAGER.GUI_PANELS.loadingInfoPanel.close();
			});
			file.browseForDirectory("Please select folder to upload.");
		}
		
		public function loadAndInitFolder(path:String, initAsRoot:Boolean = false):void
		{
			MANAGER.D_EXTERNALFOLDERS.loadFolder(path, function(folder:core.fs.Folder):void
			{
				MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(0);
				MANAGER.GUI_PANELS.loadingInfoPanel.close();
				if (initAsRoot) MANAGER.D_TARA = folder;
				else {
					var copyCutPaste:CopyCutPaste = new CopyCutPaste();
					copyCutPaste.buffer = folder;
					paste(null, copyCutPaste);
				}
				regTARA();
			}, function(loaded:uint, loadings:uint):void
			{
				MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(Math.floor(loaded / loadings * 100));
			});
		}
		
		public function addFolder(e:MouseEvent = null):void
		{
			var file:File = new File();
			MANAGER.GUI_PANELS.loadingInfo();
			file.addEventListener(Event.SELECT, function(e1:Event):void
			{
				loadAndInitFolder(file.nativePath);
			});
			file.addEventListener(Event.CANCEL, function(e:Event):void
			{
				MANAGER.GUI_PANELS.loadingInfoPanel.g_loaderLabel_set(0);
				MANAGER.GUI_PANELS.loadingInfoPanel.close();
			});
			file.browseForDirectory("Please select folder to upload.");
		}
		
		public function addFile(e:MouseEvent = null):void
		{
			var file:File = new File();
			file.browse();
			
			file.addEventListener(Event.SELECT, function(e1:Event):void
			{
				loadAndAddFile(file.nativePath, file.nativePath.split("\\")[file.nativePath.split("\\").length-1]);
			});
		}
		
		public function loadAndAddFile(url:String, name:String):void
		{
			var loader:URLLoader = new URLLoader();
			loader.dataFormat = URLLoaderDataFormat.BINARY;
			loader.addEventListener(Event.COMPLETE, function(e:Event):void
			{
				var copyCutPaste:CopyCutPaste = new CopyCutPaste();
				copyCutPaste.buffer = new Data(name, e.target.data as ByteArray);
				paste(null, copyCutPaste);
			});
			loader.load(new URLRequest(url));
		}
	}
}