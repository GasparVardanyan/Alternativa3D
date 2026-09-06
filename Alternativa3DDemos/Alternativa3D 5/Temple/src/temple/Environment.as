package temple {
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Box;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	
	/**
	 * The sky box.
	 */
	public class Environment extends TextureLoader {
		
		[Embed(source="environmentfrontlow.jpg")] private static const bmpFront:Class;
		[Embed(source="environmentbacklow.jpg")] private static const bmpBack:Class;
		[Embed(source="environmentleftlow.jpg")] private static const bmpLeft:Class;
		[Embed(source="environmentrightlow.jpg")] private static const bmpRight:Class;
		[Embed(source="environmenttoplow.jpg")] private static const bmpTop:Class;
		private static const front:Texture = new Texture(new bmpFront().bitmapData);
		private static const back:Texture = new Texture(new bmpBack().bitmapData);
		private static const left:Texture = new Texture(new bmpLeft().bitmapData);
		private static const right:Texture = new Texture(new bmpRight().bitmapData);
		private static const top:Texture = new Texture(new bmpTop().bitmapData);
		
		public var frontMaterial:TextureMaterial;
		public var backMaterial:TextureMaterial;
		public var leftMaterial:TextureMaterial;
		public var rightMaterial:TextureMaterial;
		public var topMaterial:TextureMaterial;
		
		/**
		 * 
		 */
		public function Environment() {
			super("Environment");

			clonePropertiesFrom(new Box(50000, 50000, 50000, 1, 1, 1, true));
			
			frontMaterial = new TextureMaterial(front, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
			setMaterialToSurface(frontMaterial, "front");
			backMaterial = new TextureMaterial(back, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
			setMaterialToSurface(backMaterial, "back");
			leftMaterial = new TextureMaterial(left, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
			setMaterialToSurface(leftMaterial, "left");
			rightMaterial = new TextureMaterial(right, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
			setMaterialToSurface(rightMaterial, "right");
			topMaterial = new TextureMaterial(top, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
			setMaterialToSurface(topMaterial, "top");

			bindings = [
				new TextureMaterialBinding([frontMaterial], "environmentfront.jpg"),
				new TextureMaterialBinding([backMaterial], "environmentback.jpg"),
				new TextureMaterialBinding([leftMaterial], "environmentleft.jpg"),
				new TextureMaterialBinding([rightMaterial], "environmentright.jpg"),
				new TextureMaterialBinding([topMaterial], "environmenttop.jpg")];
			loadingMessage = "Loading environment texture";
		}
	}
}