package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;
	
	public class CollisionTriangle extends CollisionPrimitive {
		
		public var v0:Vector3 = new Vector3();
		public var v1:Vector3 = new Vector3();
		public var v2:Vector3 = new Vector3();
		public var e0:Vector3 = new Vector3();
		public var e1:Vector3 = new Vector3();
		public var e2:Vector3 = new Vector3();
		public var len0:Number;
		public var len1:Number;
		public var len2:Number;
		
		public function CollisionTriangle(v0:Vector3, v1:Vector3, v2:Vector3, collisionGroup:int) {
			super(TRIANGLE, collisionGroup);
			
			this.v0.vCopy(v0);
			this.v1.vCopy(v1);
			this.v2.vCopy(v2);
			
			e0.vDiff(v1, v0);
			len0 = e0.vLength();
			e0.vNormalize();
			
			e1.vDiff(v2, v1);
			len1 = e1.vLength();
			e1.vNormalize();
			
			e2.vDiff(v0, v2);
			len2 = e2.vLength();
			e2.vNormalize();
		}
		
	}
}