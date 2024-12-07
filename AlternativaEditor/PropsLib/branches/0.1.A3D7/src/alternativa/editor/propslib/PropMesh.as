package alternativa.editor.propslib {
	import alternativa.engine3d.core.Object3D;

	public class PropMesh extends PropObject {
		
		public var bitmaps:Object;
		
		public function PropMesh(object3d:Object3D, bitmaps:Object) {
			super(object3d);
			this.bitmaps = bitmaps;
		}
		
		override public function toString():String {
			return "[PropMesh object3d=" + object3d + ", bitmaps=" + bitmaps + "]";
		}
		
	}
}