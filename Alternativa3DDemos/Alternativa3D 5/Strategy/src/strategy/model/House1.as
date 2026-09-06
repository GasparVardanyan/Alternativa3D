package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;

	public class House1 extends Mesh {

		private var texture:Texture;
		public var material:TextureMaterial;
		
		public function House1(texture:Texture) {
			super("House1");
			this.texture = texture
			this.mobility = 1;
			x = 2892.2436186718337;
			y = 1090.9052158035418;

			createVertex(881.6492867876764, -504.7721936604606, 1733.8992052592419, 2);
			createVertex(881.6492867876764, 568.0214338372596, 1733.8992052592419, 3);
			createVertex(-191.14453449666502, 568.0214338372596, 1733.8992052592419, 4);
			createVertex(345.2521823588844, 31.624620088399496, 2163.016617501006, 6);
			createVertex(-191.14453449666502, -504.7721936604606, 1733.8992052592419, 8);

			createFace([6, 8, 2], 0);
			setUVsToFace(new Point(0.125807985663414, 0.2554214298725128), new Point(0.022671930491924286, 0.12334072589874268), new Point(0.22894564270973206, 0.12334232032299042), 0);
			createFace([6, 2, 3], 1);
			setUVsToFace(new Point(0.3320816457271576, 0.2554227411746979), new Point(0.22894564270973206, 0.12334232032299042), new Point(0.4352194368839264, 0.12334366142749786), 1);
			createFace([6, 3, 4], 2);
			setUVsToFace(new Point(0.5383554697036743, 0.2554240822792053), new Point(0.4352194368839264, 0.12334366142749786), new Point(0.6414931416511536, 0.12334498763084412), 2);
			createFace([6, 4, 8], 3);
			setUVsToFace(new Point(0.7446288466453552, 0.2554251551628113), new Point(0.6414931416511536, 0.12334498763084412), new Point(0.8477667570114136, 0.12334631383419037), 3);

			createSurface([1, 0, 2, 3], "house_1");
			material = new TextureMaterial(texture, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 25);
			setMaterialToSurface(material, "house_1");
		}
	}
}