package alternativa.physics.collision {
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	
	public interface ICollisionPredicate {
		
		function considerCollision(primitive:CollisionPrimitive):Boolean;
		
	}
}