package alternativa.physics3dintegration {
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.physics.types.Body;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;

	/**
     * EN:
     * Physic simulation object.
     *
     * RU:
	 * Физический объект симуляции.
	 */
	public class PhysicalSimObject extends SimulationObject {

		private static var _t:Matrix4 = new Matrix4();

		/**
         * EN:
         * The body.
         *
         * RU:
		 * Тело.
		 */
		public function get body():Body {
			return sceneObject as Body;
		}

		/**
         * EN:
         * Creates physic simulation object.
         * @param transform transformation object
         * @param isMovable mobility of the object. <code>true</code> - object is static, otherwise, <code>false</code>.
         *
         * RU:
		 * Создает физический объект симуляции.
		 * @param transform трансформация объекта
		 * @param isMovable подвижность объекта. true - если статический, иначе false.
		 */
		public function PhysicalSimObject(transform:Matrix4 = null, isMovable:Boolean = true) {
			super(new Body(), transform);
			body.movable = isMovable;
		}

		/**
		 * @inheritDoc
		 */
		override public function interpolate(t:Number):void {
			super.interpolate(t);
			if (body.movable) {
				body.interpolateToMatrixSLERP(t, _t);
				updatePositionAppearance(_t);
			}
		}

		/**
         * EN:
         * Adds physical primitive.
         * @param physicsPrimitive physical primitive
         * @param localTransform local transformation of primitive
         *
         * RU:
		 * Добавляет физический примитив.
		 * @param physicsPrimitive физический примитив
		 * @param localTransform локальная трансформация примитива
		 */
		public function addPhysicsPrimitive(physicsPrimitive:PhysicsPrimitive, localTransform:Matrix4 = null):void {
			var body:Body = this.body, prim:CollisionPrimitive = physicsPrimitive.primitive;
			body.addPhysicsPrimitive(physicsPrimitive, localTransform);
			prim.calcDerivedData(_transform);
			body.aabb.addBoundBox(prim.aabb);
		}

	}
}
