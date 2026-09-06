package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;

	import flash.geom.Point;
	
	/**
	 * Вспомогательный объект для оптимизации BSP-дерева. 
	 */	
	public class Box2 extends Mesh {

		public function Box2() {
			super("Box2");
			mobility = -20;
			x = -495.264440660043;
			y = -898.073381195293;
			scaleX = 1.017769455909729;
			scaleY = 0.8804313540458679;
			scaleZ = 1.0061378479003906;

			createVertex(-535.3460854784345, -618.8443624280841, 0, 0);
			createVertex(-535.3460854784345, -618.8443624280841, 802.6460871188864, 4);
			createVertex(535.3460378776197, -618.8443624280841, 0, 8);
			createVertex(535.3460378776197, -618.8443624280841, 802.6460871188864, 9);
			createVertex(535.3460378776197, 618.8444174541295, 0, 11);
			createVertex(535.3460378776197, 618.8444174541295, 802.6460871188864, 12);
			createVertex(-535.3460854784345, 618.8444174541295, 0, 14);
			createVertex(-535.3460854784345, 618.8444174541295, 802.6460871188864, 18);

			createFace([8, 9, 4, 0], 8);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 8);
			createFace([9, 8, 11, 12], 9);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 9);
			createFace([0, 4, 18, 14], 10);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 10);
			createFace([12, 11, 14, 18], 11);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 11);

			createSurface([9, 8, 11, 10], "05 - Default");
			setMaterialToSurface(new FillMaterial(0x969696, 0), "05 - Default");
		}
	}
}