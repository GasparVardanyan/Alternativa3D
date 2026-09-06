package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.A3DBase;

	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DAngularLimit extends A3DBase {

		/** 
		* 
		* @public 
		* @param ptr 
		*/
		public function A3DAngularLimit(ptr : uint) {
			pointer = ptr;
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
			halfRange = (high - low) / 2;
			center = normalizeAngle(low + halfRange);
			softness = _softness;
			biasFactor = _biasFactor;
			relaxationFactor = _relaxationFactor;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get low():Number {
			return normalizeAngle(center - halfRange);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get high():Number {
			return normalizeAngle(center + halfRange);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get center() : Number {
			return memUser._mrf(pointer + 0);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set center(v : Number) : void {
			memUser._mwf(pointer + 0, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get halfRange() : Number {
			return memUser._mrf(pointer + 4);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set halfRange(v : Number) : void {
			memUser._mwf(pointer + 4, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get softness() : Number {
			return memUser._mrf(pointer + 8);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set softness(v : Number) : void {
			memUser._mwf(pointer + 8, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get biasFactor() : Number {
			return memUser._mrf(pointer + 12);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set biasFactor(v : Number) : void {
			memUser._mwf(pointer + 12, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get relaxationFactor() : Number {
			return memUser._mrf(pointer + 16);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set relaxationFactor(v : Number) : void {
			memUser._mwf(pointer + 16, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get correction() : Number {
			return memUser._mrf(pointer + 20);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get sign() : Number {
			return memUser._mrf(pointer + 24);
		}


		/** 
		* 
		* @private 
		* @param angleInRadians 
		* @return Number 
		*/
		private function normalizeAngle(angleInRadians : Number) : Number {
			var pi2 : Number = 2 * Math.PI;
			var result : Number = angleInRadians % pi2;
			if (result < -Math.PI) {
				return result + pi2;
			} else if (result > Math.PI) {
				return result - pi2;
			} else {
				return result;
			}
		}
	}
}