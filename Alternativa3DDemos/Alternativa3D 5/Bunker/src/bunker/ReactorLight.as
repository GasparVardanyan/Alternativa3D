package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.types.Point3D;

	/**
	 * The lamp above doorway in the reactor room.
	 */
	public class ReactorLight extends Mesh {

		public function ReactorLight() {
			super("ReactorLight");

			coords = new Point3D(6.017908068568778e-13, 2322.834716796875, -629.9212646484375);

			createVertex(-23.62204360961974, -520.2474365234375, 149.6064453125, "0");
			createVertex(23.622047424315806, -520.2474365234375, 149.6064453125, "1");
			createVertex(-23.62204360961974, -513.0888671875, 164.718994140625, "2");
			createVertex(23.622047424315806, -513.0888671875, 164.718994140625, "3");

			createFace(["0", "2", "3", "1"], "2");

			createSurface(["2"], "ReactorLight");
			setMaterialToSurface(new FillMaterial(0xFFFFFF), "ReactorLight");
		}
	}
}