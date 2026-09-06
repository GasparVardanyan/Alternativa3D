package entity {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.AnimSprite;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import entity.Entity;
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	/**
	 * ...
	 * @author redefy
	 */
	public class Flash extends Entity{
		private var bitmapResource:BitmapTextureResource;
		private var materials:Vector.<Material>;
		private var material:TextureMaterial;
		private var sprite:AnimSprite;
		private var conteiner:Object3D = new Object3D();
		private var flash:Boolean = false;
		
		public function Flash():void {
			materials = new Vector.<Material>();
			var bitmap:BitmapData = Bitmap(new GFX.FLASH()).bitmapData;
			
			for (var i:int = 0; i < 4; i++) {
				var bitmapData:BitmapData = new BitmapData(128, 128, true, 0xFF);
				bitmapData.copyPixels(bitmap, new Rectangle(i * 128, 0 , 128, 128), new Point(0, 0));
				bitmapResource = new BitmapTextureResource(bitmapData);
				material = new TextureMaterial(bitmapResource, null, 0.5);
				material.useDiffuseAlphaChannel = true;
				materials.push(material);
			}
			
			sprite = new AnimSprite(128, 128, materials, true, 0);
			sprite.scaleX = sprite.scaleY = sprite.scaleZ = 0.13;
			conteiner.addChild(sprite);
			GV.hand.addChild(conteiner);
			conteiner.visible = false;
			
			conteiner.x = 10;
			conteiner.y = 40;
			conteiner.z = -9;
		}
		
		public function start():void {
			conteiner.visible = true;
			flash = true;
		}
		
		public function stop():void {
			conteiner.visible = false;
			flash = false;
		}
		
		override public function update():void {
			super.update();
			if(flash) sprite.frame++;
		}
	}
}