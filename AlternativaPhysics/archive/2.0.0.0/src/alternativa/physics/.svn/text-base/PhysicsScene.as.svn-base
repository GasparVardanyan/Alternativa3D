package alternativa.physics {

	import alternativa.physics.collision.ICollisionDetector;
	import alternativa.physics.collision.KdTreeCollisionDetector;
	import alternativa.physics.constraints.Constraint;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;

	/**
	 * Класс реализует физическую симуляцию поведения твёрдых тел.
	 */
	public class PhysicsScene {

		private static var lastBodyId:int;

		// Максимальное количество контактов
		public const MAX_CONTACTS:int = 1000;

		//////////////////////////////////////////////////////////////////
		// Настроечные параметры симуляции. Могут быть изменены в любой
		// момент времени без нарушения корректной работы симуляции.
		//////////////////////////////////////////////////////////////////
		// Количество шагов, за которое пересекающиеся тела должны разделиться
		public var penResolutionSteps:int = 10;
		// Величина допустимой глубины пересечения
		public var allowedPenetration:Number = 0.1;
		// Максимальная скорость, добавляемая с целью разделения тел
		public var maxPenResolutionSpeed:Number = 0.5;
		// Количество итераций для обработки упругих контактов
		public var collisionIterations:int = 5;
		// Количество итераций для обработки неупругих контактов
		public var contactIterations:int = 5;
		// Флаг использования предсказания состояний
		public var usePrediction:Boolean = false;

		public var freezeSteps:int = 10;
		public var linSpeedFreezeLimit:Number = 1;
		public var angSpeedFreezeLimit:Number = 0.01;

		// Вектор гравитации
		public var _gravity:Vector3 = new Vector3(0, 0, -9.8);
		// Модуль вектора гравитации
		public var _gravityMagnitude:Number = 9.8;

		// Использующийся детектор столкновений
		public var collisionDetector:ICollisionDetector;

		// Список тел, участвующих в симуляции
		public var bodies:BodyList = new BodyList();

		// Список контактов на текущем шаге симуляции
		public var contacts:Contact;
		// Список ограничений
		public var constraints:Vector.<Constraint> = new Vector.<Constraint>();
		// Количество ограничений
		public var constraintsNum:int;
		// Временная метка. Число прошедших шагов с начала симуляции.
		public var frame:int;
		// Время с начала симуляции, мс
		public var time:int;
		// Первый неиспользованный контакт на текущем шаге симуляции
		private var borderContact:Contact;

		// Временные переменные для избежания создания экземпляров
		private var _t:Vector3 = new Vector3();
		private var _v:Vector3 = new Vector3();

		/**
		 *
		 */
		public function PhysicsScene() {
			contacts = new Contact(0);
			var contact:Contact = contacts;
			for (var i:int = 1; i < MAX_CONTACTS; i++) {
				contact.next = new Contact(i);
				contact = contact.next;
			}
			collisionDetector = new KdTreeCollisionDetector();
		}

		/**
		 * Вектор гравитации.
		 */
		public function get gravity():Vector3 {
			return _gravity.clone();
		}

		/**
		 * @private
		 */
		public function set gravity(value:Vector3):void {
			_gravity.copy(value);
			_gravityMagnitude = _gravity.length();
		}

		/**
		 * Добавляет тело в симуляцию.
		 *
		 * @param body
		 */
		public function addBody(body:Body):void {
			body.id = lastBodyId++;
			body.world = this;
			bodies.append(body);
		}

		/**
		 * Удаляет тело из симуляции.
		 * @param body
		 */
		public function removeBody(body:Body):void {
			if (bodies.remove(body)) {
				body.world = null;
			}
		}

		/**
		 * Добавляет ограничение.
		 * @param c
		 */
		public function addConstraint(c:Constraint):void {
			constraints[constraintsNum++] = c;
			c.world = this;
		}

		/**
		 * Удаляет ограничение.
		 * @param c
		 */
		public function removeConstraint(c:Constraint):Boolean {
			var idx:int = constraints.indexOf(c);
			if (idx < 0) return false;
			constraints.splice(idx, 1);
			constraintsNum--;
			c.world = null;
			return true;
		}

		/**
		 * Применяет к телам действующте на них силы. Аккумуляторы сил и моментов тел очищаются после завершения шага
		 * симуляции, поэтому на момент вызова метода могут уже содержать некоторые значения.
		 *
		 * @param dt промежуток времени, в течении которого действуют силы
		 */
		private function applyForces(dt:Number):void {
			var item:BodyListItem = bodies.head;
			while (item != null) {
				var body:Body = item.body;
				body.beforePhysicsStep(dt);
				body.calcAccelerations();
				// Ускорение свободного падения применяется только к подвижным телам во избежание некорректного изменения
				// фиктивной скорости неподвижных тел.
				if (body.useGravity && body.movable && !body.frozen) {
					body.accel.x += _gravity.x;
					body.accel.y += _gravity.y;
					body.accel.z += _gravity.z;
				}
				item = item.next;
			}
		}

		/**
		 * Определяет все столкновения на текущем шаге симуляции и заполняет список получившихся контактов.
		 *
		 * @param dt длительность шага симуляции
		 */
		private function detectCollisions(dt:Number):void {
			var item:BodyListItem = bodies.head;
			while (item != null) {
				var body:Body = item.body;
				if (!body.frozen) {
					body.contactsNum = 0;
					body.saveState();
					// При включённом режиме предсказания состояние тел интегрируется на один шаг вперёд
					if (usePrediction) {
						body.integrateVelocity(dt);
						body.integratePosition(dt);
					}
					body.calcDerivedData();
				}
				item = item.next;
			}

			borderContact = collisionDetector.getAllContacts(contacts);

			// Расчёт относительных векторов точки контакта вынесен сюда из-за необходимости учитывать
			// положение тел в предсказанном состоянии
			var contact:Contact = contacts;
			while (contact != borderContact) {
				var b1:Body = contact.body1;
				var b2:Body = contact.body2;
				for (var j:int = 0; j < contact.pcount; j++) {
					var cp:ContactPoint = contact.points[j];
					var bPos:Vector3 = b1.state.pos;
					cp.r1.x = cp.pos.x - bPos.x;
					cp.r1.y = cp.pos.y - bPos.y;
					cp.r1.z = cp.pos.z - bPos.z;
					if (b2 != null) {
						bPos = b2.state.pos;
						cp.r2.x = cp.pos.x - bPos.x;
						cp.r2.y = cp.pos.y - bPos.y;
						cp.r2.z = cp.pos.z - bPos.z;
					}
				}
				contact = contact.next;
			}

			// Восстановление состояния тел
			if (usePrediction) {
				item = bodies.head;
				while (item != null) {
					body = item.body;
					if (!body.frozen) {
						body.restoreState();
						body.calcDerivedData();
					}
					item = item.next;
				}
			}
		}

		/**
		 * Подготваливает полученные из детектора столкновений контакты, расчитывая значения, не меняющиеся
		 * в ходе шага симуляции.
		 */
		private function preProcessContacts(dt:Number):void {
			var contact:Contact = contacts;
			while (contact != borderContact) {
				var b1:Body = contact.body1;
				var b2:Body = contact.body2;
				// Столкнувшиеся тела размораживаются
				if (b1.frozen) {
					b1.frozen = false;
					b1.freezeCounter = 0;
				}
				if (b2 != null && b2.frozen) {
					b2.frozen = false;
					b2.freezeCounter = 0;
				}
				contact.restitution = b1.material.restitution;
				if (b2 != null &&  b2.material.restitution < contact.restitution) contact.restitution = b2.material.restitution;
				contact.friction = b1.material.friction;
				if (b2 != null &&  b2.material.friction < contact.friction) contact.friction = b2.material.friction;
				for (var j:int = 0; j < contact.pcount; j++) {
					var cp:ContactPoint = contact.points[j];
					cp.accumImpulseN = 0;
					// Расчитываем изменение нормальной скорости на единицу нормального импульса
					// dV = b.invMass + ((invI * (r % n)) % r) * n
					cp.velByUnitImpulseN = 0;
					if (b1.movable) {
						cp.angularInertia1 = _v.cross2(cp.r1, contact.normal).transformBy3(b1.invInertiaWorld).cross(cp.r1).dot(contact.normal);
						cp.velByUnitImpulseN += b1.invMass + cp.angularInertia1;
					}
					if (b2 != null && b2.movable) {
						cp.angularInertia2 = _v.cross2(cp.r2, contact.normal).transformBy3(b2.invInertiaWorld).cross(cp.r2).dot(contact.normal);
						cp.velByUnitImpulseN += b2.invMass + cp.angularInertia2;
					}
					// Расчёт требуемой конечной скорости для упругого контакта
					calcSepVelocity(b1, b2, cp, _v);
					cp.normalVel = _v.dot(contact.normal);
					if (cp.normalVel < 0) cp.normalVel = - contact.restitution*cp.normalVel;
					// Скорость разделения неупругого контакта
					cp.minSepVel = cp.penetration > allowedPenetration ? (cp.penetration - allowedPenetration)/(penResolutionSteps*dt) : 0;
					if (cp.minSepVel > maxPenResolutionSpeed) cp.minSepVel = maxPenResolutionSpeed;
				}
				contact = contact.next;
			}
			for (var i:int = 0; i < constraintsNum; i++) {
				var constraint:Constraint = constraints[i];
				constraint.preProcess(dt);
			}
		}

		/**
		 *
		 * @param dt
		 * @param forceInelastic
		 */
		private function processContacts(dt:Number, forceInelastic:Boolean):void {
			var iterNum:int = forceInelastic ? contactIterations : collisionIterations;
			var i:int;
			var forwardLoop:Boolean = false;
			for (var iter:int = 0; iter < iterNum; iter++) {
				forwardLoop = !forwardLoop;
				var contact:Contact = contacts;
				while (contact != borderContact) {
					resolveContact(contact, forceInelastic, forwardLoop);
					contact = contact.next;
				}
				// Ограничения
				for (i = 0; i < constraintsNum; i++) {
					var constraint:Constraint = constraints[i];
					constraint.apply(dt);
				}
			}
		}

		/**
		 *
		 * @param contactInfo
		 * @param forceInelastic
		 * @param forwardLoop
		 */
		private function resolveContact(contactInfo:Contact, forceInelastic:Boolean, forwardLoop:Boolean):void {
			var b1:Body = contactInfo.body1;
			var b2:Body = contactInfo.body2;
			var normal:Vector3 = contactInfo.normal;
			var i:int;
			if (forwardLoop) {
				for (i = 0; i < contactInfo.pcount; i++) resolveContactPoint(i, b1, b2, contactInfo, normal, forceInelastic);
			} else {
				for (i = contactInfo.pcount - 1; i >= 0; i--) resolveContactPoint(i, b1, b2, contactInfo, normal, forceInelastic);
			}
		}

		/**
		 *
		 * @param idx
		 * @param b1
		 * @param b2
		 * @param contact
		 * @param normal
		 * @param forceInelastic
		 */
		private function resolveContactPoint(idx:int, b1:Body, b2:Body, contact:Contact, normal:Vector3, forceInelastic:Boolean):void {
			var cp:ContactPoint = contact.points[idx];
			if (!forceInelastic) {
				cp.satisfied = true;
			}

			var newVel:Number = 0;
			calcSepVelocity(b1, b2, cp, _v);
			var cnormal:Vector3 = contact.normal;
			var sepVel:Number = _v.x*cnormal.x + _v.y*cnormal.y + _v.z*cnormal.z;
			if (forceInelastic) {
				var minSpeVel:Number = cp.minSepVel;
				if (sepVel < minSpeVel) {
					cp.satisfied = false;
				} else if (cp.satisfied) return;
				newVel = minSpeVel;
			} else {
				newVel = cp.normalVel;
			}
			var deltaVel:Number = newVel - sepVel;
			var impulse:Number = deltaVel/cp.velByUnitImpulseN;
			var accumImpulse:Number = cp.accumImpulseN + impulse;
			if (accumImpulse < 0) {
				accumImpulse = 0;
			}
			var deltaImpulse:Number = accumImpulse - cp.accumImpulseN;
			cp.accumImpulseN = accumImpulse;
			// Применяем импульс к телам
			if (b1.movable) {
				b1.applyRelPosWorldImpulse(cp.r1, normal, deltaImpulse);
			}
			if (b2 != null && b2.movable) {
				b2.applyRelPosWorldImpulse(cp.r2, normal, -deltaImpulse);
			}

			// Учёт силы трения
			calcSepVelocity(b1, b2, cp, _v);
			// Расчитываем изменение касательной скорости на единицу касательного импульса
			var tanSpeedByUnitImpulse:Number = 0;

//			_v.vAddScaled(-_v.vDot(contact.normal), contact.normal);
			var dot:Number = _v.x*cnormal.x + _v.y*cnormal.y + _v.z*cnormal.z;
			_v.x -= dot*cnormal.x;
			_v.y -= dot*cnormal.y;
			_v.z -= dot*cnormal.z;

			var tanSpeed:Number = _v.length();
			if (tanSpeed < 0.001) return;

//			_t.vCopy(_v).vNormalize().vReverse();
			_t.x = -_v.x;
			_t.y = -_v.y;
			_t.z = -_v.z;
			_t.normalize();

			var r:Vector3;
			var m:Matrix3;
			var xx:Number;
			var yy:Number;
			var zz:Number;
			// dV = b.invMass + ((invI * (r % t)) % r) * t
			if (b1.movable) {
//				_v.vCross2(cp.r1, _t).vTransformBy3(b1.invInertiaWorld).vCross(cp.r1);
				r = cp.r1;
				m = b1.invInertiaWorld;

				_v.x = r.y*_t.z - r.z*_t.y;
				_v.y = r.z*_t.x - r.x*_t.z;
				_v.z = r.x*_t.y - r.y*_t.x;

				xx = m.a*_v.x + m.b*_v.y + m.c*_v.z;
				yy = m.e*_v.x + m.f*_v.y + m.g*_v.z;
				zz = m.i*_v.x + m.j*_v.y + m.k*_v.z;

				_v.x = yy*r.z - zz*r.y;
				_v.y = zz*r.x - xx*r.z;
				_v.z = xx*r.y - yy*r.x;

				tanSpeedByUnitImpulse += b1.invMass + _v.x*_t.x + _v.y*_t.y + _v.z*_t.z;
			}
			if (b2 != null && b2.movable) {
//				_v.vCross2(cp.r2, _t).vTransformBy3(b2.invInertiaWorld).vCross(cp.r2);

				r = cp.r2;
				m = b2.invInertiaWorld;

				_v.x = r.y*_t.z - r.z*_t.y;
				_v.y = r.z*_t.x - r.x*_t.z;
				_v.z = r.x*_t.y - r.y*_t.x;

				xx = m.a*_v.x + m.b*_v.y + m.c*_v.z;
				yy = m.e*_v.x + m.f*_v.y + m.g*_v.z;
				zz = m.i*_v.x + m.j*_v.y + m.k*_v.z;

				_v.x = yy*r.z - zz*r.y;
				_v.y = zz*r.x - xx*r.z;
				_v.z = xx*r.y - yy*r.x;

				tanSpeedByUnitImpulse += b2.invMass + _v.x*_t.x + _v.y*_t.y + _v.z*_t.z;
			}

			var tanImpulse:Number = tanSpeed/tanSpeedByUnitImpulse;
			var max:Number = contact.friction*cp.accumImpulseN;
			if (max < 0) {
				if (tanImpulse < max) tanImpulse = max;
			} else {
				if (tanImpulse > max) tanImpulse = max;
			}

			// Применяем импульс к телам
			if (b1.movable) {
				b1.applyRelPosWorldImpulse(cp.r1, _t, tanImpulse);
			}
			if (b2 != null && b2.movable) {
				b2.applyRelPosWorldImpulse(cp.r2, _t, -tanImpulse);
			}
		}

		/**
		 *
		 * @param body1
		 * @param body2
		 * @param cp
		 * @param result
		 */
		private function calcSepVelocity(body1:Body, body2:Body, cp:ContactPoint, result:Vector3):void {
			// sepVel = (V1 - V2)*normal
			// V1 = V1_c + w1%r1
//			result.vCopy(body1.state.velocity).vAdd(_v1.vCross2(body1.state.rotation, cp.r1));
			var rot:Vector3 = body1.state.rotation;
			var v:Vector3 = cp.r1;
			var x:Number = rot.y*v.z - rot.z*v.y;
			var y:Number = rot.z*v.x - rot.x*v.z;
			var z:Number = rot.x*v.y - rot.y*v.x;
			v = body1.state.velocity;
			result.x = v.x + x;
			result.y = v.y + y;
			result.z = v.z + z;
			// V2 = V2_c + w2%r2
			if (body2 != null) {
//				result.vSubtract(body2.state.velocity).vSubtract(_v2.vCross2(body2.state.rotation, cp.r2));
				rot = body2.state.rotation;
				v = cp.r2;
				x = rot.y*v.z - rot.z*v.y;
				y = rot.z*v.x - rot.x*v.z;
				z = rot.x*v.y - rot.y*v.x;
				v = body2.state.velocity;
				result.x -= v.x + x;
				result.y -= v.y + y;
				result.z -= v.z + z;
			}
		}

		/**
		 *
		 * @param dt
		 */
		private function intergateVelocities(dt:Number):void {
			var item:BodyListItem = bodies.head;
			while (item != null) {
				item.body.integrateVelocity(dt);
				item = item.next;
			}
		}

		/**
		 *
		 * @param dt
		 */
		private function integratePositions(dt:Number):void {
			var item:BodyListItem = bodies.head;
			while (item != null) {
				var body:Body = item.body;
				if (body.movable && !body.frozen) {
					body.integratePosition(dt);
				}
				item = item.next;
			}
		}

		/**
		 *
		 */
		private function postPhysics():void {
			var item:BodyListItem = bodies.head;
			while (item != null) {
				var body:Body = item.body;
				body.clearAccumulators();
				body.calcDerivedData();
				if (body.canFreeze) {
					if (body.state.velocity.length() < linSpeedFreezeLimit && body.state.rotation.length() < angSpeedFreezeLimit) {
						if (!body.frozen) {
							body.freezeCounter++;
							if (body.freezeCounter >= freezeSteps)
								body.frozen = true;
						}
					} else {
						body.freezeCounter = 0;
						body.frozen = false;
					}
				}
				item = item.next;
			}
		}

		/**
		 *
		 * @param delta
		 */
		public function update(delta:int):void {
			frame++;
			time += delta;
			var dt:Number = 0.001*delta;
			applyForces(dt);
			detectCollisions(dt);
			preProcessContacts(dt);
			processContacts(dt, false);
			intergateVelocities(dt);
			processContacts(dt, true);
			integratePositions(dt);
			postPhysics();
		}

	}
}