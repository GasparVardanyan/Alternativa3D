package alternativa.physics.collision.primitives {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;
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
		// Переменные используются в функции поиска пересечения с лучом
		private static var _o:Vector3 = new Vector3();
		private static var _v:Vector3 = new Vector3();

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
			aabb.maxX = hs.x*(t.a < 0 ? -t.a : t.a) + hs.y*(t.b < 0 ? -t.b : t.b) + EPSILON*(t.c < 0 ? -t.c : t.c);
			aabb.minX = -aabb.maxX;

			aabb.maxY = hs.x*(t.e < 0 ? -t.e : t.e) + hs.y*(t.f < 0 ? -t.f : t.f) + EPSILON*(t.g < 0 ? -t.g : t.g);
			aabb.minY = -aabb.maxY;

			aabb.maxZ = hs.x*(t.i < 0 ? -t.i : t.i) + hs.y*(t.j < 0 ? -t.j : t.j) + EPSILON*(t.k < 0 ? -t.k : t.k);
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
		override public function getSegmentIntersection(origin:Vector3, vector:Vector3, threshold:Number, normal:Vector3):Number {
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
			
			// Проверка параллельности сегмента и плоскости примитива
			if (_v.z > -threshold && _v.z < threshold) return -1;
			var t:Number = -_o.z/_v.z;
			if (t < 0) return -1;
			// Проверка вхождения точки пересечения в прямоугольник
			_o.x += _v.x*t;
			_o.y += _v.y*t;
			_o.z = 0;
			if (_o.x < (-hs.x - EPSILON) || _o.x > (hs.x + EPSILON) || _o.y < (-hs.y - EPSILON) || _o.y > (hs.y + EPSILON)) return -1;

			normal.x = transform.c;
			normal.y = transform.g;
			normal.z = transform.k;
			return t;
		}
	}
}