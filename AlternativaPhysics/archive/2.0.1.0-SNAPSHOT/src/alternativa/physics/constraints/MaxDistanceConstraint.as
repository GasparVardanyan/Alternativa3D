package alternativa.physics.constraints {
	
	import alternativa.physics.Body;
	import alternativa.math.Matrix3;
	import alternativa.math.Vector3;
	
	/**
	 * 
	 */
	public class MaxDistanceConstraint extends Constraint {
		// Первое тело ограничения
		public var body1:Body;
		// Второе тело ограничения. Может быть null.
		public var body2:Body;
		// Первая точка крепления в системе координат первого тела
		public var r1:Vector3;
		// Вторая точка привязки в системе координат второго тела. В случае отсутствия второго тела, координаты задаются в мировой системе.
		public var r2:Vector3;
		// Максимально допустимое расстояние между точками крепления
		public var maxDistance:Number;
		// Радиус-вектор первой точки крепления, трансформированный без смещения в мировую систему координат
		public var wr1:Vector3 = new Vector3();
		// Радиус-вектор второй точки крепления, трансформированный без смещения в мировую систему координат
		public var wr2:Vector3 = new Vector3();
		// Минимальная скорость сближения для удовлетворения ограничения
		private var minClosingVel:Number;
		// Изменение относительной скорости на единицу импульса
		private var velByUnitImpulseN:Number;
		// Направление корректирующего импульса
		private var impulseDirection:Vector3 = new Vector3();
		
		// Вспомогательные переменные
//		private static var _v:Vector3 = new Vector3();
//		private static var _v1:Vector3 = new Vector3();
//		private static var _v2:Vector3 = new Vector3();
		
		/**
		 * @param body1
		 * @param body2
		 * @param r1
		 * @param r2
		 * @param maxDistance
		 */
		public function MaxDistanceConstraint(body1:Body, body2:Body, r1:Vector3, r2:Vector3, maxDistance:Number) {
			super();
			this.body1 = body1;
			this.body2 = body2;
			this.r1 = r1.clone();
			this.r2 = r2.clone();
			this.maxDistance = maxDistance;
		}
		
		/**
		 * @param dt
		 */
		override public function preProcess(dt:Number):void {
			// Вычислим расстояние между точками
			var m:Matrix3 = body1.baseMatrix;
			wr1.x = m.a*r1.x + m.b*r1.y + m.c*r1.z;
			wr1.y = m.e*r1.x + m.f*r1.y + m.g*r1.z;
			wr1.z = m.i*r1.x + m.j*r1.y + m.k*r1.z;
			if (body2 != null) {
				m = body2.baseMatrix;
				wr2.x = m.a*r2.x + m.b*r2.y + m.c*r2.z;
				wr2.y = m.e*r2.x + m.f*r2.y + m.g*r2.z;
				wr2.z = m.i*r2.x + m.j*r2.y + m.k*r2.z;
			}	else {
				wr2.x = r2.x;
				wr2.y = r2.y;
				wr2.z = r2.z;
			}
			var p1:Vector3 = body1.state.pos;
			impulseDirection.x = wr2.x - wr1.x - p1.x;
			impulseDirection.y = wr2.y - wr1.y - p1.y;
			impulseDirection.z = wr2.z - wr1.z - p1.z;
			if (body2 != null) {
				var p2:Vector3 = body2.state.pos;
				impulseDirection.x += p2.x;
				impulseDirection.y += p2.y;
				impulseDirection.z += p2.z;
			}
			
			var len:Number = Math.sqrt(impulseDirection.x*impulseDirection.x + impulseDirection.y*impulseDirection.y + impulseDirection.z*impulseDirection.z);
			var delta:Number = len - maxDistance;
			if (delta > 0) {
				satisfied = false;
				if (len < 0.001) {
					impulseDirection.x = 1;
				}	else {
					len = 1/len;
					impulseDirection.x *= len;
					impulseDirection.y *= len;
					impulseDirection.z *= len;
				}
				minClosingVel = delta/(world.penResolutionSteps*dt);
				if (minClosingVel > world.maxPenResolutionSpeed) {
					minClosingVel = world.maxPenResolutionSpeed;
				}
				// Расчитываем изменение нормальной скорости на единицу нормального импульса
				// dV = b.invMass + ((invI * (r % n)) % r) * n
				var x:Number;
				var y:Number;
				var z:Number;
				var vx:Number;
				var vy:Number;
				var vz:Number;
				velByUnitImpulseN = 0;
				if (body1.movable) {
//					velByUnitImpulseN += body1.invMass + _v.vCross2(wr1, impulseDirection).vTransformBy3(body1.invInertiaWorld).vCross(wr1).vDot(impulseDirection);
					vx = wr1.y*impulseDirection.z - wr1.z*impulseDirection.y;
					vy = wr1.z*impulseDirection.x - wr1.x*impulseDirection.z;
					vz = wr1.x*impulseDirection.y - wr1.y*impulseDirection.x;
					
					m = body1.invInertiaWorld;
					x = m.a*vx + m.b*vy + m.c*vz;
					y = m.e*vx + m.f*vy + m.g*vz;
					z = m.i*vx + m.j*vy + m.k*vz;
					
					vx = y*wr1.z - z*wr1.y;
					vy = z*wr1.x - x*wr1.z;
					vz = x*wr1.y - y*wr1.x;
					velByUnitImpulseN += body1.invMass + vx*impulseDirection.x + vy*impulseDirection.y + vz*impulseDirection.z;
				}
				if (body2 != null && body2.movable) {
//					velByUnitImpulseN += body2.invMass + _v.vCross2(wr2, impulseDirection).vTransformBy3(body2.invInertiaWorld).vCross(wr2).vDot(impulseDirection);
					vx = wr2.y*impulseDirection.z - wr2.z*impulseDirection.y;
					vy = wr2.z*impulseDirection.x - wr2.x*impulseDirection.z;
					vz = wr2.x*impulseDirection.y - wr2.y*impulseDirection.x;
					
					m = body2.invInertiaWorld;
					x = m.a*vx + m.b*vy + m.c*vz;
					y = m.e*vx + m.f*vy + m.g*vz;
					z = m.i*vx + m.j*vy + m.k*vz;
					
					vx = y*wr2.z - z*wr2.y;
					vy = z*wr2.x - x*wr2.z;
					vz = x*wr2.y - y*wr2.x;
					velByUnitImpulseN += body2.invMass + vx*impulseDirection.x + vy*impulseDirection.y + vz*impulseDirection.z;
				}
			} else {
				satisfied = true;
			}
		}
		
		/**
		 * @param dt
		 */
		override public function apply(dt:Number):void {
			if (satisfied) return;
			// Расчитываем проекцию скорости относительной скорости
			// sepVel = (V1 - V2)*normal
			// V1 = V1_c + w1%r1
			var vel:Vector3 = body1.state.velocity;
			var rot:Vector3 = body1.state.rotation;
//			v1Cross2(state.rotation, wr1);
			var vx:Number = vel.x + rot.y*wr1.z - rot.z*wr1.y;
			var vy:Number = vel.y + rot.z*wr1.x - rot.x*wr1.z;
			var vz:Number = vel.z + rot.x*wr1.y - rot.y*wr1.x;
			// V2 = V2_c + w2%r2
			if (body2 != null) {
				vel = body2.state.velocity;
				rot = body2.state.rotation;
//				_v2.vCross2(state.rotation, wr2);
				vx -= vel.x + rot.y*wr2.z - rot.z*wr2.y;
				vy -= vel.y + rot.z*wr2.x - rot.x*wr2.z;
				vz -= vel.z + rot.x*wr2.y - rot.y*wr2.x;
			}
			var closingVel:Number = vx*impulseDirection.x + vy*impulseDirection.y + vz*impulseDirection.z;
			if (closingVel > minClosingVel) return;
			var impulse:Number = (minClosingVel - closingVel)/velByUnitImpulseN;
			if (body1.movable) {
				body1.applyRelPosWorldImpulse(wr1, impulseDirection, impulse);
			}
			if (body2 != null && body2.movable) {
				body2.applyRelPosWorldImpulse(wr2, impulseDirection, -impulse);
			}
		}
		
	}
}