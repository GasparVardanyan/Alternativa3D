package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.types.RayIntersection;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.types.Vector3;

	public class BruteForceCollisionDetector implements ICollisionDetector {
		public function BruteForceCollisionDetector() {
		}

		public function addPrimitive(primitive:CollisionPrimitive, isStatic:Boolean=true):Boolean {
			return false;
		}
		
		public function removePrimitive(primitive:CollisionPrimitive, isStatic:Boolean=true):Boolean {
			return false;
		}

		public function init():void {
		}
		
		public function getAllCollisions(contacts:Vector.<Contact>):int {
			return 0;
		}
		
		public function intersectRay(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, intersection:RayIntersection):Boolean {
			return false;
		}

		public function intersectRayWithStatic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean {
			return false;
		}
		
		public function testBodyPrimitiveCollision(body:Body, primitive:CollisionPrimitive):Boolean {
			return false;
		}

		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			return false;
		}
		
		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
		}

	}
}