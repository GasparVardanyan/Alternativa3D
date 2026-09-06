package bunker {
	import flash.display.BitmapData;
	
	/**
	 * The link between materials and their texture.
	 */	
	public class TextureMaterialBinding {
		// Materials, which texture is assigned to
		public var materials:Array;
		// URL for diffuse map
		public var textureUrl:String;
		// URL for transparency map
		public var alphaUrl:String;
		// Temporary storage for transparency map
		public var alphaBitmapData:BitmapData;
		
		public function TextureMaterialBinding(materials:Array, textureUrl:String, alphaUrl:String = null) {
			this.materials = materials;
			this.textureUrl = textureUrl;
			this.alphaUrl = alphaUrl;
		}
	}
}