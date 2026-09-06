package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.types.Point3D;

	import flash.geom.Point;

	public class Cap extends Mesh {

		public function Cap() {
			super("Cap");
			this.mobility = -250;
			coords = new Point3D(3234.35219446013, 1123.8486507431396, -1724.9024675791698);
			scaleX = 1.1813756227493286;
			scaleY = 1.2291179895401;

			createVertex(-449.9232920673283, -432.40653799177994, 0, 0);
			createVertex(449.92329206732865, -432.40653799177994, 0, 1);
			createVertex(-449.9232920673283, 432.40649857599107, 0, 2);
			createVertex(449.92329206732865, 432.40649857599107, 0, 3);

			createFace([1, 3, 2, 0], 2);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 2);

			createSurface([2], "07 - Default");
			setMaterialToSurface(new FillMaterial(0x191919), "07 - Default");
		}
	}
} 