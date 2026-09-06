package entity {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Decal;
	import alternativa.engine3d.objects.Sprite3D;
	import alternativa.engine3d.resources.BitmapTextureResource;
	
	import flash.display.Bitmap;
	/**
	 * ...
	 * @author redefy
	 */
	public class Crosshair extends Entity{
		private var bitmapResource:BitmapTextureResource;
		private var material:TextureMaterial;
		private var sprite:Sprite3D;
		private var conteiner:Decal= new Decal();
		
		public function Crosshair():void {
			bitmapResource = new BitmapTextureResource(Bitmap(new GFX.CROSSHAIR()).bitmapData);
			material = new TextureMaterial(bitmapResource, null, 0.8);
			material.useDiffuseAlphaChannel = true;
			
			sprite = new Sprite3D(2, 2, material);
			sprite.scaleX = sprite.scaleY = sprite.scaleZ = 0.5;
			conteiner.addChild(sprite);
			GV.hand.addChild(conteiner);
			
			conteiner.x = 2;
			conteiner.y = 10;
			conteiner.z = -2;
		}
	}
}