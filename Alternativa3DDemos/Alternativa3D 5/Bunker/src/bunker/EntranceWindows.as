package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;

	/**
	 * Windows at the entrance room.
	 */
	public class EntranceWindows extends Mesh {

		public function EntranceWindows() {
			super("EntranceWindows");
			
			mobility = 1;

			x = 539.3701171875;
			y = -1921.2598876953125;

			createVertex(-3.00927734375, 272.6431884765625, 90.55119323730469, "0");
			createVertex(-3.00927734375, 272.6431884765625, 66.92913818359375, "1");
			createVertex(40.68670654296875, 144.41357421875, 66.92911529541016, "2");
			createVertex(40.68670654296875, 144.41357421875, 90.55119323730469, "3");
			createVertex(-351.32147216796875, 272.6431884765625, 90.55119323730469, "4");
			createVertex(-395.0174560546875, 144.41357421875, 90.55119323730469, "5");
			createVertex(-395.0174560546875, 144.41357421875, 66.92911529541016, "6");
			createVertex(-351.32147216796875, 272.6431884765625, 66.92913818359375, "7");

			createFace(["5", "6", "7", "4"], "0");
			createFace(["1", "2", "3", "0"], "4");

			createSurface(["4", "0"], "EntranceWindows");
			setMaterialToSurface(new FillMaterial(0xFFFFFF), "EntranceWindows");
		}
	}
}