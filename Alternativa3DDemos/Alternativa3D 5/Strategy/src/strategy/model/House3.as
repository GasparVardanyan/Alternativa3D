package strategy.model {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;

	public class House3 extends Mesh {

		private var texture:Texture;
		public var material:TextureMaterial;
		
		public function House3(texture:Texture) {
			super("House3");
			this.mobility = 1;
			this.texture = texture;
			x = -2891.760508624954;
			y = -2576.875077395667;
			rotationZ = -1.5707964897155762;

			createVertex(881.6491752389103, -504.7723407015054, 1733.8992052592419, 2);
			createVertex(881.6490004586061, 568.0214805828083, 1733.8992052592419, 3);
			createVertex(-191.14443325249567, 568.0214995891885, 1733.8992052592419, 4);
			createVertex(345.2523709931914, 31.6246763371522, 2163.016617501006, 6);
			createVertex(-191.14445225884418, -504.77212790853525, 1733.8992052592419, 8);

			createFace([6, 8, 2], 0);
			setUVsToFace(new Point(0.125807985663414, 0.2554214298725128), new Point(0.022671930491924286, 0.12334072589874268), new Point(0.22894564270973206, 0.12334232032299042), 0);
			createFace([6, 2, 3], 1);
			setUVsToFace(new Point(0.3320816457271576, 0.2554227411746979), new Point(0.22894564270973206, 0.12334232032299042), new Point(0.4352194368839264, 0.12334366142749786), 1);
			createFace([6, 3, 4], 2);
			setUVsToFace(new Point(0.5383554697036743, 0.2554240822792053), new Point(0.4352194368839264, 0.12334366142749786), new Point(0.6414931416511536, 0.12334498763084412), 2);
			createFace([6, 4, 8], 3);
			setUVsToFace(new Point(0.7446288466453552, 0.2554251551628113), new Point(0.6414931416511536, 0.12334498763084412), new Point(0.8477667570114136, 0.12334631383419037), 3);

			createSurface([3, 1, 2, 0], "house_2");
			material = new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25);
			setMaterialToSurface(material, "house_2");
		}
	}
}
