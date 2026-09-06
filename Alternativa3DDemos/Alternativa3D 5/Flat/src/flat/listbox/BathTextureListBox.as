package flat.listbox {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Листбокс с текстурами для ванной комнаты.
	 */ 
	public class BathTextureListBox extends TextureListBox {
		[Embed(source="textures/bath/wall_bath1.jpg")] private static const bmp0:Class;
		private var wallBitmap0:Bitmap = new bmp0();
		[Embed(source="textures/bath/floor_bath_1.jpg")] private static const bmp1:Class;
		private var wallBitmap1:Bitmap = new bmp1();
		[Embed(source="textures/bath/floor_bath_2.jpg")] private static const bmp2:Class;
		private var wallBitmap2:Bitmap = new bmp2();
		
		public function BathTextureListBox() {
			super();
			// Добавление дифуз в слоты
			wallBitmap0.width = SLOT_WIDTH;
			wallBitmap0.height = SLOT_HEIGHT;
			slots[0].addChild(wallBitmap0);
			
			wallBitmap1.width = SLOT_WIDTH;
			wallBitmap1.height = SLOT_HEIGHT;
			slots[1].addChild(wallBitmap1);
			
			wallBitmap2.width = SLOT_WIDTH;
			wallBitmap2.height = SLOT_HEIGHT;
			slots[2].addChild(wallBitmap2);
			
		}
		
	}
}