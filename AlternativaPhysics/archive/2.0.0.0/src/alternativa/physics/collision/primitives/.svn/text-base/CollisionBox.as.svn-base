package alternativa.physics.collision.primitives {
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.math.Matrix4;
	import alternativa.math.Vector3;
	
	/**
	 * Ориентированный бокс.
	 */
	public class CollisionBox extends CollisionPrimitive {
		
		// Половинные размеры вдоль каждой из осей
		public var hs:Vector3 = new Vector3();
		
		public var excludedFaces:int;
		
		/**
		 * @param hs
		 * @param collisionGroup
		 */
		public function CollisionBox(hs:Vector3, collisionGroup:int) {
			super(BOX, collisionGroup);
			this.hs.copy(hs);
		}

		/**
		 * @return 
		 */
		override public function calculateAABB():BoundBox {
			var t:Matrix4 = transform;
			
			var xx:Number;
			var yy:Number;
			var zz:Number;
			
			xx = t.a < 0 ? -t.a : t.a;
			yy = t.b < 0 ? -t.b : t.b;
			zz = t.c < 0 ? -t.c : t.c;
			aabb.maxX = hs.x*xx + hs.y*yy + hs.z*zz;
			aabb.minX = -aabb.maxX;

			xx = t.e < 0 ? -t.e : t.e;
			yy = t.f < 0 ? -t.f : t.f;
			zz = t.g < 0 ? -t.g : t.g;
			aabb.maxY = hs.x*xx + hs.y*yy + hs.z*zz;
			aabb.minY = -aabb.maxY;

			xx = t.i < 0 ? -t.i : t.i;
			yy = t.j < 0 ? -t.j : t.j;
			zz = t.k < 0 ? -t.k : t.k;
			aabb.maxZ = hs.x*xx + hs.y*yy + hs.z*zz;
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
			hs.copy(box.hs);
			return this;
		}
		
		/**
		 * @return 
		 */
		override protected function createPrimitive():CollisionPrimitive {
			return new CollisionBox(hs, collisionGroup);
		}
	
		/**
		 * Вычисляет пересечение луча с примитивом.
		 * 
		 * @param origin начальная точка луча в мировых координатах 
		 * @param vector направляющий вектор луча в мировых координатах. Вектор может быть любой отличной от нуля длины.
		 * @param epsilon погрешность измерения расстояния. Величина, не превышающая по абсолютному значению указанную погрешность, считается равной нулю.
		 * @param normal если пересечение существует, в этот параметр записывается нормаль к примитиву в точке пересечения
		 * @return если пересечение существует, возвращается неотрицательное время точки пересечения, в противном случае возвращается -1.
		 */
		override public function raycast(origin:Vector3, vector:Vector3, epsilon:Number, normal:Vector3):Number {
			var tMin:Number = -1;
			var tMax:Number = 1e308;
			var t1:Number;
			var t2:Number;
			// Перевод параметров сегмента в систему координат примитива
			// Inlined transform.transformVectorInverse(origin, _o);
			var vx:Number = origin.x - transform.d;
			var vy:Number = origin.y - transform.h;
			var vz:Number = origin.z - transform.l;
			var ox:Number = transform.a*vx + transform.e*vy + transform.i*vz;
			var oy:Number = transform.b*vx + transform.f*vy + transform.j*vz;
			var oz:Number = transform.c*vx + transform.g*vy + transform.k*vz;
			// Inlined transform.deltaTransformVectorInverse(vector, _v);
			vx = transform.a*vector.x + transform.e*vector.y + transform.i*vector.z;
			vy = transform.b*vector.x + transform.f*vector.y + transform.j*vector.z;
			vz = transform.c*vector.x + transform.g*vector.y + transform.k*vector.z;
			// X
			if (vx < epsilon && vx > -epsilon) {
				if (ox < -hs.x || ox > hs.x) return -1;
			} else {
				t1 = (-hs.x - ox)/vx;
				t2 = (hs.x - ox)/vx;
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
			if (vy < epsilon && vy > -epsilon) {
				if (oy < -hs.y || oy > hs.y) return -1;
			} else {
				t1 = (-hs.y - oy)/vy;
				t2 = (hs.y - oy)/vy;
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
			if (vz < epsilon && vz > -epsilon) {
				if (oz < -hs.z || oz > hs.z) return -1;
			} else {
				t1 = (-hs.z - oz)/vz;
				t2 = (hs.z - oz)/vz;
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
			vx = normal.x;
			vy = normal.y;
			vz = normal.z;
			normal.x = transform.a*vx + transform.b*vy + transform.c*vz;
			normal.y = transform.e*vx + transform.f*vy + transform.g*vz;
			normal.z = transform.i*vx + transform.j*vy + transform.k*vz;
			
			return tMin;
		}
		
		/**
		 * Создаёт строковое представление объекта.
		 * 
		 * @return строковое представление объекта
		 */
		override public function toString():String {
			return "[CollisionBox hs=" + hs + "]";
		}
		
	}
}