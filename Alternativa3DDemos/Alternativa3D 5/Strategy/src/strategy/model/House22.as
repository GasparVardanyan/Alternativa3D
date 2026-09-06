package strategy.model {
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	public class House22 extends Mesh {
		private var texture:Texture;
		public var material:TextureMaterial;
		
		public function House22(texture:Texture, name:String=null) {
			super(name);
			this.texture = texture;
			x = -2891.760508624954;
			y = -2576.875077395667;
			rotationZ = -1.5707963705062866;
			this.mobility = -10;
			
			createVertex(649.5812239096367, 1310.1919563047873, 0, 61);
			createVertex(30.107988719865123, 1310.191929226752, 0, 58);
			createVertex(30.107988719865123, 1310.191929226752, 815.7219155046309, 59);
			createVertex(649.5812239096367, 1310.1919563047873, 815.7219155046309, 60);
			createFace([61, 58, 59, 60], 99);
			setUVsToFace(new Point(0.40276315808296204, 0.7094799280166626), new Point(0.50337815284729, 0.7094804048538208), new Point(0.5033776164054871, 0.8419703245162964), 99);
			
			createSurface([99], "house_2");
			material = new TextureMaterial(texture, 1, true, false, BlendMode.NORMAL, -1, 0x000000, 25);
			setMaterialToSurface(material, "house_2");
		}
		
	}
}