package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	/**
	 * Плоскость неба в отраженной сцене. 
	 */	
	public class Sky extends Mesh {

		[Embed(source="textures/clouds_low.jpg")] private static const bmpCraterla:Class;
		private static const craterla:Texture = new Texture(new bmpCraterla().bitmapData, "craterla.png");

		public function Sky() {
			super("Sky");
			this.mobility = -500;
			z = -5654.203716703007;
			rotationZ = -3.141592502593994;

			createVertex(-15239.999797570166, -15240.000233509874, 7.21911420268384e-13, 0);
			createVertex(15240.000233509874, -15239.999797570166, 7.21911420268384e-13, 1);
			createVertex(-15240.000233509874, 15239.999797570166, 7.21911420268384e-13, 2);
			createVertex(15239.999797570166, 15240.000233509874, 7.21911420268384e-13, 3);

			createFace([1, 3, 2, 0], 2);
			setUVsToFace(new Point(1.0000000000000002, 0), new Point(1, 1), new Point(0, 1), 2);

			createSurface([2], "sky");
			setMaterialToSurface(new TextureMaterial(craterla, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "sky");
		}
	}
}