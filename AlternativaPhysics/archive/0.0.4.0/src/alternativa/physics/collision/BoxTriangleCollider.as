package alternativa.physics.collision {
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.collision.primitives.CollisionPrimitive;

	public class BoxTriangleCollider implements ICollider {
		public function BoxTriangleCollider() {
		}

		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			return false;
		}
		
		/**
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
		}
		
	}
}