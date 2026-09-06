package alternativaphysics.math {
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	

	/** 
	* Математические функции.
	* @public 
	* @author redefy 
	*/
	public class A3DMath {

		/** 
		* Константа для преобразования радиан в градусы
		* @public (constant) 
		*/
		public static const RADIANS_TO_DEGREES : Number = 180 / Math.PI;

		/** 
		* Константа для преобразования градусов в радианы
		* @public (constant) 
		*/
		public static const DEGREES_TO_RADIANS : Number = Math.PI / 180;
		

		/** 
		*  Возвращает Vector3D c углами поворота, выдранными из матрицы
		* @public 
		* @param m Матрица 4x4
		* @return Vector3D 
		*/
		public static function matrix2euler( m:Matrix3D ) : Vector3D{
			return m.decompose()[1];
		}
		

		/** 
		* Создает матрицу 4x4, которая содержит углы поворота взятые из переданного в функцию вектора ang. 
		* @public 
		* @param ang Vector3D c углами поворота
		* @return Matrix3D 
		*/
		public static function euler2matrix( ang:Vector3D ) : Matrix3D{
			var m:Matrix3D = new Matrix3D();
			var data:Vector.<Vector3D> = Vector.<Vector3D>([new Vector3D(), ang, new Vector3D(1, 1, 1)]);
			m.recompose(data);
			return m;
		}
		

		/** 
		* Увеличивает значение элементов x, y и z вектора v1 на значения элементов x, y и z вектора v2.
		* @public 
		* @param v1 вектор
		* @param v2 вектор
		* @return Vector3D 
		*/
		public static function vectorMultiply(v1:Vector3D, v2:Vector3D):Vector3D {
			return new Vector3D(v1.x * v2.x, v1.y * v2.y, v1.z * v2.z);
		}
		

		/** 
		* Преобразовывает все составляющие трехмерного вектора из градусов в радианы
		* @public 
		* @param degrees Трехмерный вектор, который требуется преобразовать.
		* @return Vector3D 
		*/
		public static function degrees2radiansV3D(degrees:Vector3D):Vector3D {
			var deg:Vector3D = degrees.clone();
			deg.x *= A3DMath.DEGREES_TO_RADIANS;
			deg.y *= A3DMath.DEGREES_TO_RADIANS;
			deg.z *= A3DMath.DEGREES_TO_RADIANS;
			return deg;
		}

		/** 
		*  Преобразовывает все составляющие трехмерного вектора из радиан в градусы
		* @public 
		* @param radians Трехмерный вектор, который требуется преобразовать.
		* @return Vector3D 
		*/
		public static function radians2degreesV3D(radians:Vector3D):Vector3D {
			var rad:Vector3D = radians.clone();
			rad.x *= A3DMath.RADIANS_TO_DEGREES;
			rad.y *= A3DMath.RADIANS_TO_DEGREES;
			rad.z *= A3DMath.RADIANS_TO_DEGREES;
			return rad;
		}
	}
}