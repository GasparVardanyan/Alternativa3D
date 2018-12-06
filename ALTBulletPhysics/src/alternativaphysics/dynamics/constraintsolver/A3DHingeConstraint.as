package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.dynamics.A3DRigidBody;
	
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;


	/** 
	* Шарнирное соединение.
	* @public 
	* @author redefy 
	*/
	public class A3DHingeConstraint extends A3DTypedConstraint {

		private var m_limit : A3DAngularLimit;
		private var _pivotInA:Vector3D;
		private var _pivotInB:Vector3D;
		private var _axisInA:Vector3D;
		private var _axisInB:Vector3D;


		/** 
		* 
		* @public 
		* @param rbA Первое твердое тело в ограничении.
		* @param pivotInA  Первая точка ограничения.
		* @param axisInA Ось первого тела.
		* @param rbB Второе твердое тело в ограничении.
		* @param pivotInB Вторая точка ограничения.
		* @param axisInB Ось второго тела.
		* @param useReferenceFrameA 
		*/
		public function A3DHingeConstraint(rbA : A3DRigidBody, pivotInA : Vector3D, axisInA : Vector3D, rbB : A3DRigidBody = null, pivotInB : Vector3D = null, axisInB : Vector3D = null, useReferenceFrameA : Boolean = false) {
			super(1);
			m_rbA = rbA;
			m_rbB = rbB;
			
			_pivotInA=pivotInA;
			_pivotInB=pivotInB;
			_axisInA=axisInA;
			_axisInB=axisInB;

			if (rbB) {
				pointer = bullet.createHingeConstraintMethod2(rbA.pointer, rbB.pointer, pivotInA.x / _scaling, pivotInA.y / _scaling, pivotInA.z / _scaling, pivotInB.x / _scaling, pivotInB.y / _scaling, pivotInB.z / _scaling, axisInA.x, axisInA.y, axisInA.z, axisInB.x, axisInB.y, axisInB.z, useReferenceFrameA ? 1 : 0);
			} else {
				pointer = bullet.createHingeConstraintMethod1(rbA.pointer, pivotInA.x / _scaling, pivotInA.y / _scaling, pivotInA.z / _scaling, axisInA.x, axisInA.y, axisInA.z, useReferenceFrameA ? 1 : 0);
			}
			
			m_limit = new A3DAngularLimit(pointer + 676);
		}
		

		/** 
		* Первая точка ограничения.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get pivotInA():Vector3D{
			return _pivotInA;
		}

		/** 
		* Вторая точка ограничения.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get pivotInB():Vector3D{
			return _pivotInB;
		}

		/** 
		* Ось первого тела.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get axisInA():Vector3D{
			return _axisInA;
		}

		/** 
		* Ось второго тела.
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get axisInB():Vector3D{
			return _axisInB;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return A3DAngularLimit 
		*/
		public function get limit():A3DAngularLimit {
			return m_limit;
		}


		/** 
		* 
		* @public 
		* @param low 
		* @param high 
		* @param _softness 
		* @param _biasFactor 
		* @param _relaxationFactor 
		* @return void 
		*/
		public function setLimit(low : Number, high : Number, _softness : Number = 0.9, _biasFactor : Number = 0.3, _relaxationFactor : Number = 1.0) : void {
			m_limit.setLimit(low, high, _softness, _biasFactor, _relaxationFactor);
		}


		/** 
		* 
		* @public 
		* @param _enableMotor 
		* @param _targetVelocity 
		* @param _maxMotorImpulse 
		* @return void 
		*/
		public function setAngularMotor(_enableMotor : Boolean, _targetVelocity : Number, _maxMotorImpulse : Number) : void {
			enableAngularMotor = _enableMotor;
			motorTargetVelocity = _targetVelocity;
			maxMotorImpulse = _maxMotorImpulse;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get motorTargetVelocity() : Number {
			return memUser._mrf(pointer + 668);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set motorTargetVelocity(v : Number) : void {
			memUser._mwf(pointer + 668, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get maxMotorImpulse() : Number {
			return memUser._mrf(pointer + 672);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set maxMotorImpulse(v : Number) : void {
			memUser._mwf(pointer + 672, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get angularOnly() : Boolean {
			return memUser._mru8(pointer + 724) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set angularOnly(v : Boolean) : void {
			memUser._mw8(pointer + 724, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get enableAngularMotor() : Boolean {
			return memUser._mru8(pointer + 725) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set enableAngularMotor(v : Boolean) : void {
			memUser._mw8(pointer + 725, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get useOffsetForConstraintFrame() : Boolean {
			return memUser._mru8(pointer + 727) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set useOffsetForConstraintFrame(v : Boolean) : void {
			memUser._mw8(pointer + 727, v ? 1 : 0);
		}
	}
}