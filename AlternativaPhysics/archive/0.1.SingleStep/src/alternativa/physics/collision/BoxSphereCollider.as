package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.primitives.RigidBox;
	import alternativa.physics.rigid.primitives.RigidSphere;
	import alternativa.physics.types.Vector3;

	/**
	 * 
	 */
	public class BoxSphereCollider implements ICollider {
		
		private var center:Vector3 = new Vector3();
		private var closestPt:Vector3 = new Vector3();
		
		/**
		 * 
		 */
		public function BoxSphereCollider() {
		}

		/**
		 * 
		 * @param body1
		 * @param body2
		 * @param collisionInfo
		 * @return 
		 */
		public function collide(body1:Body, body2:Body, collisionInfo:CollisionInfo):Boolean {
			var box:RigidBox = body1 as RigidBox;
			var sphere:RigidSphere;
			if (box == null) {
				box = body2 as RigidBox;
				sphere = body1 as RigidSphere;
			} else {
				sphere = body2 as RigidSphere;
			}
			// Трансформируем центр сферы в систему коорлинат бокса
			box.transform.transformVectorInverse(sphere.state.pos, center);
			// Выполняем поиск разделяющей оси
			var hs:Vector3 = box.halfSize;
			var sx:Number = hs.x + sphere.r;
			var sy:Number = hs.y + sphere.r;
			var sz:Number = hs.z + sphere.r;
			if (center.x > sx || center.x < -sx
				|| center.y > sy || center.y < -sy
				|| center.z > sz || center.z < -sz) {
				return false;
			}
			// Находим ближайшую к сфере точку на боксе
			if (center.x > hs.x) {
				closestPt.x = hs.x;
			} else if (center.x < -hs.x) {
				closestPt.x = -hs.x;
			} else {
				closestPt.x = center.x;
			}

			if (center.y > hs.y) {
				closestPt.y = hs.y;
			} else if (center.y < -hs.y) {
				closestPt.y = -hs.y;
			} else {
				closestPt.y = center.y;
			}

			if (center.z > hs.z) {
				closestPt.z = hs.z;
			} else if (center.z < -hs.z) {
				closestPt.z = -hs.z;
			} else {
				closestPt.z = center.z;
			}
			
			// TODO: Предусмотреть обработку случая, когда центр сферы внутри бокса
			
			var distSqr:Number = center.subtract(closestPt).lengthSqr();
			if (distSqr > sphere.r*sphere.r) {
				return false;
			}
			// Зафиксированно столкновение
			collisionInfo.body1 = box;
			collisionInfo.body2 = sphere;
			collisionInfo.normal.copy(closestPt).transformBy4(box.transform).subtract(sphere.state.pos).normalize();
			collisionInfo.pcount = 1;

			var cp:CollisionPoint = collisionInfo.points[0];
			cp.penetration = sphere.r - Math.sqrt(distSqr);
			cp.pos.copy(collisionInfo.normal).scale(sphere.r).add(sphere.state.pos);

			return true;
		}
		
	}
}