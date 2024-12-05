package alternativa.physics.collision {
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.types.RayIntersection;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.types.Vector3;
	
	/**
	 * Интерфейс детектора столкновений.
	 */
	public interface ICollisionDetector {
		
		/**
		 * Добавляет физический примитив в коллайдер.
		 * 
		 * @param primitive добавляемый примитив
		 * @param isStatic указывает тип примитива: статический или динамический
		 * @return true если примитив был успешно добавлен, иначе false
		 */
		function addPrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true):Boolean;

		/**
		 * Удаляет физический примитив из коллайдера.
		 * 
		 * @param primitive удаляемый примитив
		 * @param isStatic указывает тип примитива: статический или динамический
		 * @return true если примитив был успшено удалён, иначе false
		 */
		function removePrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true):Boolean;
		
		/**
		 * Выполняет инициализацию детектора после обновления списка примитивов.
		 */
		function init():void;
		
		/**
		 * Получает все столкновения в текущей конфигурации физической геометрии.
		 * 
		 * @param contacts список контактов, в кторые будет записана информация о столкновении
		 * @return количество найденных столкновений
		 */
		function getAllCollisions(contacts:Vector.<Contact>):int;

		/**
		 * Тестирует луч на пересечение с физической геометрией.  Подразумевается, что детектор содержит набор примитивов, для которых выполняется проверка.
		 * В случае наличия нескольких пересечений, метод должен возвращать ближайшее к началу луча пересечение.
		 *
		 * @param origin начальная точка луча в мировых координатах
		 * @param dir направляющий вектор луча в мировых координатах. Длина вектора должна быть отлична от нуля.
		 * @param collisionGroup идентификатор группы
		 * @param maxTime параметр, задающий длину проверяемого сегмента. Единица соответствует одной длине направлящего вектора.
		 * @param predicate предикат, применяемый к столкновениям
		 * @param result переменная для записи информации о столкновении в случае положительного теста. В случае отрицательного результата сохранность начальных данных в
		 *  переданной структуре не гарантируется. 
		 * @return true в случае наличия пересечения, иначе false
		 */
		function intersectRay(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean;

		/**
		 * Тестирует луч на пересечение со статической физической геометрией.  Подразумевается, что детектор содержит набор примитивов, для которых выполняется проверка.
		 * В случае наличия нескольких пересечений, метод должен возвращать ближайшее к началу луча пересечение.
		 * 
		 * @param origin начальная точка луча в мировых координатах
		 * @param dir направляющий вектор луча в мировых координатах. Длина вектора должна быть отлична от нуля.
		 * @param collisionGroup идентификатор группы
		 * @param maxTime параметр, задающий длину проверяемого сегмента. Единица соответствует одной длине направлящего вектора.
		 * @param predicate предикат, применяемый к столкновениям
		 * @param result переменная для записи информации о столкновении в случае положительного теста. В случае отрицательного результата сохранность начальных данных в
		 *  переданной структуре не гарантируется. 
		 * @return true в случае наличия пересечения, иначе false
		 */
		function intersectRayWithStatic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean;
		
		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean;
		
		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean;
		
	}
}