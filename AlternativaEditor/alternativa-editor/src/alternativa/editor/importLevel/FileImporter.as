package alternativa.editor.importLevel {
	import alternativa.editor.LibraryManager;
	import alternativa.editor.events.LevelLoaded;
	import alternativa.editor.scene.MainScene;
	
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;
	import mx.events.CloseEvent;
	
	
	public class FileImporter extends EventDispatcher {
		protected var scene:MainScene;
		protected var libraryManager:LibraryManager;
		protected var libname:String = "";
		
		public function FileImporter(scene:MainScene, libraryManager:LibraryManager) {
			this.scene = scene;
			this.libraryManager = libraryManager;
		}
		
		public function importFromFileStream(stream:FileStream):void {
			
		}
		
		/**
		 * Обработка алерта загрузки библиотеки.
		*/ 
		protected function libAlertListener(e:CloseEvent):void {
				
			switch (e.detail) {
				case Alert.YES:
//					libraryManager.loadLibrary(loadingLevel);
					break;
				case Alert.NO:
					scene.clear();
					endLoadLevel();
					break;	
			}
				
		}
		
		/**
		 * Конец загрузки уровня.
		 */ 
		protected function endLoadLevel():void {
//			fileStream.close();
			scene.changed = false;
//			emptyPath = false;
//			fileForSave = file.clone();
//			fileForSave.addEventListener(Event.SELECT, onSaveFileSelect);
			libname = "";
//			progressBar.visible = false;
//			cursorScene.visible = true;
//			dispatchEvent(new LevelLoaded());
		}

	}
}