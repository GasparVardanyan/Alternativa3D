package alternativa.physics.collision {
	import alternativa.physics.rigid.Body;
	
	public interface IBodyCollisionPredicate {
		function considerBodies(body1:Body, body2:Body):Boolean;
	}
}