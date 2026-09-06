package engine.model {
	
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.types.Texture;
	
	/**
	 * Статичная геометрия.
	 */ 
	public class StaticObjects extends Object3D
	{
		[Embed(source="textures/engine.jpg")] private static const bmpEngine:Class;
		private static const engineTexture:Texture = new Texture(new bmpEngine().bitmapData, "engine.png");
		
		public function StaticObjects()
		{
			
			this.addChild(new Shell0(engineTexture));
			this.addChild(new Shell1(engineTexture));
			this.addChild(new Shell11(engineTexture));
			this.addChild(new Shell12(engineTexture));
			this.addChild(new Shell13(engineTexture));
			this.addChild(new Shell14(engineTexture));
			this.addChild(new Shell15(engineTexture));
			
			//Вспомогательные плоскости для оптимизации BSP-дерева
			this.addChild(new Splitter0());
			this.addChild(new Splitter1());
			this.addChild(new Splitter2());
			this.addChild(new Splitter3());
			this.addChild(new Splitter4());
			this.addChild(new Splitter5());
			this.addChild(new Splitter6());
		}
		
		
		

	}
}