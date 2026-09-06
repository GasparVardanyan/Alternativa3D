package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;
	
	/**
	 * Забор.
	 */	
	public class FenceClass extends Mesh {

		[Embed(source="textures/fence.png")] private static const bmpFence:Class;
		private static const fenceTexture:Texture = new Texture(new bmpFence().bitmapData, "fence.png");

		public function FenceClass() {
			super("Fence");
			this.mobility = -25;
			createVertex(-5079.999825347221, -5079.999825347221, 304.8000105802845, 3);
			createVertex(-5079.999825347221, 5080.000185012778, 304.8000105802845, 10);
			createVertex(5080.000185012778, 5080.000185012778, 304.8000105802845, 11);
			createVertex(5080.000185012778, -5079.999825347221, 304.8000105802845, 12);
			createVertex(5080.000185012778, -5079.999825347221, 0, 14);
			createVertex(5080.000185012778, 5080.000185012778, 0, 17);
			createVertex(-5079.999825347221, 5080.000185012778, 0, 20);
			createVertex(-5079.999825347221, -5079.999825347221, 0, 22);

			createFace([14, 12, 3, 22], 16);
			setUVsToFace(new Point(16.5, 0.050000011920928955), new Point(16.5, 0.949999988079071), new Point(-15.5, 0.949999988079071), 16);
			createFace([11, 10, 20, 17], 17);
			setUVsToFace(new Point(-15.5, 0.949999988079071), new Point(16.5, 0.949999988079071), new Point(16.5, 0.050000011920928955), 17);
			createFace([20, 10, 11, 17], 18);
			setUVsToFace(new Point(16.5, 0.050000011920928955), new Point(16.5, 0.949999988079071), new Point(-15.5, 0.949999988079071), 18);
			createFace([12, 11, 17, 14], 19);
			setUVsToFace(new Point(-15.5, 0.949999988079071), new Point(16.5, 0.949999988079071), new Point(16.5, 0.050000011920928955), 19);
			createFace([17, 11, 12, 14], 20);
			setUVsToFace(new Point(16.5, 0.050000011920928955), new Point(16.5, 0.949999988079071), new Point(-15.5, 0.949999988079071), 20);
			createFace([3, 12, 14, 22], 21);
			setUVsToFace(new Point(-15.5, 0.949999988079071), new Point(16.5, 0.949999988079071), new Point(16.5, 0.050000011920928955), 21);
			createFace([10, 3, 22, 20], 22);
			setUVsToFace(new Point(-15.5, 0.949999988079071), new Point(16.5, 0.949999988079071), new Point(16.5, 0.050000011920928955), 22);
			createFace([22, 3, 10, 20], 23);
			setUVsToFace(new Point(16.5, 0.050000011920928955), new Point(16.5, 0.949999988079071), new Point(-15.5, 0.949999988079071), 23);

			createSurface([20, 18, 23, 16, 21, 19, 17, 22], "fenceS");
			setMaterialToSurface(new TextureMaterial(fenceTexture, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 25), "fenceS");
		}
	}
}