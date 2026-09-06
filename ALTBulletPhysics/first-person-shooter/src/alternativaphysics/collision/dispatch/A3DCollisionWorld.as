package alternativaphysics.collision.dispatch {
	import alternativaphysics.A3DBase;
	import alternativaphysics.collision.dispatch.A3DCollisionObject;
	
	public class A3DCollisionWorld extends A3DBase{
		
		protected var m_collisionObjects : Vector.<A3DCollisionObject>;
		
		public function A3DCollisionWorld(){
			m_collisionObjects =  new Vector.<A3DCollisionObject>();
		}
		
		public function get collisionObjects() : Vector.<A3DCollisionObject> {
			return m_collisionObjects;
		}
		
		public function addCollisionObject(obj:A3DCollisionObject, group:int = 1, mask:int = -1):void{
			bullet.addCollisionObjectMethod(obj.pointer, group, mask);
			
			if(m_collisionObjects.indexOf(obj) < 0){
				m_collisionObjects.push(obj);
			}
		}
		
		public function removeCollisionObject(obj:A3DCollisionObject) : void {
			bullet.removeCollisionObjectMethod(obj.pointer);
			
			if(m_collisionObjects.indexOf(obj) >= 0) {
				m_collisionObjects.splice(m_collisionObjects.indexOf(obj), 1);
			}
		}
	}
}