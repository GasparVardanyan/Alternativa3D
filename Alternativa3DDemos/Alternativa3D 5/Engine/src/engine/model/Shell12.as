package  engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell12 extends Mesh {

		public function Shell12(texture:Texture) {
			super("Shell12");
			this.mobility = 14;
			coords = new Point3D(48.15937876843723, -865.5138375524733, -2279.010312687642);

			createVertex(615.9325477204949, 800.6764191208811, 690.1946936969453, 1);
			createVertex(792.5436669801725, 977.3641809892794, 464.70535630881403, 3);
			createVertex(-783.1588473676366, 22.190796684004575, 465.24214524979106, 4);
			createVertex(792.5439576601044, 22.190990470625866, 464.70535630881403, 5);
			createVertex(-606.3947335704495, 22.190990470625866, 690.6111411461003, 6);
			createVertex(615.9325477204949, 22.190990470625866, 690.1948874835665, 7);
			createVertex(-783.1588473676366, 977.3641809892794, 465.24214524979106, 9);
			createVertex(-606.3947335704495, 800.6764191208811, 690.6111411461003, 10);

			createFace([7, 5, 3, 1], 6);
			setUVsToFace(new Point(0.007584963426986762, 0.9202367815453568), new Point(0.021168872714042664, 0.9202368855476379), new Point(0.021168872714042664, 0.9777794480323792), 6);
			createFace([9, 4, 6, 10], 7);
			setUVsToFace(new Point(0.44492417573928833, 0.9777793320997626), new Point(0.44492417573928833, 0.9202368855476379), new Point(0.45850104093551636, 0.9202368855476379), 7);
			createFace([3, 9, 10, 1], 8);
			setUVsToFace(new Point(0.05457894504070282, 0.8388572335243225), new Point(0.14950387179851532, 0.838890016078949), new Point(0.13885494359597156, 0.8524669227703195), 8);

			createSurface([6, 8, 7], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}