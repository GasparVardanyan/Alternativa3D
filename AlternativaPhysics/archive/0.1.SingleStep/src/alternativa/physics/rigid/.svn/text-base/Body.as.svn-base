package alternativa.physics.rigid {
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Quaternion;
	import alternativa.physics.types.Vector3;
	
	
	public class Body {
		
		public static const BOX:int = 1;
		public static const PLANE:int = 2;
		public static const SPHERE:int = 3;
		
		public static var linDamping:Number = 0.995;
		public static var rotDamping:Number = 0.995;
		
		public var id:int;
		public var type:int;
		public var name:String;
		// Текущее и предыдущее состояние тела. Промежуточное состояние вычисляется линейной интерполяцией.
		public var state:BodyState = new BodyState();
		public var prevState:BodyState = new BodyState();
		// Линейное и угловое ускорение тела на текущем шаге симуляции
		public var accel:Vector3 = new Vector3();
		public var angleAccel:Vector3 = new Vector3();
		// Материал тела
		public var material:BodyMaterial = new BodyMaterial();
		
		public var invMass:Number = 1;
		public var invInertia:Matrix3 = new Matrix3();
		public var invInertiaWorld:Matrix3 = new Matrix3();
		public var baseMatrix:Matrix3 = new Matrix3();
		public var transform:Matrix4 = new Matrix4();
		
		private var forceAccum:Vector3 = new Vector3();
		private var torqueAccum:Vector3 = new Vector3();
		
		/**
		 * 
		 * @param type
		 * @param invMass
		 * @param invInertia
		 */
		public function Body(type:int, invMass:Number, invInertia:Matrix3) {
			this.type = type;
			this.invMass = invMass;
			this.invInertia.copy(invInertia);
		}
		
		/**
		 * 
		 */
		public function clearAccumulators():void {
			forceAccum.reset();
			torqueAccum.reset();
		}
		
		/**
		 * 
		 * @param f
		 */
		public function addForce(f:Vector3):void {
			forceAccum.add(f);
		}
		
		/**
		 * 
		 * @param t
		 */
		public function addTorque(t:Vector3):void {
			torqueAccum.add(t);
		}

		/**
		 * 
		 */
		public function calcAccelerations():void {
			calcDerivedData();
			
			accel.x = forceAccum.x*invMass;
			accel.y = forceAccum.y*invMass;
			accel.z = forceAccum.z*invMass;
			
			invInertiaWorld.transformVector(torqueAccum, angleAccel);
		}
		
		/**
		 * Вычисление вспомогательной информации.
		 */
		public function calcDerivedData():void {
			// Вычисление базисной матрицы и обратного тензора инерции в мировых координатах
			state.orientation.toMatrix3(baseMatrix);
			invInertiaWorld.copy(invInertia).append(baseMatrix).prepend(baseMatrix.transpose());
			transform.setFromMatrix3(baseMatrix.transpose(), state.pos);
		}

		/**
		 * 
		 * @param t
		 * @param result
		 */
		public function interpolate(t:Number, pos:Vector3, orientation:Quaternion):void {
			var t1:Number = 1 - t;
			pos.x = prevState.pos.x*t1 + state.pos.x*t;
			pos.y = prevState.pos.y*t1 + state.pos.y*t;
			pos.z = prevState.pos.z*t1 + state.pos.z*t;
			orientation.w = prevState.orientation.w*t1 + state.orientation.w*t;
			orientation.x = prevState.orientation.x*t1 + state.orientation.x*t;
			orientation.y = prevState.orientation.y*t1 + state.orientation.y*t;
			orientation.z = prevState.orientation.z*t1 + state.orientation.z*t;
		}
		
		/**
		 * 
		 */
		public function saveState():void {
			prevState.copy(state);
		}
		
		/**
		 * 
		 */
		public function restoreState():void {
			state.copy(prevState);
		}

		/**
		 * 
		 * @param dt
		 */
		public function integrateVelocity(dt:Number):void {
			// v = v + a*t
			state.velocity.x += accel.x*dt;
			state.velocity.y += accel.y*dt;
			state.velocity.z += accel.z*dt;
			// rot = rot + eps*t
			state.rotation.x += angleAccel.x*dt;
			state.rotation.y += angleAccel.y*dt;
			state.rotation.z += angleAccel.z*dt;

			state.velocity.x *= linDamping;
			state.velocity.y *= linDamping;
			state.velocity.z *= linDamping;
			
			state.rotation.x *= rotDamping;
			state.rotation.y *= rotDamping;
			state.rotation.z *= rotDamping;
		}

		/**
		 * 
		 */
		public function integratePosition(dt:Number):void {
			// pos = pos + v*t
			state.pos.x += state.velocity.x*dt;
			state.pos.y += state.velocity.y*dt;
			state.pos.z += state.velocity.z*dt;
			// q = q + 0.5*rot*q
			state.orientation.addScaledVector(state.rotation, dt);
		}
		
		public function setPosition(pos:Vector3):void {
			state.pos.copy(pos);
		}

		public function setPositionXYZ(x:Number, y:Number, z:Number):void {
			state.pos.reset(x, y, z);
		}
		
		public function setVelocity(vel:Vector3):void {
			state.velocity.copy(vel);
		}

		public function setVelocityXYZ(x:Number, y:Number, z:Number):void {
			state.velocity.reset(x, y, z);
		}

		public function setRotation(rot:Vector3):void {
			state.rotation.copy(rot);
		}

		public function setRotationXYZ(x:Number, y:Number, z:Number):void {
			state.rotation.reset(x, y, z);
		}
		
		public function setOrientation(q:Quaternion):void {
			state.orientation.copy(q);
		}
		
		private var _v:Vector3 = new Vector3();
		public function applyWorldImpulse(r:Vector3, dir:Vector3, magnitude:Number):void {
			var d:Number = magnitude*invMass;
			// Линейная часть
			state.velocity.x += d*dir.x;
			state.velocity.y += d*dir.y;
			state.velocity.z += d*dir.z;
			// Вращательная часть
			var rx:Number = r.x - state.pos.x;
			var ry:Number = r.y - state.pos.y;
			var rz:Number = r.z - state.pos.z;
			_v.x = (ry*dir.z - rz*dir.y)*magnitude;
			_v.y = (rz*dir.x - rx*dir.z)*magnitude;
			_v.z = (rx*dir.y - ry*dir.x)*magnitude;
			_v.transformBy3(invInertiaWorld);
			state.rotation.x += _v.x;
			state.rotation.y += _v.y;
			state.rotation.z += _v.z;
		}

	}
}