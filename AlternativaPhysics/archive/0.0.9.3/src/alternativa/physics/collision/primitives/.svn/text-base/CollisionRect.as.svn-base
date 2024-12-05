package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.math.Matrix4;
	import alternativa.math.Vector3;
	use namespace altphysics;
	
	/**
	 * Ориентированный прямоугольник. Задаётся половинами размеров вдоль осей X (ширина) и Y (длина) локальной системы
	 * координат примитива. Таким образом, прямоугольник лежит в плоскости XY, его стороны параллельны осям этой
	 * плоскости, а нормаль направлена вдоль локальной оси Z.
	 * 
	 * Прямоугольник может быть одно- или двусторонним. В случае одностороннего прямоугольника,
	 * столкновения с внутренней стороны не регистрируются.
	 */	
	public class CollisionRect extends CollisionPrimitive {
		// Половинные размеры прямоугольника вдоль осей X и Y. Нормаль направлена вдоль оси Z.
		public var hs:Vector3 = new Vector3();
		// Флаг указывает, является примитив одно- или двусторонним
		public var twoSided:Boolean = true;
		
		// Малое значение. Используется для указания фиктивной высоты примитива и в функции определения пересечения с сегментом.
		private static const EPSILON:Number = 0.005;

		/**
		 * Создаёт новый экземпляр примитива.
		 * 
		 * @param hs половинные размерв прямоугольника вдоль осей X и Y. Значение z игнорируется.
		 * @param collisionGroup группа примитива
		 */
		public function CollisionRect(hs:Vector3, collisionGroup:int) {
			super(RECT, collisionGroup);
			this.hs.vCopy(hs);
		}

		/**
		 * Расчитывает ограничивающий бокс прямоугольника. Для избежания проблем высота примитива принимается равной
		 * не нулю, а малому значению.
		 * 
		 * @return 
		 */
		override public function calculateAABB():BoundBox {
			// Баунд бокс прямоугольника имеет минимальную высоту, отличную от нуля во избежание проблем с построением kd-дерева
			var t:Matrix4 = transform;
			var xx:Number = t.a < 0 ? -t.a : t.a;
			var yy:Number = t.b < 0 ? -t.b : t.b;
			var zz:Number = t.c < 0 ? -t.c : t.c;
			aabb.maxX = hs.x*xx + hs.y*yy + EPSILON*zz;
			aabb.minX = -aabb.maxX;

			xx = t.e < 0 ? -t.e : t.e;
			yy = t.f < 0 ? -t.f : t.f;
			zz = t.g < 0 ? -t.g : t.g;
			aabb.maxY = hs.x*xx + hs.y*yy + EPSILON*zz;
			aabb.minY = -aabb.maxY;

			xx = t.i < 0 ? -t.i : t.i;
			yy = t.j < 0 ? -t.j : t.j;
			zz = t.k < 0 ? -t.k : t.k;
			aabb.maxZ = hs.x*xx + hs.y*yy + EPSILON*zz;
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
			var rect:CollisionRect = source as CollisionRect;
			if (rect == null) return this;
			super.copyFrom(rect);
			hs.vCopy(rect.hs);
			return this;
		}
		
		/**
		 * Создаёт строковое представление объекта.
		 * 
		 * @return строковое представление объекта
		 */
		override public function toString():String {
			return "[CollisionRect hs=" + hs + "]";
		}
		
		/**
		 * @return 
		 */
		override protected function createPrimitive():CollisionPrimitive {
			return new CollisionRect(hs, collisionGroup);
		}
	
		/**
		 * @param origin
		 * @param vector
		 * @param collisionGroup
		 * @param threshold
		 * @param normal
		 * @return 
		 */
		override public function getRayIntersection(origin:Vector3, vector:Vector3, threshold:Number, normal:Vector3):Number {
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
			
			// Проверка параллельности сегмента и плоскости примитива
			if (vz > -threshold && vz < threshold) return -1;
			var t:Number = -oz/vz;
			if (t < 0) return -1;
			// Проверка вхождения точки пересечения в прямоугольник
			ox += vx*t;
			oy += vy*t;
			oz = 0;
			if (ox < (-hs.x - threshold) || ox > (hs.x + threshold) || oy < (-hs.y - threshold) || oy > (hs.y + threshold)) return -1;

			normal.x = transform.c;
			normal.y = transform.g;
			normal.z = transform.k;
			return t;
		}
		
	}
}