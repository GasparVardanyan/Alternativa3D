package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.primitives.RigidPlane;
	import alternativa.physics.rigid.primitives.RigidSphere;
	import alternativa.physics.types.Vector3;
	
	import flash.utils.getTimer;

	/**
	 * 
	 */
	public class SpherePlaneCollider implements ICollider {

		private var normal:Vector3 = new Vector3();
		
		/**
		 * 
		 */
		public function SpherePlaneCollider() {
		}

		/**
		 * 
		 * @param body1
		 * @param body2
		 * @param collisionInfo
		 * @return 
		 */
		public function collide(body1:Body, body2:Body, collisionInfo:CollisionInfo):Boolean {
			var sphere:RigidSphere = body1 as RigidSphere;
			var plane:RigidPlane;
			if (sphere == null) {
				sphere = body2 as RigidSphere;
				plane = body1 as RigidPlane;
			} else {
				plane = body2 as RigidPlane;
			}
			
			// Вычисляем глобальные нормаль и смещение плоскости
			plane.baseMatrix.transformVector(plane.normal, normal);
			var offset:Number = plane.offset + normal.x*plane.transform.d + normal.y*plane.transform.h + normal.z*plane.transform.l;
			
			var dist:Number = sphere.state.pos.dot(normal) - offset;
			if (dist > sphere.r) return false;
				
			collisionInfo.body1 = sphere;
			collisionInfo.body2 = plane;
			collisionInfo.normal.copy(normal);
			collisionInfo.pcount = 1;

			var cp:CollisionPoint = collisionInfo.points[0];
			cp.penetration = sphere.r - dist;
			cp.pos.copy(normal).reverse().scale(sphere.r).add(sphere.state.pos);

			return true;
		}
		
	}
}