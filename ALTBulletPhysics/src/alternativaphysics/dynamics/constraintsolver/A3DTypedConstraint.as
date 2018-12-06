package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.A3DBase;
	import alternativaphysics.dynamics.A3DRigidBody;


	/** 
	* Базовый класс для всех классов-ограничений.
	* @public 
	* @author redefy 
	*/
	public class A3DTypedConstraint extends A3DBase {

		protected var m_rbA : A3DRigidBody;
		protected var m_rbB : A3DRigidBody;
		protected var m_constraintType:int;


		/** 
		* Конструктор
		* @public 
		* @param type Тип ограничения
		*/
		public function A3DTypedConstraint(type:int) {
			m_constraintType = type;
		}


		/** 
		* Первое твердое тело, участвующее в данном ограничении
		* @public (getter) 
		* @return A3DRigidBody 
		*/
		public function get rigidBodyA() : A3DRigidBody {
			return m_rbA;
		}


		/** 
		* Второе твердое тело, участвующее в данном ограничении
		* @public (getter) 
		* @return A3DRigidBody 
		*/
		public function get rigidBodyB() : A3DRigidBody {
			return m_rbB;
		}
		

		/** 
		* Тип ограничения
		* @public (getter) 
		* @return int 
		*/
		public function get constraintType():int {
			return m_constraintType;
		}
	}
}