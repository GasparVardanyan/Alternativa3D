package alternativa.physics.rigid.primitives {
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Vector3;
	
	public class RigidBox extends Body {
		
		public var halfSize:Vector3 = new Vector3();
		
		/**
		 * 
		 * @param halfSize
		 * @param mass
		 */
		public function RigidBox(halfSize:Vector3, mass:Number) {
			/* Момент инерции бокса:
			
			  m*(hy*hy + hz*hz)/3            0                     0
			           0            m*(hz*hz + hx*hx)/3            0
			           0                     0            m*(hx*hx + hy*hy)/3
			           
			 hx, hy, hz -- половина размера бокса вдоль соответствующей оси
			*/
			var m:Matrix3 = new Matrix3();
			if (mass == Infinity) {
				mass = 0;
				m.a = m.f = m.k = 0;
			} else {
				mass = 1/mass;
				var xx:Number = halfSize.x*halfSize.x;
				var yy:Number = halfSize.y*halfSize.y;
				var zz:Number = halfSize.z*halfSize.z;
				m.a = 3*mass/(yy + zz);
				m.f = 3*mass/(zz + xx);
				m.k = 3*mass/(xx + yy);
			}
			super(Body.BOX, mass, m);
			this.halfSize.copy(halfSize);
		}
		
	}
}