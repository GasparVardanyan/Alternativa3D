package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.A3DBase;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DTranslationalLimitMotor extends A3DBase {

		private var m_lowerLimit : A3DVector3;
		private var m_upperLimit : A3DVector3;
		private var m_accumulatedImpulse : A3DVector3;
		private var m_normalCFM : A3DVector3;
		private var m_stopERP : A3DVector3;
		private var m_stopCFM : A3DVector3;
		private var m_targetVelocity : A3DVector3;
		private var m_maxMotorForce : A3DVector3;
		private var m_currentLimitError : A3DVector3;
		private var m_currentLinearDiff : A3DVector3;


		/** 
		* 
		* @public 
		* @param ptr 
		*/
		public function A3DTranslationalLimitMotor(ptr : uint) {
			pointer = ptr;

			m_lowerLimit = new A3DVector3(ptr + 0);
			m_upperLimit = new A3DVector3(ptr + 16);
			m_accumulatedImpulse = new A3DVector3(ptr + 32);
			m_normalCFM = new A3DVector3(ptr + 60);
			m_stopERP = new A3DVector3(ptr + 76);
			m_stopCFM = new A3DVector3(ptr + 92);
			m_targetVelocity = new A3DVector3(ptr + 112);
			m_maxMotorForce = new A3DVector3(ptr + 128);
			m_currentLimitError = new A3DVector3(ptr + 144);
			m_currentLinearDiff = new A3DVector3(ptr + 160);
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get lowerLimit() : Vector3D {
			return m_lowerLimit.sv3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set lowerLimit(v : Vector3D) : void {
			m_lowerLimit.sv3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get upperLimit() : Vector3D {
			return m_upperLimit.sv3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set upperLimit(v : Vector3D) : void {
			m_upperLimit.sv3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get accumulatedImpulse() : Vector3D {
			return m_accumulatedImpulse.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set accumulatedImpulse(v : Vector3D) : void {
			m_accumulatedImpulse.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get normalCFM() : Vector3D {
			return m_normalCFM.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set normalCFM(v : Vector3D) : void {
			m_normalCFM.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get stopERP() : Vector3D {
			return m_stopERP.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set stopERP(v : Vector3D) : void {
			m_stopERP.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get stopCFM() : Vector3D {
			return m_stopCFM.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set stopCFM(v : Vector3D) : void {
			m_stopCFM.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get targetVelocity() : Vector3D {
			return m_targetVelocity.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set targetVelocity(v : Vector3D) : void {
			m_targetVelocity.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get maxMotorForce() : Vector3D {
			return m_maxMotorForce.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set maxMotorForce(v : Vector3D) : void {
			m_maxMotorForce.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get currentLimitError() : Vector3D {
			return m_currentLimitError.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set currentLimitError(v : Vector3D) : void {
			m_currentLimitError.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get currentLinearDiff() : Vector3D {
			return m_currentLinearDiff.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set currentLinearDiff(v : Vector3D) : void {
			m_currentLinearDiff.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get limitSoftness() : Number {
			return memUser._mrf(pointer + 48);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set limitSoftness(v : Number) : void {
			memUser._mwf(pointer + 48, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get damping() : Number {
			return memUser._mrf(pointer + 52);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set damping(v : Number) : void {
			memUser._mwf(pointer + 52, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get restitution() : Number {
			return memUser._mrf(pointer + 56);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set restitution(v : Number) : void {
			memUser._mwf(pointer + 56, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get enableMotorX() : Boolean {
			return memUser._mru8(pointer + 108) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set enableMotorX(v : Boolean) : void {
			memUser._mw8(pointer + 108, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get enableMotorY() : Boolean {
			return memUser._mru8(pointer + 109) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set enableMotorY(v : Boolean) : void {
			memUser._mw8(pointer + 109, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get enableMotorZ() : Boolean {
			return memUser._mru8(pointer + 110) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set enableMotorZ(v : Boolean) : void {
			memUser._mw8(pointer + 110, v ? 1 : 0);
		}
	}
}