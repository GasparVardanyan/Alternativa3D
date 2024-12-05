package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	
	public interface IRayCollisionPredicate {
		function considerBody(body:Body):Boolean;
	}
}