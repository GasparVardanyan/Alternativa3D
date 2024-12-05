package alternativa.physics.registry {
	import alternativa.physics.force.IBodyForceGenerator;
	import alternativa.physics.rigid.Body;
	
	public class BodyForceRegistration {
		
		public var body:Body;
		public var forceGenerator:IBodyForceGenerator;
		
		public var next:BodyForceRegistration;
		
		public function BodyForceRegistration(body:Body, forceGenerator:IBodyForceGenerator) {
			this.body = body;
			this.forceGenerator = forceGenerator;
		}
	}
}