package alternativa.physics.primitives {

	import alternativa.physics.Body;
	import alternativa.physics.altphysics;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;
	
	use namespace altphysics;	

	public class RigidPlane extends Body {
		
		public var normal:Vector3 = new Vector3();
		public var offset:Number;

		public function RigidPlane() {
			super(0, Matrix3.ZERO);
			this.normal.vCopy(Vector3.Z_AXIS);
			this.offset = 0;
			movable = false;
		}
		
	}
}