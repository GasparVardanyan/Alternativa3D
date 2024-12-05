package alternativa.physics.collision.primitives {
	
	import alternativa.physics.collision.ICollisionPredicate;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;
	
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
		// предикатом результата столкновение либо регистрируется, либо игнорируется.
		// Nullable
		public var postCollisionPredicate:ICollisionPredicate;
		// Тело, владеющее примитивом. Поле сделано открытым для быстрого доступа на чтение. Установка значения должна выполняться вызовом метода setBody().
		// Nullable
		public var body:Body;
		// Трансформация примитива в системе координат тела, если оно указано. Не допускается масштабирование матрицы.
		public var localTransform:Matrix4;
		// Полная трансформация примитива. Не допускается масштабирование матрицы.
		public var transform:Matrix4 = new Matrix4();
		// AABB в мировой системе координат. Расчитывается системой вызовом функции calculateBoundBox().
		public var aabb:BoundBox = new BoundBox();
		
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
		 * @param body тело, которое владеет примитивом. Если указано значение null, матрица локальной трансформации удаляется.
		 * @param localTransform трансформация примитива в системе координат тела. Указание значения null равносильно
		 *   заданию единичной матрицы, однако в первом случае не будет дополнительного умножения матриц при вычислении полной трансформации примитива.
		 */
		public function setBody(body:Body, localTransform:Matrix4 = null):void {
			if (this.body == body) return;
			this.body = body;
			if (body == null) {
				this.localTransform = null;
			}	else {
				if (localTransform != null) {
					if (this.localTransform == null) {
						this.localTransform = new Matrix4();
					}
					this.localTransform.copy(localTransform);
				} else {
					this.localTransform = null;
				}
			}
		}
		
		/**
		 * Рассчитывает AABB примитива. Наследники должны переопределять этот метод, реализуя в нём корректный рассчёт.
		 * 
		 * @return ссылка на свой AABB
		 */
		public function calculateAABB():BoundBox {
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
		public function getRayIntersection(origin:Vector3, vector:Vector3, epsilon:Number, normal:Vector3):Number {
			return -1;
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
			if (source == null) {
				throw new ArgumentError("Parameter source cannot be null");
			}
			type = source.type;
			transform.copy(source.transform);
			collisionGroup = source.collisionGroup;
			setBody(source.body, source.localTransform);
			aabb.copyFrom(source.aabb);
			return this;
		}
		
		/**
		 * Создаёт строковое представление объекта.
		 * 
		 * @return строковое представление объекта
		 */
		public function toString():String {
			return "[CollisionPrimitive type=" + type + "]";
		}
		
		/**
		 * Создаёт новый экземпляр примитива соответствующего типа.
		 * 
		 * @return новый экземпляр примитива
		 */
		protected function createPrimitive():CollisionPrimitive {
			return new CollisionPrimitive(type, collisionGroup);
		}

	}
}