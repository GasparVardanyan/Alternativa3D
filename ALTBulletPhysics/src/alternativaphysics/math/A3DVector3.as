package alternativaphysics.math {
	import alternativaphysics.A3DBase;

	import flash.geom.Vector3D;


	/** 
	* Трехмерный вектор.
	* @public 
	* @author redefy 
	*/
	public class A3DVector3 extends A3DBase {

		private var _v3d : Vector3D = new Vector3D();


		/** 
		* Конструктор.
		* @public 
		* @param ptr 
		*/
		public function A3DVector3(ptr : uint) {
			pointer = ptr;
		}


		/** 
		* Координата X вектора.
		* @public (getter) 
		* @return Number 
		*/
		public function get x() : Number {
			return memUser._mrf(pointer + 0);
		}


		/** 
		* Координата X вектора.
		* @public (setter) 
		* @param v Координата X вектора.
		* @return void 
		*/
		public function set x(v : Number) : void {
			memUser._mwf(pointer + 0, v);
		}


		/** 
		* Координата Y вектора.
		* @public (getter) 
		* @return Number 
		*/
		public function get y() : Number {
			return memUser._mrf(pointer + 4);
		}


		/** 
		* Координата Y вектора.
		* @public (setter) 
		* @param v Координата Y вектора.
		* @return void 
		*/
		public function set y(v : Number) : void {
			memUser._mwf(pointer + 4, v);
		}


		/** 
		* Координата Z вектора.
		* @public (getter) 
		* @return Number 
		*/
		public function get z() : Number {
			return memUser._mrf(pointer + 8);
		}


		/** 
		* Координата Z вектора.
		* @public (setter) 
		* @param v Координата Z вектора.
		* @return void 
		*/
		public function set z(v : Number) : void {
			memUser._mwf(pointer + 8, v);
		}


		/** 
		* Трехмерный вектор. 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get v3d() : Vector3D {
			_v3d.setTo(x, y, z);
			return _v3d;
		}


		/** 
		* Трехмерный вектор. 
		* @public (setter) 
		* @param v Трехмерный вектор. 
		* @return void 
		*/
		public function set v3d(v : Vector3D) : void {
			x = v.x;
			y = v.y;
			z = v.z;
		}


		/** 
		* Трехмерный вектор преобразованный в соответствии с единицей измерения в физическом мире. 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get sv3d() : Vector3D {
			_v3d.setTo(x, y, z);
			_v3d.scaleBy(_scaling);
			return _v3d;
		}


		/** 
		*  Трехмерный вектор преобразованный в соответствии с единицей измерения в физическом мире. 
		* @public (setter) 
		* @param v Трехмерный вектор.
		* @return void 
		*/
		public function set sv3d(v : Vector3D) : void {
			x = v.x / _scaling;
			y = v.y / _scaling;
			z = v.z / _scaling;
		}
	}
}