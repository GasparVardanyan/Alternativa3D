package alternativa.physics.rigid.primitives {

	import alternativa.physics.altphysics;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Vector3;
	
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