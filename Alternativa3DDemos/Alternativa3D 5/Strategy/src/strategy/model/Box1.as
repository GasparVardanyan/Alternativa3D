package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;

	import flash.geom.Point;
	
	/**
	 * Вспомогательный объект для оптимизации BSP-дерева. 
	 */	
	public class Box1 extends Mesh {

		public function Box1() {
			super("Box1");
			mobility = -20;
			x = 1216.3161656384527;
			y = 3483.8385167360116;
			scaleX = 1.017769455909729;
			scaleY = 0.8804313540458679;
			scaleZ = 1.0061378479003906;

			createVertex(-535.3460378776198, -618.8444724801741, 0, 0);
			createVertex(-535.3460378776198, -618.8444724801741, 802.6460871188864, 4);
			createVertex(535.3460854784345, -618.8444724801741, 0, 8);
			createVertex(535.3460854784345, -618.8444724801741, 802.6460871188864, 9);
			createVertex(535.3460854784345, 618.8444724801741, 0, 11);
			createVertex(535.3460854784345, 618.8444724801741, 802.6460871188864, 12);
			createVertex(-535.3460378776198, 618.8444724801741, 0, 14);
			createVertex(-535.3460378776198, 618.8444724801741, 802.6460871188864, 18);

			createFace([18, 14, 0, 4], 8);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 8);
			createFace([8, 9, 4, 0], 9);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 9);
			createFace([11, 12, 9, 8], 10);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 10);
			createFace([14, 18, 12, 11], 11);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 11);

			createSurface([11, 10, 9, 8], "05 - Default");
			setMaterialToSurface(new FillMaterial(0x969696, 0), "05 - Default");
		}
	}
}