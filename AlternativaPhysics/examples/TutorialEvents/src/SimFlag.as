package {
	import alternativa.engine3d.objects.Mesh;
	import alternativa.physics3dintegration.SimulationObject;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.geometry.GeometryMesh;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionCylinder;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;

	public class SimFlag extends SimulationObject {
		private var cyl:CollisionCylinder;
		public var flagColor:uint;
		public var onContact:Function;

		public function SimFlag(transform:Matrix4, flagColor:uint, onContact:Function = null) {
			super(null, transform);
			this.flagColor = flagColor;
			var r:Number = 0.05;
			cyl = new CollisionCylinder(r, 3, CollisionType.TRIGGER);
			var localTransform:Matrix4 = new Matrix4();
			localTransform.setPositionXYZ(0, 0, 1.5);
			addCollisionPrimitive(cyl, localTransform);
			var appearance:Mesh = MeshUtils.createCylinder(r, 3, new VertexLightMaterial(0x804000));
			addAppearanceComponent(appearance, localTransform);

            // EN: Add a triangular flag.
            // EN: Create a geometric mesh.
			// RU: Добавление треугольного флага.
			// RU: Создание геометрического меша.
			var mesh:GeometryMesh = new GeometryMesh(2);
			var v1:Vector3,  v2:Vector3, v3:Vector3;
            // EN: Add triangle vertices.
			// RU: Добавление вершин треугольника.
			v1 = mesh.addVertexXYZ(0, r, 3);
			v2 = mesh.addVertexXYZ(0, r, 2.0);
			v3 = mesh.addVertexXYZ(0, r + 1.5, 2.5);
            // EN: Add triangle faces.
			// RU: Добавление грани треугольника.
			mesh.addTriangleFace(v1, v2, v3);
            // EN: Convert the geometric mesh to A3D mesh.
			// RU: Конвертирование геометрического меша в меш A3D.
			addAppearanceComponent(MeshUtils.createMesh3dFromGeometryMesh(mesh, new VertexLightMaterial(flagColor)));
			this.onContact = onContact;
			if (onContact != null) {
				/**
                 * EN:
                 * Add event handler.
                 *
                 * RU:
				 * Добавление обработчика события.
				 */
				cyl.addEventListener(ContactEvent.OnContact, onContact, this);
			}
		}

		override public function set visible(value:Boolean):void {
			super.visible = value;
			if (!value) {
				cyl.removeEventListener(ContactEvent.OnContact, onContact, this);
			} else {
				cyl.addEventListener(ContactEvent.OnContact, onContact, this);
			}
		}


	}
}
