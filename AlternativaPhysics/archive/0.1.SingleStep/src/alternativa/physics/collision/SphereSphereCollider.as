package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.primitives.RigidSphere;
	import alternativa.physics.types.Vector3;

	public class SphereSphereCollider implements ICollider {
		
		public function SphereSphereCollider() {
		}

		public function collide(body1:Body, body2:Body, colInfo:CollisionInfo):Boolean {
			var s1:RigidSphere;
			var s2:RigidSphere;
			if (body1.id < body2.id) {
				s1 = body1 as RigidSphere;
				s2 = body2 as RigidSphere;
			} else {
				s1 = body2 as RigidSphere;
				s2 = body1 as RigidSphere;
			}
			
			var p1:Vector3 = s1.state.pos;
			var p2:Vector3 = s2.state.pos;
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
			
			colInfo.body1 = s1;
			colInfo.body2 = s2;
			colInfo.normal.x = dx;
			colInfo.normal.y = dy;
			colInfo.normal.z = dz;
			colInfo.pcount = 1;
			var cp:CollisionPoint = colInfo.points[0];
			cp.penetration = sum - len;
			cp.pos.x = p1.x - dx*s1.r;
			cp.pos.y = p1.y - dy*s1.r;
			cp.pos.z = p1.z - dz*s1.r;
			
			return true;
		}
		
	}
}