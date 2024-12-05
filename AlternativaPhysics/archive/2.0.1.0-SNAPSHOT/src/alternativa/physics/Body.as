package alternativa.physics {
	
	import alternativa.math.Matrix3;
	import alternativa.math.Matrix4;
	import alternativa.math.Quaternion;
	import alternativa.math.Vector3;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.IBodyCollisionPredicate;
	import alternativa.physics.collision.types.BoundBox;
	
	/**
	 * 
	 */
	public class Body {
		
		public static var linDamping:Number = 0.997;
		public static var rotDamping:Number = 0.997;
		
		// Идентификатор тела, уникальный в пределах мира
		public var id:int;
		// Имя тела
		public var name:String;
		// Мир, в котором находится тело
		public var world:PhysicsScene;
		// Флаг подвижности тела
		public var movable:Boolean = true;
		// Флаг указывает, может ли тело быть заморожено
		public var canFreeze:Boolean = false;
		
		public var freezeCounter:int;
		public var frozen:Boolean = false;

		public var useGravity:Boolean = true;
		
		// Ограничивающий бокс тела
		public var aabb:BoundBox = new BoundBox();
		// Предикат, через который тело получает сообщения о столкновениях
		public var postCollisionPredicate:IBodyCollisionPredicate;

		// Текущее состояние тела
		public var state:BodyState = new BodyState();
		// Предыдущее состояние тела
		public var prevState:BodyState = new BodyState();
		// Линейное ускорение тела на текущем шаге симуляции
		public var accel:Vector3 = new Vector3();
		// Угловое ускорение тела на текущем шаге симуляции
		public var angleAccel:Vector3 = new Vector3();
		// Физический материал тела
		public var material:BodyMaterial = new BodyMaterial();
		// Обратная масса тела
		public var invMass:Number = 1;
		// Обратная матрица тензора инерции в локальных координатах
		public var invInertia:Matrix3 = new Matrix3();
		// Обратная матрица тензора инерции  в мировых координатах
		public var invInertiaWorld:Matrix3 = new Matrix3();
		// Базисная матрица тела в мировых координатах
		public var baseMatrix:Matrix3 = new Matrix3();
		
		public const MAX_CONTACTS:int = 20;
		public var contacts:Vector.<Contact> = new Vector.<Contact>(MAX_CONTACTS);
		public var contactsNum:int;
		
		public var collisionPrimitives:CollisionPrimitiveList;
		
		// Аккумулятор сил
		public var forceAccum:Vector3 = new Vector3();
		// Аккумулятор моментов
		public var torqueAccum:Vector3 = new Vector3();

		// Внутренние переменные для избежания создания экземпляров
		private static var _r:Vector3 = new Vector3();
		private static var _f:Vector3 = new Vector3();
		private static var _q:Quaternion = new Quaternion();

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
				collisionPrimitives = new CollisionPrimitiveList();
			}
			collisionPrimitives.append(primitive);
			primitive.setBody(this, localTransform);
		}
		
		/**
		 * 
		 * @param primitive
		 */
		public function removeCollisionPrimitive(primitive:CollisionPrimitive):void {
			if (collisionPrimitives == null) return;
			primitive.setBody(null);
			collisionPrimitives.remove(primitive);
			if (collisionPrimitives.size == 0) {
				collisionPrimitives = null;
			}
		}

		/**
		 *
		 * @param t
		 * @param pos
		 * @param orientation
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
		 * @param t
		 * @param pos
		 * @param orientation
		 */
		public function interpolateSLERP(t:Number, pos:Vector3, orientation:Quaternion):void {
			var t1:Number = 1 - t;
			pos.x = prevState.pos.x*t1 + state.pos.x*t;
			pos.y = prevState.pos.y*t1 + state.pos.y*t;
			pos.z = prevState.pos.z*t1 + state.pos.z*t;
			orientation.slerp(prevState.orientation, state.orientation, t);
		}

		/**
		 *
		 * @param t
		 * @param m
		 */
		public function interpolateToMatrix(t:Number, m:Matrix4):void {
			var t1:Number = 1 - t;
			m.d = prevState.pos.x*t1 + state.pos.x*t;
			m.h = prevState.pos.y*t1 + state.pos.y*t;
			m.l = prevState.pos.z*t1 + state.pos.z*t;
			_q.w = prevState.orientation.w*t1 + state.orientation.w*t;
			_q.x = prevState.orientation.x*t1 + state.orientation.x*t;
			_q.y = prevState.orientation.y*t1 + state.orientation.y*t;
			_q.z = prevState.orientation.z*t1 + state.orientation.z*t;
			_q.normalize();
			_q.toMatrix4(m);
		}
		
		/**
		 *
		 * @param t
		 * @param m
		 */
		public function interpolateToMatrixSLERP(t:Number, m:Matrix4):void {
			var t1:Number = 1 - t;
			m.d = prevState.pos.x*t1 + state.pos.x*t;
			m.h = prevState.pos.y*t1 + state.pos.y*t;
			m.l = prevState.pos.z*t1 + state.pos.z*t;
			_q.slerp(prevState.orientation, state.orientation, t);
			_q.normalize();
			_q.toMatrix4(m);
		}

		/**
		 * 
		 * @param pos
		 */
		public function setPosition(pos:Vector3):void {
			state.pos.copy(pos);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setPositionXYZ(x:Number, y:Number, z:Number):void {
			state.pos.reset(x, y, z);
		}
		
		/**
		 * 
		 * @param vel
		 */
		public function setVelocity(vel:Vector3):void {
			state.velocity.copy(vel);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setVelocityXYZ(x:Number, y:Number, z:Number):void {
			state.velocity.reset(x, y, z);
		}

		/**
		 * 
		 * @param rot
		 */
		public function setRotation(rot:Vector3):void {
			state.rotation.copy(rot);
		}

		/**
		 * 
		 * @param x
		 * @param y
		 * @param z
		 */
		public function setRotationXYZ(x:Number, y:Number, z:Number):void {
			state.rotation.reset(x, y, z);
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
			forceAccum.add(f);
		}

		/**
		 * 
		 * @param fx
		 * @param fy
		 * @param fz
		 */
		public function addForceXYZ(fx:Number, fy:Number, fz:Number):void {
			forceAccum.x += fx;
			forceAccum.y += fy;
			forceAccum.z += fz;
		}

		/**
		 * 
		 * @param px
		 * @param py
		 * @param pz
		 * @param fx
		 * @param fy
		 * @param fz
		 */
		public function addWorldForceXYZ(px:Number, py:Number, pz:Number, fx:Number, fy:Number, fz:Number):void {
			forceAccum.x += fx;
			forceAccum.y += fy;
			forceAccum.z += fz;
			
			var pos:Vector3 = state.pos;
			var rx:Number = px - pos.x;
			var ry:Number = py - pos.y;
			var rz:Number = pz - pos.z;

//			var x:Number = ry*fz - rz*fy;
//			var y:Number = rz*fx - rx*fz;
//			var z:Number = rx*fy - ry*fx;
			
			torqueAccum.x += ry*fz - rz*fy;
			torqueAccum.y += rz*fx - rx*fz;
			torqueAccum.z += rx*fy - ry*fx;
		}

		/**
		 * @param pos
		 * @param f
		 */
		public function addWorldForce(pos:Vector3, force:Vector3):void {
			forceAccum.add(force);
			torqueAccum.add(_r.diff(pos, state.pos).cross(force));
		}

		/**
		 * @param pos
		 * @param f
		 */
		public function addWorldForceScaled(pos:Vector3, force:Vector3, scale:Number):void {
			_f.x = scale*force.x;
			_f.y = scale*force.y;
			_f.z = scale*force.z;
			forceAccum.add(_f);
			torqueAccum.add(_r.diff(pos, state.pos).cross(_f));
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
			forceAccum.add(_f);
			torqueAccum.add(_r.cross(_f));
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
			forceAccum.add(worldForce);
			torqueAccum.add(_r.cross(worldForce));
		}
		
		/**
		 * @param dt
		 */
		public function beforePhysicsStep(dt:Number):void {
		}

		/**
		 * @param t
		 */
		public function addTorque(t:Vector3):void {
			torqueAccum.add(t);
		}

		/**
		 * 
		 */
		internal function clearAccumulators():void {
			forceAccum.x = forceAccum.y =	forceAccum.z = 0;
			torqueAccum.x = torqueAccum.y = torqueAccum.z = 0;
		}
		
		/**
		 * 
		 */
		internal function calcAccelerations():void {
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
		public function calcDerivedData():void {
			// Вычисление базисной матрицы и обратного тензора инерции в мировых координатах
			state.orientation.toMatrix3(baseMatrix);
			invInertiaWorld.copy(invInertia).append(baseMatrix).prependTransposed(baseMatrix);
			if (collisionPrimitives != null) {
				aabb.infinity();
				var item:CollisionPrimitiveListItem = collisionPrimitives.head;
				while (item != null) {
					var primitive:CollisionPrimitive = item.primitive;
					primitive.transform.setFromMatrix3(baseMatrix, state.pos);
					if (primitive.localTransform != null) {
						primitive.transform.prepend(primitive.localTransform);
					}
					primitive.calculateAABB();
					aabb.addBoundBox(primitive.aabb);
					item = item.next;
				}
			}
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
		internal function restoreState():void {
			state.copy(prevState);
		}

		/**
		 * @param dt
		 */
		internal function integrateVelocity(dt:Number):void {
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
		internal function integratePosition(dt:Number):void {
			// pos = pos + v*t
			state.pos.x += state.velocity.x*dt;
			state.pos.y += state.velocity.y*dt;
			state.pos.z += state.velocity.z*dt;
			// q = q + 0.5*rot*q
			state.orientation.addScaledVector(state.rotation, dt);
		}
		
	}
}