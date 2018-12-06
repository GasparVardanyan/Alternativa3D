package alternativa.physics3dintegration {
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.physics.types.SceneObject;

	/**
     * EN:
     * Simulation object. It combines the graphics and the physics. May be a non-physical object.
     *
     * RU:
	 * Объект симуляции. Он объединяет графику и физику. Может быть и не физическим объектом.
	 */
	public class SimulationObject extends Appearance {
		/**
         * EN:
         * Scene object.
         *
         * RU:
		 * Объект сцены.
		 */
		public var sceneObject:SceneObject;


		/**
         * EN:
         * Creates simulation object.
         * @param sceneObject object of physical scene
         * @param transform object's transformation
         *
         * RU:
		 * Создает объект симуляции.
		 * @param sceneObject объект физической сцены
		 * @param transform трансформация объекта
		 */
		public function SimulationObject(sceneObject:SceneObject = null, transform:Matrix4 = null) {
			if (sceneObject == null) {
				this.sceneObject = new SceneObject();
			} else {
				this.sceneObject = sceneObject;
			}
			this.transform = (transform == null ? Matrix4.IDENTITY : transform);
		}

		/**
         * EN:
         * Sets object transformation.
         * @param m4 transformation
         *
         * RU:
		 * Устанвливает трансформацию объекта.
		 * @param m4 трансформация
		 */
		override public function set transform(m4:Matrix4):void {
			super.transform = m4;
			sceneObject.transform = m4;
		}

		/**
         * EN:
         * Adds geometrical primitive. It is non-physical primitive.
         * @param collisionPrimitive geometrical primitive
         * @param localTransform local transformation
         *
         * RU:
		 * Добавляет геометрический примитив. Он является не физическим примитивом.
		 * @param collisionPrimitive геометрический примитив
		 * @param localTransform локальная трансформация
		 */
		public function addCollisionPrimitive(collisionPrimitive:CollisionPrimitive, localTransform:Matrix4 = null):void {
			if (localTransform != null) {
				collisionPrimitive.localTransform = localTransform.clone();
			}
			sceneObject.addPrimitive(collisionPrimitive);
			collisionPrimitive.calcDerivedData(_transform);
		}
	}
}
