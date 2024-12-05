package alternativa.math {
	import flash.geom.Vector3D;
	
	/**
	 * 
	 */
	public class Matrix3 {
		
		public static const ZERO:Matrix3 = new Matrix3(0, 0, 0, 0, 0, 0, 0, 0, 0);
		public static const IDENTITY:Matrix3 = new Matrix3();
		
		public var a:Number;
		public var b:Number;
		public var c:Number;
		
		public var e:Number;
		public var f:Number;
		public var g:Number;
		
		public var i:Number;
		public var j:Number;
		public var k:Number;
		
		/**
		 * 
		 * @param a
		 * @param b
		 * @param c
		 * @param e
		 * @param f
		 * @param g
		 * @param i
		 * @param j
		 * @param k
		 */
		public function Matrix3(a:Number = 1, b:Number = 0, c:Number = 0, e:Number = 0, f:Number = 1, g:Number = 0, i:Number = 0, j:Number = 0, k:Number = 1) {
			this.a = a;
			this.b = b;
			this.c = c;

			this.e = e;
			this.f = f;
			this.g = g;

			this.i = i;
			this.j = j;
			this.k = k;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function toIdentity():Matrix3 {
			a = f =	k = 1;
			b = c = e = g = i =	j = 0;
			return this;
		}

		/**
		 * Преобразование матрицы в обратную.
		 */
		public function invert():Matrix3 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;
			
			var det:Number = 1/(-cc*ff*ii + bb*gg*ii + cc*ee*jj - aa*gg*jj - bb*ee*kk + aa*ff*kk);

			a = (ff*kk - gg*jj)*det;
			b = (cc*jj - bb*kk)*det;
			c = (bb*gg - cc*ff)*det;
			e = (gg*ii - ee*kk)*det;
			f = (aa*kk - cc*ii)*det;
			g = (cc*ee - aa*gg)*det;
			i = (ee*jj - ff*ii)*det;
			j = (bb*ii - aa*jj)*det;
			k = (aa*ff - bb*ee)*det;
			
			return this;
		}		

		/**
		 * Умножение на матрицу справа: M * this
		 *  
		 * @param m левый операнд умножения
		 */
		public function append(m:Matrix3):Matrix3 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;

			a = m.a*aa + m.b*ee + m.c*ii;
			b = m.a*bb + m.b*ff + m.c*jj;
			c = m.a*cc + m.b*gg + m.c*kk;
			e = m.e*aa + m.f*ee + m.g*ii;
			f = m.e*bb + m.f*ff + m.g*jj;
			g = m.e*cc + m.f*gg + m.g*kk;
			i = m.i*aa + m.j*ee + m.k*ii;
			j = m.i*bb + m.j*ff + m.k*jj;
			k = m.i*cc + m.j*gg + m.k*kk;
			
			return this;
		}

		/**
		 * Умножение на матрицу слева: this * M
		 * 
		 * @param matrix правый операнд умножения
		 */
		public function prepend(m:Matrix3):Matrix3 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;

			a = aa*m.a + bb*m.e + cc*m.i;
			b = aa*m.b + bb*m.f + cc*m.j;
			c = aa*m.c + bb*m.g + cc*m.k;
			e = ee*m.a + ff*m.e + gg*m.i;
			f = ee*m.b + ff*m.f + gg*m.j;
			g = ee*m.c + ff*m.g + gg*m.k;
			i = ii*m.a + jj*m.e + kk*m.i;
			j = ii*m.b + jj*m.f + kk*m.j;
			k = ii*m.c + jj*m.g + kk*m.k;
			
			return this;
		}

		/**
		 * Умножение на матрицу слева: this * M
		 * 
		 * @param matrix правый операнд умножения
		 */
		public function prependTransposed(m:Matrix3):Matrix3 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;

			a = aa*m.a + bb*m.b + cc*m.c;
			b = aa*m.e + bb*m.f + cc*m.g;
			c = aa*m.i + bb*m.j + cc*m.k;
			e = ee*m.a + ff*m.b + gg*m.c;
			f = ee*m.e + ff*m.f + gg*m.g;
			g = ee*m.i + ff*m.j + gg*m.k;
			i = ii*m.a + jj*m.b + kk*m.c;
			j = ii*m.e + jj*m.f + kk*m.g;
			k = ii*m.i + jj*m.j + kk*m.k;
			
			return this;
		}
		
		/**
		 * 
		 * @param m
		 */
		public function add(m:Matrix3):Matrix3 {
			a += m.a;
			b += m.b;
			c += m.c;
			e += m.e;
			f += m.f;
			g += m.g;
			i += m.i;
			j += m.j;
			k += m.k;
			
			return this;
		}

		/**
		 * 
		 * @param m
		 */
		public function subtract(m:Matrix3):Matrix3 {
			a -= m.a;
			b -= m.b;
			c -= m.c;
			e -= m.e;
			f -= m.f;
			g -= m.g;
			i -= m.i;
			j -= m.j;
			k -= m.k;
			
			return this;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function transpose():Matrix3 {
			var tmp:Number = b;
			b = e;
			e = tmp;
			tmp = c;
			c = i;
			i = tmp;
			tmp = g;
			g = j;
			j = tmp;
			
			return this;
		}
		
		/**
		 * Трансформирует заданный вектор.
		 * 
		 * @param vin входной вектор
		 * @param vout вектор, в который записывается результат трансформации
		 */
		public function transformVector(vin:Vector3, vout:Vector3):void {
			vout.x = a*vin.x + b*vin.y + c*vin.z;
			vout.y = e*vin.x + f*vin.y + g*vin.z;
			vout.z = i*vin.x + j*vin.y + k*vin.z;
		}

		/**
		 * Выполняет обратную трансформацию заданного вектора. При этом подразумевается, что квадратная матрица содержит только вращения.
		 * 
		 * @param vin входной вектор
		 * @param vout вектор, в который записывается результат трансформации
		 */
		public function transformVectorInverse(vin:Vector3, vout:Vector3):void {
			vout.x = a*vin.x + e*vin.y + i*vin.z;
			vout.y = b*vin.x + f*vin.y + j*vin.z;
			vout.z = c*vin.x + g*vin.y + k*vin.z;
		}

		/**
		 * Трансформирует заданный вектор.
		 * 
		 * @param vin входной вектор
		 * @param vout вектор, в который записывается результат трансформации
		 */
		public function transformVector3To3D(vin:Vector3, vout:Vector3D):void {
			vout.x = a*vin.x + b*vin.y + c*vin.z;
			vout.y = e*vin.x + f*vin.y + g*vin.z;
			vout.z = i*vin.x + j*vin.y + k*vin.z;
		}
		
		/**
		 * 
		 * @param matrix
		 */
		public function createSkewSymmetric(v:Vector3):Matrix3 {
			a = f = k = 0;
			b = -v.z;
			c = v.y;
			e = v.z;
			g = -v.x;
			i = -v.y;
			j = v.x;
			return this;
		}

		/**
		 * Копирование значений указанной матрицы.
		 *  
		 * @param matrix матрица, значения которой копируются
		 */
		public function copy(m:Matrix3):Matrix3 {
			a = m.a;
			b = m.b;
			c = m.c;
			e = m.e;
			f = m.f;
			g = m.g;
			i = m.i;
			j = m.j;
			k = m.k;
			
			return this;
		}
		
		/**
		 * @return 
		 */
		public function setRotationMatrix(rx:Number, ry:Number, rz:Number):Matrix3 {
			var cosX:Number = Math.cos(rx);
			var sinX:Number = Math.sin(rx);
			var cosY:Number = Math.cos(ry);
			var sinY:Number = Math.sin(ry);
			var cosZ:Number = Math.cos(rz);
			var sinZ:Number = Math.sin(rz);

			var cosZsinY:Number = cosZ*sinY;
			var sinZsinY:Number = sinZ*sinY;
			
			a = cosZ*cosY;
			b = cosZsinY*sinX - sinZ*cosX;
			c = cosZsinY*cosX + sinZ*sinX;

			e = sinZ*cosY;
			f = sinZsinY*sinX + cosZ*cosX;
			g = sinZsinY*cosX - cosZ*sinX;
			
			i = -sinY;
			j = cosY*sinX;
			k = cosY*cosX;
			
			return this;
		}
	
		/**
		 * Метод формирует матрицу поворота на заданный угол относительно заданной оси. 
		 * 
		 * @param axis нормализованный вектор, задающий ось, относительно которой выполняется поворот
		 * @param angle угол поворота в радианах
		 */
		public function fromAxisAngle(axis:Vector3, angle:Number):void {
			var c1:Number = Math.cos(angle);
			var s:Number = Math.sin(angle);
			var t:Number = 1 - c1;
			var x:Number = axis.x;
			var y:Number = axis.y;
			var z:Number = axis.z;

			a = t*x*x + c1;
			b = t*x*y - z*s;
			c = t*x*z + y*s;
				 
			e = t*x*y + z*s;
			f = t*y*y + c1;
			g = t*y*z - x*s;

			i = t*x*z - y*s;
			j = t*y*z + x*s;
			k = t*z*z + c1;
		}
		
		/**
		 * Клонирование матрицы.
		 * 
		 * @return клон матрицы
		 */
		public function clone():Matrix3 {
			return new Matrix3(a, b, c, e, f, g, i, j, k);
		}
		
		/**
		 * 
		 * @return 
		 */
		public function toString():String {
			return "[Matrix3 (" + a + ", " + b + ", " + c + "), (" + e + ", " + f + ", " + g + "), (" + i + ", " + j + ", " + k + ")]";
		}

		/**
		 * @param angles
		 */
		public function getEulerAngles(angles:Vector3):void {
			if (-1 < i && i < 1) {
				angles.x = Math.atan2(j, k);
				angles.y = -Math.asin(i);
				angles.z = Math.atan2(e, a);
			} else {
				angles.x = 0;
				angles.y = (i <= -1) ? Math.PI : -Math.PI;
				angles.y *= 0.5;
				angles.z = Math.atan2(-b, f);
			}
		}

	}
}