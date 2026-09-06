package engine.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;

	import flash.display.BlendMode;
	import flash.geom.Point;

	public class Shell14 extends Mesh {

		public function Shell14(texture:Texture) {
			super("Shell14");
			this.mobility = 12;
			coords = new Point3D(48.15937876843723, -865.5138375524733, -2279.010312687642);

			createVertex(-386.4600958950136, 581.3400007453715, 1672.8779298674297, 0);
			createVertex(397.19381573170324, 581.3403883186141, 1672.6106981166688, 1);
			createVertex(-605.8465596654717, 800.6762737809152, 1526.727742035297, 2);
			createVertex(616.4803824988855, 800.6766129075024, 1526.3113914794526, 3);
			createVertex(-386.4600958950136, 22.19118425724716, 1672.8775422941872, 4);
			createVertex(397.19381573170324, 22.19118425724716, 1672.6106981166688, 5);
			createVertex(616.4803824988855, 22.19118425724716, 1526.3113914794526, 6);
			createVertex(-605.846026752263, 22.19118425724716, 1526.727742035297, 7);

			createFace([3, 2, 0, 1], 8);
			setUVsToFace(new Point(0.05765824019908905, 0.5424831509590149), new Point(0.13129489123821259, 0.5425085425376892), new Point(0.11807832444731473, 0.555725472431687), 8);
			createFace([0, 2, 7, 4], 9);
			setUVsToFace(new Point(0.11807827651500702, 0.555709183216095), new Point(0.13129492334286272, 0.5424956426905931), new Point(0.13129489123821259, 0.5893941521644592), 9);
			createFace([5, 1, 0, 4], 10);
			setUVsToFace(new Point(0.07086865603923798, 0.5893941755131497), new Point(0.07086865603923798, 0.555709183216095), new Point(0.11807827651500702, 0.555709183216095), 10);
			createFace([5, 6, 3, 1], 11);
			setUVsToFace(new Point(0.07086865603923798, 0.5893941521644592), new Point(0.05765824019908905, 0.5893941521644592), new Point(0.05765824019908905, 0.5424831509590149), 11);

			createSurface([10, 9, 8, 11], "01 - Default");
			setMaterialToSurface(new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25), "01 - Default");
		}
	}
}