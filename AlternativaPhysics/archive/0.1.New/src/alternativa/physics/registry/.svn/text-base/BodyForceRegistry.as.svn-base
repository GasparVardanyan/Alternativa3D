package alternativa.physics.registry {
	import alternativa.physics.force.IBodyForceGenerator;
	import alternativa.physics.rigid.Body;
	
	/**
	 * Реестр генераторов сил.
	 */
	public class BodyForceRegistry {
		
		protected var registrations:BodyForceRegistration;
		
		/**
		 * 
		 */
		public function BodyForceRegistry() {
		}
		
		/**
		 * Добавляет генератор для указанного тела.
		 * 
		 * @param body тело, для которого добавляется генератор
		 * @param fg добавляемый генератор сил
		 */
		public function add(body:Body, fg:IBodyForceGenerator):void {
			// Запись добавляется в начало списка
			var registration:BodyForceRegistration = new BodyForceRegistration(body, fg);
			registration.next = registrations;
			registrations = registration;
		}

		/**
		 * Удаляет генератор сил для тела.
		 * 
		 * @param body
		 * @param fg
		 */
		public function remove(body:Body, fg:IBodyForceGenerator):void {
			var curr:BodyForceRegistration = registrations;
			var prev:BodyForceRegistration = null;
			while (curr != null && (curr.body != body || curr.forceGenerator != fg)) {
				prev = curr;
				curr = curr.next;
			}
			if (curr != null) {
				if (curr == registrations) {
					registrations = curr.next;
				} else {
					prev.next = curr.next;
				}
			}
		}
		
		/**
		 * Очищает реестр.
		 */
		public function clear():void {
			registrations = null;
		}
		
		/**
		 * Запускает все зарегистрированные генераторы.
		 *   
		 * @param time время, в течении которого действуют генераторы
		 */
		public function updateForces(time:Number):void {
			var curr:BodyForceRegistration = registrations;
			while (curr != null) {
				curr.forceGenerator.updateForce(curr.body, time);
				curr = curr.next;
			}
		}
	}
}