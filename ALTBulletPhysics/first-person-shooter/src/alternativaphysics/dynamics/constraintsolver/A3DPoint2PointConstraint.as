package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.dynamics.A3DRigidBody;

	import flash.geom.Vector3D;

	/** 
	* Точечное ограничение.
	* @public 
	* @author redefy 
	*/
	public class A3DPoint2PointConstraint extends A3DTypedConstraint {
		
		private var _pivotInA:Vector3D;
		private var _pivotInB:Vector3D;
		

		/** 
		* Конструктор
		* @public 
		* @param rbA Первое твердое тело ограничения
		* @param pivotInA Первая точка ограничения
		* @param rbB Второе твердое тело ограничения
		* @param pivotInB Вторая точка ограничения
		*/
		public function A3DPoint2PointConstraint(rbA : A3DRigidBody, pivotInA : Vector3D, rbB : A3DRigidBody = null, pivotInB : Vector3D = null) {
			super(0);
			m_rbA = rbA;
			m_rbB = rbB;
			
			_pivotInA = pivotInA;
			_pivotInB = pivotInB;

			if (rbB) {
				pointer = bullet.createP2PConstraintMethod2(rbA.pointer, rbB.pointer, pivotInA.x / _scaling, pivotInA.y / _scaling, pivotInA.z / _scaling, pivotInB.x / _scaling, pivotInB.y / _scaling, pivotInB.z / _scaling);
			} else {
				pointer = bullet.createP2PConstraintMethod1(rbA.pointer, pivotInA.x / _scaling, pivotInA.y / _scaling, pivotInA.z / _scaling);
			}
		}
		

		/** 
		* Первая точка ограничения
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get pivotInA():Vector3D {
			return _pivotInA;
		}
		

		/** 
		* Вторая точка ограничения
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get pivotInB():Vector3D {
			return _pivotInB;
		}
	}
}