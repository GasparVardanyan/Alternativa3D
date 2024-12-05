package alternativa.physics.rigid {
	import alternativa.physics.force.IBodyForceGenerator;
	import alternativa.physics.rigid.Body;
	
	public class BodyForceRegistry {
		
		protected var registrations:BodyForceRegistration;
		
		public function BodyForceRegistry() {
		}
		
		public function add(body:Body, fg:IBodyForceGenerator):void {
			var registration:BodyForceRegistration = new BodyForceRegistration(body, fg);
			registration.next = registrations;
			registrations = registration;
		}

		public function remove(body:Body, fg:IBodyForceGenerator):void {
			var current:BodyForceRegistration = registrations;
			var prev:BodyForceRegistration = null;
			while (current != null) {
				if (current.body == body && current.forceGenerator == fg) {
					if (current == registrations) {
						registrations = current.next;
					} else {
						prev.next = current.next;
					}
					break;
				}
				prev = current;
				current = current.next;
			}
		}
		
		public function clear():void {
			registrations = null;
		}
		
		public function updateForces(time:Number):void {
			var current:BodyForceRegistration = registrations;
			while (current != null) {
				current.forceGenerator.updateForce(current.body, time);
				current = current.next;
			}
		}
	}
}