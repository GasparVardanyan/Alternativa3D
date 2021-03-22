package a3d_helper.physics
{
	import alternativa.physicsengine.physics.types.Body;
	
	public interface IBodyFilter
	{
		function acceptBody(data:Body):Boolean;
	}
}
