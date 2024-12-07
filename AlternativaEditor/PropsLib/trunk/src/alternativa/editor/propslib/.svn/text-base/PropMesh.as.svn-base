package alternativa.editor.propslib {
	import alternativa.engine3d.core.Object3D;
	import alternativa.types.Map;

	/**
	 * 
	 */
	public class PropMesh extends PropObject {
		
		/**
		 * Набор дополнительных текстур, указанных в XML-описании пропа (textureName => BitmapData).
		 */
		public var bitmaps:Map;

		/**
		 * 
		 * @param object3d
		 * @param bitmaps
		 */		
		public function PropMesh(object3d:Object3D, bitmaps:Map) {
			super(object3d);
			this.bitmaps = bitmaps;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return "[PropMesh object3d=" + object3d + ", bitmaps=" + bitmaps + "]";
		}
		
	}
}