/**
 * Created by IntelliJ IDEA.
 * User: ponomarev
 * Date: 30.08.2011
 * Time: 17:35
 * To change this template use File | Settings | File Templates.
 */
package {
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.physics3dintegration.DynamicObject;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionBall;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;

	import flash.display3D.Context3D;
	import flash.geom.Rectangle;

	/**
     * EN:
     * Create the ball.
     * RU:
	 * Создание шара.
	 */
	public class SimBall extends DynamicObject {
		private var appearance:Mesh;

		public function SimBall(radius:Number, transform:Matrix4) {
			super(transform);
			addPhysicsPrimitive(
					new PhysicsPrimitive(new CollisionBall(radius, CollisionType.DYNAMIC), 10)
			);
			appearance = MeshUtils.createSphere(radius, new VertexLightMaterial(0xFFFF40));
			addAppearanceComponent(appearance);
		}

		/**
         * EN:
         * Set the ball color.
         * @param context Context.
         * @param color Color.
         *
         * RU:
		 * Установка цвета шара.
		 * @param context Контекст.
		 * @param color Цвет.
		 */
		public function setColor(context:Context3D, color:uint):void {
			var r:Resource;
			/**
             * EN:
             * Dispose the resource of the material.
             *
             * RU:
			 * Уничтожаем ресурс материала.
			 */
			for each (r in appearance.getResources(false, BitmapTextureResource)) {
				r.dispose();
			}
			/**
             * EN:
             * Set the material.
             *
             * RU:
             * Установливаем материал.
			 */
			appearance.setMaterialToAllSurfaces(new VertexLightMaterial(color, 1.0));
			/**
			 * EN:
             * Upload the resource of the material.
             *
             * RU:
             * Загружаем ресурс материала.
             *
			 */
			for each (r in appearance.getResources(false, BitmapTextureResource)) {
				r.upload(context);
			}

		}

	}
}
