package {
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.physics3dintegration.SimulationObject;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionCylinder;
	import alternativa.physicsengine.math.Matrix4;

	import flash.display3D.Context3D;

	/**
	 * EN:
     * Non-physical object. It formed the flags.
     *
     * RU:
     * Не физический объект. В него складываются флаги.
	 */
	public class SimTargetTrigger extends SimulationObject {
		private var appearance:Mesh;
		private var trig:CollisionCylinder;
		private var onContact:Function;

		/**
         * EN:
         * @param transform Transformation
         * @param onContact Handler for the contact event.
         *
		 * RU:
		 * @param transform Трансформация.
		 * @param onContact Обработчик события на контакт с этим триггером.
		 */
		public function SimTargetTrigger(transform:Matrix4, onContact:Function) {
			super(null, transform);
			var r:Number = 1;
			var h:Number = 0.01;
			var localTransform:Matrix4 = new Matrix4();
			localTransform.setPositionXYZ(0, 0, h*0.5);
			appearance = MeshUtils.createCylinder(r, h, new VertexLightMaterial(0x555555));
			addAppearanceComponent(appearance, localTransform);
			trig = new CollisionCylinder(r, h, CollisionType.TRIGGER);
			addCollisionPrimitive(trig, localTransform);
			this.onContact = onContact;
			if (onContact != null) {
				/**
                 * EN:
                 * Add event listener for the trig.
                 * Event type - on contact.
                 * onContact - event handler.
                 * This is the user data class.
                 *
                 * RU:
				 * Добавление слушателя события для примитива trig.
				 * Тип события - на контакт.
				 * onContact - обработчик события.
				 * Данный класс является пользовательскими данными.
				 */
				trig.addEventListener(ContactEvent.OnContact, onContact, this);
			}
		}

		/**
         * EN:
         * Change color. Similarly, the setColor function of SimBall class.
         *
         * RU:
		 * Смена цвета. Аналогично функции setColor класса SimBall.
		 */
		public function setColor(context:Context3D, color:uint):void {
			var r:Resource;
			for each (r in appearance.getResources(false, BitmapTextureResource)) {
				r.dispose();
			}
			appearance.setMaterialToAllSurfaces(new VertexLightMaterial(color, 1.0));
			for each (r in appearance.getResources(false, BitmapTextureResource)) {
				r.upload(context);
			}
			/**
             * EN:
             * Remove event listener.
             * Remove the listener handled correctly:
             * - if it's not removed during event handling
             * - if it's removed during handling of another type event or another body.
             * - if remove listener, which is handled the event.
             *
             * RU:
			 * Удаления слушателя события.
			 * Корректно обрабатывается удаление слушателя, если:
			 * - удаляется не во время обработки события
			 * - удаляется во время обработки события другого типа или другого тела.
			 * - удаляется прослушиватель, который обрабатывает событие.
			 */
			trig.removeEventListener(ContactEvent.OnContact, onContact, this);
		}
	}
}
