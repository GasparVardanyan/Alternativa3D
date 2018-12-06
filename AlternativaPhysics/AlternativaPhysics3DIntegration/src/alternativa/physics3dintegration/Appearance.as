package alternativa.physics3dintegration {
	import alternativa.engine3d.core.Object3D;
	import alternativa.physicsengine.math.Matrix4;
	
	import flash.events.EventDispatcher;

	/**
     * EN:
     * Appearance.<br>
     * Specifies the object appearance.
     *
     * RU:
	 * Внешний вид.<br>
	 * Задает как объект выглядит.
	 */
	public class Appearance extends EventDispatcher{
		/**
         * EN:
         * Components of the appearance.
         *
         * RU:
		 * Составляющие внешнего вида.
		 */
		public var appearanceComponents:Vector.<AppearanceComponent> = new Vector.<AppearanceComponent>();
		/**
         * EN:
         * Transformation of the appearance.
         *
         * RU:
		 * Трансформация внешнего вида.
		 */
		protected var _transform:Matrix4 = new Matrix4();

		/**
		 * @private
         * EN: Object visibility.
		 * RU: Видимость объекта.
		 */
		private var _visible:Boolean;

		/**
         * EN:
         * Adds a component of appearance with specidied local transformation.
         * @param appearanceObject <code>Object3d</code> components of appearance
         * @param localTransform local transformation in appearance coordinates
         * Transformation of <code>Object3d</code> is not taken into account.
         *
         * RU:
		 * Добавляет компоненту внешнего вида c заданной локальной трансформацией.
		 * @param appearanceObject <code>Object3d</code>-компоненты внешнего вида
		 * @param localTransform локальная трансформация в системе координат всего внешнего вида
		 * Трансформация <code>Object3d</code> не учитывается.
		 *
		 */
		public function addAppearanceComponent(appearanceObject:Object3D, localTransform:Matrix4 = null):void {
			var component:AppearanceComponent = new AppearanceComponent(appearanceObject, localTransform);
			appearanceComponents.push(component);
			component.transform = transform;
		}

		/**
         * EN:
         * Interpolates the object appearance. Does not change the transformation of the body.
         * @param t relative time from 0 to 1. <br>
         * 0 - previous simulation step.<br>
         * 1 - current simulation step.
         *
         * RU:
		 * Интерполирует внешний вид объекта. Не изменяет трансформацию тела.
		 * @param t относительное время от 0 до 1. <br>
		 * 0 - предыдущий шаг симуляции.<br>
		 * 1 - текущий шаг симуляции.
		 */
		public function interpolate(t:Number):void {
		}

		/**
         * EN:
         * Transformation of appearance.
         *
         * RU:
		 * Трансформация внешнего вида.
		 */
		public function get transform():Matrix4 {
			return _transform;
		}

		public function set transform(m4:Matrix4):void {
			_transform.copy(m4);
			updatePositionAppearance(m4);
		}

		/**
         * EN:
         * Updates position of appearance.<br>
         * Transformations is not changed. Use on interpolation for smooth rendering.
         * @param m4 transformation of appearance
         *
         * RU:
		 * Обновляет положение внешнего вида.<br>
		 * Трансформация не изменяется. Используется при интерполяции для плавной отрисовки.
		 * @param m4 трансформация внешнего вида
		 */
		public function updatePositionAppearance(m4:Matrix4):void {
			for each (var component:AppearanceComponent in appearanceComponents) {
				component.transform = m4;
			}
		}

		/**
         * EN:
         * Object's visibility.
         *
         * RU:
		 * Видимость объекта.
		 */
		public function get visible():Boolean {
			return _visible;
		}

		public function set visible(value:Boolean):void {
			_visible = value;
			for each (var component:AppearanceComponent in appearanceComponents) {
				component.visible = _visible;
			}
		}
	}
}
