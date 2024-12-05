package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;
	
	
	/**
	 * Сфера.
	 */	
	public class CollisionSphere extends CollisionPrimitive {
		
		// Радиус сферы
		public var r:Number = 0;
		
		/**
		 * 
		 * @param r
		 * @param collisionGroup
		 */
		public function CollisionSphere(r:Number, collisionGroup:int) {
			super(SPHERE, collisionGroup);
			this.r = r;
		}
		
		/**
		 * @return 
		 */
		override public function calculateAABB():BoundBox {
			aabb.maxX = transform.d + r;
			aabb.minX = transform.d - r;

			aabb.maxY = transform.h + r;
			aabb.minY = transform.h - r;

			aabb.maxZ = transform.l + r;
			aabb.minZ = transform.l - r;
			
			return aabb;
		}
		
		/**
		 * @param origin
		 * @param vector
		 * @param threshold
		 * @param normal
		 * @return 
		 */
		override public function getRayIntersection(origin:Vector3, vector:Vector3, threshold:Number, normal:Vector3):Number {
			var px:Number = origin.x - transform.d;
			var py:Number = origin.y - transform.h;
			var pz:Number = origin.z - transform.l;
			var k:Number = vector.x*px + vector.y*py + vector.z*pz;
			if (k > 0) return -1;
			var a:Number = vector.x*vector.x + vector.y*vector.y + vector.z*vector.z;
			var D:Number = k*k - a*(px*px + py*py + pz*pz - r*r);
			if (D < 0) return -1;
			return -(k + Math.sqrt(D))/a;
		}
		
		/**
		 * @param source
		 * @return 
		 */
		override public function copyFrom(source:CollisionPrimitive):CollisionPrimitive {
			var sphere:CollisionSphere = source as CollisionSphere;
			if (sphere == null) return this;
			super.copyFrom(sphere);
			r = sphere.r;
			return this;
		}
		
		/**
		 * @return 
		 */
		override protected function createPrimitive():CollisionPrimitive {
			return new CollisionSphere(r, collisionGroup);
		}
	}
}