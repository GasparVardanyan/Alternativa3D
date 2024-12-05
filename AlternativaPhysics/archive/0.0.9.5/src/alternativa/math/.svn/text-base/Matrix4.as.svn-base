package alternativa.math {
	
	/**
	 * 
	 */
	public class Matrix4 {
		
		public static const IDENTITY:Matrix4 = new Matrix4();
		
		public var a:Number;
		public var b:Number;
		public var c:Number;
		public var d:Number;
		
		public var e:Number;
		public var f:Number;
		public var g:Number;
		public var h:Number;
		
		public var i:Number;
		public var j:Number;
		public var k:Number;
		public var l:Number;
		
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
		public function Matrix4(a:Number = 1, b:Number = 0, c:Number = 0, d:Number = 0, e:Number = 0, f:Number = 1, g:Number = 0, h:Number = 0, i:Number = 0, j:Number = 0, k:Number = 1, l:Number = 0) {
			this.a = a;
			this.b = b;
			this.c = c;
			this.d = d;

			this.e = e;
			this.f = f;
			this.g = g;
			this.h = h;

			this.i = i;
			this.j = j;
			this.k = k;
			this.l = l;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function toIdentity():Matrix4 {
			a = f =	k = 1;
			b = c = e = g = i =	j = d = h = l = 0;
			return this;
		}

		/**
		 * Преобразование матрицы в обратную.
		 */
		public function invert():Matrix4 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var dd:Number = d;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var hh:Number = h;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;
			var ll:Number = l;
			
			var det:Number = -cc*ff*ii + bb*gg*ii + cc*ee*jj - aa*gg*jj - bb*ee*kk + aa*ff*kk;

			a = (-gg*jj + ff*kk)/det;
			b = (cc*jj - bb*kk)/det;
			c = (-cc*ff + bb*gg)/det;
			d = (dd*gg*jj - cc*hh*jj - dd*ff*kk + bb*hh*kk + cc*ff*ll - bb*gg*ll)/det;
			e = (gg*ii - ee*kk)/det;
			f = (-cc*ii + aa*kk)/det;
			g = (cc*ee - aa*gg)/det;
			h = (cc*hh*ii - dd*gg*ii + dd*ee*kk - aa*hh*kk - cc*ee*ll + aa*gg*ll)/det;
			i = (-ff*ii + ee*jj)/det;
			j = (bb*ii - aa*jj)/det;
			k = (-bb*ee + aa*ff)/det;
			l = (dd*ff*ii - bb*hh*ii - dd*ee*jj + aa*hh*jj + bb*ee*ll - aa*ff*ll)/det;
			
			return this;
		}		

		/**
		 * Умножение на матрицу справа: M * this
		 *  
		 * @param m левый операнд умножения
		 */
		public function append(m:Matrix4):Matrix4 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var dd:Number = d;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var hh:Number = h;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;
			var ll:Number = l;

			a = m.a*aa + m.b*ee + m.c*ii;
			b = m.a*bb + m.b*ff + m.c*jj;
			c = m.a*cc + m.b*gg + m.c*kk;
			d = m.a*dd + m.b*hh + m.c*ll + m.d;
			e = m.e*aa + m.f*ee + m.g*ii;
			f = m.e*bb + m.f*ff + m.g*jj;
			g = m.e*cc + m.f*gg + m.g*kk;
			h = m.e*dd + m.f*hh + m.g*ll + m.h;
			i = m.i*aa + m.j*ee + m.k*ii;
			j = m.i*bb + m.j*ff + m.k*jj;
			k = m.i*cc + m.j*gg + m.k*kk;
			l = m.i*dd + m.j*hh + m.k*ll + m.l;
			
			return this;
		}

		/**
		 * Умножение на матрицу слева: this * M
		 * 
		 * @param matrix правый операнд умножения
		 */
		public function prepend(m:Matrix4):Matrix4 {
			var aa:Number = a;
			var bb:Number = b;
			var cc:Number = c;
			var dd:Number = d;
			var ee:Number = e;
			var ff:Number = f;
			var gg:Number = g;
			var hh:Number = h;
			var ii:Number = i;
			var jj:Number = j;
			var kk:Number = k;
			var ll:Number = l;

			a = aa*m.a + bb*m.e + cc*m.i;
			b = aa*m.b + bb*m.f + cc*m.j;
			c = aa*m.c + bb*m.g + cc*m.k;
			d = aa*m.d + bb*m.h + cc*m.l + dd;
			e = ee*m.a + ff*m.e + gg*m.i;
			f = ee*m.b + ff*m.f + gg*m.j;
			g = ee*m.c + ff*m.g + gg*m.k;
			h = ee*m.d + ff*m.h + gg*m.l + hh;
			i = ii*m.a + jj*m.e + kk*m.i;
			j = ii*m.b + jj*m.f + kk*m.j;
			k = ii*m.c + jj*m.g + kk*m.k;
			l = ii*m.d + jj*m.h + kk*m.l + ll;
			
			return this;
		}
		
		/**
		 * 
		 * @param m
		 */
		public function add(m:Matrix4):Matrix4 {
			a += m.a;
			b += m.b;
			c += m.c;
			d += m.d;
			e += m.e;
			f += m.f;
			g += m.g;
			h += m.h;
			i += m.i;
			j += m.j;
			k += m.k;
			l += m.l;
			
			return this;
		}

		/**
		 * 
		 * @param m
		 */
		public function subtract(m:Matrix4):Matrix4 {
			a -= m.a;
			b -= m.b;
			c -= m.c;
			d -= m.d;
			e -= m.e;
			f -= m.f;
			g -= m.g;
			h -= m.h;
			i -= m.i;
			j -= m.j;
			k -= m.k;
			l -= m.l;
			
			return this;
		}
		
		/**
		 * Трансформирует заданный вектор.
		 * 
		 * @param vin входной вектор
		 * @param vout вектор, в который записывается результат трансформации
		 */
		public function transformVector(vin:Vector3, vout:Vector3):void {
			vout.x = a*vin.x + b*vin.y + c*vin.z + d;
			vout.y = e*vin.x + f*vin.y + g*vin.z + h;
			vout.z = i*vin.x + j*vin.y + k*vin.z + l;
		}

		/**
		 * Выполняет обратную трансформацию заданного вектора. При этом подразумевается, что квадратная матрица содержит только вращения.
		 * 
		 * @param vin входной вектор
		 * @param vout вектор, в который записывается результат трансформации
		 */
		public function transformVectorInverse(vin:Vector3, vout:Vector3):void {
			var xx:Number = vin.x - d;
			var yy:Number = vin.y - h;
			var zz:Number = vin.z - l;
			vout.x = a*xx + e*yy + i*zz;
			vout.y = b*xx + f*yy + j*zz;
			vout.z = c*xx + g*yy + k*zz;
		}

		/**
		 * 
		 * @param arrin
		 * @param Vector3
		 * @param arrout
		 * @param Vector3
		 */
		public function transformVectors(arrin:Vector.<Vector3>, arrout:Vector.<Vector3>):void {
			var len:int = arrin.length;
			var vin:Vector3;
			var vout:Vector3;
			for (var idx:int = 0; idx < len; idx++) {
				vin = arrin[idx];
				vout = arrout[idx];
				vout.x = a*vin.x + b*vin.y + c*vin.z + d;
				vout.y = e*vin.x + f*vin.y + g*vin.z + h;
				vout.z = i*vin.x + j*vin.y + k*vin.z + l;
			}
		}

		/**
		 * 
		 * @param arrin
		 * @param Vector3
		 * @param arrout
		 * @param Vector3
		 * @param len
		 */
		public function transformVectorsN(arrin:Vector.<Vector3>, arrout:Vector.<Vector3>, len:int):void {
			var vin:Vector3;
			var vout:Vector3;
			for (var idx:int = 0; idx < len; idx++) {
				vin = arrin[idx];
				vout = arrout[idx];
				vout.x = a*vin.x + b*vin.y + c*vin.z + d;
				vout.y = e*vin.x + f*vin.y + g*vin.z + h;
				vout.z = i*vin.x + j*vin.y + k*vin.z + l;
			}
		}

		/**
		 * 
		 * @param arrin
		 * @param Vector3
		 * @param arrout
		 * @param Vector3
		 */
		public function transformVectorsInverse(arrin:Vector.<Vector3>, arrout:Vector.<Vector3>):void {
			var len:int = arrin.length;
			var vin:Vector3;
			var vout:Vector3;
			for (var idx:int = 0; idx < len; idx++) {
				vin = arrin[idx];
				vout = arrout[idx];
				var xx:Number = vin.x - d;
				var yy:Number = vin.y - h;
				var zz:Number = vin.z - l;
				vout.x = a*xx + e*yy + i*zz;
				vout.y = b*xx + f*yy + j*zz;
				vout.z = c*xx + g*yy + k*zz;
			}
		}

		/**
		 * 
		 * @param arrin
		 * @param Vector3
		 * @param arrout
		 * @param Vector3
		 */
		public function transformVectorsInverseN(arrin:Vector.<Vector3>, arrout:Vector.<Vector3>, len:int):void {
			var vin:Vector3;
			var vout:Vector3;
			for (var idx:int = 0; idx < len; idx++) {
				vin = arrin[idx];
				vout = arrout[idx];
				var xx:Number = vin.x - d;
				var yy:Number = vin.y - h;
				var zz:Number = vin.z - l;
				vout.x = a*xx + e*yy + i*zz;
				vout.y = b*xx + f*yy + j*zz;
				vout.z = c*xx + g*yy + k*zz;
			}
		}
		
		/**
		 * 
		 * @param i
		 * @param axis
		 */
		public function getAxis(idx:int, axis:Vector3):void {
			switch (idx) {
				case 0:
					axis.x = a;
					axis.y = e;
					axis.z = i;
					return;
				case 1:
					axis.x = b;
					axis.y = f;
					axis.z = j;
					return;
				case 2:
					axis.x = c;
					axis.y = g;
					axis.z = k;
					return;
				case 3:
					axis.x = d;
					axis.y = h;
					axis.z = l;
					return;
			}
		}

		/**
		 * Трансформирует заданный вектор без учёта смещения центра матрицы.
		 * 
		 * @param pin входной вектор
		 * @param pout вектор, в который записывается результат трансформации
		 */
		public function deltaTransformVector(vin:Vector3, vout:Vector3):void {
			vout.x = a*vin.x + b*vin.y + c*vin.z + d;
			vout.y = e*vin.x + f*vin.y + g*vin.z + h;
			vout.z = i*vin.x + j*vin.y + k*vin.z + l;
		}

		/**
		 * Трансформирует заданный вектор без учёта смещения центра матрицы.
		 * 
		 * @param pin входной вектор
		 * @param pout вектор, в который записывается результат трансформации
		 */
		public function deltaTransformVectorInverse(vin:Vector3, vout:Vector3):void {
			vout.x = a*vin.x + e*vin.y + i*vin.z;
			vout.y = b*vin.x + f*vin.y + j*vin.z;
			vout.z = c*vin.x + g*vin.y + k*vin.z;
		}

		/**
		 * Копирование значений указанной матрицы.
		 *  
		 * @param matrix матрица, значения которой копируются
		 */
		public function copy(m:Matrix4):Matrix4 {
			a = m.a;
			b = m.b;
			c = m.c;
			d = m.d;
			e = m.e;
			f = m.f;
			g = m.g;
			h = m.h;
			i = m.i;
			j = m.j;
			k = m.k;
			l = m.l;
			
			return this;
		}
		
		public function setFromMatrix3(m:Matrix3, offset:Vector3):Matrix4 {
			a = m.a;
			b = m.b;
			c = m.c;
			d = offset.x;
			e = m.e;
			f = m.f;
			g = m.g;
			h = offset.y;
			i = m.i;
			j = m.j;
			k = m.k;
			l = offset.z;
			
			return this;
		}
		
		public function setOrientationFromMatrix3(m:Matrix3):Matrix4 {
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

		public function setRotationMatrix(rx:Number, ry:Number, rz:Number):Matrix4 {
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

		public function setMatrix(x:Number, y:Number, z:Number, rx:Number, ry:Number, rz:Number):Matrix4 {
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
			d = x;

			e = sinZ*cosY;
			f = sinZsinY*sinX + cosZ*cosX;
			g = sinZsinY*cosX - cosZ*sinX;
			h = y;

			i = -sinY;
			j = cosY*sinX;
			k = cosY*cosX;
			l = z;

			return this;
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
		
		/**
		 * Устанавливает координаты матрицы.
		 * 
		 * @param pos
		 */
		public function setPosition(pos:Vector3):void {
			d = pos.x;
			h = pos.y;
			l = pos.z;
		}
		
		/**
		 * Клонирование матрицы.
		 * 
		 * @return клон матрицы
		 */
		public function clone():Matrix4 {
			return new Matrix4(a, b, c, d, e, f, g, h, i, j, k, l);
		}
		
		/**
		 * 
		 * @return 
		 */
		public function toString():String {
			return "[Matrix4 [" + a.toFixed(3) + " " + b.toFixed(3) + " " + c.toFixed(3) + " " + d.toFixed(3) + "] [" + e.toFixed(3) + " " + f.toFixed(3) + " " + g.toFixed(3) + " " + h.toFixed(3) + "] [" + i.toFixed(3) + " " + j.toFixed(3) + " " + k.toFixed(3) + " " + l.toFixed(3) + "]]";
		}

	}
}