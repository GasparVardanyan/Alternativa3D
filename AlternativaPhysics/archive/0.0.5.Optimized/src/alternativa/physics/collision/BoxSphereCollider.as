package alternativa.physics.collision {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionSphere;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactPoint;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;
	/**
	 * 
	 */
	public class BoxSphereCollider implements ICollider {
		
		private var center:Vector3 = new Vector3();
		private var closestPt:Vector3 = new Vector3();

		private var bPos:Vector3 = new Vector3();
		private var sPos:Vector3 = new Vector3();
		
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
		public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			var sphere:CollisionSphere = prim1 as CollisionSphere;
			var box:CollisionBox;
			if (sphere == null) {
				sphere = prim2 as CollisionSphere;
				box = prim1 as CollisionBox;
			} else {
				box = prim2 as CollisionBox;
			}
			// Трансформируем центр сферы в систему координат бокса
			sphere.transform.getAxis(3, sPos);
			box.transform.getAxis(3, bPos);
			box.transform.transformVectorInverse(sPos, center);
			// Выполняем поиск разделяющей оси
			var hs:Vector3 = box.hs;
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
			
			var distSqr:Number = center.vSubtract(closestPt).vLengthSqr();
			if (distSqr > sphere.r*sphere.r) {
				return false;
			}
			// Зафиксированно столкновение
			contact.body1 = sphere.body;
			contact.body2 = box.body;
			contact.normal.vCopy(closestPt).vTransformBy4(box.transform).vSubtract(sPos).vNormalize().vReverse();
			contact.pcount = 1;

			var cp:ContactPoint = contact.points[0];
			cp.penetration = sphere.r - Math.sqrt(distSqr);
			cp.pos.vCopy(contact.normal).vScale(-sphere.r).vAdd(sPos);
			cp.r1.vDiff(cp.pos, sPos);
			cp.r2.vDiff(cp.pos, bPos);

			return true;
		}
		
		/**
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
		}
		
	}
}