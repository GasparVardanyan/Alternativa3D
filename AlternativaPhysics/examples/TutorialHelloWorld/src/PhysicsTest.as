package {
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.physics3dintegration.DynamicObject;
	import alternativa.physics3dintegration.PhysicalSimObject;
	import alternativa.physics3dintegration.PhysicsSprite;
	import alternativa.physics3dintegration.StaticObject;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionBox;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionRect;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;

	[SWF (backgroundColor="0x000000", width="1024", height="768", frameRate="60")]
	public 	class PhysicsTest extends PhysicsSprite {
		public function PhysicsTest():void {
	        super();
		}
		override protected function setScene():void {
			addChild(camera.diagram);
            // EN: Create and add lights.
			// RU: Создание и добавление на сцену источников света.
			var light:Light3D;
			light = new OmniLight(0xFFFFFF, 1, 7000);
			light.x = 0;
			light.y = 200;
			light.z = 1000;
			light.intensity = 0.8;
			addObject3D(light);
			light = new AmbientLight(0xFFFFFF);
			light.intensity = 0.2;
			addObject3D(light);

            // EN: Create plane.
            // EN: Create static object.
			// RU: Cоздание плоскости.
			// RU: Создаем статический объект.
			var plane:PhysicalSimObject = new StaticObject();
            // EN: Add a physical primitive with standart material and geometry of rectangle. It is abstract object. You can't see it without visualization.
			// RU: Добавление физического примитива стандартного материала с геометрией прямоугольника. Это абстрактный объект, который без визуализации невиден.
			plane.addPhysicsPrimitive(
					new PhysicsPrimitive(new CollisionRect(10, 10, CollisionType.STATIC))
			);
            // EN: Add a graphical representation of rectangle. Physical object and its graphical representation should be identical.
			// RU: Добавляем графическое отображение прямоугольника. Важно, чтобы физический объект и его графическое отображение полностью совпадали.
			plane.addAppearanceComponent(
					MeshUtils.createRectangle(10, 10, new VertexLightMaterial(0x777777))
			);
            // EN: Add object to scene.
			// RU: Добавляем объект на сцену.
			addSimObject(plane);

            // EN: Create a cube. Displacement along the Z axis at 1.
            // EN: Object transformation.
			// RU: Создадим куб.
			// RU: Трансформация объекта. Смещение по оси Z на 1.
			var transform:Matrix4 = new Matrix4();
			transform.setPositionXYZ(0, 0, 1);
            //Create dynamic object with created transformation and velocity vector (0,0,10).
			// RU: Создание динамического объекта с созданной трансформацией и вектором скорости (0,0,10).
			var box:PhysicalSimObject = new DynamicObject(transform, new Vector3(0, 0, 10));
			// RU: Добавление физического примитива массой 10, стандартного материала с геометрией куба.
            // EN: Add a physical primitive (weight: 10, standart material, geometry of cube).
			box.addPhysicsPrimitive(
					new PhysicsPrimitive(new CollisionBox(new Vector3(1, 1, 1), CollisionType.DYNAMIC), 10)
			);
            // EN: Add a graphical representation of a cube
			// RU: Добавление графического отображения куба.
			box.addAppearanceComponent(
					MeshUtils.createBox(new Vector3(2, 2, 2), new VertexLightMaterial(0x77AA77))
			);
            // EN: Add object to scene.
			// RU: Добавление объекта на сцену.
			addSimObject(box);
		}
	}
}
