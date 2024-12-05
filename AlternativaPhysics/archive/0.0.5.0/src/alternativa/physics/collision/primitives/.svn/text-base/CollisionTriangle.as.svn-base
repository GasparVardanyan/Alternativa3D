package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;
	
	/**
	 * Примитив треугольник.
	 */
	public class CollisionTriangle extends CollisionPrimitive {
		
		public var v0:Vector3 = new Vector3();
		public var v1:Vector3 = new Vector3();
		public var v2:Vector3 = new Vector3();
		
		public var e0:Vector3 = new Vector3();
		public var e1:Vector3 = new Vector3();
		public var e2:Vector3 = new Vector3();
		
		public var len0:Number;
		public var len1:Number;
		public var len2:Number;
		
		/**
		 * 
		 * @param v0
		 * @param v1
		 * @param v2
		 * @param collisionGroup
		 */
		public function CollisionTriangle(v0:Vector3, v1:Vector3, v2:Vector3, collisionGroup:int) {
			super(TRIANGLE, collisionGroup);
			initVertices(v0, v1, v2);
		}
		
		/**
		 * Рассчитывает AABB примитива.
		 * 
		 * @return ссылка на свой AABB
		 */
		override public function calculateAABB():BoundBox {
			var epsilon:Number = 0.005;
			var a:Number;
			var b:Number;
			var eps_c:Number = epsilon*transform.c;
			var eps_g:Number = epsilon*transform.g;
			var eps_k:Number = epsilon*transform.k;
			
			// Вершина 0
			// Ось X
			a = v0.x*transform.a + v0.y*transform.b;
			aabb.minX = aabb.maxX = a + eps_c;
			b = a - eps_c;
			if (b > aabb.maxX) aabb.maxX = b;
			else if (b < aabb.minX) aabb.minX = b;
			// Ось Y
			a = v0.x*transform.e + v0.y*transform.f;
			aabb.minY = aabb.maxY = a + eps_g;
			b = a - eps_g;
			if (b > aabb.maxY) aabb.maxY = b;
			else if (b < aabb.minY) aabb.minY = b;
			// Ось Z
			a = v0.x*transform.i + v0.y*transform.j;
			aabb.minZ = aabb.maxZ = a + eps_k;
			b = a - eps_k;
			if (b > aabb.maxZ) aabb.maxZ = b;
			else if (b < aabb.minZ) aabb.minZ = b;
			
			// Вершина 1
			// Ось X
			a = v1.x*transform.a + v1.y*transform.b;
			b = a + eps_c;
			if (b > aabb.maxX) aabb.maxX = b;
			else if (b < aabb.minX) aabb.minX = b;
			b = a - eps_c;
			if (b > aabb.maxX) aabb.maxX = b;
			else if (b < aabb.minX) aabb.minX = b;
			// Ось Y
			a = v1.x*transform.e + v1.y*transform.f;
			b = a + eps_g;
			if (b > aabb.maxY) aabb.maxY = b;
			else if (b < aabb.minY) aabb.minY = b;
			b = a - eps_g;
			if (b > aabb.maxY) aabb.maxY = b;
			else if (b < aabb.minY) aabb.minY = b;
			// Ось Z
			a = v1.x*transform.i + v1.y*transform.j;
			b = a + eps_k;
			if (b > aabb.maxZ) aabb.maxZ = b;
			else if (b < aabb.minZ) aabb.minZ = b;
			b = a - eps_k;
			if (b > aabb.maxZ) aabb.maxZ = b;
			else if (b < aabb.minZ) aabb.minZ = b;

			// Вершина 2
			// Ось X
			a = v2.x*transform.a + v2.y*transform.b;
			b = a + eps_c;
			if (b > aabb.maxX) aabb.maxX = b;
			else if (b < aabb.minX) aabb.minX = b;
			b = a - eps_c;
			if (b > aabb.maxX) aabb.maxX = b;
			else if (b < aabb.minX) aabb.minX = b;
			// Ось Y
			a = v2.x*transform.e + v2.y*transform.f;
			b = a + eps_g;
			if (b > aabb.maxY) aabb.maxY = b;
			else if (b < aabb.minY) aabb.minY = b;
			b = a - eps_g;
			if (b > aabb.maxY) aabb.maxY = b;
			else if (b < aabb.minY) aabb.minY = b;
			// Ось Z
			a = v2.x*transform.i + v2.y*transform.j;
			b = a + eps_k;
			if (b > aabb.maxZ) aabb.maxZ = b;
			else if (b < aabb.minZ) aabb.minZ = b;
			b = a - eps_k;
			if (b > aabb.maxZ) aabb.maxZ = b;
			else if (b < aabb.minZ) aabb.minZ = b;
			
			aabb.minX += transform.d;
			aabb.maxX += transform.d;

			aabb.minY += transform.h;
			aabb.maxY += transform.h;

			aabb.minZ += transform.l;
			aabb.maxZ += transform.l;
			
			return aabb;
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
		override public function getRayIntersection(origin:Vector3, vector:Vector3, epsilon:Number, normal:Vector3):Number {
			// Луч трансформируется в систему координат примитива, затем проверяется пересечение

			var vz:Number = vector.x*transform.c + vector.y*transform.g + vector.z*transform.k;
			// Если луч параллелен плоскости птимитива, то пересечения нет
			if (vz < epsilon && vz > -epsilon) return -1;

			var tx:Number = origin.x - transform.d;
			var ty:Number = origin.y - transform.h;
			var tz:Number = origin.z - transform.l;
			
			var oz:Number = tx*transform.c + ty*transform.g + tz*transform.k;
			var t:Number = -oz/vz;
			if (t < 0) return -1;
			
			var ox:Number = tx*transform.a + ty*transform.e + tz*transform.i;
			var oy:Number = tx*transform.b + ty*transform.f + tz*transform.j;
			
			tx = ox + t*(vector.x*transform.a + vector.y*transform.e + vector.z*transform.i);
			ty = oy + t*(vector.x*transform.b + vector.y*transform.f + vector.z*transform.j);
			tz = oz + t*vz;
			
			// Проверка вхождения точки в треугольник
			if ((e0.x*(ty - v0.y) - e0.y*(tx - v0.x) < 0) || (e1.x*(ty - v1.y) - e1.y*(tx - v1.x) < 0) || (e2.x*(ty - v2.y) - e2.y*(tx - v2.x) < 0)) return -1;
			
			// Запись нормали
			normal.x = transform.c;
			normal.y = transform.g;
			normal.z = transform.k;
			
			return t;
		}
		
		/**
		 * Копирует параметры указанного примитива. Объекты копируются по значению.
		 * 
		 * @param source примитив, чьи параметры копируются
		 * @return this
		 */
		override public function copyFrom(source:CollisionPrimitive):CollisionPrimitive {
			super.copyFrom(source);
			var tri:CollisionTriangle = source as CollisionTriangle;
			if (tri != null) {
				v0.vCopy(tri.v0);
				v1.vCopy(tri.v1);
				v2.vCopy(tri.v2);

				e0.vCopy(tri.e0);
				e1.vCopy(tri.e1);
				e2.vCopy(tri.e2);

				len0 = tri.len0;
				len1 = tri.len1;
				len2 = tri.len2;
			}
			return this;
		}

		/**
		 * Создаёт строковое представление объекта.
		 * 
		 * @return строковое представление объекта
		 */
		override public function toString():String {
			return "[CollisionTriangle v0=" + v0 + ", v1=" + v1 + ", v2=" + v2 + "]";
		}

		/**
		 * Создаёт новый экземпляр примитива соответствующего типа.
		 * 
		 * @return новый экземпляр примитива
		 */
		override protected function createPrimitive():CollisionPrimitive {
			return new CollisionTriangle(v0, v1, v2, collisionGroup);
		}
		
		/**
		 * 
		 * @param v0
		 * @param v1
		 * @param v2
		 */
		private function initVertices(v0:Vector3, v1:Vector3, v2:Vector3):void {
			this.v0.vCopy(v0);
			this.v1.vCopy(v1);
			this.v2.vCopy(v2);
			
			e0.vDiff(v1, v0);
			len0 = e0.vLength();
			e0.vNormalize();
			
			e1.vDiff(v2, v1);
			len1 = e1.vLength();
			e1.vNormalize();
			
			e2.vDiff(v0, v2);
			len2 = e2.vLength();
			e2.vNormalize();
		}
		
	}
}