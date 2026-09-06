package flat.listbox {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Листбокс с текстурами для пола.
	 */ 
	public class FloorTextureListBox extends TextureListBox {
		
		[Embed(source="textures/floor/floor_1.jpg")] private static const bmp0:Class;
		private var wallBitmap0:Bitmap = new bmp0();
		
		[Embed(source="textures/floor/floor_2.jpg")] private static const bmp1:Class;
		private var wallBitmap1:Bitmap = new bmp1();
		
		[Embed(source="textures/floor/floor_3.jpg")] private static const bmp2:Class;
		private var wallBitmap2:Bitmap = new bmp2();
		
		[Embed(source="textures/floor/floor_4.jpg")] private static const bmp3:Class;
		private var wallBitmap3:Bitmap = new bmp3();
		
		[Embed(source="textures/floor/foor_5.jpg")] private static const bmp4:Class;
		private var wallBitmap4:Bitmap = new bmp4();
		
		
		public function FloorTextureListBox() {
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
			
			wallBitmap3.width = SLOT_WIDTH;
			wallBitmap3.height = SLOT_HEIGHT;
			slots[3].addChild(wallBitmap3);
			
			wallBitmap4.width = SLOT_WIDTH;
			wallBitmap4.height = SLOT_HEIGHT;
			slots[4].addChild(wallBitmap4);
			
		 
		}
		
		
	}
}