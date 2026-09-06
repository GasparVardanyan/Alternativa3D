package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell13 extends Mesh {

		public function Shell13(texture:Texture) {
			super("Shell13");
			this.mobility = 13;
			coords = new Point3D(48.15937876843723, -865.5138375524733, -2279.010312687642);

			createVertex(-605.8465596654717, 800.6762737809152, 1526.727742035297, 0);
			createVertex(616.4803824988855, 800.6766129075024, 1526.3113914794526, 1);
			createVertex(-606.3947335704495, 800.6764191208811, 690.6111411461003, 2);
			createVertex(615.9325477204949, 800.6764191208811, 690.1946936969453, 3);
			createVertex(-606.3947335704495, 22.190990470625866, 690.6111411461003, 4);
			createVertex(616.4803824988855, 22.19118425724716, 1526.3113914794526, 5);
			createVertex(615.9325477204949, 22.190990470625866, 690.1948874835665, 6);
			createVertex(-605.846026752263, 22.19118425724716, 1526.727742035297, 7);

			createFace([1, 3, 2, 0], 6);
			setUVsToFace(new Point(0.05765824019908905, 0.5424831509590149), new Point(0.05769149959087372, 0.492112934589386), new Point(0.1313280314207077, 0.49213820695877075), 6);
			createFace([6, 3, 1, 5], 7);
			setUVsToFace(new Point(0.010776684619486332, 0.492112934589386), new Point(0.05769149959087372, 0.492112934589386), new Point(0.05765824019908905, 0.5424831509590149), 7);
			createFace([2, 4, 7, 0], 8);
			setUVsToFace(new Point(0.1313280314207077, 0.49213820695877075), new Point(0.17820970714092255, 0.4921385645866394), new Point(0.17817654653566534, 0.5425089001654021), 8);

			createSurface([8, 7, 6], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}