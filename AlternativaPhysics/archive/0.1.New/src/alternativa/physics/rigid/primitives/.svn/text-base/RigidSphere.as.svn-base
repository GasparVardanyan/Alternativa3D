package alternativa.physics.rigid.primitives {
	import alternativa.physics.rigid.Body;
	import alternativa.types.Matrix3D;

	public class RigidSphere extends Body {
		
		public var r:Number;
		
		public function RigidSphere(radius:Number, invMass:Number) {
			super();
			r = radius;
			var m:Matrix3D = new Matrix3D();
			var k:Number = 2.5*invMass/(r*r);
			m.a = m.f = m.k = k;
			setInvParams(invMass, m);
		}
		
	}
}