package alternativaphysics.dynamics.character {
	import alternativaphysics.A3DBase;
	import alternativaphysics.collision.dispatch.A3DGhostObject;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import alternativaphysics.math.A3DVector3;

	import flash.geom.Vector3D;


	/** 
	* Контроллер персонажа.
	* @public 
	* @author redefy 
	*/
	public class A3DKinematicCharacterController extends A3DBase {
		
		private var m_shape : A3DCollisionShape;
		private var m_ghostObject : A3DGhostObject;
		private var m_walkDirection : A3DVector3;
		private var m_normalizedDirection : A3DVector3;


		/** 
		* Конструктор
		* @public 
		* @param ghostObject 
		* @param shape 
		* @param stepHeight 
		*/
		public function A3DKinematicCharacterController(ghostObject : A3DGhostObject, shape : A3DCollisionShape, stepHeight : Number) {
			m_ghostObject = ghostObject;
			m_shape = shape;

			pointer = bullet.createCharacterMethod(ghostObject.pointer, shape.pointer, stepHeight, 2);

			m_walkDirection = new A3DVector3(pointer + 60);
			m_normalizedDirection = new A3DVector3(pointer + 76);
		}


		/** 
		* 
		* @public (getter) 
		* @return A3DGhostObject 
		*/
		public function get ghostObject() : A3DGhostObject {
			return m_ghostObject;
		}


		/** 
		* Ссылка на шейп прикрепленный к персонажу.
		* @public (getter) 
		* @return A3DCollisionShape 
		*/
		public function get shape() : A3DCollisionShape {
			return m_shape;
		}

		/**
		 * Вызывается физическим миром для обновления позиции,поворота персонажа.
		 * @public
		 */
		public function updateTransform() : void {
			m_ghostObject.updateTransform();
		}


		/** 
		* 
		* @public (getter) 
		* @return Vector3D 
		*/
		public function get walkDirection() : Vector3D {
			return m_walkDirection.v3d;
		}
		
		/**
		 * set the walk direction and speed
		 */
		public function setWalkDirection(walkDirection : Vector3D) : void {
			useWalkDirection = true;
			m_walkDirection.v3d = walkDirection;
			var vec : Vector3D = walkDirection.clone();
			vec.normalize();
			m_normalizedDirection.v3d = vec;
		}

		/**
		 * set the walk direction and speed with time interval
		 */
		public function setVelocityForTimeInterval(velocity : Vector3D, timeInterval : Number) : void {
			useWalkDirection = false;
			m_walkDirection.v3d = velocity;
			var vec : Vector3D = velocity.clone();
			vec.normalize();
			m_normalizedDirection.v3d = vec;
			velocityTimeInterval = timeInterval;
		}

		/**
		 * Устанавливает позицию персонажа в мировых координатах.
		 * @public 
		 * @param origin Позиция персонажа
		 */
		public function warp(origin : Vector3D) : void {
			m_ghostObject.position = origin;
		}

		/**
		 * Находится ли персонаж в контакте с землей?
		 * @public 
		 */
		public function onGround() : Boolean {
			return (verticalVelocity == 0 && verticalOffset == 0);
		}

		/**
		 * Может ли персонаж прыгать? (находится на земле)
		 * @public 
		 */
		public function canJump() : Boolean {
			return onGround();
		}


		/** 
		* Заставляет персонажа прыгнуть
		* @public 
		* @return void 
		*/
		public function jump() : void {
			if (!canJump()) return;

			verticalVelocity = jumpSpeed;
			wasJumping = true;
		}

		/**
		 * The max slope determines the maximum angle that the controller can walk up.
		 * The slope angle is measured in radians.
		 */
		public function setMaxSlope(slopeRadians : Number) : void {
			maxSlopeRadians = slopeRadians;
			maxSlopeCosine = Math.cos(slopeRadians);
		}


		/** 
		* 
		* @public 
		* @return Number 
		*/
		public function getMaxSlope() : Number {
			return maxSlopeRadians;
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get fallSpeed() : Number {
			return memUser._mrf(pointer + 24);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set fallSpeed(v : Number) : void {
			memUser._mwf(pointer + 24, v);
		}


		/** 
		* Скорость прыжка.
		* @public (getter) 
		* @return Number 
		*/
		public function get jumpSpeed() : Number {
			return memUser._mrf(pointer + 28);
		}


		/** 
		* Скорость прыжка.
		* @public (setter) 
		* @param v Скорость прыжка.
		* @return void 
		*/
		public function set jumpSpeed(v : Number) : void {
			memUser._mwf(pointer + 28, v);
		}


		/** 
		* Максимальная высота прыжка
		* @public (getter) 
		* @return Number 
		*/
		public function get maxJumpHeight() : Number {
			return memUser._mrf(pointer + 32) * _scaling;
		}


		/** 
		* Максимальная высота прыжка
		* @public (setter) 
		* @param v высота прыжка
		* @return void 
		*/
		public function set maxJumpHeight(v : Number) : void {
			memUser._mwf(pointer + 32, v / _scaling);
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get gravity() : Number {
			return memUser._mrf(pointer + 44);
		}


		/** 
		* 
		* @public (setter) 
		* @param v 
		* @return void 
		*/
		public function set gravity(v : Number) : void {
			memUser._mwf(pointer + 44, v);
		}

		private function get wasJumping() : Boolean {
			return memUser._mru8(pointer + 169) == 1;
		}

		private function set wasJumping(v : Boolean) : void {
			memUser._mw8(pointer + 169, v ? 1 : 0);
		}

		private function get useWalkDirection() : Boolean {
			return memUser._mru8(pointer + 171) == 1;
		}

		private function set useWalkDirection(v : Boolean) : void {
			memUser._mw8(pointer + 171, v ? 1 : 0);
		}

		private function get velocityTimeInterval() : Number {
			return memUser._mrf(pointer + 172);
		}

		private function set velocityTimeInterval(v : Number) : void {
			memUser._mwf(pointer + 172, v);
		}


		private function get verticalVelocity() : Number {
			return memUser._mrf(pointer + 16);
		}

		private function set verticalVelocity(v : Number) : void {
			memUser._mwf(pointer + 16, v);
		}

		private function get verticalOffset() : Number {
			return memUser._mrf(pointer + 20);
		}

		private function set verticalOffset(v : Number) : void {
			memUser._mwf(pointer + 20, v);
		}

		private function get maxSlopeRadians() : Number {
			return memUser._mrf(pointer + 36);
		}

		private function set maxSlopeRadians(v : Number) : void {
			memUser._mwf(pointer + 36, v);
		}

		private function get maxSlopeCosine() : Number {
			return memUser._mrf(pointer + 40);
		}

		private function set maxSlopeCosine(v : Number) : void {
			memUser._mwf(pointer + 40, v);
		}
	}
}