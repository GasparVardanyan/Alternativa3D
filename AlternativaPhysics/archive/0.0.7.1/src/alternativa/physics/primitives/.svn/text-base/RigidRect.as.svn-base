package alternativa.physics.primitives {

	import alternativa.physics.Body;
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionRect;
	import alternativa.physics.math.Matrix3;
	import alternativa.physics.math.Vector3;

	use namespace altphysics;	

	public class RigidRect extends Body {
		
		public function RigidRect(halfWidth:Number, halfLength:Number) {
			super(0, Matrix3.ZERO);
			movable = false;
			addCollisionPrimitive(new CollisionRect(new Vector3(halfWidth, halfLength, 0), 1));
		}
		
	}
}