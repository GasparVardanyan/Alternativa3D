package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.types.Point3D;
	
	import flash.display.BlendMode;

	/**
	 * Force field around the lightning in the reactor room. 
	 */
	public class Core extends Mesh {

		public function Core() {
			super("Core");

			coords = new Point3D(4.137311695497081e-13, 2322.834716796875, -433.07086181640625);

			createVertex(78.74015808105428, 0, 0, "0");
			createVertex(68.19097900390584, 39.3701171875, 0, "1");
			createVertex(39.370075225829666, 68.19091796875, 0, "2");
			createVertex(-0.0000034418416861646908, 78.740234375, 0, "3");
			createVertex(-39.37008285522502, 68.19091796875, 0, "4");
			createVertex(-68.19097900390666, 39.3701171875, 0, "5");
			createVertex(-78.7401580810551, 0, 0, "6");
			createVertex(-68.1909866333012, -39.3701171875, 0, "7");
			createVertex(-39.37010192871135, -68.19091796875, 0, "8");
			createVertex(-0.00003660726766147694, -78.740234375, 0, "9");
			createVertex(39.370040893554275, -68.19091796875, 0, "10");
			createVertex(68.19094848632771, -39.3701171875, 0, "11");
			createVertex(78.74015808105428, 0, 409.4488220214844, "12");
			createVertex(68.19097900390584, 39.3701171875, 409.4488220214844, "13");
			createVertex(39.370075225829666, 68.19091796875, 409.4488220214844, "14");
			createVertex(-39.37008285522502, 68.19091796875, 409.4488220214844, "16");
			createVertex(-68.19097900390666, 39.3701171875, 409.4488220214844, "17");
			createVertex(-78.7401580810551, 0, 409.4488220214844, "18");
			createVertex(-68.1909866333012, -39.3701171875, 409.4488220214844, "19");
			createVertex(-39.37010192871135, -68.19091796875, 409.4488220214844, "20");
			createVertex(-0.00003660726766147694, -78.740234375, 409.4488220214844, "21");
			createVertex(39.370040893554275, -68.19091796875, 409.4488220214844, "22");
			createVertex(68.19094848632771, -39.3701171875, 409.4488220214844, "23");
			createVertex(-0.0000034418425956593925, 78.740234375, 409.4488220214844, "25");

			createFace(["7", "19", "18", "6"], "0");
			createFace(["23", "11", "0", "12"], "1");
			createFace(["12", "0", "1", "13"], "2");
			createFace(["17", "5", "6", "18"], "3");
			createFace(["2", "14", "13", "1"], "4");
			createFace(["11", "23", "22", "10"], "5");
			createFace(["3", "25", "14", "2"], "24");
			createFace(["20", "8", "9", "21"], "8");
			createFace(["10", "22", "21", "9"], "10");
			createFace(["19", "7", "8", "20"], "11");
			createFace(["16", "4", "5", "17"], "12");
			createFace(["25", "3", "4", "16"], "9");

			createSurface(["24", "9", "4", "2", "0", "1", "3", "5", "10", "11", "12", "8"], "Core");
			setMaterialToSurface(new FillMaterial(0x1DFF1D, 0.25, BlendMode.ADD), "Core");
		}
	}
}
