package alternativa.physics.collision.primitives {
	
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.ICollisionPredicate;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;
	
	use namespace altphysics;
	
	/**
	 * Базовый класс для примитивов, использующихся детектором столкновений. 
	 */
	public class CollisionPrimitive {
		// Константы типов примитива
		public static const BOX:int = 1;
		public static const PLANE:int = 2;
		public static const SPHERE:int = 3;
		public static const RECT:int = 4;
		public static const TRIANGLE:int = 5;
		
		// Тип примитива
		public var type:int;
		// Группы примитива. Каждая группа определяется установленным битом. Столкновения проверяются только для примитивов,
		// имеющих хотя бы одну общую группу.
		public var collisionGroup:int;
		// Предикат примитива, вызывающийся детектором при нахождении столкновения. В зависимости от возвращённого
		// предикатом результата столкновение либо регистрируется, либо игнорируется. Nullable.
		public var postCollisionPredicate:ICollisionPredicate;

		// Тело, владеющее примитивом. Может быть null.
		altphysics var body:Body;
		// Трансформация примитива в системе координат тела, если оно указано. Не допускается масштабирование матрицы.
		altphysics var localTransform:Matrix4 = new Matrix4();
		// Полная трансформация примитива. Не допускается масштабирование матрицы.
		altphysics var transform:Matrix4 = new Matrix4();
		// AABB в мировой системе координат. Расчитывается системой вызовом функции calculateBoundBox().
		altphysics var aabb:BoundBox = new BoundBox();
		
		/**
		 * Создаёт новый экземпляр примитива.
		 * 
		 * @param type тип примитива
		 * @param collisionGroup группа примитива
		 */
		public function CollisionPrimitive(type:int, collisionGroup:int) {
			this.type = type;
			this.collisionGroup = collisionGroup;
		}
		
		/**
		 * Устанавливает тело, владеющее примитивом.
		 * 
		 * @param body тело, к которому относится примитив. Если указано значение null, матрица локальной трансформации удаляется.
		 * @param localTransform трансформация примитива в системе координат тела. Указание значения null равносильно
		 *   заданию единичной матрицы.
		 */
		public function setBody(body:Body, localTransform:Matrix4 = null):void {
			if (this.body == body) return;
			this.body = body;
			if (body == null) this.localTransform = null;
			else {
				if (this.localTransform == null) this.localTransform = new Matrix4();
				if (localTransform != null) this.localTransform.copy(localTransform);
			}
		}
		
		/**
		 * Наследники должны переопределять этот метод, реализуя в нём корректный расчёт ограничивающего бокса, выравненного
		 * по осям мировой системы координат.
		 * 
		 * @return ссылка на свой баунд бокс
		 */
		public function calculateAABB():BoundBox {
			return aabb;
		}
		
		/**
		 * Клонирует примитив. Переопределять не рекомендуется. Вместо этого переопределяются методы createPrimitive() и copyFrom().
		 * 
		 * @return клон примитива
		 */
		public function clone():CollisionPrimitive {
			var p:CollisionPrimitive = createPrimitive();
			return p.copyFrom(this);
		}
		
		/**
		 * Копирует параметры указанного примитива. Объекты копируются по значению.
		 * 
		 * @param source примитив, чьи параметры копируются
		 * @return this
		 */
		public function copyFrom(source:CollisionPrimitive):CollisionPrimitive {
			type = source.type;
			transform.copy(source.transform);
			collisionGroup = source.collisionGroup;
			setBody(source.body, source.localTransform);
			aabb.copyFrom(source.aabb);
			return this;
		}
		
		/**
		 * Создаёт новый экземпляр примитива соотвествующего типа.
		 * 
		 * @return новый экземпляр примитива
		 */
		protected function createPrimitive():CollisionPrimitive {
			return new CollisionPrimitive(type, collisionGroup);
		}

		/**
		 * Метод должен вычислять параметры пересечения заданного сегмента с примитивом.
		 * 
		 * @param origin начальная точка сегмента в мировых координатах 
		 * @param vector вектор сегмента в мировых координатах 
		 * @param threshold погрешность измерения расстояния. Величина, не превышающая по абсолютному значению указанную
		 * 		погрешность, считается равной нулю.
		 * @param normal возвращаемое значение. Нормаль к примитиву в точке пересечения с сегментом.
		 * @return в случае наличия пересечения возвращается время точки пересечения, в противном случае возвращается -1.
		 */
		public function getSegmentIntersection(origin:Vector3, vector:Vector3, threshold:Number, normal:Vector3):Number {
			return -1;
		}
		
	}
}