package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell25 extends Mesh {

		public function Shell25(texture:Texture) {
			super("Shell25");
			this.mobility = 4;
			coords = new Point3D(48.15937876843723, -2696.2563565090977, -2279.010312687642);

			createVertex(-606.3947820171048, -800.6763222275705, 690.6110442527897, 0);
			createVertex(-783.1589442609472, -977.3639872026581, 465.24195146316976, 2);
			createVertex(-783.1588473676366, -22.19069979069393, 465.24214524979106, 4);
			createVertex(792.5439576601044, -22.191087363936514, 464.70535630881403, 5);
			createVertex(-606.3947335704495, -22.190893577315222, 690.6111411461003, 6);
			createVertex(615.9325477204949, -22.191087363936514, 690.1948874835665, 7);
			createVertex(792.5435700868618, -977.3643747759006, 464.70535630881403, 12);
			createVertex(615.9324992738397, -800.676709800813, 690.1946936969453, 13);

			createFace([4, 2, 0, 6], 6);
			setUVsToFace(new Point(0.55104660987854, 0.5785183310508728), new Point(0.5510463218699561, 0.6361880958484993), new Point(0.5374393463134766, 0.6255201101303101), 6);
			createFace([12, 5, 7, 13], 7);
			setUVsToFace(new Point(0.9757365892699857, 0.6361922267619418), new Point(0.975737452507019, 0.5785226225852966), new Point(0.9893515706062317, 0.5785227417945862), 7);
			createFace([0, 2, 12, 13], 8);
			setUVsToFace(new Point(0.7420062621511639, 0.8566206828130166), new Point(0.7313507199287415, 0.8430007696151733), new Point(0.8264853358268738, 0.8430855870246887), 8);

			createSurface([6, 7, 8], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}