package alternativa.physics.rigid {
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Vector3;
	
	public class PhysicsUtils {
		
		/**
		 * @param mass
		 * @param halfSize
		 * @param result
		 */
		public static function getBoxInvInertia(mass:Number, halfSize:Vector3, result:Matrix3):void {
			if (mass <= 0) throw new ArgumentError();
			/* Момент инерции бокса:
			
			  m*(hy*hy + hz*hz)/3            0                     0
			           0            m*(hz*hz + hx*hx)/3            0
			           0                     0            m*(hx*hx + hy*hy)/3
			           
			 hx, hy, hz -- половина размера бокса вдоль соответствующей оси
			*/
			result.copy(Matrix3.ZERO);
			if (mass == Infinity) return;
			var xx:Number = halfSize.x*halfSize.x;
			var yy:Number = halfSize.y*halfSize.y;
			var zz:Number = halfSize.z*halfSize.z;
			result.a = 3/(mass*(yy + zz));
			result.f = 3/(mass*(zz + xx));
			result.k = 3/(mass*(xx + yy));
		}
		
		/**
		 * @param mass
		 * @param r
		 * @param h
		 * @param result
		 */
		public static function getCylinderInvInertia(mass:Number, r:Number, h:Number, result:Matrix3):void {
			if (mass <= 0) throw new ArgumentError();

			result.copy(Matrix3.ZERO);
			if (mass == Infinity) return;

			result.a = result.f = 1/(mass*(h*h/12 + r*r/4));
			result.k = 2/(mass*r*r);
		}

	}
}