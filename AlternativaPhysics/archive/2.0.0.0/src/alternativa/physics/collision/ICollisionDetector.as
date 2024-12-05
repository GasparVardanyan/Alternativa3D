package alternativa.physics.collision {
	import alternativa.physics.Contact;
	import alternativa.physics.collision.types.RayHit;
	import alternativa.math.Vector3;
	
	/**
	 * Интерфейс детектора столкновений.
	 */
	public interface ICollisionDetector {
		
		/**
		 * Получает все столкновения в текущей конфигурации физической геометрии.
		 * 
		 * @param contacts список контактов, в кторые будет записана информация о столкновении
		 * @return количество найденных столкновений
		 */
		function getAllContacts(contacts:Contact):Contact;

		/**
		 * Тестирует луч на пересечение с физической геометрией.  Подразумевается, что детектор содержит набор примитивов, для которых выполняется проверка.
		 * В случае наличия нескольких пересечений, метод должен возвращать ближайшее к началу луча пересечение.
		 *
		 * @param origin начальная точка луча в мировых координатах
		 * @param direction направляющий вектор луча в мировых координатах. Длина вектора должна быть отлична от нуля.
		 * @param collisionGroup идентификатор группы
		 * @param maxTime параметр, задающий длину проверяемого сегмента. Единица соответствует одной длине направлящего вектора.
		 * @param predicate предикат, применяемый к столкновениям
		 * @param result переменная для записи информации о столкновении в случае положительного теста. В случае отрицательного результата сохранность начальных данных в
		 *  переданной структуре не гарантируется. 
		 * @return true в случае наличия пересечения, иначе false
		 */
		function raycast(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayHit):Boolean;

		/**
		 * 
		 * @param origin
		 * @param direction
		 * @param collisionGroup
		 * @param maxTime
		 * @param predicate
		 * @param result
		 * @return 
		 */
		function raycastStatic(origin:Vector3, direction:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayHit):Boolean;

		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean;
		
		/**
		 * 
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean;
		
	}
}