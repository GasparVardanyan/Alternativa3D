package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	
	/**
	 * 
	 */
	public class CollisionDetector implements ICollider {
		
		private var colliders:Object = {};
		
		/**
		 * 
		 */
		public function CollisionDetector() {
			addCollider(Body.BOX, Body.BOX, new BoxBoxCollider());
			addCollider(Body.BOX, Body.PLANE, new BoxPlaneCollider());
			addCollider(Body.BOX, Body.SPHERE, new BoxSphereCollider());
			addCollider(Body.SPHERE, Body.PLANE, new SpherePlaneCollider());
			addCollider(Body.SPHERE, Body.SPHERE, new SphereSphereCollider());
		}
		
		/**
		 * 
		 * @param type1
		 * @param type2
		 * @param collider
		 */
		private function addCollider(type1:int, type2:int, collider:ICollider):void {
			colliders[type1 <= type2 ? (type1 << 16) | type2 : (type2 << 16) | type1] = collider;
		}
		
		/**
		 * 
		 * @param body1
		 * @param body2
		 * @param contactInfo
		 * @return 
		 */
		public function collide(body1:Body, body2:Body, contactInfo:CollisionInfo):Boolean {
			var collider:ICollider = colliders[body1.type <= body2.type ? (body1.type << 16) | body2.type : (body2.type << 16) | body1.type] as ICollider;
			return collider == null ? false : collider.collide(body1, body2, contactInfo);
		}

	}
}