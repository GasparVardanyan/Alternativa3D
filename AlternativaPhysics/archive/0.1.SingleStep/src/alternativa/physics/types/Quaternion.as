package alternativa.physics.types {
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Vector3;
	

	public class Quaternion {

		public var w:Number;
		public var x:Number;
		public var y:Number;
		public var z:Number;

		public static function multiply(q1:Quaternion, q2:Quaternion, result:Quaternion):void {
			result.w = q1.w*q2.w - q1.x*q2.x - q1.y*q2.y - q1.z*q2.z;
			result.x = q1.w*q2.x + q1.x*q2.w + q1.y*q2.z - q1.z*q2.y;
			result.y = q1.w*q2.y + q1.y*q2.w + q1.z*q2.x - q1.x*q2.z;
			result.z = q1.w*q2.z + q1.z*q2.w + q1.x*q2.y - q1.y*q2.x;
		}

		public static function createFromAxisAngle(axis:Vector3, angle:Number):Quaternion {
			var q:Quaternion = new Quaternion();
			q.setFromAxisAngle(axis, angle);
			return q;
		}

		public static function createFromAxisAngleComponents(x:Number, y:Number, z:Number, angle:Number):Quaternion {
			var q:Quaternion = new Quaternion();
			q.setFromAxisAngleComponents(x, y, z, angle);
			return q;
		}
		
		public function Quaternion(w:Number = 1, x:Number = 0, y:Number = 0, z:Number = 0) {
			this.w = w;
			this.x = x;
			this.y = y;
			this.z = z;
		}

		public function reset(w:Number = 1, x:Number = 0, y:Number = 0, z:Number = 0):Quaternion {
			this.w = w;
			this.x = x;
			this.y = y;
			this.z = z;
			return this;
		}

		public function normalize():Quaternion {
			var d:Number = w*w + x*x + y*y + z*z;
			if (d == 0) {
				w = 1;
			} else {
				d = 1/Math.sqrt(d);
				w *= d;
				x *= d;
				y *= d;
				z *= d;
			}
			return this;
		}

		/**
		 * Умножает на указанный кватернион слева: this * q
		 *  
		 * @param q множитель
		 */
		public function prepend(q:Quaternion):Quaternion {
			var ww:Number = w*q.w - x*q.x - y*q.y - z*q.z;
			var xx:Number = w*q.x + x*q.w + y*q.z - z*q.y;
			var yy:Number = w*q.y + y*q.w + z*q.x - x*q.z;
			var zz:Number = w*q.z + z*q.w + x*q.y - y*q.x;
			w = ww;
			x = xx;
			y = yy;
			z = zz;
			return this;
		}

		/**
		 * Умножает на указанный кватернион справа: q * this
		 *  
		 * @param q множитель
		 */
		public function append(q:Quaternion):Quaternion {
			var ww:Number = q.w*w - q.x*x - q.y*y - q.z*z;
			var xx:Number = q.w*x + q.x*w + q.y*z - q.z*y;
			var yy:Number = q.w*y + q.y*w + q.z*x - q.x*z;
			var zz:Number = q.w*z + q.z*w + q.x*y - q.y*x;
			w = ww;
			x = xx;
			y = yy;
			z = zz;
			return this;
		}

		/**
		 * 
		 * @param vector
		 */
		public function rotateByVector(v:Vector3):Quaternion {
			var ww:Number = -v.x*x - v.y*y - v.z*z;
			var xx:Number = v.x*w + v.y*z - v.z*y;
			var yy:Number = v.y*w + v.z*x - v.x*z;
			var zz:Number = v.z*w + v.x*y - v.y*x;
			w = ww;
			x = xx;
			y = yy;
			z = zz;
			return this;
		}

		/**
		 * Добавляет вращение, приданное вектором угловой скорости за указанное время.
		 * 
		 * @param v
		 * @param scale
		 */
		public function addScaledVector(v:Vector3, scale:Number):Quaternion {
			var vx:Number = v.x*scale;
			var vy:Number = v.y*scale;
			var vz:Number = v.z*scale;
			var ww:Number = -x*vx - y*vy - z*vz;
			var xx:Number = vx*w + vy*z - vz*y;
			var yy:Number = vy*w + vz*x - vx*z;
			var zz:Number = vz*w + vx*y - vy*x;
			w += 0.5*ww;
			x += 0.5*xx;
			y += 0.5*yy;
			z += 0.5*zz;
			// inlined normalize
			var d:Number = w*w + x*x + y*y + z*z;
			if (d == 0) {
				w = 1;
			} else {
				d = 1/Math.sqrt(d);
				w *= d;
				x *= d;
				y *= d;
				z *= d;
			}
			return this;
		}
		
		/**
		 * 
		 * @param m
		 * @return 
		 */
		public function toMatrix3(m:Matrix3):Quaternion {
			var qi2:Number = 2*x*x;
			var qj2:Number = 2*y*y;
			var qk2:Number = 2*z*z;
			var qij:Number = 2*x*y;
			var qjk:Number = 2*y*z;
			var qki:Number = 2*z*x;
			var qri:Number = 2*w*x;
			var qrj:Number = 2*w*y;
			var qrk:Number = 2*w*z;
			
			m.a = 1 - qj2 - qk2;
			m.b = qij - qrk;
			m.c = qki + qrj;
			
			m.e = qij + qrk;
			m.f = 1 - qi2 - qk2;
			m.g = qjk - qri;
			
			m.i = qki - qrj;
			m.j = qjk + qri;
			m.k = 1 - qi2 - qj2;
			return this;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function length():Number {
			return Math.sqrt(w*w + x*x + y*y + z*z);
		}

		/**
		 * 
		 * @return 
		 */
		public function lengthSqr():Number {
			return w*w + x*x + y*y + z*z;
		}
		
		/**
		 * 
		 * @param axis
		 * @param angle
		 * @return 
		 */		
		public function setFromAxisAngle(axis:Vector3, angle:Number):Quaternion {
			w = Math.cos(0.5*angle);
			var k:Number = Math.sin(0.5*angle)/Math.sqrt(axis.x*axis.x + axis.y*axis.y + axis.z*axis.z);
			x = axis.x*k;
			y = axis.y*k;
			z = axis.z*k;
			return this;
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 * @param angle
		 */
		public function setFromAxisAngleComponents(x:Number, y:Number, z:Number, angle:Number):Quaternion {
			w = Math.cos(0.5*angle);
			var k:Number = Math.sin(0.5*angle)/Math.sqrt(x*x + y*y + z*z);
			this.x = x*k;
			this.y = y*k;
			this.z = z*k;
			return this;
		}
		
		/**
		 * 
		 * @param vector
		 */
		public function toAxisVector(v:Vector3 = null):Vector3 {
			if (w < -1 || w > 1) {
				normalize();
			}
			if (v == null) {
				v = new Vector3();
			}
			if (w > -1 && w < 1) {
				if (w == 0) {
					v.x = x;
					v.y = y;
					v.z = z;
				} else {
					var angle:Number = 2*Math.acos(w);
					var coeff:Number = 1/Math.sqrt(1 - w*w);
					v.x = x*coeff*angle;
					v.y = y*coeff*angle;
					v.z = z*coeff*angle;
				}
			} else {
				v.x = 0;
				v.y = 0;
				v.z = 0;
			}
			return v;
		}
		
		/**
		 * 
		 * @param rotations
		 */
		public function getEulerAngles(angles:Vector3):Vector3 {
			var qi2:Number = 2*x*x;
			var qj2:Number = 2*y*y;
			var qk2:Number = 2*z*z;
			var qij:Number = 2*x*y;
			var qjk:Number = 2*y*z;
			var qki:Number = 2*z*x;
			var qri:Number = 2*w*x;
			var qrj:Number = 2*w*y;
			var qrk:Number = 2*w*z;

			var aa:Number = 1 - qj2 - qk2;
			var bb:Number = qij - qrk;
			var ee:Number = qij + qrk;
			var ff:Number = 1 - qi2 - qk2;
			var ii:Number = qki - qrj;
			var jj:Number = qjk + qri;
			var kk:Number = 1 - qi2 - qj2;

			if (-1 < ii && ii < 1) {
				if (angles == null) {
					angles = new Vector3(Math.atan2(jj, kk), -Math.asin(ii), Math.atan2(ee, aa)); 
				} else {
					angles.x = Math.atan2(jj, kk);
					angles.y = -Math.asin(ii);
					angles.z = Math.atan2(ee, aa);
				}
			} else {
				if (angles == null) {
					angles = new Vector3(0, 0.5*((ii <= -1) ? Math.PI : -Math.PI), Math.atan2(-bb, ff)); 
				} else {
					angles.x = 0;
					angles.y = 0.5*((ii <= -1) ? Math.PI : -Math.PI);
					angles.z = Math.atan2(-bb, ff);
				}
			}
			return angles;
		}
		
		/**
		 * 
		 */
		public function conjugate():void {
			x = -x;
			y = -y;
			z = -z;
		}

		/**
		 * Выполняет линейную интерполяцию.
		 * 
		 * @param q1 начало отрезка
		 * @param q2 конец отрезка
		 * @param t время, обычно задаётся в интервале [0, 1]
		 */
		public function nlerp(q1:Quaternion, q2:Quaternion, t:Number):Quaternion {
			var d:Number = 1 - t;
			w = q1.w*d + q2.w*t;
			x = q1.x*d + q2.x*t;
			y = q1.y*d + q2.y*t;
			z = q1.z*d + q2.z*t;
			// inlined normalize
			d = w*w + x*x + y*y + z*z;
			if (d == 0) {
				w = 1;
			} else {
				d = 1/Math.sqrt(d);
				w *= d;
				x *= d;
				y *= d;
				z *= d;
			}
			return this;
		}
		
		/**
		 * 
		 * @param q
		 * @return 
		 */
		public function subtract(q:Quaternion):Quaternion {
			w -= q.w;
			x -= q.x;
			y -= q.y;
			z -= q.z;
			return this;
		}

		/**
		 * 
		 * @param q1
		 * @param q2
		 * @return 
		 */
		public function diff(q1:Quaternion, q2:Quaternion):Quaternion {
			w = q2.w - q1.w;
			x = q2.x - q1.x;
			y = q2.y - q1.y;
			z = q2.z - q1.z;
			return this;
		}

		/**
		 * 
		 * @param q
		 * @return 
		 */
		public function copy(q:Quaternion):Quaternion {
			w = q.w;
			x = q.x;
			y = q.y;
			z = q.z;
			return this;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function clone():Quaternion {
			return new Quaternion(w, x, y, z);
		}

		/**
		 * 
		 * @return 
		 */
		public function toString():String {
			return "[" + w + ", " + x + ", " + y + ", " + z + "]";
		}
	}
}
