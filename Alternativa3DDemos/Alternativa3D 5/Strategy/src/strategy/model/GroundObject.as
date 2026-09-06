package strategy.model {
	import alternativa.utils.BitmapUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;

	/**
	 * Земля. 
	 */	
	public class GroundObject extends TextureLoader {	
		private var ground:Ground;	
		
		[Embed(source="textures/ground_alpha.gif")] private static const bmpGroundAlpha:Class;
		private static const groundAlpha:Bitmap = new bmpGroundAlpha();
		
		public function GroundObject() {
			super();
			ground = new Ground("ground"); 
			addChild(ground);
			// Путь к текстуре высокого разрешения
			urls = ["alternativa/demo/strategy/model/textures/ground.jpg"];
			materials = [[ground.material]];
		}
		
		override public function updateAfterLoad(newBitmapData:BitmapData):void {
			
			var bitmapData:BitmapData = BitmapUtils.mergeBitmapAlpha(newBitmapData, groundAlpha.bitmapData, false);
			super.updateAfterLoad(bitmapData);	
		}
		
	}
}