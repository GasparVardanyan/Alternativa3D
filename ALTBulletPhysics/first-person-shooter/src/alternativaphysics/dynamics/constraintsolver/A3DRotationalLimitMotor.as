package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.A3DBase;

	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DRotationalLimitMotor extends A3DBase {

		/** 
		* 
		* @public 
		* @param ptr 
		*/
		public function A3DRotationalLimitMotor(ptr : uint) {
			pointer = ptr;
		}


		/** 
		* 
		* @public 
		* @return Boolean 
		*/
		public function isLimited() : Boolean {
			if (loLimit > hiLimit) return false;

			return true;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get loLimit() : Number {
			return memUser._mrf(pointer + 0);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set loLimit(v : Number) : void {
			memUser._mwf(pointer + 0, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get hiLimit() : Number {
			return memUser._mrf(pointer + 4);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set hiLimit(v : Number) : void {
			memUser._mwf(pointer + 4, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get targetVelocity() : Number {
			return memUser._mrf(pointer + 8);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set targetVelocity(v : Number) : void {
			memUser._mwf(pointer + 8, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get maxMotorForce() : Number {
			return memUser._mrf(pointer + 12);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set maxMotorForce(v : Number) : void {
			memUser._mwf(pointer + 12, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get maxLimitForce() : Number {
			return memUser._mrf(pointer + 16);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set maxLimitForce(v : Number) : void {
			memUser._mwf(pointer + 16, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get damping() : Number {
			return memUser._mrf(pointer + 20);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set damping(v : Number) : void {
			memUser._mwf(pointer + 20, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get limitSoftness() : Number {
			return memUser._mrf(pointer + 24);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set limitSoftness(v : Number) : void {
			memUser._mwf(pointer + 24, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get normalCFM() : Number {
			return memUser._mrf(pointer + 28);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set normalCFM(v : Number) : void {
			memUser._mwf(pointer + 28, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get stopERP() : Number {
			return memUser._mrf(pointer + 32);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set stopERP(v : Number) : void {
			memUser._mwf(pointer + 32, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get stopCFM() : Number {
			return memUser._mrf(pointer + 36);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set stopCFM(v : Number) : void {
			memUser._mwf(pointer + 36, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get bounce() : Number {
			return memUser._mrf(pointer + 40);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set bounce(v : Number) : void {
			memUser._mwf(pointer + 40, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get enableMotor() : Boolean {
			return memUser._mru8(pointer + 44) == 1;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set enableMotor(v : Boolean) : void {
			memUser._mw8(pointer + 44, v ? 1 : 0);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get currentLimitError() : Number {
			return memUser._mrf(pointer + 48);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set currentLimitError(v : Number) : void {
			memUser._mwf(pointer + 48, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get currentPosition() : Number {
			return memUser._mrf(pointer + 52);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set currentPosition(v : Number) : void {
			memUser._mwf(pointer + 52, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get currentLimit() : int {
			return memUser._mr32(pointer + 56);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set currentLimit(v : int) : void {
			memUser._mw32(pointer + 56, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get accumulatedImpulse() : Number {
			return memUser._mrf(pointer + 60);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set accumulatedImpulse(v : Number) : void {
			memUser._mwf(pointer + 60, v);
		}
	}
}