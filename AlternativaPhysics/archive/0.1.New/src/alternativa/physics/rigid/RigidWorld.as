package alternativa.physics.rigid {
	import flash.utils.getTimer;
	
	
	/**
	 * Физический симулятор.
	 */
	public class RigidWorld {
		/**
		 * При установленном значении <code>true</code>, перед процедурой определения столкновений все скорости и положения тел будут временно проинтегрированы
		 * на один шаг, а после состояния тел будут возвращены к значениям на начало шага симуляции.
		 */
		public var predictCollisions:Boolean = false;
		/**
		 * Максимально допустимая глубина пересечения тел в точке контакта.
		 */		
		public var maxPenetration:Number = 0.01;
		/**
		 * Максимальное значение дополнительной скорости разделения в точке контакта.
		 */		
		public var maxSepVelocity:Number = 0.5;
		/**
		 * Количество шагов симуляции, за которое должно быть устранено пересечение тел в отсутствие внешних воздействий.
		 * Исходя из значения данного параметра вычисляется дополнительный импульс разделения в точке контакта. 
		 */		
		public var penResolutionSteps:int = 5;
		
		public var conllisionIterations:int = 3;
		
		// Список тел в симуляторе.
		public var bodies:Body;
		// Ссылка на последнее тело в списке
		private var lastBody:Body;
		// Реестр генераторов сил.
		public var forceRegistry:BodyForceRegistry = new BodyForceRegistry();
		// Список контактов
		public var contacts:Contact;
		
		private var contactGenerators:ContactGenerator;
		private var maxContacts:int;
		private var numContacts:int;
		
		public var timeStamp:uint;
		
		/**
		 * 
		 * @param maxContacts максимально допустимое количество контактов
		 */
		public function RigidWorld(maxContacts:int = 100) {
			this.maxContacts = maxContacts;
			createContactsList(maxContacts);
		}
		
		/**
		 * Создаёт список контактов заданной длины.
		 */
		private function createContactsList(num:int):void {
			contacts = new Contact(0);
			var last:Contact = contacts;
			for (var i:int = 1; i < num; i++) {
				last = last.next = new Contact(i);
			}
		}
		
		/**
		 * Добавляет телов симулятор.
		 * 
		 * @param body добавляемое тело
		 */
		public function addBody(body:Body):void {
			if (bodies == null) {
				bodies = lastBody = body;
			} else {
				lastBody = lastBody.next = body;
			}
		}
		
		/**
		 * Удаляет тело из симулятора.
		 * 
		 * @param body удаляемое тело
		 */
		public function removeBody(body:Body):Boolean {
			if (body == null) {
				return false;
			}
			
			if (body == bodies) {
				if (lastBody == bodies) {
					lastBody = null;
				}
				bodies = bodies.next;
				return true;
			}
			
			var b:Body = bodies;
			var prev:Body;
			while (b != null && b != body) {
				prev = b;
				b = b.next;
			}
			if (b == null) {
				return false;
			} else {
				if (lastBody == b) {
					lastBody = prev;
				}
				prev.next = b.next;
				return true;
			}
		}
		
		/**
		 * 
		 * @param gen
		 * 
		 */
		public function addContactGenerator(gen:ContactGenerator):void {
			if (contactGenerators == null) {
				contactGenerators = gen;
			} else {
				gen.next = contactGenerators;
				contactGenerators = gen;
			}
		}
		
		/**
		 * Выполняет шаг симуляции.
		 * 
		 * @param dt длительность шага симуляции
		 */
		public function runPhysics(dt:Number):void {
			// Применяем все силы, действующие на тела 
			forceRegistry.updateForces(dt);
			// Сохраняем состояние тела и считаем ускорения
			var body:Body = bodies;
			while (body != null) {
				body.prevState.copy(body.state);
				body.calcAccelerations();
				body = body.next;
			}
			// Создаём контакты. Контакты получаются из детектора столкновений и ограничений.
			generateContacts(dt);
			// Разрешение контактов. Изменяются скорости тел.
			processContacts(dt, false);
			// Интегрирование скоростей тел с откорректированными начальными условиями
			integrateVelocity(dt);
			// Разрешение оставшихся актуальных контактов, используя абсолютно неупругое взаимодействие
			processContacts(dt, true);
			// Shock propagation
			shockPropagation();
			// Интегрирование положения тел, используя ранее полученные скорости
			integratePosition(dt);
			
			timeStamp++;
		}

		/**
		 * 
		 * @param dt
		 */
		private function integrateVelocity(dt:Number):void {
			var curr:Body = bodies;
			while (curr != null) {
				curr.integrateVelocity(dt);
				curr = curr.next;
			}
		}

		/**
		 * 
		 * @param dt
		 */
		private function integratePosition(dt:Number):void {
			var curr:Body = bodies;
			while (curr != null) {
				curr.integratePosition(dt);
				curr = curr.next;
			}
		}
		
		/**
		 * 
		 */
		private function generateContacts(dt:Number):void {
			var body:Body;
			if (predictCollisions) {
				// Для всех тел сохраняем текущее состояние и интегрируем его
				body = bodies;
				while (body != null) {
					body.integrateFull(dt);
					body.calcDerivedData();
					body = body.next;
				}
			}
			
			var gen:ContactGenerator = contactGenerators;
			var contact:Contact = contacts;
			while (gen != null && contact != null) {
				contact = gen.addContacts(contact);
				gen = gen.next;
			}
			numContacts = contact == null ? maxContacts : contact.index;
			
			if (predictCollisions) {
				// Восстанавливаем сохранённое состояние
				body = bodies;
				while (body != null) {
					body.state.copy(body.prevState);
					body = body.next;
				}
			}
		}
		
		/**
		 * 
		 * @param inelastic
		 */
		private function processContacts(dt:Number, forceInelastic:Boolean):void {
			if (numContacts == 0) {
				return;
			}
			
			// Вычисление дополнительных скоростей разделения в точках контактов
			var contact:Contact = contacts;
			while (contact != null && contact.index < numContacts) {
				var time:Number = penResolutionSteps*dt;
				if (contact.penetration > maxPenetration) {
					var minSepVel:Number = (contact.penetration - maxPenetration)/time;
					contact.minSepVelocity = minSepVel < maxSepVelocity ? minSepVel : maxSepVelocity;
				} else {
					contact.minSepVelocity = 0;
				}
				contact = contact.next;
			}
			
			// Итерационное применение импульсов к контактам
			var iterations:int = conllisionIterations*numContacts;
			trace("timeStamp", timeStamp);
			for (var iter:int = 0; iter < iterations; iter++) {
				contact = contacts;
				var max:Number = 0;
				var bestContact:Contact = null;
				while (contact != null && contact.index < numContacts) {
					if (contact.getSepVelocity() <= contact.minSepVelocity) {
						if (contact.getSepVelocity() < max) {
							max = contact.getSepVelocity();
							bestContact = contact;
						}
					}
					contact = contact.next;
				}
				if (bestContact == null) {
					return;
				}
//				trace(timeStamp, "bestContact", bestContact.index);
				trace(bestContact.index, "before", bestContact.getSepVelocity(), max);
				bestContact.resolve(forceInelastic, dt);
				trace(bestContact.index, "after", bestContact.getSepVelocity(), bestContact.minSepVelocity);
			}
			contact = contacts;
			while (contact != null && contact.index < numContacts) {
				trace(contact.getSepVelocity());
				contact = contact.next;
			}
		}
		
		/**
		 * 
		 */
		private function shockPropagation():void {
			
		}
		
	}
}