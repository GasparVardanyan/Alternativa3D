package alternativaphysics.dynamics {
	import alternativa.engine3d.core.Object3D;

	import alternativaphysics.collision.dispatch.A3DCollisionObject;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import alternativaphysics.data.A3DCollisionFlags;
	import alternativaphysics.math.A3DMatrix3x3;
	import alternativaphysics.math.A3DVector3;
	import alternativaphysics.math.A3DMath;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DRigidBody extends A3DCollisionObject {

		/** 
		* 
		* @private 
		*/
		private var m_invInertiaTensorWorld : A3DMatrix3x3;

		/** 
		* 
		* @private 
		*/
		private var m_linearVelocity : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_angularVelocity : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_linearFactor : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_angularFactor : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_gravity : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_gravity_acceleration : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_invInertiaLocal : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_totalForce : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_totalTorque : A3DVector3;

		/** 
		* 
		* @private 
		*/
		private var m_invMass : A3DVector3;

		/**
		 * rigidbody is static if mass is zero, otherwise is dynamic
		 */
		public function A3DRigidBody(shape : A3DCollisionShape, skin : Object3D = null, mass : Number = 0) {
			pointer = bullet.createBodyMethod(this, shape.pointer, mass);
			super(shape, skin, pointer);

			m_invInertiaTensorWorld = new A3DMatrix3x3(pointer + 256);
			m_linearVelocity = new A3DVector3(pointer + 304);
			m_angularVelocity = new A3DVector3(pointer + 320);
			m_linearFactor = new A3DVector3(pointer + 340);
			m_angularFactor = new A3DVector3(pointer + 504);
			m_gravity = new A3DVector3(pointer + 356);
			m_gravity_acceleration = new A3DVector3(pointer + 372);
			m_invInertiaLocal = new A3DVector3(pointer + 388);
			m_totalForce = new A3DVector3(pointer + 404);
			m_totalTorque = new A3DVector3(pointer + 420);
			m_invMass = new A3DVector3(pointer + 520);
		}
		
		/**
		 * add force to the rigidbody's mass center
		 */
		public function applyCentralForce(force : Vector3D) : void {
			var vec : Vector3D = A3DMath.vectorMultiply(force, m_linearFactor.v3d);
			m_totalForce.v3d = vec.add(m_totalForce.v3d);
			activate();
		}

		/**
		 * add torque to the rigidbody
		 */
		public function applyTorque(torque : Vector3D) : void {
			var vec : Vector3D = A3DMath.vectorMultiply(torque, m_angularFactor.v3d);
			m_totalTorque.v3d = vec.add(m_totalTorque.v3d);
			activate();
		}

		/**
		 * add force to the rigidbody, rel_pos is the position in body's local coordinates
		 */
		public function applyForce(force : Vector3D, rel_pos : Vector3D) : void {
			applyCentralForce(force);
			rel_pos.scaleBy(1 / _scaling);
			var vec : Vector3D = A3DMath.vectorMultiply(force, m_linearFactor.v3d);
			applyTorque(rel_pos.crossProduct(vec));
		}

		/**
		 * add impulse to the rigidbody's mass center
		 */
		public function applyCentralImpulse(impulse : Vector3D) : void {
			var vec : Vector3D = A3DMath.vectorMultiply(impulse, m_linearFactor.v3d);
			vec.scaleBy(inverseMass);
			m_linearVelocity.v3d = vec.add(m_linearVelocity.v3d);
			activate();
		}

		/**
		 * add a torque impulse to the rigidbody
		 */
		public function applyTorqueImpulse(torque : Vector3D) : void {
			var tor : Vector3D = torque.clone();
			var vec : Vector3D = A3DMath.vectorMultiply(new Vector3D(m_invInertiaTensorWorld.row1.dotProduct(tor), m_invInertiaTensorWorld.row2.dotProduct(tor), m_invInertiaTensorWorld.row3.dotProduct(tor)), m_angularFactor.v3d);
			m_angularVelocity.v3d = vec.add(m_angularVelocity.v3d);
			activate();
		}

		/**
		 * add a impulse to the rigidbody, rel_pos is the position in body's local coordinates
		 */
		public function applyImpulse(impulse : Vector3D, rel_pos : Vector3D) : void {
			if (inverseMass != 0) {
				applyCentralImpulse(impulse);
				rel_pos.scaleBy(1 / _scaling);
				var vec : Vector3D = A3DMath.vectorMultiply(impulse, m_linearFactor.v3d);
				applyTorqueImpulse(rel_pos.crossProduct(vec));
			}
		}

		/**
		 * clear all force and torque to zero
		 */
		public function clearForces() : void {
			m_totalForce.v3d = new Vector3D();
			m_totalTorque.v3d = new Vector3D();
		}

		/**
		 * set the gravity of this rigidbody
		 */
		public function set gravity(acceleration : Vector3D) : void {
			if (inverseMass != 0) {
				var vec : Vector3D = acceleration.clone();
				vec.scaleBy(1 / inverseMass);
				m_gravity.v3d = vec;
				activate();
			}
			m_gravity_acceleration.v3d = acceleration;
		}


		/** 
		* 
		* @public (getter) 
		* @return Matrix3D 
		*/
		public function get invInertiaTensorWorld() : Matrix3D {
			return m_invInertiaTensorWorld.m3d;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get linearVelocity() : Vector3D {
			return m_linearVelocity.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set linearVelocity(v : Vector3D) : void {
			m_linearVelocity.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get angularVelocity() : Vector3D {
			return m_angularVelocity.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set angularVelocity(v : Vector3D) : void {
			m_angularVelocity.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get linearFactor() : Vector3D {
			return m_linearFactor.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set linearFactor(v : Vector3D) : void {
			m_linearFactor.v3d = v;

			var vec : Vector3D = v.clone();
			vec.scaleBy(inverseMass);
			m_invMass.v3d = vec;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get angularFactor() : Vector3D {
			return m_angularFactor.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set angularFactor(v : Vector3D) : void {
			m_angularFactor.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get gravity() : Vector3D {
			return m_gravity.v3d;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get gravityAcceleration() : Vector3D {
			return m_gravity_acceleration.v3d;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get invInertiaLocal() : Vector3D {
			return m_invInertiaLocal.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set invInertiaLocal(v : Vector3D) : void {
			m_invInertiaLocal.v3d = v;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get totalForce() : Vector3D {
			return m_totalForce.v3d;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get totalTorque() : Vector3D {
			return m_totalTorque.v3d;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get mass() : Number {
			return 1 / inverseMass;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set mass(v : Number) : void {
			bullet.setBodyMassMethod(pointer, v);
   	        var physicsWorld:A3DDynamicsWorld = A3DDynamicsWorld.getInstance();
			if (v == 0) {
				if (physicsWorld.nonStaticRigidBodies.indexOf(this) >= 0) {
					physicsWorld.nonStaticRigidBodies.splice(physicsWorld.nonStaticRigidBodies.indexOf(this), 1);
				}
			} else {
				if (physicsWorld.nonStaticRigidBodies.indexOf(this) < 0) {
					physicsWorld.nonStaticRigidBodies.push(this);
				}
			}

			activate();
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get inverseMass() : Number {
			return memUser._mrf(pointer + 336);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set inverseMass(v : Number) : void {
			memUser._mwf(pointer + 336, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get linearDamping() : Number {
			return memUser._mrf(pointer + 436);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set linearDamping(v : Number) : void {
			memUser._mwf(pointer + 436, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get angularDamping() : Number {
			return memUser._mrf(pointer + 440);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set angularDamping(v : Number) : void {
			memUser._mwf(pointer + 440, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get linearSleepingThreshold() : Number {
			return memUser._mrf(pointer + 464);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set linearSleepingThreshold(v : Number) : void {
			memUser._mwf(pointer + 464, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get angularSleepingThreshold() : Number {
			return memUser._mrf(pointer + 468);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set angularSleepingThreshold(v : Number) : void {
			memUser._mwf(pointer + 468, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get rigidbodyFlags() : int {
			return memUser._mr32(pointer + 496);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set rigidbodyFlags(v : int) : void {
			memUser._mw32(pointer + 496, v);
		}
	}
}