package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.WireMaterial;

	import flash.geom.Point;
	
	/**
	 * Вспомогательный объект для оптимизации BSP-дерева. 
	 */	
	public class BigBox2 extends Mesh {

		public function BigBox2() {
			super("BigBox2");
			this.mobility = -20;
			x = 2611.18480490868;
			y = 1741.5161821957197;
			rotationZ = -1.5707963705062866;
			scaleX = 0.8398900628089905;

			createVertex(-785.3185051580473, -996.9070092178575, 0, 0);
			createVertex(1375.6362347765844, -996.9070267765574, 0, 1);
			createVertex(-785.3179253677723, 1162.7080717196425, 2196.8252128113586, 6);
			createVertex(1375.6361223811869, 1162.708151054228, 2196.8252128113586, 7);
			createVertex(1375.6362347765844, -996.9070267765574, 2196.8252128113586, 9);
			createVertex(1375.6361223811869, 1162.708151054228, 0, 13);
			createVertex(-785.3185051580473, -996.9070092178575, 2196.8252128113586, 17);
			createVertex(-785.3179253677723, 1162.7080717196425, 0, 19);

			createFace([7, 13, 19, 6], 8);
			setUVsToFace(new Point(0, 1), new Point(0, 0), new Point(1, 0), 8);
			createFace([0, 17, 6, 19], 9);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 9);
			createFace([1, 9, 17, 0], 10);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 10);
			createFace([13, 7, 9, 1], 11);
			setUVsToFace(new Point(1, 0), new Point(1, 1), new Point(0, 1), 11);

			createSurface([11, 10, 9, 8], 0);
			setMaterialToSurface(new WireMaterial(0, 0x7F7F7F, 0), 0);
		}
	}
}