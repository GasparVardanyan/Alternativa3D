package alternativa.editor {
	import __AS3__.vec.Vector;
	
	import alternativa.editor.prop.Bonus;
	import alternativa.editor.prop.Flag;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Spawn;
	import alternativa.editor.prop.Tile;
	import alternativa.editor.prop.TileSprite3D;
	import alternativa.editor.propslib.PropData;
	import alternativa.editor.propslib.PropGroup;
	import alternativa.editor.propslib.PropMesh;
	import alternativa.editor.propslib.PropObject;
	import alternativa.editor.propslib.PropsLibrary;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	
	import mx.controls.Alert;
	import mx.controls.ProgressBar;
	
	/**
	 * @author danilova
	 */	
	public class LibraryManager extends EventDispatcher {
		
		private static const GRP_SPAWN_POINTS:String = "Spawn Points";
		private static const GRP_BONUS_REGIONS:String = "Bonus Regions";
		private static const GRP_FLAGS:String = "Flags";
		
		// Файл библиотеки
		private var fileLoadLibrary:File = new File();
		// Индикатор загрузки библиотеки с очисткой текущих 
		private var clearLibrary:Boolean = false;
		// 
		public var libraryProgressBar:ProgressBar;
		//
		public var libraries:Array = [];
		//
		private var propsLibraries:Map = new Map();
		//
		private var nextFunction:Function;
		//  Имя пропа (библа + группа + имя меша) -> проп
		public var nameProp:Map = new Map();
		
		private var libraryCount:int;
		private var index:int = 0;
		
		public function LibraryManager() {
			
			fileLoadLibrary.addEventListener(Event.SELECT, onSelect);
			libraryProgressBar = new ProgressBar();
			libraryProgressBar.labelPlacement = "left";
			libraryProgressBar.indeterminate = true;
			libraryProgressBar.label = "Loading library...";
			libraryProgressBar.direction = "right";
			libraryProgressBar.width = 200;
			libraryProgressBar.visible = false;
		}
		
		public function loadLibrary(nextFunction:Function = null):void {
			this.nextFunction = nextFunction;
			fileLoadLibrary.browseForDirectory("Load library");
			
		}
		
		public function clearAndLoadLibrary():void {
			clearLibrary = true;
			loadLibrary();
		}
		
		private function onSelect(e:Event):void {
			
			libraryProgressBar.visible = true;
			
			var propsLibrary:PropsLibrary;
			var list:Array = fileLoadLibrary.getDirectoryListing();
			index = 0;
			
			
			if ((list[0] as File).isDirectory) {
				libraryCount = list.length;
				for (var i:int = 0; i < libraryCount; i++) {
					var file:File = list[i];
					if (file.isDirectory) {
						propsLibrary = new PropsLibrary();
						propsLibrary.addEventListener(Event.COMPLETE, onLoadingComplete);
						propsLibrary.load(file.url);		
					}						
				}
			} else {
				libraryCount = 1;
				propsLibrary = new PropsLibrary();
				propsLibrary.addEventListener(Event.COMPLETE, onLoadingComplete);
				propsLibrary.load(fileLoadLibrary.url);		
			}		
				
			if (clearLibrary) {
				clearLibrary = false;
//				cursorScene.clear();
				libraries.length = 0;
				propsLibraries.clear();
			}			
							
		}
		
		
		
		private function onLoadingComplete(e:Event):void {
			try {
				index++;
				var propslibrary:PropsLibrary = e.target as PropsLibrary;
				var library:String = propslibrary.name;
				libraries.push(library);
				var libraryProps:Array = [];
				var groups:Vector.<PropGroup> = propslibrary.rootGroup.groups;
				var len:int = groups.length;
				for (var i:int = 0; i < len; i++) {
					var group:PropGroup = groups[i];
					// Получаем имя группы
					var groupName:String = group.name;
					var props:Vector.<PropData> = group.props;
					var propsLen:int = props.length;
					for (var j:int = 0; j < propsLen; j++) {
						var propData:PropData = props[j];
						var propObject:PropObject = propData.statelessData.object;
						var name:String = propData.name; 
						if (propObject) {
							var object:Object3D = propObject.object3d;
							object.coords = new Point3D();
							var prop:Prop;
							if (object is Mesh) {
								switch (groupName) {
									case GRP_SPAWN_POINTS:
										prop = new Spawn(object, library, groupName);
										break;
									case GRP_BONUS_REGIONS:
										prop = new Bonus(object, library, groupName);
										break;
									case GRP_FLAGS:
										prop = new Flag(object, library, groupName);
										break;
									default:
										var tile:Tile = new Tile(object, library, groupName); 
										prop = tile;
										tile.bitmaps = (propObject as PropMesh).bitmaps;
										// Установка текстуры по умолчанию
										// TODO: Желательно, чтобы устанавливалась первая указанная в XML текстура 
										if (tile.bitmaps != null) {
											for (var tName:String in tile.bitmaps) {
												tile.textureName = tName;
												break;
											}
										}
										break;
								}
								
							} else if (object is Sprite3D) {
								prop = new TileSprite3D(object as Sprite3D, library, groupName);
							}
							
							prop.name = name;
				
							// Получаем иконку пропа
							prop.icon = AlternativaEditor.preview.getPropIcon(prop); 
							libraryProps.push(prop);
							nameProp.add(library + groupName + name, prop);
							
						}
						
					}
				}
				
				propsLibraries.add(library, libraryProps);
				libraryProgressBar.visible = false;
				if (index == libraryCount) {
					dispatchEvent(new Event(Event.CHANGE));
					if (nextFunction != null) {
						// Если загрузили библиотеку в процессе загрузки уровня, продолжаем загружать уровень
						nextFunction();
						nextFunction = null;
					}
				}
				
				
			} catch (err:Error) {
				Alert.show(err.message);
			}
			
		}
		
		public function getLibrary(libraryName:String):Array {
			return propsLibraries[libraryName];
		}

	}
}