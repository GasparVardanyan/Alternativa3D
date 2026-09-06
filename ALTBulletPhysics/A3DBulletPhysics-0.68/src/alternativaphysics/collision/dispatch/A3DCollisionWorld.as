package alternativaphysics.collision.dispatch {
	import alternativaphysics.A3DBase;
	import alternativaphysics.collision.dispatch.A3DCollisionObject;
	import alternativaphysics.collision.shapes.A3DBvhTriangleMeshShape;
   	import alternativaphysics.collision.shapes.A3DConvexHullShape;
   	import alternativaphysics.collision.shapes.A3DHeightfieldTerrainShape;
   	import alternativaphysics.collision.shapes.A3DCompoundShape;
   	import alternativaphysics.data.A3DCollisionShapeType;
	
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
			obj.removeAllRays();
			if(obj.shape.shapeType==A3DCollisionShapeType.TRIANGLE_MESH_SHAPE){
				A3DBvhTriangleMeshShape(obj.shape).deleteBvhTriangleMeshShapeBuffer();
   	        }else if(obj.shape.shapeType==A3DCollisionShapeType.CONVEX_HULL_SHAPE){
				A3DConvexHullShape(obj.shape).deleteConvexHullShapeBuffer();
			}else if(obj.shape.shapeType==A3DCollisionShapeType.HEIGHT_FIELD_TERRAIN){
				A3DHeightfieldTerrainShape(obj.shape).deleteHeightfieldTerrainShapeBuffer();
			}else if(obj.shape.shapeType==A3DCollisionShapeType.COMPOUND_SHAPE){
				A3DCompoundShape(obj.shape).removeAllChildren();
			}
			bullet.removeCollisionObjectMethod(obj.pointer);
			
			if(m_collisionObjects.indexOf(obj) >= 0) {
				m_collisionObjects.splice(m_collisionObjects.indexOf(obj), 1);
			}
		}
	}
}