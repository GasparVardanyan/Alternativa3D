package alternativaphysics.collision.shapes {
	import flash.geom.Vector3D;
	import alternativaphysics.A3DBase;
	

	/** 
	* Базовый класс для всех шейпов.
	* @public 
	* @author redefy 
	*/
	public class A3DCollisionShape extends A3DBase {
		
		protected var m_shapeType:int;
		protected var m_localScaling:Vector3D;
		

		/** 
		* Конструктор
		* @public 
		* @param ptr 
		* @param type Тип шейпа
		*/
		public function A3DCollisionShape(ptr:uint, type:int) {
			pointer = ptr;
			m_shapeType = type;
			
			m_localScaling = new Vector3D(1, 1, 1);
		}
		
		/** 
		* Тип шейпа. Константы типов шейпов определены в классе A3DCollisionShapeType.
		* @public (getter) 
		* @return int
		*/
		public function get shapeType():int {
			return m_shapeType;
		}
		

		/** 
		* Вектор с значениями текущего масштабирования шейпа.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get localScaling():Vector3D {
			return m_localScaling;
		}
		

		/** 
		* Масштабирует шейп
		* @public (setter) 
		* @param scale Вектор с значениями масштабирования для всех трех осей
		* @return void 
		*/
		public function set localScaling(scale:Vector3D):void {
			m_localScaling.setTo(scale.x, scale.y, scale.z);
			bullet.setShapeScalingMethod(pointer, scale.x, scale.y, scale.z);
		}
	}
}