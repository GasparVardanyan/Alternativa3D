package alternativa.physics.rigid.constraints {
	
	import alternativa.physics.altphysics;
	import alternativa.physics.rigid.Body;
	import alternativa.physics.rigid.BodyState;
	import alternativa.physics.types.Vector3;
	
	use namespace altphysics;
	
	/**
	 * 
	 */
	public class MaxDistanceConstraint extends Constraint {
		// Первое тело ограничения
		altphysics var body1:Body;
		// Второе тело ограничения. Может быть null.
		altphysics var body2:Body;
		// Первая точка крепления в системе координат первого тела
		altphysics var r1:Vector3;
		// Вторая точка привязки в системе координат второго тела. В случае отсутствия второго тела, координаты задаются в мировой системе.
		altphysics var r2:Vector3;
		// Максимально допустимое расстояние между точками крепления
		altphysics var maxDistance:Number;
		// Радиус-вектор первой точки крепления, трансформированный без смещения в мировую систему координат
		altphysics var wr1:Vector3 = new Vector3();
		// Радиус-вектор второй точки крепления, трансформированный без смещения в мировую систему координат
		altphysics var wr2:Vector3 = new Vector3();
		// Минимальная скорость сближения для удовлетворения ограничения
		private var minClosingVel:Number;
		// Изменение относительной скорости на единицу импульса
		private var velByUnitImpulseN:Number;
		// Направление корректирующего импульса
		private var impulseDirection:Vector3 = new Vector3();
		
		// Вспомогательные переменные
		private static var _v:Vector3 = new Vector3();
		private static var _v1:Vector3 = new Vector3();
		private static var _v2:Vector3 = new Vector3();
		
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
			this.r1 = r1.vClone();
			this.r2 = r2.vClone();
			this.maxDistance = maxDistance;
		}
		
		/**
		 * @param dt
		 */
		override public function preProcess(dt:Number):void {
			// Вычислим расстояние между точками
			body1.baseMatrix.transformVector(r1, wr1);
			if (body2 != null) body2.baseMatrix.transformVector(r2, wr2);
			else wr2.vCopy(r2);
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
			
			var delta:Number = impulseDirection.vLength() - maxDistance;
			if (delta > 0) {
				satisfied = false;
				impulseDirection.vNormalize();
				minClosingVel = delta/(world.penResolutionSteps*dt);
				if (minClosingVel > world.maxPenResolutionSpeed) minClosingVel = world.maxPenResolutionSpeed;
				// Расчитываем изменение нормальной скорости на единицу нормального импульса
				// dV = b.invMass + ((invI * (r % n)) % r) * n
				velByUnitImpulseN = 0;
				if (body1.movable) velByUnitImpulseN += body1.invMass + _v.vCross2(wr1, impulseDirection).vTransformBy3(body1.invInertiaWorld).vCross(wr1).vDot(impulseDirection);
				if (body2 != null && body2.movable) velByUnitImpulseN += body2.invMass + _v.vCross2(wr2, impulseDirection).vTransformBy3(body2.invInertiaWorld).vCross(wr2).vDot(impulseDirection);
			} else satisfied = true;
		}
		
		/**
		 * @param dt
		 */
		override public function apply(dt:Number):void {
			if (satisfied) return;
			// Расчитываем проекцию скорости относительной скорости
			// sepVel = (V1 - V2)*normal
			// V1 = V1_c + w1%r1
			var state:BodyState = body1.state;
			_v1.vCross2(state.rotation, wr1);
			_v.x = state.velocity.x + _v1.x;
			_v.y = state.velocity.y + _v1.y;
			_v.z = state.velocity.z + _v1.z;
			// V2 = V2_c + w2%r2
			if (body2 != null) {
				state = body2.state;
				_v2.vCross2(state.rotation, wr2);
				_v.x -= state.velocity.x - _v2.x;
				_v.y -= state.velocity.y - _v2.y;
				_v.z -= state.velocity.z - _v2.z;
			}
			var closingVel:Number = _v.x*impulseDirection.x + _v.y*impulseDirection.y + _v.z*impulseDirection.z;
			if (closingVel > minClosingVel) return;
			var impulse:Number = (minClosingVel - closingVel)/velByUnitImpulseN;
			if (body1.movable) body1.applyRelPosWorldImpulse(wr1, impulseDirection, impulse);
			if (body2 != null && body2.movable) body2.applyRelPosWorldImpulse(wr2, impulseDirection, -impulse);
		}
		
	}
}