package alternativa.physics {


	import alternativa.physics.collision.ICollisionDetector;
	import alternativa.physics.collision.KdTreeCollisionDetector;
	import alternativa.physics.constraints.Constraint;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;

	use namespace altphysics;

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

		// Переменные для процедуры разделения тел путём непосредственного их перемещенеия.
		// !!!!!!!!!!!!!!!!!!!!!!!!
		// !!! Экспериментально !!!
		// !!!!!!!!!!!!!!!!!!!!!!!!
		public var staticSeparationIterations:int = 10;
		public var staticSeparationSteps:int = 10;
		public var maxAngleMove:Number = 10;
		public var useStaticSeparation:Boolean = false;

		// Вектор гравитации
		public var _gravity:Vector3 = new Vector3(0, 0, -9.8);
		// Модуль вектора гравитации
		public var _gravityMagnitude:Number = 9.8;

		// Использующийся детектор столкновений
		public var collisionDetector:ICollisionDetector;

		// Список тел, участвующих в симуляции
		public var bodies:BodyList = new BodyList();

		// Список контактов на текущем шаге симуляции
		altphysics var contacts:Contact;
		// Количество контактов на текущем шаге симуляции
//		altphysics var contactsNum:int;
		// Список ограничений
		altphysics var constraints:Vector.<Constraint> = new Vector.<Constraint>();
		// Количество ограничений
		altphysics var constraintsNum:int;
		// Временная метка. Число прошедших шагов с начала симуляции.
		public var timeStamp:int;
		// Время с начала симуляции, мс
		public var time:int;
		// Первый неиспользованный контакт на текущем шаге симуляции
		private var borderContact:Contact;

		// Временные переменные для избежания создания экземпляров
		private var _r:Vector3 = new Vector3();
		private var _t:Vector3 = new Vector3();
		private var _v:Vector3 = new Vector3();
		private var _v1:Vector3 = new Vector3();
		private var _v2:Vector3 = new Vector3();

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
			return _gravity.vClone();
		}

		/**
		 * @private
		 */
		public function set gravity(value:Vector3):void {
			_gravity.vCopy(value);
			_gravityMagnitude = _gravity.vLength();
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
		 * @return
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
			constraints.splice(idx, 1)
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
				if (body.movable && !body.frozen) {
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
						cp.angularInertia1 = _v.vCross2(cp.r1, contact.normal).vTransformBy3(b1.invInertiaWorld).vCross(cp.r1).vDot(contact.normal);
						cp.velByUnitImpulseN += b1.invMass + cp.angularInertia1;
					}
					if (b2 != null && b2.movable) {
						cp.angularInertia2 = _v.vCross2(cp.r2, contact.normal).vTransformBy3(b2.invInertiaWorld).vCross(cp.r2).vDot(contact.normal);
						cp.velByUnitImpulseN += b2.invMass + cp.angularInertia2;
					}
					// Расчёт требуемой конечной скорости для упругого контакта
					calcSepVelocity(b1, b2, cp, _v);
					cp.normalVel = _v.vDot(contact.normal);
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

			// Разделение контактов путём непосредственного изменения координат и ориентации. Экспериментально.
//			if (forceInelastic && useStaticSeparation) performStaticSeparation();
		}

		/**
		 *
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
		 * @param colInfo
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
				var minSpeVel:Number = useStaticSeparation ? 0 : cp.minSepVel;
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

			var tanSpeed:Number = _v.vLength();
			if (tanSpeed < 0.001) return;

//			_t.vCopy(_v).vNormalize().vReverse();
			_t.x = -_v.x;
			_t.y = -_v.y;
			_t.z = -_v.z;
			_t.vNormalize();

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
		 * @param cp
		 * @param normal
		 * @return
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
		private function performStaticSeparation():void {
			var iterNum:int = staticSeparationIterations;
//			iterNum = 100;

			// 1. В начале каждой итерации для всех контактов сбрасывается флаг satisfied с одновременным поиском наихудшего контакта, т.е. имеющего наибольшую величину пересечения тел.
			// 2. Если найденный контакт имеет величину пересечения меньше предельно допустимой процедура прерывается, т.к. разделение контактов не требуется.
			// 3. Если процедура продолжается, то выполняется разделение найденного контакта и установка его флага satisfied в true, после чего запускается внутренний цикл, состоящий
			// из contactsNum - 1 итераций. На каждой итерации ищется наихудший контакт среди оставшихся (satisfied == false). Если такой контакт найден, то выполняется его разделение
			// и переход к следующей итерации внутреннего цикла, иначе внутренний цикл прерывается и выполняется переход к следующей итерации внешнего цикла (шаг 1.).
//			for (var iter:int = 0; iter < iterNum; iter++) {
//				// Ищем контакт с максимальной величиной пересечения тел, одновременно сбрасывая флаги satisfied в false
//				var worstContact:Contact = contacts[0];
//				var i:int;
//				for (i = 1; i < contactsNum; i++) {
//					var contact:Contact = contacts[i];
//					contact.satisfied = false;
//					if (contact.maxPenetration > worstContact.maxPenetration) worstContact = contact;
//				}
//				if (worstContact.maxPenetration <= allowedPenetration) return;
//
//				resolveInterpenetration(worstContact);
//				// Внутренний цикл по оставшимся контактам
//				for (i = 1; i < contactsNum; i++) {
//					worstContact = getWorstContact();
//					if (worstContact == null) break;
//					resolveInterpenetration(worstContact);
//				}
//			}
		}

		/**
		 *
		 */
//		private function getWorstContact():Contact {
//			var maxPen:Number = 0;
//			var worst:Contact = null;
//			for (var i:int = 0; i < contactsNum; i++) {
//				var c:Contact = contacts[i];
//				if (!c.satisfied && c.maxPenetration > maxPen) {
//					worst = c;
//					maxPen = c.maxPenetration;
//				}
//			}
//			return maxPen > allowedPenetration ? worst : null;
//		}

		/**
		 * Разделяет указанный контакт, выполняя staticSeparationSteps итераций по списку точек контакта.
		 * 1. В начале каждой итерации ищется точка с наибольшим пересечением, одновременно сбрасываются флаги satisfied у точек.
		 * 2. Для найденной точки выполняется процедура разделения.
		 * 3. После выполняется pcount - 1 итерация по списку точек, каждый раз ищется наихудшая среди имеющих satisfied == false, для которой выполняется процедура разделения.
		 * Если наихудшая точка не найдена, то выполнется переход к следующей итерации внешнего цикла (шаг 1).
		 *
		 * В конце процедуры разделения обновляются значения пересечений для остальных точек контакта, а также для всех прочих контактов, относящихся к телам текущего.
		 *
		 * @param contact контакт для разделения
		 */
		private function resolveInterpenetration(contact:Contact):void {
			contact.satisfied = true;

			for (var step:int = 0; step < staticSeparationSteps; step++) {
				var worstCp:ContactPoint = contact.points[0];
				var cp:ContactPoint;
				var i:int;
				for (i = 1; i < contact.pcount; i++) {
					cp = contact.points[i];
					cp.satisfied = false;
					if (cp.penetration > worstCp.penetration) worstCp = cp;
				}
				if (worstCp.penetration <= allowedPenetration) break;
				separateContactPoint(worstCp, contact);
				// Разделяем оставшиеся точки
				var maxPen:Number = 0;
				for (i = 1; i < contact.pcount; i++) {
					// Поиск наихудшей точки
					for (var j:int = 0; j < contact.pcount; j++) {
						cp = contact.points[j];
						if (cp.satisfied) continue;
						if (cp.penetration > maxPen) {
							maxPen = cp.penetration;
							worstCp = cp;
						}
					}
					if (maxPen <= allowedPenetration) break;
					separateContactPoint(worstCp, contact);
				}
			}
		}

		/**
		 *
		 * @param cp
		 * @param contact
		 */
		private function separateContactPoint(cp:ContactPoint, contact:Contact):void {
//			cp.satisfied = true;
//
//			var b1:Body = contact.body1;
//			var b2:Body = contact.body2;
//			var totalMove:Number = cp.penetration - allowedPenetration;
//			var moveCoeff:Number = totalMove/cp.velByUnitImpulseN;
//			var linMove1:Number;
//			var angleMove1:Number;
//			if (b1.movable) {
//				linMove1 = b1.invMass*moveCoeff;
//				angleMove1 = cp.angularInertia1*moveCoeff;
//				if (angleMove1 > maxAngleMove) {
//					linMove1 += angleMove1 - maxAngleMove;
//					angleMove1 -= maxAngleMove;
//				}
//				b1.state.pos.vAddScaled(linMove1, contact.normal);
//				_v1.vCross2(cp.r1, contact.normal).vTransformBy3(b1.invInertiaWorld).vScale(angleMove1);
//				b1.state.orientation.addScaledVector(_v1, 1);
//			}
//			var linMove2:Number;
//			var angleMove2:Number;
//			if (b2 != null && b2.movable) {
//				linMove2 = b2.invMass*moveCoeff;
//				angleMove2 = cp.angularInertia2*moveCoeff;
//				if (angleMove2 > maxAngleMove) {
//					linMove2 += angleMove2 - maxAngleMove;
//					angleMove2 -= maxAngleMove;
//				}
//				b2.state.pos.vAddScaled(-linMove2, contact.normal);
//				_v2.vCross2(cp.r2, contact.normal).vTransformBy3(b2.invInertiaWorld).vScale(angleMove2);
//				_v2.vReverse();
//				b2.state.orientation.addScaledVector(_v2, 1);
//			}
//			cp.penetration = allowedPenetration;
//			// Обновляем пересечения в других точках
//			var i:int;
//			for (i = 0; i < contact.pcount; i++) {
//				var cp1:ContactPoint = contact.points[i];
//				if (cp1 == cp) continue;
//				var angularMove:Number;
//				if (b1.movable) {
//					angularMove = _v.vCross2(_v1, cp1.r1).vDot(contact.normal);
//					cp1.penetration -= linMove1 + angularMove;
//				}
//				if (b2 != null && b2.movable) {
//					angularMove = _v.vCross2(_v2, cp1.r2).vDot(contact.normal);
//					cp1.penetration -= linMove2 - angularMove;
//				}
//				// Обновление максимального значения для контакта
//				if (cp1.penetration > contact.maxPenetration) contact.maxPenetration = cp1.penetration;
//			}
//			// Обновляем пересечения для других контактов
//			var c:Contact;
//			var j:int;
//			if (b1.movable) {
//				for (i = 0; i < b1.contactsNum; i++) {
//					c = b1.contacts[i];
//					if (c == contact) continue;
//					for (j = 0; j < c.pcount; j++) {
//						cp1 = c.points[j];
//						if (b1 == c.body1) cp1.penetration -= linMove1*contact.normal.vDot(c.normal) + _v.vCross2(_v1, cp1.r1).vDot(c.normal);
//						else cp1.penetration += linMove1*contact.normal.vDot(c.normal) + _v.vCross2(_v1, cp1.r2).vDot(c.normal);
//						if (c.maxPenetration < cp1.penetration) c.maxPenetration = cp1.penetration;
//					}
//				}
//			}
//			if (b2 != null && b2.movable) {
//				for (i = 0; i < b2.contactsNum; i++) {
//					c = b2.contacts[i];
//					if (c == contact) continue;
//					for (j = 0; j < c.pcount; j++) {
//						cp1 = c.points[j];
//						if (b2 == c.body1) cp1.penetration -= linMove2*contact.normal.vDot(c.normal) + _v.vCross2(_v2, cp1.r1).vDot(c.normal);
//						else cp1.penetration += linMove2*contact.normal.vDot(c.normal) + _v.vCross2(_v2, cp1.r2).vDot(c.normal);
//						if (c.maxPenetration < cp1.penetration) c.maxPenetration = cp1.penetration;
//					}
//				}
//			}
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
					if (body.state.velocity.vLength() < linSpeedFreezeLimit && body.state.rotation.vLength() < angSpeedFreezeLimit) {
						if (!body.frozen) {
							body.freezeCounter++;
							if (body.freezeCounter >= freezeSteps) body.frozen = true;
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
			timeStamp++;
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