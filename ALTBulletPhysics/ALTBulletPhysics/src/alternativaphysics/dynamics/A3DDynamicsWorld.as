package alternativaphysics.dynamics {
	import alternativaphysics.A3DBase;
	import alternativaphysics.collision.dispatch.A3DCollisionWorld;
	import alternativaphysics.collision.shapes.A3DBvhTriangleMeshShape;
   	import alternativaphysics.collision.shapes.A3DConvexHullShape;
   	import alternativaphysics.collision.shapes.A3DHeightfieldTerrainShape;
   	import alternativaphysics.collision.shapes.A3DCompoundShape;
	import alternativaphysics.data.A3DCollisionFlags;
	import alternativaphysics.data.A3DCollisionShapeType;
	import alternativaphysics.dynamics.character.A3DKinematicCharacterController;
	import alternativaphysics.dynamics.constraintsolver.A3DTypedConstraint;
	import alternativaphysics.dynamics.vehicle.A3DRaycastVehicle;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Vector3D;


	/** 
	* Самый важный класс в Bullet. Именно в этом классе происходит симуляция физической модели и расчет столкновений тел.
	* @public 
	* @author redefy 
	*/
	public class A3DDynamicsWorld extends A3DCollisionWorld {

		private static var currentDynamicsWorld : A3DDynamicsWorld;
		private var m_gravity : A3DVector3;
		private var m_rigidBodies : Vector.<A3DRigidBody>;
		private var m_nonStaticRigidBodies : Vector.<A3DRigidBody>;
		private var m_vehicles : Vector.<A3DRaycastVehicle>;
		private var m_characters : Vector.<A3DKinematicCharacterController>;
		private var m_constraints:Vector.<A3DTypedConstraint>;
		
		/** 
		* Инициализирует A3DDynamicsWorld, если до этого экземпляр этого класса не был уже создан. Выводит версию библиотеки.
		* @public 
		* @return A3DDynamicsWorld
		*/
		public static function getInstance() : A3DDynamicsWorld {
			if (!currentDynamicsWorld) {
				trace("version: AwayPhysics v0.68 (23-11-2011)");
				currentDynamicsWorld = new A3DDynamicsWorld();
			}
			return currentDynamicsWorld;
		}
		
		/** 
		* Конструктор
		* @public 
		*/
		public function A3DDynamicsWorld() {
			A3DBase.initialize();
			
			super();
			m_rigidBodies = new Vector.<A3DRigidBody>();
			m_nonStaticRigidBodies = new Vector.<A3DRigidBody>();
			m_vehicles = new Vector.<A3DRaycastVehicle>();
			m_characters = new Vector.<A3DKinematicCharacterController>();
			m_constraints = new Vector.<A3DTypedConstraint>();
		}

		/** 
		* Определяет алгоритм BroadPhase.
		* 
		* Динамическое AABB дерево.
		* При использовании этого алгоритма AABB автоматически подстраиваются под размеры мира и его содержимое. 
		* Этот алгоритм хорошо оптимизирован и является хорошим выбором для широкой фазы. 
		* Он подойдет для динамических миров, которые содержат много движущихся объектов. 
		* Добавление и удаление тел при использовании этого алгоритма происходит быстрее чем при SAP.
		* @public 
		* @return void
		*/
		public function initWithDbvtBroadphase() : void {
			pointer = bullet.createDiscreteDynamicsWorldWithDbvtMethod();
			m_gravity = new A3DVector3(pointer + 224);
			this.gravity = new Vector3D(0, 0, -10);
		}

		/** 
		* Определяет алгоритм BroadPhase.
		* 
		* Sweep and Prune (SAP) 
        * Этот алгоритм хорош для миров, в которых тела перемещаются мало или вообще не движутся. 
		* Использование этого алгоритма связано с одним ограничением. Мир должен быть фиксированным и известным заранее. 
		* @public 
		* @param worldAabbMin Минимальный размер AABB
		* @param worldAabbMaх Максимальный размер AABB
		* @return void
		*/
		public function initWithAxisSweep3(worldAabbMin : Vector3D, worldAabbMax : Vector3D) : void {
			pointer = bullet.createDiscreteDynamicsWorldWithAxisSweep3Method(worldAabbMin.x / _scaling, worldAabbMin.y / _scaling, worldAabbMin.z / _scaling, worldAabbMax.x / _scaling, worldAabbMax.y / _scaling, worldAabbMax.z / _scaling);
			m_gravity = new A3DVector3(pointer + 224);
			this.gravity = new Vector3D(0, 0, -10);
		}

		/**
		* Добавляет твердое тело в физический мир.
		* 
		* @public 
		* @param body Твердое тело
		* @return void
		*/
		public function addRigidBody(body : A3DRigidBody) : void {
			bullet.addBodyMethod(body.pointer);

			if (body.collisionFlags != A3DCollisionFlags.CF_STATIC_OBJECT) {
				if (m_nonStaticRigidBodies.indexOf(body) < 0) {
					m_nonStaticRigidBodies.push(body);
				}
			}
			if (m_rigidBodies.indexOf(body) < 0) {
				m_rigidBodies.push(body);
			}
			
			if(m_collisionObjects.indexOf(body) < 0){
				m_collisionObjects.push(body);
			}
		}

		/**
		 * add a rigidbody to physics world with group and mask
		 * refer to: http://bulletphysics.org/mediawiki-1.5.8/index.php/Collision_Filtering
		 */
		public function addRigidBodyWithGroup(body : A3DRigidBody, group : int, mask : int) : void {
			bullet.addBodyWithGroupMethod(body.pointer, group, mask);

			if (body.collisionFlags != A3DCollisionFlags.CF_STATIC_OBJECT) {
				if (m_nonStaticRigidBodies.indexOf(body) < 0) {
					m_nonStaticRigidBodies.push(body);
				}
			}
			if (m_rigidBodies.indexOf(body) < 0) {
				m_rigidBodies.push(body);
			}
			
			if(m_collisionObjects.indexOf(body) < 0){
				m_collisionObjects.push(body);
			}
		}

		/**
		* Удаляет твердое тело из физического мира.
		* 
		* @public 
		* @param body Твердое тело
		* @return void
		*/
		public function removeRigidBody(body : A3DRigidBody) : void {
			body.removeAllRays();
   	       if(body.shape.shapeType==A3DCollisionShapeType.TRIANGLE_MESH_SHAPE){
				A3DBvhTriangleMeshShape(body.shape).deleteBvhTriangleMeshShapeBuffer();
   	       }else if(body.shape.shapeType==A3DCollisionShapeType.CONVEX_HULL_SHAPE){
				A3DConvexHullShape(body.shape).deleteConvexHullShapeBuffer();
   	       }else if(body.shape.shapeType==A3DCollisionShapeType.HEIGHT_FIELD_TERRAIN){
				A3DHeightfieldTerrainShape(body.shape).deleteHeightfieldTerrainShapeBuffer();
   	       }else if(body.shape.shapeType==A3DCollisionShapeType.COMPOUND_SHAPE){
				A3DCompoundShape(body.shape).removeAllChildren();
   	       }
	 
			bullet.removeBodyMethod(body.pointer);

			if (m_nonStaticRigidBodies.indexOf(body) >= 0) {
				m_nonStaticRigidBodies.splice(m_nonStaticRigidBodies.indexOf(body), 1);
			}
			if (m_rigidBodies.indexOf(body) >= 0) {
				m_rigidBodies.splice(m_rigidBodies.indexOf(body), 1);
			}
			if(m_collisionObjects.indexOf(body) >= 0) {
				m_collisionObjects.splice(m_collisionObjects.indexOf(body), 1);
   	        }
		}
		
		/**
   	      * add a constraint to physics world
   	     */
		public function addConstraint(constraint : A3DTypedConstraint, disableCollisionsBetweenLinkedBodies : Boolean = false) : void {
			bullet.addConstraintMethod(constraint.pointer, disableCollisionsBetweenLinkedBodies ? 1 : 0);
			
			if (m_constraints.indexOf(constraint) < 0) {
				m_constraints.push(constraint);
			}
		}
		
		/**
   	     * remove a constraint from physics world
   	     */
		public function removeConstraint(constraint : A3DTypedConstraint) : void {
			bullet.removeConstraintMethod(constraint.pointer);
			
			if (m_constraints.indexOf(constraint) >= 0) {
				m_constraints.splice(m_constraints.indexOf(constraint), 1);
			}
		}
		
		/**
   	     * add a vehicle to physics world
   	     */
		public function addVehicle(vehicle : A3DRaycastVehicle) : void {
			bullet.addVehicleMethod(vehicle.pointer);

			if (m_vehicles.indexOf(vehicle) < 0) {
				m_vehicles.push(vehicle);
			}
		}
		
		/**
   	      * remove a vehicle from physics world
   	      */
		public function removeVehicle(vehicle : A3DRaycastVehicle) : void {
			removeRigidBody(vehicle.getRigidBody());
			bullet.removeVehicleMethod(vehicle.pointer);

			if (m_vehicles.indexOf(vehicle) >= 0) {
				m_vehicles.splice(m_vehicles.indexOf(vehicle), 1);
			}
		}
		
		/**
   	      * add a character to physics world
   	      */
		public function addCharacter(character : A3DKinematicCharacterController, group : int = 32, mask : int = -1) : void {
			bullet.addCharacterMethod(character.pointer, group, mask);

			if (m_characters.indexOf(character) < 0) {
				m_characters.push(character);
			}
			
			if(m_collisionObjects.indexOf(character.ghostObject) < 0){
				m_collisionObjects.push(character.ghostObject);
			}
		}
		
		/**
   	      * remove a character from physics world
   	      */
		public function removeCharacter(character : A3DKinematicCharacterController) : void {
			character.ghostObject.removeAllRays();
   	       if(character.shape.shapeType==A3DCollisionShapeType.CONVEX_HULL_SHAPE){
				A3DConvexHullShape(character.shape).deleteConvexHullShapeBuffer();
   	       }else if(character.shape.shapeType==A3DCollisionShapeType.COMPOUND_SHAPE){
				A3DCompoundShape(character.shape).removeAllChildren();
   	       }
			
			bullet.removeCharacterMethod(character.pointer);

			if (m_characters.indexOf(character) >= 0) {
				m_characters.splice(m_characters.indexOf(character), 1);
			}
			
			if(m_collisionObjects.indexOf(character.ghostObject) >= 0) {
				m_collisionObjects.splice(m_collisionObjects.indexOf(character.ghostObject), 1);
			}
		}
		
		/**
   	      * clear all objects from physics world
   	     */
   	     public function cleanWorld():void{
			while (m_constraints.length > 0){
				removeConstraint(m_constraints[0]);
			}
			m_constraints.length = 0;
   	       
   	       while (m_vehicles.length > 0){
				removeVehicle(m_vehicles[0]);
   	       }
   	       m_vehicles.length = 0;
   	       
   	       while (m_characters.length > 0){
				removeCharacter(m_characters[0]);
   	       }
   	       m_characters.length = 0;
   	       
   	       while (m_rigidBodies.length > 0){
				removeRigidBody(m_rigidBodies[0]);
   	       }
   	       m_nonStaticRigidBodies.length = 0;
				m_rigidBodies.length = 0;
   	       
   	       while (m_collisionObjects.length > 0){
				removeCollisionObject(m_collisionObjects[0]);
   	       }
   	       m_collisionObjects.length = 0;
   	     }

		/**
		* Гравитация которая действует в физическом мире.
		* 
		* @public (getter)
		* @return Vector3D
		*/
		public function get gravity() : Vector3D {
			return m_gravity.v3d;
		}

		/**
		* Гравитация которая действует в физическом мире.
		* 
		* @public (setter)
		* @param g Вектор гравитации
		* @return void
		*/
		public function set gravity(g : Vector3D) : void {
			m_gravity.v3d = g;
			for each (var body:A3DRigidBody in m_nonStaticRigidBodies) {
				body.gravity = g;
			}
		}
		
		/**
		* Возвращает все твердые тела.
		* 
		* @public (getter)
		* @return Vector.<A3DRigidBody>
		*/
		public function get rigidBodies() : Vector.<A3DRigidBody> {
			return m_rigidBodies;
		}

		/**
		* Возвращает все нестатические твердые тела.
		* 
		* @public (getter)
		* @return Vector.<A3DRigidBody>
		*/
		public function get nonStaticRigidBodies() : Vector.<A3DRigidBody> {
			return m_nonStaticRigidBodies;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return Vector. 
		*/
		public function get constraints() : Vector.<A3DTypedConstraint> {
			return m_constraints;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector. 
		*/
		public function get vehicles() : Vector.<A3DRaycastVehicle> {
			return m_vehicles;
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector.<A3DKinematicCharacterController> 
		*/
		public function get characters() : Vector.<A3DKinematicCharacterController> {
			return m_characters;
		}

		/**
		 * set physics world scaling
		 * refer to http://www.bulletphysics.org/mediawiki-1.5.8/index.php?title=Scaling_The_World
		 */
		public function set scaling(v : Number) : void {
			_scaling = v;
		}

		/**
		 * get physics world scaling
		 */
		public function get scaling() : Number {
			return _scaling;
		}

		/**
		 * get if implement object collision callback
		 */
		public function get collisionCallbackOn() : Boolean {
			return memUser._mru8(pointer + 247) == 1;
		}

		/**
		 * set this to true if need add a collision event to object, default is false
		 */
		public function set collisionCallbackOn(v : Boolean) : void {
			memUser._mw8(pointer + 247, v ? 1 : 0);
		}

	
		/** 
		* Обновляет физический мир
		* @public 
		* @param timeStep Вектор гравитации Время которое мы будем моделировать в мире в текущем обновлении мира. 
		* Обычно передается время прошедшее с последнего вызова метода Step()
		* @param maxSubSteps максимальное число подшагов, которые могут быть выполнены за одно обновление мира
		* @param fixedTimeStep фиксированное время шага в мире. Именно этого времени шага движок будет стараться придерживатьcя. 
		* Как правило, лучше оставить по умолчанию равным 1/60, то есть 60 ГЦ.
		* @return  void 
		*/
		public function step(timeStep : Number, maxSubSteps : int = 1, fixedTimeStep : Number = 1.0 / 60) : void {
			bullet.stepMethod(timeStep, maxSubSteps, fixedTimeStep);

			for each (var body:A3DRigidBody in m_nonStaticRigidBodies) {
				body.updateTransform();
			}

			for each (var vehicle:A3DRaycastVehicle in m_vehicles) {
				vehicle.updateWheelsTransform();
			}

			for each (var character:A3DKinematicCharacterController in m_characters) {
				character.updateTransform();
			}
		}
	}
}
