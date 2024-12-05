package alternativa.math {
	import flash.geom.Vector3D;
	
	/**
	 * 
	 */
	public class Vector3 {
		
		public static const ZERO:Vector3 = new Vector3(0, 0, 0);
		public static const X_AXIS:Vector3 = new Vector3(1, 0, 0);
		public static const Y_AXIS:Vector3 = new Vector3(0, 1, 0);
		public static const Z_AXIS:Vector3 = new Vector3(0, 0, 1);

		public static const RIGHT:Vector3 = new Vector3(1, 0, 0);
		public static const LEFT:Vector3 = new Vector3(-1, 0, 0);

		public static const FORWARD:Vector3 = new Vector3(0, 1, 0);
		public static const BACK:Vector3 = new Vector3(0, -1, 0);

		public static const UP:Vector3 = new Vector3(0, 0, 1);
		public static const DOWN:Vector3 = new Vector3(0, 0, -1);

		public var x:Number;
		public var y:Number;
		public var z:Number;

		/**
		 * Создаёт новый экземпляр.
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
		 * Вычисляет длину вектора.
		 *
		 * @return длина вектора
		 */
		public function length():Number {
			return Math.sqrt(x*x + y*y + z*z);
		}

		/**
		 * Вычисляет квадрат длины вектора.
		 *
		 * @return квадрат длины вектора
		 */
		public function lengthSqr():Number {
			return x*x + y*y + z*z;
		}
		
		/**
		 * Устанавливает длину вектора.
		 * 
		 * @param length новая длина
		 * @return this
		 */
		public function setLength(length:Number):Vector3 {
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
		 * Нормализует вектор.
		 * 
		 * @return this
		 */
		public function normalize():Vector3 {
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
		 * Прибавляет вектор.
		 * 
		 * @param v прибавляемый вектор
		 * @return this
		 */		
		public function add(v:Vector3):Vector3 {
			x += v.x;
			y += v.y;
			z += v.z;
			return this;
		}

		/**
		 * Прибавляет вектор с домножением на скаляр.
		 *
		 * @param k множитель
		 * @param v вектор
		 * @return this
		 */
		public function addScaled(k:Number, v:Vector3):Vector3 {
			x += k*v.x;
			y += k*v.y;
			z += k*v.z;
			return this;
		}

		/**
		 * Вычитает вектор.
		 *
		 * @param v вычитаемый вектор
		 * @return this
		 */
		public function subtract(v:Vector3):Vector3 {
			x -= v.x;
			y -= v.y;
			z -= v.z;
			return this;
		}
		
		/**
		 * Вычисляет сумму векторов и сохраняет её в текущем векторе.
		 * 
		 * @param a уменьшаемый вектор
		 * @param b вычитаемый вектор
		 * @return this
		 */
		public function sum(a:Vector3, b:Vector3):Vector3 {
			x = a.x + b.x;
			y = a.y + b.y;
			z = a.z + b.z;
			return this;
		}

		/**
		 * Вычисляет разность векторов и сохраняет её в текущем векторе.
		 * 
		 * @param a уменьшаемый вектор
		 * @param b вычитаемый вектор
		 * @return this
		 */
		public function diff(a:Vector3, b:Vector3):Vector3 {
			x = a.x - b.x;
			y = a.y - b.y;
			z = a.z - b.z;
			return this;
		}
		
		/**
		 * Умножает вектор на скаляр.
		 * 
		 * @param k множитель
		 * @return this
		 */
		public function scale(k:Number):Vector3 {
			x *= k;
			y *= k;
			z *= k;
			return this;
		}

		/**
		 * Инвертирует вектор.
		 *
		 * @return this
		 */
		public function reverse():Vector3 {
			x = -x;
			y = -y;
			z = -z;
			return this;
		}
		
		/**
		 * Вычисляет скалярное произведение с вектором.
		 * 
		 * @param v вектор
		 * @return скалярное произведение с вектором
		 */
		public function dot(v:Vector3):Number {
			return x*v.x + y*v.y + z*v.z;
		}
		
		/**
		 * Вычисляет векторное произведение с вектором и записывает результат в текущий.
		 *  
		 * @param v вектор, на который умножается текущий
		 * @return this
		 */
		public function cross(v:Vector3):Vector3 {
			var xx:Number = y*v.z - z*v.y;
			var yy:Number = z*v.x - x*v.z;
			var zz:Number = x*v.y - y*v.x;
			x = xx;
			y = yy;
			z = zz;
			return this;
		}

		/**
		 * Вычисляет векторное произведение и записывает результат в текущий вектор.
		 *
		 * @param a первый вектор произведения
		 * @param b второй вектор произведения
		 * @return this
		 */
		public function cross2(a:Vector3, b:Vector3):Vector3 {
			x = a.y*b.z - a.z*b.y;
			y = a.z*b.x - a.x*b.z;
			z = a.x*b.y - a.y*b.x;
			return this;
		}
		
		/**
		 * Трансформирует вектор заданной матрицей 3x3.
		 * 
		 * @param m матрица трансформации
		 * @return this
		 */
		public function transform3(m:Matrix3):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz;
			y = m.e*xx + m.f*yy + m.g*zz;
			z = m.i*xx + m.j*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Трансформирует вектор транспонированной заданной матрицей. Если матрица ортогональна,
		 * операция эквивалентна трансформированию матрицей, обратной к заданной.
		 *
		 * @param m матрица трансформации
		 * @return this
		 */
		public function transformTransposed3(m:Matrix3):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.e*yy + m.i*zz;
			y = m.b*xx + m.f*yy + m.j*zz;
			z = m.c*xx + m.g*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Трансформирует координаты точки матрицей 4x3.
		 *
		 * @param m матрица трансформации
		 * @return this
		 */
		public function transform4(m:Matrix4):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz + m.d;
			y = m.e*xx + m.f*yy + m.g*zz + m.h;
			z = m.i*xx + m.j*yy + m.k*zz + m.l;
			return this;
		}
		
		/**
		 * Выполняет обратную трансформацию координат точки. Матрица должна быть ортогональной.
		 *
		 * @param m матрица прямой трансформации
		 * @return this
		 */
		public function transformTransposed4(m:Matrix4):Vector3 {
			var xx:Number = x - m.d;
			var yy:Number = y - m.h;
			var zz:Number = z - m.l;
			x = m.a*xx + m.e*yy + m.i*zz;
			y = m.b*xx + m.f*yy + m.j*zz;
			z = m.c*xx + m.g*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Трансформирует вектор (т.е. без учёта смещения матрицы).
		 * 
		 * @param m матрица трансформации
		 * @return this
		 */
		public function transformVector4(m:Matrix4):Vector3 {
			var xx:Number = x;
			var yy:Number = y;
			var zz:Number = z;
			x = m.a*xx + m.b*yy + m.c*zz;
			y = m.e*xx + m.f*yy + m.g*zz;
			z = m.i*xx + m.j*yy + m.k*zz;
			return this;
		}
		
		/**
		 * Установливает компоненты вектора.
		 *
		 * @return this
		 */
		public function reset(x:Number = 0, y:Number = 0, z:Number = 0):Vector3 {
			this.x = x;
			this.y = y;
			this.z = z;
			return this;
		}

		/**
		 * Копирует компоненты вектора.
		 * 
		 * @param v копируемый вектор
		 * @return this
		 */
		public function copy(v:Vector3):Vector3 {
			x = v.x;
			y = v.y;
			z = v.z;
			return this;
		}
		
		/**
		 * Клонирует вектор.
		 *  
		 * @return клонированный вектор
		 */		
		public function clone():Vector3 {
			return new Vector3(x, y, z);
		}
		
		/**
		 * Копирует компоненты вектора в экземпляр класса Vector3D.
		 * 
		 * @param result экземпляр, в который копируются компоненты
		 * @return переданный параметр
		 */
		public function toVector3D(result:Vector3D):Vector3D {
			result.x = x;
			result.y = y;
			result.z = z;
			return result;
		}
		
		/**
		 * Копирует компоненты вектора.
		 *
		 * @param source копируемый вектор
		 * @return this
		 */
		public function copyFromVector3D(source:Vector3D):Vector3 {
			x = source.x;
			y = source.y;
			z = source.z;
			return this;
		}

		/**
		 * Вычисляет расстояние до указанной точки.
		 *
		 * @param v точка
		 * @return расстояние до точки
		 */
		public function distanceTo(v:Vector3):Number {
			var dx:Number = x - v.x;
			var dy:Number = y - v.y;
			var dz:Number = z - v.z;
			return Math.sqrt(dx*dx + dy*dy + dz*dz);
		}

		/**
		 * Формирует строковое представление вектора.
		 *
		 * @return строковое представление вектора
		 */
		public function toString():String {
			return "Vector3(" + x + ", " + y + ", " + z + ")";
		}

	}
}