package alternativa.editor.export {
	import alternativa.engine3d.core.Object3D;
	
	import flash.filesystem.FileStream;
	
	/**
	 * Базовый класс для экспортёров данных.
	 */
	public class FileExporter {
		
		// Корневой объект сцены, в котором находятся пропы экспортируемого уровня
		public var root:Object3D;
		
		/**
		 * 
		 * @param root
		 */
		public function FileExporter(root:Object3D) {
			this.root = root;
		}
		
		/**
		 * Метод сохраняет данные уровня в заданный файловый поток.
		 * @param stream
		 */
		public function exportToFileStream(stream:FileStream):void {
		}
		
	}
}