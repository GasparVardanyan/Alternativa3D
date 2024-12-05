package alternativa.physics.collision {
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.rigid.Contact;
	
	/**
	 * Интерфейс определителя столкновений между двумя примитивами.
	 */	
	public interface ICollider {
		
		/**
		 * Проверяет наличие пересечения примитивов. Если пересечение существует, заполняется информация о контакте.
		 * 
		 * @param prim1 первый примитив
		 * @param prim2 второй примитив
		 * @param contact переменная, в которую записывается информация о контакте, если пересечение существует
		 * @return true, если пересечение существует, иначе false
		 */
		function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean;
		
		/**
		 * Выполняет быстрый тест на наличие пересечения двух примитивов.
		 * 
		 * @param prim1 первый примитив
		 * @param prim2 второй примитив
		 * @return true, если пересечение существует, иначе false
		 */
		function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean;
	}
}