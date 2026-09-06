package alternativaphysics.collision.dispatch {
	import alternativa.engine3d.core.Object3D;

	import alternativaphysics.A3DBase;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import alternativaphysics.data.A3DCollisionFlags;
	import alternativaphysics.events.A3DEvent;
	import alternativaphysics.math.A3DTransform;
	import alternativaphysics.math.A3DVector3;
	import alternativaphysics.math.A3DMath;

	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.IEventDispatcher;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DCollisionObject extends A3DBase implements IEventDispatcher {

		/** 
		* 
		* @public (constant) 
		*/
		public static const ACTIVE_TAG : int = 1;

		/** 
		* 
		* @public (constant) 
		*/
		public static const ISLAND_SLEEPING : int = 2;

		/** 
		* 
		* @public (constant) 
		*/
		public static const WANTS_DEACTIVATION : int = 3;

		/** 
		* 
		* @public (constant) 
		*/
		public static const DISABLE_DEACTIVATION : int = 4;

		/** 
		* 
		* @public (constant) 
		*/
		public static const DISABLE_SIMULATION : int = 5;
		

		/** 
		* 
		* @private 
		*/
		private var m_shape : A3DCollisionShape;

		/** 
		* 
		* @private 
		*/
		private var m_skin : Object3D;

		/** 
		* 
		* @private 
		*/
		private var m_worldTransform : A3DTransform;

		/** 
		* 
		* @private 
		*/
		private var m_anisotropicFriction : A3DVector3;
		
		private var _rays:Vector.<A3DRay>;
		/** 
		* 
		* @private 
		*/
		private var _transform:Matrix3D = new Matrix3D();

		/** 
		* 
		* @private 
		*/
		private var _originScale:Vector3D = new Vector3D(1, 1, 1);

		/** 
		* 
		* @private 
		*/
		private var _dispatcher : EventDispatcher;


		/** 
		* 
		* @public 
		* @param ptr 
		* @param shape 
		* @param skin 
		*/
		public function A3DCollisionObject(shape : A3DCollisionShape, skin : Object3D, ptr : uint = 0) {
			m_shape = shape;
			m_skin = skin;

			if(ptr>0){
				pointer = ptr;
				m_worldTransform = new A3DTransform(ptr + 4);
				m_anisotropicFriction = new A3DVector3(ptr + 164);
			}else{
				pointer = bullet.createCollisionObjectMethod(this, shape.pointer);
   	         
				m_worldTransform = new A3DTransform(pointer + 4);
				m_anisotropicFriction = new A3DVector3(pointer + 164);
			}
			
			if (m_skin) {
				_originScale.setTo(m_skin.scaleX, m_skin.scaleY, m_skin.scaleZ);
			}
			
			_rays = new Vector.<A3DRay>();
			_dispatcher = new EventDispatcher(this);
		}


		/** 
		* 
		* @public (getter) 
		* @return A3DCollisionShape 
		*/
		public function get shape() : A3DCollisionShape {
			return m_shape;
		}


		/** 
		* 
		* @public (getter) 
		* @return Object3D 
		*/
		public function get skin() : Object3D {
			return m_skin;
		}
		

		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set skin(value:Object3D):void {
			m_skin = value;
			_originScale.setTo(m_skin.scaleX, m_skin.scaleY, m_skin.scaleZ);
		}

		/**
		 * update the transform of skin mesh
		 * called by dynamicsWorld
		 */
		public function updateTransform() : void {
			if (!m_skin) return;
			
			_transform.identity();
			_transform.appendScale(_originScale.x * m_shape.localScaling.x, _originScale.y * m_shape.localScaling.y, _originScale.z * m_shape.localScaling.z);
			_transform.append(m_worldTransform.transform);
			
			m_skin.matrix = _transform;
		}

		/**
		 * set the position in world coordinates
		 */
		public function set position(pos : Vector3D) : void {
			m_worldTransform.position = pos;
			updateTransform();
		}


		/** 
		* get the position in world coordinates
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get position() : Vector3D {
			return m_worldTransform.position;
		}
		

		/** 
		* set the position in x axis
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set x(v:Number):void {
			m_worldTransform.position = new Vector3D(v, m_worldTransform.position.y, m_worldTransform.position.z);
			updateTransform();
		}

		/** 
		* get the position in x axis
		* @public (getter) 
		* @return Number 
		*/
		public function get x():Number {
			 return m_worldTransform.position.x;
		}
		

		/** 
		* set the position in y axis
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set y(v:Number):void {
			m_worldTransform.position = new Vector3D(m_worldTransform.position.x, v, m_worldTransform.position.z);
			updateTransform();
		}

		/** 
		* get the position in y axis
		* @public (getter) 
		* @return Number 
		*/
		public function get y():Number {
			return m_worldTransform.position.y;
		}
		

		/** 
		* set the position in z axis
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set z(v:Number):void {
			m_worldTransform.position = new Vector3D(m_worldTransform.position.x, m_worldTransform.position.y, v);
			updateTransform();
		}

		/** 
		* get the position in z axis
		* @public (getter) 
		* @return Number 
		*/
		public function get z():Number {
			 return m_worldTransform.position.z;
		}

		/**
		 * set the euler angle in degrees
		 */
		public function set rotation(rot : Vector3D) : void {
			m_worldTransform.rotation = A3DMath.degrees2radiansV3D(rot);
			updateTransform();
		}


		/** 
		* get the euler angle in degrees
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get rotation() : Vector3D {
			return A3DMath.radians2degreesV3D(m_worldTransform.rotation);
		}
		

		/** 
		* set the angle of x axis in degree
		* @public (setter) 
		* @param angle 
		* @return void 
		*/
		public function set rotationX(angle:Number):void {
			m_worldTransform.rotation = new Vector3D(angle * A3DMath.DEGREES_TO_RADIANS, m_worldTransform.rotation.y, m_worldTransform.rotation.z);
			updateTransform();
		}

		/** 
		* get the angle of x axis in degree
		* @public (getter) 
		* @return Number 
		*/
		public function get rotationX():Number {
			return m_worldTransform.rotation.x * A3DMath.RADIANS_TO_DEGREES;
		}
		

		/** 
		* set the angle of y axis in degree
		* @public (setter) 
		* @param angle 
		* @return void 
		*/
		public function set rotationY(angle:Number):void {
			m_worldTransform.rotation = new Vector3D(m_worldTransform.rotation.x, angle * A3DMath.DEGREES_TO_RADIANS, m_worldTransform.rotation.z);
			updateTransform();
		}

		/** 
		* get the angle of y axis in degree
		* @public (getter) 
		* @return Number 
		*/
		public function get rotationY():Number {
			return m_worldTransform.rotation.y * A3DMath.RADIANS_TO_DEGREES;
		}
		

		/** 
		* set the angle of z axis in degree
		* @public (setter) 
		* @param angle 
		* @return void 
		*/
		public function set rotationZ(angle:Number):void {
			m_worldTransform.rotation = new Vector3D(m_worldTransform.rotation.x, m_worldTransform.rotation.y, angle * A3DMath.DEGREES_TO_RADIANS);
			updateTransform();
		}

		/** 
		* get the angle of z axis in degree
		* @public (getter) 
		* @return Number 
		*/
		public function get rotationZ():Number {
			 return m_worldTransform.rotation.z * A3DMath.RADIANS_TO_DEGREES;
		}
		
		/**
		 * set the scaling of collision shape
		 */
		public function set scale(sc:Vector3D):void {
			m_shape.localScaling = sc;
			updateTransform();
		}
		

		/** 
		* get the scaling of collision shape
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get scale():Vector3D {
			return m_shape.localScaling;
		}

		/**
		 * set the transform in world coordinates
		 */
		public function set transform(tr:Matrix3D) : void {
			m_worldTransform.transform = tr;
			m_shape.localScaling = tr.decompose()[2];
			updateTransform();
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Matrix3D 
		*/
		public function get transform():Matrix3D {
			return m_worldTransform.transform;
		}
		

		/** 
		* get the transform in world coordinates
		* @public (getter) 
		* @return A3DTransform 
		*/
		public function get worldTransform():A3DTransform {
			return m_worldTransform;
		}
		
		/**
		 * get the front direction in world coordinates
		 */
		public function get front():Vector3D {
			return m_worldTransform.basis.column2;
		}
		/**
		 * get the up direction in world coordinates
		 */
		public function get up():Vector3D {
			return m_worldTransform.basis.column3;
		}
		/**
		 * get the right direction in world coordinates
		 */
		public function get right():Vector3D {
			return m_worldTransform.basis.column1;
		}
		
		/**
   	    * add a ray in local space
   	    */
   	    public function addRay(from:Vector3D, to:Vector3D):void {
   	        var ptr:uint = bullet.addRayMethod(pointer, from.x/_scaling, from.y/_scaling, from.z/_scaling, to.x/_scaling, to.y/_scaling, to.z/_scaling);
   	       _rays.push(new A3DRay(from, to, ptr));
   	    }
   	     /**
   	      * remove a ray by index
   	      */
   	     public function removeRay(index:uint):void {
   	       if(index<_rays.length){
   	        bullet.removeRayMethod(_rays[index].pointer);
   	         _rays.splice(index, 1);
   	       }
   	     }
		 
		 /**
   	      * remove all rays in this collision object
   	      */
		public function removeAllRays():void {
			while (_rays.length > 0){
				removeRay(0);
			}
			_rays.length = 0;
   	    }
	 
   	     /**
   	      * get all rays
   	      */
   	    public function get rays():Vector.<A3DRay> {
   	       return _rays;
   	    }
		

		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get anisotropicFriction() : Vector3D {
			return m_anisotropicFriction.v3d;
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set anisotropicFriction(v : Vector3D) : void {
			m_anisotropicFriction.v3d = v;
			hasAnisotropicFriction = (v.x != 1 || v.y != 1 || v.z != 1) ? 1 : 0;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get friction() : Number {
			return memUser._mrf(pointer + 224);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set friction(v : Number) : void {
			memUser._mwf(pointer + 224, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get restitution() : Number {
			return memUser._mrf(pointer + 228);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set restitution(v : Number) : void {
			memUser._mwf(pointer + 228, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get hasAnisotropicFriction() : int {
			return memUser._mr32(pointer + 180);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set hasAnisotropicFriction(v : int) : void {
			memUser._mw32(pointer + 180, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get contactProcessingThreshold() : Number {
			return memUser._mrf(pointer + 184);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set contactProcessingThreshold(v : Number) : void {
			memUser._mwf(pointer + 184, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get collisionFlags() : int {
			return memUser._mr32(pointer + 204);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set collisionFlags(v : int) : void {
			memUser._mw32(pointer + 204, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get islandTag() : int {
			return memUser._mr32(pointer + 208);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set islandTag(v : int) : void {
			memUser._mw32(pointer + 208, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get companionId() : int {
			return memUser._mr32(pointer + 212);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set companionId(v : int) : void {
			memUser._mw32(pointer + 212, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get deactivationTime() : Number {
			return memUser._mrf(pointer + 220);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set deactivationTime(v : Number) : void {
			memUser._mwf(pointer + 220, v);
		}


		/** 
		* 
		* @public (getter) 
		* @return int 
		*/
		public function get activationState() : int {
			return memUser._mr32(pointer + 216);
		}


		/** 
		* 
		* @public (setter) 
		* @param newState 
		* @return void 
		*/
		public function set activationState(newState : int) : void {
			if (activationState != A3DCollisionObject.DISABLE_DEACTIVATION && activationState != A3DCollisionObject.DISABLE_SIMULATION) {
				memUser._mw32(pointer + 216, newState);
			}
		}


		/** 
		* 
		* @public 
		* @param newState 
		* @return void 
		*/
		public function forceActivationState(newState : int) : void {
			memUser._mw32(pointer + 216, newState);
		}


		/** 
		* 
		* @public 
		* @param forceActivation 
		* @return void 
		*/
		public function activate(forceActivation : Boolean = false) : void {
			if (forceActivation || (collisionFlags != A3DCollisionFlags.CF_STATIC_OBJECT && collisionFlags != A3DCollisionFlags.CF_KINEMATIC_OBJECT)) {
				this.activationState = A3DCollisionObject.ACTIVE_TAG;
				this.deactivationTime = 0;
			}
		}


		/** 
		* 
		* @public (getter) 
		* @return Boolean 
		*/
		public function get isActive() : Boolean {
			return (activationState != A3DCollisionObject.ISLAND_SLEEPING && activationState != A3DCollisionObject.DISABLE_SIMULATION);
		}
		
		/**
		 * reserved to distinguish Bullet's btCollisionObject, btRigidBody, btSoftBody, btGhostObject etc.
		 * the values defined by A3DCollisionObjectTypes
		 */
		public function get internalType() : int {
			return memUser._mr32(pointer + 232);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get hitFraction() : Number {
			return memUser._mrf(pointer + 240);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set hitFraction(v : Number) : void {
			memUser._mwf(pointer + 240, v);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get ccdSweptSphereRadius() : Number {
			return memUser._mrf(pointer + 244);
		}

		/**
		 * used to motion clamping
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Anti_tunneling_by_Motion_Clamping
		 */
		public function set ccdSweptSphereRadius(v : Number) : void {
			memUser._mwf(pointer + 244, v);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get ccdMotionThreshold() : Number {
			return memUser._mrf(pointer + 248);
		}

		/**
		 * used to motion clamping
		 * refer to http://bulletphysics.org/mediawiki-1.5.8/index.php/Anti_tunneling_by_Motion_Clamping
		 */
		public function set ccdMotionThreshold(v : Number) : void {
			memUser._mwf(pointer + 248, v);
		}


		/** 
		* 
		* @public 
		* @param type 
		* @param listener 
		* @param useCapture 
		* @param priority 
		* @param useWeakReference 
		* @return void 
		*/
		public function addEventListener(type : String, listener : Function, useCapture : Boolean = false, priority : int = 0, useWeakReference : Boolean = false) : void {
			this.collisionFlags |= A3DCollisionFlags.CF_CUSTOM_MATERIAL_CALLBACK;
			_dispatcher.addEventListener(type, listener, useCapture, priority);
		}


		/** 
		* 
		* @public 
		* @param evt 
		* @return Boolean 
		*/
		public function dispatchEvent(evt : Event) : Boolean {
			return _dispatcher.dispatchEvent(evt);
		}


		/** 
		* 
		* @public 
		* @param type 
		* @return Boolean 
		*/
		public function hasEventListener(type : String) : Boolean {
			return _dispatcher.hasEventListener(type);
		}


		/** 
		* 
		* @public 
		* @param type 
		* @param listener 
		* @param useCapture 
		* @return void 
		*/
		public function removeEventListener(type : String, listener : Function, useCapture : Boolean = false) : void {
			this.collisionFlags &= (~A3DCollisionFlags.CF_CUSTOM_MATERIAL_CALLBACK);
			_dispatcher.removeEventListener(type, listener, useCapture);
		}


		/** 
		* 
		* @public 
		* @param type 
		* @return Boolean 
		*/
		public function willTrigger(type : String) : Boolean {
			return _dispatcher.willTrigger(type);
		}

		/**
		 * this function just called by alchemy
		 */
		public function collisionCallback(mpt : uint, obj : A3DCollisionObject) : void {
			var pt : A3DManifoldPoint = new A3DManifoldPoint(mpt);
			var event : A3DEvent = new A3DEvent(A3DEvent.COLLISION_ADDED);
			event.manifoldPoint = pt;
			event.collisionObject = obj;

			this.dispatchEvent(event);
		}
		
		/**
   	     * this function just called by alchemy
   	     */
   	    public function rayCastCallback(mpt : uint, obj : A3DCollisionObject) : void {
 	       var pt : A3DManifoldPoint = new A3DManifoldPoint(mpt);
		   var event : A3DEvent = new A3DEvent(A3DEvent.RAY_CAST);
		   event.manifoldPoint = pt;
   	       event.collisionObject = obj;

		   this.dispatchEvent(event);
	    }
	}
}