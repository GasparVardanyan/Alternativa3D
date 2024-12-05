package alternativa.physics.collision {
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.rigid.Contact;
	
	/**
	 * Интерфейс определителя столкновений между двумя примитивами.
	 */	
	public interface ICollider {
		function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean;
		
		function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean;
	}
}