package alternativa.physics.rigid.primitives {
	import alternativa.physics.rigid.Body;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;

	public class RigidBox extends Body {
		
		public var halfSize:Point3D = new Point3D();
		
		public function RigidBox(halfSize:Point3D, invMass:Number) {
			super();
			this.halfSize.copy(halfSize);
			
			var m:Matrix3D = new Matrix3D();
			var xx:Number = halfSize.x*halfSize.x;
			var yy:Number = halfSize.y*halfSize.y;
			var zz:Number = halfSize.z*halfSize.z;
			m.a = 12*invMass/(yy + zz);
			m.f = 12*invMass/(zz + xx);
			m.k = 12*invMass/(xx + yy);
			setInvParams(invMass, m);
		}
		
	}
}