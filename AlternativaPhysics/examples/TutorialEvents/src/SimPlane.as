/**
 * Created by IntelliJ IDEA.
 * User: ponomarev
 * Date: 31.08.2011
 * Time: 09:50
 * To change this template use File | Settings | File Templates.
 */
package {
	import alternativa.physics3dintegration.StaticObject;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionRect;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;

	/**
     * EN:
     * Plane class. It creates physical and graphical components. Similarly, the hello_world lesson.
     *
	 * RU:
     * Объект плоскость. Создается физическая и графическая составляющая. Аналогично уроку hello_world.
	 */
	public class SimPlane extends StaticObject {
		public function SimPlane(width:int, height:int) {
			super();
            // EN: Add a physical primitive with standart material and geometry of rectangle.
			// RU: Добавление физического примитива стандартного материала с геометрией прямоугольника.
			addPhysicsPrimitive(
					new PhysicsPrimitive(new CollisionRect(width, height, CollisionType.STATIC))
			);
            // EN: Add a graphical represenation of plane.
			// RU: Добавляем графическое изображение прямоугольника.
			addAppearanceComponent(
					MeshUtils.createRectangle(width, height, new VertexLightMaterial(0x777777))
			);
		}
	}
}
