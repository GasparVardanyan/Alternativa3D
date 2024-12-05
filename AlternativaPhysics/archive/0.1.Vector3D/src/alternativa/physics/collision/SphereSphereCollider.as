package alternativa.physics.collision {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionSphere;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactPoint;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;

	public class SphereSphereCollider implements ICollider {
		
		private var p1:Vector3 = new Vector3();
		private var p2:Vector3 = new Vector3();
		
		public function SphereSphereCollider() {
		}

		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			var s1:CollisionSphere;
			var s2:CollisionSphere;
			if (prim1.body != null) {
				s1 = prim1 as CollisionSphere;
				s2 = prim2 as CollisionSphere;
			} else {
				s1 = prim2 as CollisionSphere;
				s2 = prim1 as CollisionSphere;
			}
			
			s1.transform.getAxis(3, p1);
			s2.transform.getAxis(3, p2);
			var dx:Number = p1.x - p2.x;
			var dy:Number = p1.y - p2.y;
			var dz:Number = p1.z - p2.z;
			var len:Number = dx*dx + dy*dy + dz*dz;
			var sum:Number = s1.r + s2.r;
			if (len > sum*sum) return false;
			len = Math.sqrt(len);
			dx /= len;
			dy /= len;
			dz /= len;
			
			contact.body1 = s1.body;
			contact.body2 = s2.body;
			contact.normal.x = dx;
			contact.normal.y = dy;
			contact.normal.z = dz;
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			cp.penetration = sum - len;
			cp.pos.x = p1.x - dx*s1.r;
			cp.pos.y = p1.y - dy*s1.r;
			cp.pos.z = p1.z - dz*s1.r;
			cp.r1.vDiff(cp.pos, p1);
			cp.r2.vDiff(cp.pos, p2);
			
			return true;
		}
		
	}
}