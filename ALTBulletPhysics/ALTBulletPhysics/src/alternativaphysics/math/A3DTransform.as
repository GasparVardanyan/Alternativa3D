package alternativaphysics.math {
	
	import flash.geom.Vector3D;
	import flash.geom.Matrix3D;
	
	import alternativaphysics.A3DBase;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DTransform extends A3DBase {

		private var m_basis : A3DMatrix3x3;
		private var m_origin : A3DVector3;
		private var _transData:Vector.<Vector3D>;
		private var _transform:Matrix3D = new Matrix3D();
		
		/** 
		* Конструктор.
		* @public 
		*/
		public function A3DTransform(ptr : uint = 0) {
			pointer = ptr;
			
			_transData = new Vector.<Vector3D>(3, true);
			
			if (ptr > 0) {	
				m_basis = new A3DMatrix3x3(ptr + 0);
				m_origin = new A3DVector3(ptr + 48);
				
				_transData[0] = m_origin.sv3d;
				_transData[1] = A3DMath.matrix2euler(m_basis.m3d);
				_transData[2] = new Vector3D(1, 1, 1);
			}else {
				m_basis = null;
				m_origin = null;
				
				_transData[0] = new Vector3D();
				_transData[1] = new Vector3D();
				_transData[2] = new Vector3D(1, 1, 1);
			}
		}
		

		/** 
		* 
		* @public (getter) 
		* @return A3DVector3 
		*/
		public function get origin():A3DVector3 {
			return m_origin;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return A3DMatrix3x3 
		*/
		public function get basis():A3DMatrix3x3 {
			return m_basis;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get position():Vector3D {
			if (m_origin) {
				return m_origin.sv3d;
			}else {
				return _transData[0];
			}
		}
		

		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set position(v:Vector3D):void {
			_transData[0] = v;
			if ((m_origin)) {
				m_origin.sv3d = v;
			}
		}
		

		/** 
		* get the euler angle in radians
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get rotation():Vector3D {
			if (m_basis) {
				return A3DMath.matrix2euler(m_basis.m3d);
			}else {
				return _transData[1];
			}
		}
		

		/** 
		* 
		* @public (setter) 
		* @param v set the euler angle in radians
		* @return void 
		*/
		public function set rotation(v:Vector3D):void {
			_transData[1] = v;
			if (m_basis) {
				m_basis.m3d = A3DMath.euler2matrix(v);
			}
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Matrix3D 
		*/
		public function get rotationWithMatrix():Matrix3D {
			if (m_basis) {
				return m_basis.m3d;
			}else {
				return A3DMath.euler2matrix(_transData[1]);
			}
		}
		

		/** 
		* 
		* @public (setter) 
		* @param m 
		* @return void 
		*/
		public function set rotationWithMatrix(m:Matrix3D):void {
			_transData[1] = A3DMath.matrix2euler(m);
			if (m_basis) {
				m_basis.m3d = m;
			}
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get axisX():Vector3D {
			var m:Matrix3D = this.rotationWithMatrix;
			return new Vector3D(m.rawData[0], m.rawData[4], m.rawData[8]);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get axisY():Vector3D {
			var m:Matrix3D = this.rotationWithMatrix;
			return new Vector3D(m.rawData[1], m.rawData[5], m.rawData[9]);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get axisZ():Vector3D {
			var m:Matrix3D = this.rotationWithMatrix;
			return new Vector3D(m.rawData[2], m.rawData[6], m.rawData[10]);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Matrix3D 
		*/
		public function get transform():Matrix3D {
			if (m_origin && m_basis) {
				_transData[0] = m_origin.sv3d;
				_transData[1] = A3DMath.matrix2euler(m_basis.m3d);
			}
			_transform.identity();
			_transform.recompose(_transData);
			
			return _transform;
		}
		

		/** 
		* 
		* @public (setter) 
		* @param m 
		* @return void 
		*/
		public function set transform(m:Matrix3D):void {
			_transData = m.decompose();
			_transData[2].setTo(1, 1, 1);
			if (m_origin && m_basis) {
				m_origin.sv3d = _transData[0];
				m_basis.m3d = A3DMath.euler2matrix(_transData[1]);
			}
		}
		

		/** 
		* 
		* @public 
		* @param tr 
		* @return void 
		*/
		public function appendTransform(tr:A3DTransform):void {
			var m:Matrix3D = this.transform;
			m.append(tr.transform);
			this.transform = m;
		}
		

		/** 
		* 
		* @public 
		* @return A3DTransform 
		*/
		public function clone():A3DTransform {
			var tr:A3DTransform = new A3DTransform();
			tr.transform = this.transform;
			return tr;
		}
	}
}