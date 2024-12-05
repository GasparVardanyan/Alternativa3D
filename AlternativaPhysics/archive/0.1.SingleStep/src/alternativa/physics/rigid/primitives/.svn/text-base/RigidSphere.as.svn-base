package alternativa.physics.rigid.primitives {
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix3;

	public class RigidSphere extends Body {
		
		public var r:Number;
		
		public function RigidSphere(radius:Number, mass:Number) {
			var m:Matrix3;
			if (mass == Infinity) {
				mass = 0;
				m = Matrix3.ZERO; 
			} else {
				mass = 1/mass;
				var r2:Number = radius*radius;
				m = new Matrix3();
				m.a = m.f = m.k = 2.5*mass/r2;
			}
			super(Body.SPHERE, mass, m);
			r = radius;
		}
		
	}
}