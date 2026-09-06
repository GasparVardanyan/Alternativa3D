package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;

	/**
	 * The lamp above the screen in the entrance room.
	 */
	public class ScreenLight extends Mesh {

		public function ScreenLight() {
			super("ScreenLight");

			mobility = 3;

			x = 539.3701171875;
			y = -1921.2598876953125;

			createVertex(-169.2913818359375, -70.8662109375, 118.11026000976563, "0");
			createVertex(-185.03936767578125, -70.8662109375, 118.11026000976563, "1");
			createVertex(-185.03936767578125, 7.8740234375, 114.17323303222656, "2");
			createVertex(-169.2913818359375, 7.8740234375, 114.17323303222656, "3");
			createVertex(-169.20657348632813, -98.380859375, 118.11026000976563, "4");
			createVertex(-161.33258056640625, -84.74267578125, 118.11026000976563, "5");
			createVertex(-93.14154052734375, -124.11279296875, 114.17324829101563, "6");
			createVertex(-101.01553344726563, -137.7508544921875, 114.17324829101563, "7");
			createVertex(-253.31521606445313, -137.7508544921875, 114.17324829101563, "8");
			createVertex(-261.189208984375, -124.11279296875, 114.17324829101563, "9");
			createVertex(-192.9981689453125, -84.74267578125, 118.11026000976563, "10");
			createVertex(-185.12417602539063, -98.380859375, 118.11026000976563, "11");

			createFace(["0", "1", "2", "3"], "2");
			createFace(["4", "5", "6", "7"], "4");
			createFace(["9", "10", "11", "8"], "6");

			createSurface(["2", "6", "4"], "ScreenLight");
			setMaterialToSurface(new FillMaterial(0xFFE7AF), "ScreenLight");
		}
	}
}
