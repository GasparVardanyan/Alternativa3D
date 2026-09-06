package flat.listbox {
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Листбокс с текстурами для потолка.
	 */ 
	public class CeilTextureListBox extends TextureListBox {
		[Embed(source="textures/ceil/ceiling_1.jpg")] private static const bmp0:Class;
		private var wallBitmap0:Bitmap = new bmp0();
		
		[Embed(source="textures/ceil/ceiling_2.jpg")] private static const bmp1:Class;
		private var wallBitmap1:Bitmap = new bmp1();
	
		public function CeilTextureListBox() {
			super();
			// Добавление дифуз в слоты
			wallBitmap0.width = SLOT_WIDTH;
			wallBitmap0.height = SLOT_HEIGHT;
			slots[0].addChild(wallBitmap0);
			
			wallBitmap1.width = SLOT_WIDTH;
			wallBitmap1.height = SLOT_HEIGHT;
			slots[1].addChild(wallBitmap1);
			
		}
		
	}
}