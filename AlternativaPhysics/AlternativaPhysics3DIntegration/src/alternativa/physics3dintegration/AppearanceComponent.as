package alternativa.physics3dintegration {
	import alternativa.engine3d.core.Object3D;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;

	import flash.geom.Matrix3D;

	/**
     * EN:
     * Component of the appearance.
     *
     * RU:
	 * Компонента внешнего вида.
	 */
	public class AppearanceComponent {
		/**
         * EN:
         * <code>Object3d</code> components of the appearance.
         *
         * RU:
		 * <code>Object3d</code> компоненты внешнего вида.
		 */
		public var appearanceObject:Object3D;
		/**
         * EN:
         * Local transformation in appearance coordinates.
         *
         * RU:
		 * Локальная трансформация в системе координат всего внешнего вида.
		 */
		public var localTransform:Matrix4 = new Matrix4();
		/**
		 * @private
		 */
		private static var m3d:Matrix3D = new Matrix3D();
		/**
		 * @private
		 */
		private static var m4:Matrix4 = new Matrix4();
		private static var xAxis:Vector3 = new Vector3(), yAxis:Vector3 = new Vector3(), zAxis:Vector3 = new Vector3();

		/**
         * EN:
         * Creates a component of the appearance.
         * @param appearanceObject <code>Object3d</code> components of the appearance
         * @param localTransform local transformation of component.<br>
         *     Transformation of <code>Object3d</code> is taken into account.
         *
         * RU:
		 * Создает компоненту внешнего вида.
		 * @param appearanceObject <code>Object3d</code>-компоненты внешнего вида
		 * @param localTransform локальная трансформация компоненты.<br>
		 *     Трансформация <code>Object3d</code> учитывается.
		 */
		public function AppearanceComponent(appearanceObject:Object3D, localTransform:Matrix4 = null) {
			this.appearanceObject = appearanceObject;
			this.localTransform.setMatrix(appearanceObject.x,  appearanceObject.y,  appearanceObject.z,
					appearanceObject.rotationX, appearanceObject.rotationY, appearanceObject.rotationZ);
			var scale:Number = appearanceObject.scaleX;
			this.localTransform.m00 *= scale;
			this.localTransform.m10 *= scale;
			this.localTransform.m20 *= scale;
			scale = appearanceObject.scaleY;
			this.localTransform.m01 *= scale;
			this.localTransform.m11 *= scale;
			this.localTransform.m21 *= scale;
			scale = appearanceObject.scaleZ;
			this.localTransform.m02 *= scale;
			this.localTransform.m12 *= scale;
			this.localTransform.m22 *= scale;
			if (localTransform != null) {
				this.localTransform.append(localTransform);
			}
		}

		/**
         * EN:
         * Sets transformation.<br>
         * Recalculates the transformation of <code>appearanceObject</code>, considering the local transformation and transformation of appearance.
         * @param transform transformation of appearance
         *
         * RU:
		 * Задает трансформацию.<br>
		 * Пересчитывает трансформацию <code>appearanceObject</code>, учитывая локальную трансформацию и трансформацию внешнего вида.
		 * @param transform трансформация внешнего вида
		 */
		public function set transform(transform:Matrix4):void {
			m4.copy(localTransform);
			m4.append(transform);

			appearanceObject.x = m4.m03;
			appearanceObject.y = m4.m13;
			appearanceObject.z = m4.m23;

			m4.getAxis(0, xAxis);
			m4.getAxis(1, yAxis);
			m4.getAxis(2, zAxis);
			var scale:Number = xAxis.length();
			appearanceObject.scaleX = scale;
			xAxis.scale(1.0 / scale);
			scale = yAxis.length();
			appearanceObject.scaleY = scale;
			yAxis.scale(1.0 / scale);
			scale = zAxis.length();
			appearanceObject.scaleZ = scale;
			zAxis.scale(1.0 / scale);
			m4.setAxes(xAxis, yAxis, zAxis, xAxis);
			m4.getEulerAngles(xAxis);
			appearanceObject.rotationX = xAxis.x;
			appearanceObject.rotationY = xAxis.y;
			appearanceObject.rotationZ = xAxis.z;
			//m4.getEulerAngles()
			//m4.toMatrix3D(m3d);
			//m3d.

			//appearanceObject.matrix = m3d;
		}

		/**
         * EN:
         * Object's visibility.
         *
         * RU:
		 * Видимость объекта.
		 */
		public function get visible():Boolean {
			return appearanceObject.visible;
		}

		public function set visible(value:Boolean):void {
			appearanceObject.visible = value;
		}

	}
}
