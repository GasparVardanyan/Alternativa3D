package alternativa.physics.collision {
	
	public interface ICollisionPredicate {
		
		function considerCollision(primitive:CollisionPrimitive):Boolean;
		
	}
}