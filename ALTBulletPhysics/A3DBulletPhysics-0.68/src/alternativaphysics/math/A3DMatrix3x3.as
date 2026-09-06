package alternativaphysics.math {
	import alternativaphysics.A3DBase;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DMatrix3x3 extends A3DBase {

		private var _row1 : A3DVector3;
		private var _row2 : A3DVector3;
		private var _row3 : A3DVector3;
		

		private var _m3d : Matrix3D = new Matrix3D();
		private var _v3d : Vector3D = new Vector3D();


		/** 
		* Конструктор.
		* @public 
		* @param ptr 
		*/
		public function A3DMatrix3x3(ptr : uint) {
			pointer = ptr;
			_row1 = new A3DVector3(ptr + 0);
			_row2 = new A3DVector3(ptr + 16);
			_row3 = new A3DVector3(ptr + 32);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get row1():Vector3D {
			return _row1.v3d;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get row2():Vector3D {
			return _row2.v3d;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get row3():Vector3D {
			return _row3.v3d;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get column1():Vector3D {
			return new Vector3D(_row1.x, _row2.x, _row3.x);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get column2():Vector3D {
			return new Vector3D(_row1.y, _row2.y, _row3.y);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get column3():Vector3D {
			return new Vector3D(_row1.z, _row2.z, _row3.z);
		}


		/** 
		* 
		* @public (getter) 
		* @return Matrix3D 
		*/
		public function get m3d() : Matrix3D {
			_m3d.copyRowFrom(0, _row1.v3d);
			_m3d.copyRowFrom(1, _row2.v3d);
			_m3d.copyRowFrom(2, _row3.v3d);
			return _m3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param m 
		* @return void 
		*/
		public function set m3d(m : Matrix3D) : void {
			_v3d.setTo(m.rawData[0], m.rawData[4], m.rawData[8]);
			_row1.v3d = _v3d;
			_v3d.setTo(m.rawData[1], m.rawData[5], m.rawData[9]);
			_row2.v3d = _v3d;
			_v3d.setTo(m.rawData[2], m.rawData[6], m.rawData[10]);
			_row3.v3d = _v3d;
		}
	}
}