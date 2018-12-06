package alternativa.physics3dintegration {
	import alternativa.physicsengine.math.Matrix3;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;

	/**
     * EN:
     * Dynamic object.
     *
     * RU:
	 * Динамический объект.
	 */
	public class DynamicObject extends PhysicalSimObject {
		/**
         * EN:
         * Creates a dynamic physical object.
         * @param transform object's position
         * @param velocity velocity
         * @param invTensorInertia inverted inertia tensor. If it is null then it will be calculated automatically.
         * @param mass mass
         *
         * RU:
		 * Создает динамический физический объект.
		 * @param transform положение в пространстве объекта
		 * @param velocity скорость
		 * @param invTensorInertia обратный тензор инерции. Если null, будет высчетан автоматически.
		 * @param mass масса тела
		 */
		public function DynamicObject(transform:Matrix4 = null, velocity:Vector3 = null, invTensorInertia:Matrix3 = null, mass:Number = Number.MAX_VALUE) {
			super(transform, true);
			if (velocity == null) velocity = Vector3.ZERO;
			if (invTensorInertia) {
				body.setInvertTensorInertia(invTensorInertia, Vector3.ZERO, mass);
			}
			body.setVelocity(velocity);
		}
	}
}
