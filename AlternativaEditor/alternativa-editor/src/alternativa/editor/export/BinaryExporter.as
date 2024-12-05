package alternativa.editor.export {
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Tile;
	import alternativa.engine3d.core.Object3D;
	
	import flash.filesystem.FileStream;

	/**
	 * Сохраняет уровень в бинарном формате.
	 */
	public class BinaryExporter extends FileExporter {

		/**
		 * 
		 */
		public function BinaryExporter(root:Object3D) {
			super(root);
		}
		
		/**
		 * @param stream
		 */
		override public function exportToFileStream(stream:FileStream):void {
			for (var child:* in root.children) {
				var prop:Prop = child as Prop;
				if (prop) {
					stream.writeUTF(prop.library);
					stream.writeUTF(prop.group);
					stream.writeUTF(prop.name);
					stream.writeFloat(prop.x);
					stream.writeFloat(prop.y);
					stream.writeFloat(prop.z);
					stream.writeFloat(prop.rotationZ);
					stream.writeBoolean(prop.free);
					var tile:Tile = prop as Tile;
					if (tile) {
						stream.writeUTF(tile.textureName);
//						stream.writeBoolean(tile.isMirror);
					} else {
						stream.writeUTF("");
//						stream.writeBoolean(false);
					}
				}
			}
		}
	}
}