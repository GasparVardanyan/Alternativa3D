package engine.model {
	import alternativa.engine3d.core.Object3D;
	import alternativa.types.Texture;
	
	/**
	 * Закрывающая половина детали.
	 */ 
	public class ClosingObjects extends Object3D {
		
		[Embed(source="textures/engine.jpg")] private static const bmpEngine:Class;
		private static const engineTexture:Texture = new Texture(new bmpEngine().bitmapData, "engine.png");
		
		public function ClosingObjects() {
			addChild(new Shell2(engineTexture));
			addChild(new Shell21(engineTexture));
			addChild(new Shell22(engineTexture));
			addChild(new Shell23(engineTexture));
			addChild(new Shell24(engineTexture));
			addChild(new Shell25(engineTexture));
			addChild(new Shell(engineTexture));
		}

	}
}