package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell21 extends Mesh {

		public function Shell21(texture:Texture) {
			super("Shell21");
			this.mobility = 3;
			coords = new Point3D(48.15937876843723, -2696.2563565090977, -2279.010312687642);

			createVertex(-605.846608112127, -800.6763222275705, 1526.7276451419864, 0);
			createVertex(616.4803340522302, -800.676709800813, 1526.311294586142, 1);
			createVertex(-606.3947820171048, -800.6763222275705, 690.6110442527897, 2);
			createVertex(615.9324992738397, -800.676709800813, 690.1946936969453, 3);
			createVertex(-606.3947335704495, -22.190893577315222, 690.6111411461003, 4);
			createVertex(616.4803824988855, -22.191281150557803, 1526.3113914794526, 5);
			createVertex(615.9325477204949, -22.191087363936514, 690.1948874835665, 6);
			createVertex(-605.846026752263, -22.191281150557803, 1526.727742035297, 7);

			createFace([0, 2, 3, 1], 6);
			setUVsToFace(new Point(0.6140932645508439, 0.9450451731933805), new Point(0.6141377091407776, 0.8945625424385071), new Point(0.6879368424415588, 0.8946282267570496), 6);
			createFace([1, 3, 6, 5], 7);
			setUVsToFace(new Point(0.6878923773765564, 0.9451108574867249), new Point(0.6879368424415588, 0.8946282267570496), new Point(0.7349416613578796, 0.8946875929832458), 7);
			createFace([7, 4, 2, 0], 8);
			setUVsToFace(new Point(0.5671088333455387, 0.9450024962568886), new Point(0.5671409964561462, 0.8945336937904358), new Point(0.6141377091407776, 0.8945625424385071), 8);

			createSurface([8, 7, 6], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}