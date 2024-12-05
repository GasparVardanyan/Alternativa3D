package alternativa.physics.rigid {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.CollisionDetector;
	import alternativa.physics.collision.CollisionInfo;
	import alternativa.physics.collision.CollisionPoint;
	import alternativa.physics.collision.ICollider;
	import alternativa.physics.types.Vector3;
	
	
	public class RigidWorld {
		
		private static var lastBodyId:int;
		
		public var penResolutionSteps:int = 10;
		public var allowedPenetration:Number = 0.1;
		public var maxPenResolutionSpeed:Number = 0.5;
		public var collisionIterations:int = 5;
		public var contactIterations:int = 5;
		public var usePrediction:Boolean = false;
		public var gravity:Vector3 = new Vector3(0, 0, -9.8);
		
		private var collider:ICollider = new CollisionDetector();
		
		private var bodies:Vector.<Body> = new Vector.<Body>();
		private var bodyCount:int;
		
		public const MAX_COLLISIONS:int = 200; 
		public var collisions:Vector.<CollisionInfo> = new Vector.<CollisionInfo>(MAX_COLLISIONS, true);
		public var colNum:int;
		
		/**
		 * 
		 */
		public function RigidWorld() {
			for (var i:int = 0; i < MAX_COLLISIONS; i++) collisions[i] = new CollisionInfo();
		}
		
		/**
		 * 
		 * @param body
		 */
		public function addBody(body:Body):void {
			bodies[bodyCount++] = body;
			body.id = lastBodyId++;
		}
		
		/**
		 * 
		 * @param dt
		 */
		private function applyForces(dt:Number):void {
			for (var i:int = 0; i < bodyCount; i++) {
				var body:Body = bodies[i];
				body.calcAccelerations();
				if (body.invMass != 0) body.accel.add(gravity);
			}
		}
		
		/**
		 * 
		 * @param dt
		 */
		private function detectCollisions(dt:Number):void {
			var i:int;
			var j:int;
			var body:Body;
			
			for (i = 0; i < bodyCount; i++) {
				body = bodies[i];
				body.saveState();
				if (usePrediction) {
					body.integrateVelocity(dt);
					body.integratePosition(dt);
					body.calcDerivedData();
				}
			}
			
			colNum = 0;
			for (i = 0; i < bodyCount; i++) {
				for (j = i + 1; j < bodyCount; j++) {
					if (collider.collide(bodies[i], bodies[j], collisions[colNum])) colNum++;
				}
			}
			
			if (usePrediction) {
				for (i = 0; i < bodyCount; i++) {
					body = bodies[i];
					body.restoreState();
					body.calcDerivedData();
				}
			}
		}
		
		private var _r:Vector3 = new Vector3();
		private var _t:Vector3 = new Vector3();
		private var _v:Vector3 = new Vector3();
		private var _v1:Vector3 = new Vector3();
		private var _v2:Vector3 = new Vector3();
		/**
		 * 
		 */
		private function preProcessCollisions(dt:Number):void {
			for (var i:int = 0; i < colNum; i++) {
				var colInfo:CollisionInfo = collisions[i];
				var b1:Body = colInfo.body1;
				var b2:Body = colInfo.body2;
				colInfo.restitution = b1.material.restitution < b2.material.restitution ? b1.material.restitution : b2.material.restitution;
				colInfo.friction = b1.material.friction < b2.material.friction ? b1.material.friction : b2.material.friction;
				for (var j:int = 0; j < colInfo.pcount; j++) {
					var cp:CollisionPoint = colInfo.points[j];
					cp.accumImpulseN = 0;
					// Расчитываем изменение нормальной скорости на единицу нормального импульса
					// dV = b.invMass + ((invI * (r % n)) % r) * n
					cp.velByUnitImpulseN = 0;
					if (b1.invMass != 0) {
						cp.r1.diff(cp.pos, b1.state.pos);
						_v.cross2(cp.r1, colInfo.normal).transformBy3(b1.invInertiaWorld).cross(cp.r1);
						cp.velByUnitImpulseN += b1.invMass + _v.dot(colInfo.normal);
					}
					if (b2.invMass != 0) {
						cp.r2.diff(cp.pos, b2.state.pos);
						_v.cross2(cp.r2, colInfo.normal).transformBy3(b2.invInertiaWorld).cross(cp.r2);
						cp.velByUnitImpulseN += b2.invMass + _v.dot(colInfo.normal);
					}
					// Расчёт требуемой конечной скорости для упругого контакта
					calcSepVelocity(b1, b2, cp, _v);
					cp.normalVel = _v.dot(colInfo.normal);
					if (cp.normalVel < 0) cp.normalVel = - colInfo.restitution*cp.normalVel;
					// Скорость разделения неупругого контакта
					cp.minSepVel = cp.penetration > allowedPenetration ? (cp.penetration - allowedPenetration)/(penResolutionSteps*dt) : 0;
					if (cp.minSepVel > maxPenResolutionSpeed) cp.minSepVel = maxPenResolutionSpeed;
				}
			}
		}
		
		/**
		 * 
		 * @param dt
		 * @param forceInelastic
		 */
		private function processContacts(dt:Number, forceInelastic:Boolean):void {
			var iterNum:int = forceInelastic ? contactIterations : collisionIterations;
			
			for (var iter:int = 0; iter < iterNum; iter++) {
				for (var i:int = 0; i < colNum; i++) resolveCollision(collisions[i], forceInelastic);
			}
			
		}
		
		/**
		 * 
		 */
		private function resolveCollision(colInfo:CollisionInfo, forceInelastic:Boolean):void {
			var b1:Body = colInfo.body1;
			var b2:Body = colInfo.body2;
			var normal:Vector3 = colInfo.normal;
			var restitution:Number = forceInelastic ? 0 : colInfo.restitution;
			
			for (var i:int = 0; i < colInfo.pcount; i++) {
				var cp:CollisionPoint = colInfo.points[i];
				var newVel:Number = 0;
				calcSepVelocity(b1, b2, cp, _v);
				var sepVel:Number = _v.dot(colInfo.normal);
				
				newVel = cp.normalVel + cp.minSepVel;
				trace(cp.normalVel, cp.minSepVel);
				
//				if (forceInelastic) {
//					if (sepVel < cp.minSepVel) newVel = cp.minSepVel;
//					else newVel = 0;
//				} else {
//					newVel = cp.normalVel;
//				}
				var deltaVel:Number = newVel - sepVel;
				var impulse:Number = deltaVel/cp.velByUnitImpulseN;
				var accumImpulse:Number = cp.accumImpulseN + impulse;
				if (accumImpulse < 0) accumImpulse = 0;
				var deltaImpulse:Number = accumImpulse - cp.accumImpulseN;
				cp.accumImpulseN = accumImpulse;
				// Применяем импульс к телам
				if (b1.invMass != 0) b1.applyWorldImpulse(cp.pos, normal, deltaImpulse);
				if (b2.invMass != 0) b2.applyWorldImpulse(cp.pos, normal, -deltaImpulse);
				
				// Учёт силы трения
				calcSepVelocity(b1, b2, cp, _v);
				// Расчитываем изменение касательной скорости на единицу касательного импульса
				var tanSpeedByUnitImpulse:Number = 0;
				_v.addScaled(-_v.dot(colInfo.normal), colInfo.normal);
				var tanSpeed:Number = _v.length();
				if (tanSpeed < 0.001) continue;
				_t.copy(_v).normalize().reverse();
				// dV = b.invMass + ((invI * (r % t)) % r) * t
				if (b1.invMass != 0) {
					_v.cross2(cp.r1, _t).transformBy3(b1.invInertiaWorld).cross(cp.r1);
					tanSpeedByUnitImpulse += b1.invMass + _v.dot(_t);
				}
				if (b2.invMass != 0) {
					_v.cross2(cp.r2, _t).transformBy3(b2.invInertiaWorld).cross(cp.r2);
					tanSpeedByUnitImpulse += b2.invMass + _v.dot(_t);
				}
				
				var tanImpulse:Number = tanSpeed/tanSpeedByUnitImpulse;
				var max:Number = colInfo.friction*cp.accumImpulseN;
				if (max < 0) {
					if (tanImpulse < max) tanImpulse = max;
				} else {
					if (tanImpulse > max) tanImpulse = max;
				}
				// Применяем импульс к телам
				if (b1.invMass != 0) b1.applyWorldImpulse(cp.pos, _t, tanImpulse);
				if (b2.invMass != 0) b2.applyWorldImpulse(cp.pos, _t, -tanImpulse);
				
			}
		}
		
		/**
		 * 
		 * @param cp
		 * @param normal
		 * @return 
		 */
		private function calcSepVelocity(body1:Body, body2:Body, cp:CollisionPoint, result:Vector3):void {
			// sepVel = (V1 - V2)*normal
			result.x = result.y = result.z = 0;
			// V1 = V1_c + w1%r1
			if (body1.invMass != 0)	result.add(body1.state.velocity).add(_v1.cross2(body1.state.rotation, cp.r1));
			// V2 = V2_c + w2%r2
			if (body2.invMass != 0) result.subtract(body2.state.velocity).subtract(_v2.cross2(body2.state.rotation, cp.r2));
		}
		
		/**
		 * 
		 * @param dt
		 */
		private function intergateVelocities(dt:Number):void {
			for (var i:int = 0; i < bodyCount; i++) {
				(bodies[i] as Body).integrateVelocity(dt);
			}
		}
			
		/**
		 * 
		 * @param dt
		 */
		private function integratePositions(dt:Number):void {
			for (var i:int = 0; i < bodyCount; i++) {
				(bodies[i] as Body).integratePosition(dt);
			}
		}

		/**
		 * 
		 * @param dt
		 */
		public function runPhysics(dt:Number):void {
			applyForces(dt);
			detectCollisions(dt);
			preProcessCollisions(dt);			
			processContacts(dt, false);
			intergateVelocities(dt);
//			processContacts(dt, true);
			integratePositions(dt);
		}

	}
}