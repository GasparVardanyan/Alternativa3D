package alternativa.physics3dintegration {
	import alternativa.physicsengine.math.Matrix4;

	/**
     * EN:
     * Static physical object.
     *
     * RU:
	 * Статический физический объект.
	 */
	public class StaticObject extends PhysicalSimObject {
		/**
         * EN:
         * Creates static physical object.
         * @param transform position in object space
         *
         * RU:
		 * Создает статический физический объект.
		 * @param transform положение в пространстве объекта
		 */
		public function StaticObject(transform:Matrix4 = null) {
			super(transform, false);
		}
		/**
		 * @inheritDoc
		 */
		override public function interpolate(t:Number):void {
		}
	}
}
