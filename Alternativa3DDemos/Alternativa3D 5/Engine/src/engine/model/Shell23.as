package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell23 extends Mesh {

		public function Shell23(texture:Texture) {
			super("Shell23");
			this.mobility = 2;
			coords = new Point3D(48.15937876843723, -2696.2563565090977, -2279.010312687642);

			createVertex(-386.4601443416689, -581.3400976386822, 1672.8779298674297, 0);
			createVertex(397.1937672850479, -581.3404852119248, 1672.6106981166688, 1);
			createVertex(-605.846608112127, -800.6763222275705, 1526.7276451419864, 2);
			createVertex(616.4803340522302, -800.676709800813, 1526.311294586142, 3);
			createVertex(-386.4600958950136, -22.191281150557803, 1672.8775422941872, 4);
			createVertex(397.19381573170324, -22.191281150557803, 1672.6106981166688, 5);
			createVertex(616.4803824988855, -22.191281150557803, 1526.3113914794526, 6);
			createVertex(-605.846026752263, -22.191281150557803, 1526.727742035297, 7);

			createFace([7, 2, 0, 4], 8);
			setUVsToFace(new Point(0.6140450835227966, 0.9920217394828796), new Point(0.6141055226325989, 0.9450313448905945), new Point(0.6273311972618103, 0.9582827091217041), 8);
			createFace([1, 3, 6, 5], 9);
			setUVsToFace(new Point(0.674638298342235, 0.9583372862964117), new Point(0.6878923773765564, 0.9451108574867249), new Point(0.6878359913825989, 0.9921135306358337), 9);
			createFace([0, 2, 3, 1], 10);
			setUVsToFace(new Point(0.6273311972618103, 0.9582827091217041), new Point(0.6141055226325989, 0.9450313448905945), new Point(0.6878966151546677, 0.9451233053862771), 10);
			createFace([0, 1, 5, 4], 11);
			setUVsToFace(new Point(0.6273313164419295, 0.9582827921238574), new Point(0.674639880657196, 0.958341658115387), new Point(0.6745977997779846, 0.9920970797538757), 11);

			createSurface([11, 10, 9, 8], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}