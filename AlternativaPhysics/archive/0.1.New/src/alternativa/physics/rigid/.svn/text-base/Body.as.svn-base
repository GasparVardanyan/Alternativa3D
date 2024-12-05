package alternativa.physics.rigid {
	
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	import alternativa.types.Quaternion;
	
	/**
	 * Класс представляет твёрдое тело.
	 */
	public class Body {
		public var name:String;
		// Текущее и предыдущее состояние тела. Промежуточное состояние вычисляется линейной интерполяцией.
		public var state:BodyState = new BodyState();
		public var prevState:BodyState = new BodyState();
		// Линейное и угловое ускорение тела на текущем шаге симуляции
		public var accel:Point3D = new Point3D();
		public var angleAccel:Point3D = new Point3D();
		// Материал тела
		public var material:BodyMaterial = new BodyMaterial();
		// Постоянное ускорение, действующее на тело
		public var acceleration:Point3D = new Point3D();
		
		public var invMass:Number = 1;
		public var invInertia:Matrix3D = new Matrix3D();
		public var invInertiaWorld:Matrix3D = new Matrix3D();
		public var baseMatrix:Matrix3D = new Matrix3D();
		
		public var forceAccum:Point3D = new Point3D();
		public var torqueAccum:Point3D = new Point3D();
		
		public var velAux:Point3D = new Point3D();
		public var rotAux:Point3D = new Point3D();
		
		public var next:Body;

		/**
		 * 
		 */
		public function Body() {
			setParams(1, new Matrix3D());
		}
		
		/**
		 * 
		 * @param mass
		 * @param inertia
		 */
		public function setParams(mass:Number, inertia:Matrix3D):void {
			invMass = 1/mass;
			invInertia.copy(inertia);
			invInertia.invert();
		}

		/**
		 * 
		 * @param invMass
		 * @param invInertia
		 */
		public function setInvParams(invMass:Number, invInertia:Matrix3D):void {
			this.invMass = invMass;
			this.invInertia.copy(invInertia);
		}
		
		/**
		 * 
		 */
		public function calcAccelerations():void {
			calcDerivedData();
			
			accel.x = forceAccum.x*invMass;
			accel.y = forceAccum.y*invMass;
			accel.z = forceAccum.z*invMass;
			accel.add(acceleration);
			
			invInertiaWorld.deltaTransformVector(torqueAccum, angleAccel);
		}
		
		/**
		 * 
		 * @param dt
		 */
		public function integrateFull(dt:Number):void {
			// v = v + a*t
			var v:Point3D = state.velocity;
			v.x += accel.x*dt;
			v.y += accel.y*dt;
			v.z += accel.z*dt;
			// pos = pos + v*t + 0.5*a*t*t
			var k:Number = 0.5*dt*dt;
			state.pos.x += v.x*dt;// + accel.x*k;
			state.pos.y += v.y*dt;// + accel.y*k;
			state.pos.z += v.z*dt;// + accel.z*k;
			// rot = rot + eps*t
			state.rotation.x += angleAccel.x*dt;
			state.rotation.y += angleAccel.y*dt;
			state.rotation.z += angleAccel.z*dt;
			// q = q + 0.5*rot*q
			state.orientation.addScaledVector(state.rotation, dt);
			state.orientation.normalize();
			
			state.velocity.multiply(0.995);
			state.rotation.multiply(0.995);
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

			state.velocity.multiply(0.995);
			state.rotation.multiply(0.995);
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
			state.orientation.normalize();
		}
		
		/**
		 * Вычисление вспомогательной информации.
		 */
		public function calcDerivedData():void {
			// Вычисление базисной матрицы и обратного тензора инерции в мировых координатах
			state.orientation.toMatrix3D(baseMatrix);
			invInertiaWorld.copy(invInertia);
			invInertiaWorld.combine(baseMatrix);
			baseMatrix.transpose();
			invInertiaWorld.inverseCombine(baseMatrix);
			baseMatrix.transpose();
		}
		
		/**
		 * 
		 * @param t
		 * @param result
		 */
		public function interpolate(t:Number, pos:Point3D, orientation:Quaternion):void {
			var t1:Number = 1 - t;
			pos.x = prevState.pos.x*t1 + state.pos.x*t;
			pos.y = prevState.pos.y*t1 + state.pos.y*t;
			pos.z = prevState.pos.z*t1 + state.pos.z*t;
			orientation.w = prevState.orientation.w*t1 + state.orientation.w*t;
			orientation.x = prevState.orientation.x*t1 + state.orientation.x*t;
			orientation.y = prevState.orientation.y*t1 + state.orientation.y*t;
			orientation.z = prevState.orientation.z*t1 + state.orientation.z*t;
		}
		
		public function toString():String {
			return "[Body name=" + name + "]";
		}
	}
}