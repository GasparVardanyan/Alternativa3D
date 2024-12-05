package alternativa.math {
	import flash.geom.Vector3D;
	
	/**
	 * 
	 */
	public class Vector3 extends Vector3D {
		
		public static const ZERO:Vector3 = new Vector3(0, 0, 0);
		public static const X_AXIS:Vector3 = new Vector3(1, 0, 0);
		public static const Y_AXIS:Vector3 = new Vector3(0, 1, 0);
		public static const Z_AXIS:Vector3 = new Vector3(0, 0, 1);
		
		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function Vector3(x:Number = 0, y:Number = 0, z:Number = 0) {
			this.x = x;
			this.y = y;
			this.z = z;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function vLength():Number {
			return Math.sqrt(x*x + y*y + z*z);
		}

		/**
		 * 
		 * @return 
		 */
		public function vLengthSqr():Number {
			return x*x + y*y + z*z;
		}
		
		/**
		 * 
		 * @param length
		 * @return 
		 */
		public function vSetLength(length:Number):Vector3 {
			var d:Number = x*x + y*y + z*z;
			if (d == 0) {
				x = length;
			} else {
				var k:Number = length/Math.sqrt(x*x + y*y + z*z);
				x *= k;
				y *= k;
				z *= k;
			}
			return this;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function vNormalize():Vector3 {
			var d:Number = x*x + y*y + z*z;
			if (d == 0) {
				x = 1;
			} else {
				d = Math.sqrt(d);
				x /= d;
				y /= d;
				z /= d;
			}
			return this;
		}
		
		/**
		 * Сложение координат.
		 * 
		 * @param v точка, координаты которой прибавляются к собственным
		 */		
		public function vAdd(v:Vector3):Vector3 {
			x += v.x;
			y += v.y;
			z += v.z;
			return this;
		}

		/**
		 * 
		 * @param k
		 * @param v
		 * @return 
		 */
		public function vAddScaled(k:Number, v:Vector3):Vector3 {
			x += k*v.x;
			y += k*v.y;
			z += k*v.z;
			return this;
		}

		/**
		 * Вычитание координат.
		 * 
		 * @param v точка, координаты которой вычитаются из собственных
		 */		
		public function vSubtract(v:Vector3):Vector3 {
			x -= v.x;
			y -= v.y;
			z -= v.z;
			return this;
		}
		
		/**
		 * Вычисляет сумму векторов.
		 * 
		 * @param a уменьшаемый вектор
		 * @param b вычитаемый вектор
		 * @return this
		 */
		public function vSum(a:Vector3, b:Vector3):Vector3 {
			x = a.x + b.x;
			y = a.y + b.y;
			z = a.z + b.z;
			return this;
		}

		/**
		 * Вычисление разности векторов.
		 * 
		 * @param a уменьшаемый вектор
		 * @param b вычитаемый вектор
		 */
		public function vDiff(a:Vector3, b:Vector3):Vector3 {
			x = a.x - b.x;
			y = a.y - b.y;
			z = a.z - b.z;
			return this;
		}
		
		/**
		 * Умножение на скаляр.
		 * 
		 * @param k число, на которое умножаются координаты
		 */
		public function vScale(k:Number):Vector3 {
			x *= k;
			y *= k;
			z *= k;
			return this;
		}

		/**
		 * Инвертирование вектора.
		 */
		public function vReverse():Vector3 {
			x = -x;
			y = -y;
			z = -z;
			return this;
		}
		
		/**
		 * 
		 * @param v
		 * @return 
		 */
		public function vDot(v:Vector3):Number {
			return x*v.x + y*v.y + z*v.z;
		}
		
		/**
		 * Вычисляет векторное произведение с заданным вектором и записывает результат в текущий вектор.
		 *  
		 * @param v
		 */
		public function vCross(v:Vector3):Vector3 {
			var xx:Number = y*v.z - z*v.y;
			var yy:Number = z*v.x - x*v.z;
			var zz:Number = x*v.y - y*v.x;
			x = xx;
			y = yy;
			z = zz;
			return this;
		}

		/**
		 * Вычисляет векторное произведение с заданным вектором и записывает результат в текущий вектор.
		 *  
		 * @param v
		 */
		public function vCross2(a:Vector3, b:Vector3):Vector3 {
			x = a.y*b.z - a.z*b.y;
			y = a.z*b.x - a.x*b.z;
			z = a.x*b.y - a.y*b.x;
			return this;
		}
		
		/**
		 * Трансформация точки (вектора). Новым значением координат становится результат умножения матрицы на вектор вида
		 * <code>M &times; r</code>.
		 * 
		 * @param m матрица трансформации
		 */
		public function vTransformBy3(m:Matrix3):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz;
			y = m.e*xx + m.f*yy + m.g*zz;
			z = m.i*xx + m.j*yy + m.k*zz;
			return this;
		}
		
		/**
		 * 
		 * @param matrix
		 */
		public function vTransformBy3Tr(m:Matrix3):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.e*yy + m.i*zz;
			y = m.b*xx + m.f*yy + m.j*zz;
			z = m.c*xx + m.g*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Трансформация точки (вектора). Новым значением координат становится результат умножения матрицы на вектор вида
		 * <code>M &times; r</code>.
		 * 
		 * @param m матрица трансформации
		 */
		public function vTransformBy4(m:Matrix4):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz + m.d;
			y = m.e*xx + m.f*yy + m.g*zz + m.h;
			z = m.i*xx + m.j*yy + m.k*zz + m.l;
			return this;
		}
		
		/**
		 * 
		 * @param m
		 * @return 
		 */
		public function vTransformInverseBy4(m:Matrix4):Vector3 {
			var xx:Number = x - m.d;
			var yy:Number = y - m.h;
			var zz:Number = z - m.l;
			x = m.a*xx + m.e*yy + m.i*zz;
			y = m.b*xx + m.f*yy + m.j*zz;
			z = m.c*xx + m.g*yy + m.k*zz;
			return this;
		}
		
		/**
		 * 
		 * @param m
		 */
		public function vDeltaTransformBy4(m:Matrix4):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz;
			y = m.e*xx + m.f*yy + m.g*zz;
			z = m.i*xx + m.j*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Установка координат.
		 */
		public function vReset(x:Number = 0, y:Number = 0, z:Number = 0):Vector3 {
			this.x = x;
			this.y = y;
			this.z = z;
			return this;
		}

		/**
		 * Копирование координат точки.
		 * 
		 * @param v точка, координаты которой копируются
		 */
		public function vCopy(v:Vector3):Vector3 {
			x = v.x;
			y = v.y;
			z = v.z;
			return this;
		}
		
		/**
		 * Клонирование точки.
		 *  
		 * @return клонированная точка
		 */		
		public function vClone():Vector3 {
			return new Vector3(x, y, z);
		}
		
		/**
		 * Копирует координаты вектора в экземпляр класса Vector3D.
		 * 
		 * @param result экземпляр, в который копируются координаты
		 * @return переданный параметр
		 */
		public function toVector3D(result:Vector3D):Vector3D {
			result.x = x;
			result.y = y;
			result.z = z;
			return result;
		}
		
		/**
		 * @param source
		 * @return 
		 */
		public function copyFromVector3D(source:Vector3D):Vector3 {
			x = source.x;
			y = source.y;
			z = source.z;
			return this;
		}
		
		override public function toString():String {
			return "Vector3(" + x + "," + y + ", " + z + ")";
		}

	}
}