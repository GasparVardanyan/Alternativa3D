package alternativa.editor.importLevel {
	import alternativa.editor.LibraryManager;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Tile;
	import alternativa.editor.scene.MainScene;
	import alternativa.types.Point3D;
	
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;

	public class BinaryImporter extends FileImporter {
		
		public function BinaryImporter(scene:MainScene, libraryManager:LibraryManager) {
			super(scene, libraryManager);
		}
		
		override public function importFromFileStream(stream:FileStream):void {
			try {
				while (stream.bytesAvailable) {
					// Проверка на то, что в предыдущей итерации не загружали библиотеку
					if (libname == "") {
						var lib:String = stream.readUTF();
						// Составляем ключ: имя библиотеки + имя группы + имя меша
						libname = lib + stream.readUTF() + stream.readUTF();
					}
					// Ищем проп по ключу
					var prop:Prop = libraryManager.nameProp[libname];
					if (prop) {
						// Добавляем проп на сцену
						prop = scene.addProp(prop, new Point3D(stream.readFloat(), stream.readFloat(), stream.readFloat()), stream.readFloat(), true, false);
						var free:Boolean = stream.readBoolean();
						if (!free) {
							// Заполняем карту
							scene.occupyMap.occupy(prop);
						}
						var textureName:String = stream.readUTF();
//						var isMirror:Boolean = stream.readBoolean();
						var tile:Tile = prop as Tile;
						if (tile) {
							try {
								if (textureName != "") {
									tile.textureName = textureName;
								}
							} catch (err:Error) {
									Alert.show("Tile " + tile.name + ": texture " + textureName + " is not found");
							}
								
//							if (isMirror) {
//								tile.mirrorTexture();
//							}
						}
							libname = "";
							scene.calculate();
					} else {
						Alert.show("Library '"+ lib + "' is used by the level. Load?", "", Alert.YES|Alert.NO, null, libAlertListener);
						return;
					}
				}
			} catch  (err:Error) {
				Alert.show(err.message);
			}
			
			endLoadLevel(); 
				
		}
		
	}
}