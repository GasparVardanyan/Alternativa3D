package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.types.Point3D;
	
	import flash.geom.Point;
	
	/**
	 * Вспомогательная плоскость для оптимизации BSP-дерева.
	 */
	public class Splitter0 extends Mesh {

		public function Splitter0() {
			
			super("Splitter0");
			this.mobility = -50;
			coords = new Point3D(-564.4229131731898, 459.1328766736152, 3327.756570776076);
			rotationX = 1.5707963705062866;

			createVertex(-1270.000001295, -1270.0000012949995, 0.0000070668078579255875, 0);
			createVertex(1270.000001295, -1270.0000012949995, 0.0000070668078579255875, 1);
			createVertex(-1270.000001295, 1270.0000012949993, -0.0000070668078579255875, 2);
			createVertex(1270.000001295, 1270.0000012949993, -0.0000070668078579255875, 3);

			createFace([1, 3, 2, 0], 2);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 2);

			createSurface([2], 0);
			setMaterialToSurface(new FillMaterial(0x7F7F7F, 0), 0);
		}
	}
}