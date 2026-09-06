package alternativaphysics.collision.dispatch {
	import alternativa.engine3d.core.Object3D;

	import alternativaphysics.collision.shapes.A3DCollisionShape;

	/**
	 *used for create the character controller
	 */
	public class A3DGhostObject extends A3DCollisionObject {

		/** 
		* 
		* @public 
		* @param shape 
		* @param skin 
		*/
		public function A3DGhostObject(shape : A3DCollisionShape, skin : Object3D = null) {
			pointer = bullet.createGhostObjectMethod(this, shape.pointer);
			super(shape, skin, pointer)
		}
	}
}