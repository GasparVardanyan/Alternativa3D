package alternativa.physics.force {
	import alternativa.physics.rigid.Body;
	
	/**
	 * 
	 */
	public interface IBodyForceGenerator {
		function updateForce(body:Body, time:Number):void;
	}
}