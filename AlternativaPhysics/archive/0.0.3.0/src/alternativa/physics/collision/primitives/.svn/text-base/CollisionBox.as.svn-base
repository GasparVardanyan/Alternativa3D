package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;
	
	/**
	 * Ориентированный бокс.
	 */
	public class CollisionBox extends CollisionPrimitive {
		
		// Половинные размеры вдоль каждой из осей
		public var hs:Vector3 = new Vector3();
		
		// Используются в определении пересечения с лучом
		private static var _o:Vector3 = new Vector3();
		private static var _v:Vector3 = new Vector3();

		/**
		 * @param hs
		 * @param collisionGroup
		 */
		public function CollisionBox(hs:Vector3, collisionGroup:int) {
			super(BOX, collisionGroup);
			this.hs.vCopy(hs);
		}

		/**
		 * @return 
		 */
		override public function calculateAABB():BoundBox {
			var t:Matrix4 = transform;
			aabb.maxX = hs.x*(t.a < 0 ? -t.a : t.a) + hs.y*(t.b < 0 ? -t.b : t.b) + hs.z*(t.c < 0 ? -t.c : t.c);
			aabb.minX = -aabb.maxX;

			aabb.maxY = hs.x*(t.e < 0 ? -t.e : t.e) + hs.y*(t.f < 0 ? -t.f : t.f) + hs.z*(t.g < 0 ? -t.g : t.g);
			aabb.minY = -aabb.maxY;

			aabb.maxZ = hs.x*(t.i < 0 ? -t.i : t.i) + hs.y*(t.j < 0 ? -t.j : t.j) + hs.z*(t.k < 0 ? -t.k : t.k);
			aabb.minZ = -aabb.maxZ;
			
			aabb.minX += t.d;
			aabb.maxX += t.d;

			aabb.minY += t.h;
			aabb.maxY += t.h;

			aabb.minZ += t.l;
			aabb.maxZ += t.l;
			
			return aabb;
		}
		
		/**
		 * @param source
		 * @return 
		 */
		override public function copyFrom(source:CollisionPrimitive):CollisionPrimitive {
			var box:CollisionBox = source as CollisionBox;
			if (box == null) return this;
			super.copyFrom(box);
			hs.vCopy(box.hs);
			return this;
		}
		
		/**
		 * @return 
		 */
		override protected function createPrimitive():CollisionPrimitive {
			return new CollisionBox(hs, collisionGroup);
		}
	
		/**
		 * Вычисляет параметры пересечения заданного сегмента с примитивом.
		 * 
		 * @param origin начальная точка сегмента в мировых координатах 
		 * @param vector вектор сегмента в мировых координатах 
		 * @param threshold погрешность измерения расстояния. Величина, не превышающая по абсолютному значению указанную
		 * 		погрешность, считается равной нулю.
		 * @param normal возвращаемое значение. Нормаль к примитиву в точке пересечения с сегментом.
		 * @return в случае наличия пересечения возвращается время точки пересечения, в противном случае возвращается -1.
		 */
		override public function getSegmentIntersection(origin:Vector3, vector:Vector3, threshold:Number, normal:Vector3):Number {
			var tMin:Number = -1, tMax:Number = 1e308, t1:Number, t2:Number;
			// Перевод параметров сегмента в систему координат примитива
			// Inlined transform.transformVectorInverse(origin, _o);
			var xx:Number = origin.x - transform.d;
			var yy:Number = origin.y - transform.h;
			var zz:Number = origin.z - transform.l;
			_o.x = transform.a*xx + transform.e*yy + transform.i*zz;
			_o.y = transform.b*xx + transform.f*yy + transform.j*zz;
			_o.z = transform.c*xx + transform.g*yy + transform.k*zz;
			// Inlined transform.deltaTransformVectorInverse(vector, _v);
			_v.x = transform.a*vector.x + transform.e*vector.y + transform.i*vector.z;
			_v.y = transform.b*vector.x + transform.f*vector.y + transform.j*vector.z;
			_v.z = transform.c*vector.x + transform.g*vector.y + transform.k*vector.z;
			// X
			if (_v.x < threshold && _v.x > -threshold) {
				if (_o.x < -hs.x || _o.x > hs.x) return -1;
			} else {
				t1 = (-hs.x - _o.x)/_v.x;
				t2 = (hs.x - _o.x)/_v.x;
				if (t1 < t2) {
					if (t1 > tMin) {
						tMin = t1;
						normal.x = -1;
						normal.y = normal.z = 0;
					}
					if (t2 < tMax) tMax = t2;
				} else {
					if (t2 > tMin) {
						tMin = t2;
						normal.x = 1;
						normal.y = normal.z = 0;
					}
					if (t1 < tMax) tMax = t1;
				}
				if (tMax < tMin) return -1;
			}
			// Y
			if (_v.y < threshold && _v.y > -threshold) {
				if (_o.y < -hs.y || _o.y > hs.y) return -1;
			} else {
				t1 = (-hs.y - _o.y)/_v.y;
				t2 = (hs.y - _o.y)/_v.y;
				if (t1 < t2) {
					if (t1 > tMin) {
						tMin = t1;
						normal.y = -1;
						normal.x = normal.z = 0;
					}
					if (t2 < tMax) tMax = t2;
				} else {
					if (t2 > tMin) {
						tMin = t2;						
						normal.y = 1;
						normal.x = normal.z = 0;
					}
					if (t1 < tMax) tMax = t1;
				}
				if (tMax < tMin) return -1;
			}
			// Z
			if (_v.z < threshold && _v.z > -threshold) {
				if (_o.z < -hs.z || _o.z > hs.z) return -1;
			} else {
				t1 = (-hs.z - _o.z)/_v.z;
				t2 = (hs.z - _o.z)/_v.z;
				if (t1 < t2) {
					if (t1 > tMin) {
						tMin = t1;
						normal.z = -1;
						normal.x = normal.y = 0;
					}
					if (t2 < tMax) tMax = t2;
				} else {
					if (t2 > tMin) {
						tMin = t2;
						normal.z = 1;
						normal.x = normal.y = 0;
					}
					if (t1 < tMax) tMax = t1;
				}
				if (tMax < tMin) return -1;
			}
			// Перевод нормали в мировую систему координат
			// Inlined normal.vDeltaTransformBy4(transform);
			xx = normal.x, yy = normal.y, zz = normal.z;
			normal.x = transform.a*xx + transform.b*yy + transform.c*zz;
			normal.y = transform.e*xx + transform.f*yy + transform.g*zz;
			normal.z = transform.i*xx + transform.j*yy + transform.k*zz;
			
			return tMin;
		}
		
	}
}