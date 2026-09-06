package strategy.model {
	
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	public class House44 extends Mesh {
		private var texture:Texture;	
		public var material:TextureMaterial;
			
		public function House44(texture:Texture, name:String=null) {
			super(name);
			this.texture = texture;
			x = 2892.2436186718337;
			y = 1090.9052158035418;
			this.mobility = -10;			
			
			createVertex(649.5812811799464, 1310.1920248040008, 0, 61);
			createVertex(30.10804599017338, 1310.1920248040008, 0, 58);
			createVertex(30.10804599017338, 1310.1920248040008, 815.7219155046309, 59);
			createVertex(649.5812811799464, 1310.1920248040008, 815.7219155046309, 60);
			
			createFace([61, 58, 59, 60], 103);
			setUVsToFace(new Point(0.40276315808296204, 0.7094799280166626), new Point(0.50337815284729, 0.7094804048538208), new Point(0.5033776164054871, 0.8419703245162964), 103);
			
			createSurface([103], "house_1");
			material = new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25);
			setMaterialToSurface(material, "house_1");
		}
		
	}
}