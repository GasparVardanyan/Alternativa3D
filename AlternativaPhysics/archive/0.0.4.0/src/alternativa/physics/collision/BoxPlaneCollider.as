package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.types.Vector3;

	public class BoxPlaneCollider implements ICollider {
		
		private var verts1:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var verts2:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var normal:Vector3 = new Vector3();
		
		public function BoxPlaneCollider() {
			for (var i:int = 0; i < 8; i++) {
				verts1[i] = new Vector3();
				verts2[i] = new Vector3();
			}
		}

		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
//			var box:RigidBox = body1 as RigidBox;
//			var plane:RigidPlane;
//			if (box == null) {
//				box = body2 as RigidBox;
//				plane = body1 as RigidPlane;
//			} else {
//				plane = body2 as RigidPlane;
//			}
//			
//			// Вычисляем глобальные координаты вершин бокса
//			var sx:Number = box.halfSize.x;
//			var sy:Number = box.halfSize.y;
//			var sz:Number = box.halfSize.z;
//			(verts1[0] as Vector3).reset(-sx, -sy, -sz);
//			(verts1[1] as Vector3).reset(sx, -sy, -sz);
//			(verts1[2] as Vector3).reset(sx, sy, -sz);
//			(verts1[3] as Vector3).reset(-sx, sy, -sz);
//			(verts1[4] as Vector3).reset(-sx, -sy, sz);
//			(verts1[5] as Vector3).reset(sx, -sy, sz);
//			(verts1[6] as Vector3).reset(sx, sy, sz);
//			(verts1[7] as Vector3).reset(-sx, sy, sz);
//			
//			box.transform.transformVectors(verts1, verts2);
//			// Вычисляем глобальные нормаль и смещение плоскости
//			plane.baseMatrix.transformVector(plane.normal, normal);
//			var offset:Number = plane.offset + normal.x*plane.transform.d + normal.y*plane.transform.h + normal.z*plane.transform.l;
//			// Проверяем наличие столкновений с каждой вершиной
//			collisionInfo.pcount = 0;
//			for (var i:int = 0; i < 8; i++) {
//				// Вершина добавляется в список точек столкновения, если лежит под плоскостью
//				var dist:Number = (verts2[i] as Vector3).dot(normal);
//				if (dist < offset) {
//					var cp:ContactPoint;
//					if (collisionInfo.pcount == collisionInfo.points.length) {
//						cp = new ContactPoint();
//						collisionInfo.points[collisionInfo.pcount] = cp;
//					} else {
//						cp = collisionInfo.points[collisionInfo.pcount];
//					}
//					cp.pos.copy(verts2[i]);
//					cp.r1.diff(cp.pos, box.state.pos);
//					cp.r2.diff(cp.pos, plane.state.pos);
//					cp.penetration = offset - dist;
//					collisionInfo.pcount++;
//				}
//			}
//			if (collisionInfo.pcount > 0) {
//				collisionInfo.body1 = box;
//				collisionInfo.body2 = plane;
//				collisionInfo.normal.copy(normal);
//				return true;
//			}
			return false;
		}
		
		/**
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
		}
		
	}
}