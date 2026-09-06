package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.WireMaterial;

	import flash.geom.Point;
	
	/**
	 * Вспомогательный объект для оптимизации BSP-дерева. 
	 */	
	public class BigBox1 extends Mesh {

		public function BigBox1() {
			super("BigBox1");
			this.mobility = -20;
			x = -2440.90915165888;
			y = -2274.0274772943776;
			scaleX = 0.8398900628089905;

			createVertex(-1137.7963421907957, -1184.4966931023448, 0, 0);
			createVertex(-1137.7963421907957, -1184.4966931023448, 2196.8252128113586, 4);
			createVertex(1023.1583977438352, -1184.4966931023448, 0, 8);
			createVertex(1023.1583977438352, -1184.4966931023448, 2196.8252128113586, 9);
			createVertex(1023.1583977438352, 975.118387835134, 0, 11);
			createVertex(1023.1583977438352, 975.118387835134, 2196.8252128113586, 12);
			createVertex(-1137.795880733684, 975.118387835134, 0, 14);
			createVertex(-1137.795880733684, 975.118387835134, 2196.8252128113586, 18);

			createFace([12, 11, 14, 18], 8);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 8);
			createFace([11, 12, 9, 8], 9);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 9);
			createFace([18, 14, 0, 4], 10);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 10);
			createFace([8, 9, 4, 0], 11);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 11);

			createSurface([8, 11, 10, 9], 0);
			setMaterialToSurface(new WireMaterial(0, 0x7F7F7F, 0), 0);
		}
	}
}