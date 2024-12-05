package alternativa.physics.rigid {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.IBodyCollisionPredicate;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.types.Matrix3;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Quaternion;
	import alternativa.physics.types.Vector3;

	use namespace altphysics;
	
	/**
	 * 
	 */
	public class Body {
		
		public static var linDamping:Number = 0.997;
		public static var rotDamping:Number = 0.997;
		
		public var name:String;
		public var movable:Boolean = true;
		public var canFreeze:Boolean = false;
		
		public var freezeCounter:int;
		public var frozen:Boolean = false;
		public var aabb:BoundBox = new BoundBox();
		public var postCollisionPredicate:IBodyCollisionPredicate;

		altphysics var id:int;
		// Мир, в котором находится тело
		altphysics var world:RigidWorld;
		// Текущее и предыдущее состояние тела. Промежуточное состояние вычисляется линейной интерполяцией.
		altphysics var state:BodyState = new BodyState();
		altphysics var prevState:BodyState = new BodyState();
		// Линейное и угловое ускорение тела на текущем шаге симуляции
		altphysics var accel:Vector3 = new Vector3();
		altphysics var angleAccel:Vector3 = new Vector3();
		// Материал тела
		altphysics var material:BodyMaterial = new BodyMaterial();
		
		altphysics var invMass:Number = 1;
		altphysics var invInertia:Matrix3 = new Matrix3();
		altphysics var invInertiaWorld:Matrix3 = new Matrix3();
		altphysics var baseMatrix:Matrix3 = new Matrix3();
		
		altphysics const MAX_CONTACTS:int = 20;
		altphysics var contacts:Vector.<Contact> = new Vector.<Contact>(MAX_CONTACTS);
		altphysics var contactsNum:int;
		
		altphysics var collisionPrimitives:Vector.<CollisionPrimitive>;
		altphysics var collisionPrimitivesNum:int;
		
		// Аккумулятор сил
		altphysics var forceAccum:Vector3 = new Vector3();
		// Аккумулятор моментов
		altphysics var torqueAccum:Vector3 = new Vector3();

		// Внутренние переменные для избежания создания экземпляров
		private static var _r:Vector3 = new Vector3();
		private static var _f:Vector3 = new Vector3();
		
		/**
		 * 
		 * @param invMass
		 * @param invInertia
		 */
		public function Body(invMass:Number, invInertia:Matrix3) {
			this.invMass = invMass;
			this.invInertia.copy(invInertia);
		}
		
		/**
		 * @param primitive
		 * @param localTransform
		 */
		public function addCollisionPrimitive(primitive:CollisionPrimitive, localTransform:Matrix4 = null):void {
			if (primitive == null) {
				throw new ArgumentError("Primitive cannot be null");
			}
			if (collisionPrimitives == null) {
				collisionPrimitives = new Vector.<CollisionPrimitive>();
			}
			collisionPrimitives[collisionPrimitivesNum++] = primitive;
			primitive.setBody(this, localTransform);
		}
		
		/**
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
		 * @param pos
		 */
		public function setPosition(pos:Vector3):void {
			state.pos.vCopy(pos);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setPositionXYZ(x:Number, y:Number, z:Number):void {
			state.pos.vReset(x, y, z);
		}
		
		/**
		 * 
		 * @param vel
		 */
		public function setVelocity(vel:Vector3):void {
			state.velocity.vCopy(vel);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setVelocityXYZ(x:Number, y:Number, z:Number):void {
			state.velocity.vReset(x, y, z);
		}

		/**
		 * 
		 * @param rot
		 */
		public function setRotation(rot:Vector3):void {
			state.rotation.vCopy(rot);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setRotationXYZ(x:Number, y:Number, z:Number):void {
			state.rotation.vReset(x, y, z);
		}
		
		/**
		 * 
		 * @param q
		 */
		public function setOrientation(q:Quaternion):void {
			state.orientation.copy(q);
		}
		
		/**
		 * @param r
		 * @param dir
		 * @param magnitude
		 */
		public function applyRelPosWorldImpulse(r:Vector3, dir:Vector3, magnitude:Number):void {
			var d:Number = magnitude*invMass;
			// Линейная часть
			state.velocity.x += d*dir.x;
			state.velocity.y += d*dir.y;
			state.velocity.z += d*dir.z;

			// Вращательная часть
			var x:Number = (r.y*dir.z - r.z*dir.y)*magnitude;
			var y:Number = (r.z*dir.x - r.x*dir.z)*magnitude;
			var z:Number = (r.x*dir.y - r.y*dir.x)*magnitude;
			
			state.rotation.x += invInertiaWorld.a*x + invInertiaWorld.b*y + invInertiaWorld.c*z;
			state.rotation.y += invInertiaWorld.e*x + invInertiaWorld.f*y + invInertiaWorld.g*z;
			state.rotation.z += invInertiaWorld.i*x + invInertiaWorld.j*y + invInertiaWorld.k*z;
		}
		
		/**
		 * @param f
		 */
		public function addForce(f:Vector3):void {
			forceAccum.vAdd(f);
		}
		
		/**
		 * @param pos
		 * @param f
		 */
		public function addWorldForce(pos:Vector3, force:Vector3):void {
			forceAccum.vAdd(force);
			torqueAccum.vAdd(_r.vDiff(pos, state.pos).vCross(force));
		}

		/**
		 * @param pos
		 * @param f
		 */
		public function addWorldForceScaled(pos:Vector3, force:Vector3, scale:Number):void {
			_f.x = scale*force.x;
			_f.y = scale*force.y;
			_f.z = scale*force.z;
			forceAccum.vAdd(_f);
			torqueAccum.vAdd(_r.vDiff(pos, state.pos).vCross(_f));
		}
		
		/**
		 * @param pos
		 * @param f
		 */
		public function addLocalForce(pos:Vector3, force:Vector3):void {
			// Трансформируем точку приложения в мировую систему координат
			baseMatrix.transformVector(pos, _r);
			// Трансформируем вектор силы в мировую систему
			baseMatrix.transformVector(force, _f);
			// Добавляем силу и момент
			forceAccum.vAdd(_f);
			torqueAccum.vAdd(_r.vCross(_f));
		}
		
		/**
		 * 
		 * @param localPos
		 * @param worldForce
		 */
		public function addWorldForceAtLocalPoint(localPos:Vector3, worldForce:Vector3):void {
			// Трансформируем точку приложения в мировую систему координат
			baseMatrix.transformVector(localPos, _r);
			// Добавляем силу и момент
			forceAccum.vAdd(worldForce);
			torqueAccum.vAdd(_r.vCross(worldForce));
		}
		
		/**
		 * @param dt
		 */
		public function addExternalForces(dt:Number):void {
		}

		/**
		 * @param t
		 */
		public function addTorque(t:Vector3):void {
			torqueAccum.vAdd(t);
		}

		/**
		 * 
		 */
		altphysics function clearAccumulators():void {
			forceAccum.x = forceAccum.y =	forceAccum.z = 0;
			torqueAccum.x = torqueAccum.y = torqueAccum.z = 0;
		}
		
		/**
		 * 
		 */
		altphysics function calcAccelerations():void {
			accel.x = forceAccum.x*invMass;
			accel.y = forceAccum.y*invMass;
			accel.z = forceAccum.z*invMass;
			angleAccel.x = invInertiaWorld.a*torqueAccum.x + invInertiaWorld.b*torqueAccum.y + invInertiaWorld.c*torqueAccum.z;
			angleAccel.y = invInertiaWorld.e*torqueAccum.x + invInertiaWorld.f*torqueAccum.y + invInertiaWorld.g*torqueAccum.z;
			angleAccel.z = invInertiaWorld.i*torqueAccum.x + invInertiaWorld.j*torqueAccum.y + invInertiaWorld.k*torqueAccum.z;
		}
		
		/**
		 * Вычисляет производные данные.
		 */
		altphysics function calcDerivedData():void {
			// Вычисление базисной матрицы и обратного тензора инерции в мировых координатах
			state.orientation.toMatrix3(baseMatrix);
			invInertiaWorld.copy(invInertia).append(baseMatrix).prependTransposed(baseMatrix);
			if (collisionPrimitives != null) {
				aabb.infinity();
				for (var i:int = 0; i < collisionPrimitivesNum; i++) {
					var primitive:CollisionPrimitive = collisionPrimitives[i];
					primitive.transform.setFromMatrix3(baseMatrix, state.pos);
					if (primitive.localTransform != null) {
						primitive.transform.prepend(primitive.localTransform);
					}
					primitive.calculateAABB();
					aabb.addBoundBox(primitive.aabb);
				}
			}
		}
		
		/**
		 * 
		 */
		altphysics function saveState():void {
			prevState.copy(state);
		}
		
		/**
		 * 
		 */
		altphysics function restoreState():void {
			state.copy(prevState);
		}

		/**
		 * @param dt
		 */
		altphysics function integrateVelocity(dt:Number):void {
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
		altphysics function integratePosition(dt:Number):void {
			// pos = pos + v*t
			state.pos.x += state.velocity.x*dt;
			state.pos.y += state.velocity.y*dt;
			state.pos.z += state.velocity.z*dt;
			// q = q + 0.5*rot*q
			state.orientation.addScaledVector(state.rotation, dt);
		}
		
	}
}