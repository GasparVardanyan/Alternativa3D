package flat.listbox {	
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	/**
	 * Листбокс с обоями для стен.
	 */ 
	public class WallsTextureListBox extends TextureListBox {
		
		[Embed(source="textures/walls/wall_1.jpg")] private static const bmp0:Class;
		private var wallBitmap0:Bitmap = new bmp0();
		
		[Embed(source="textures/walls/wall_2.jpg")] private static const bmp1:Class;
		private var wallBitmap1:Bitmap = new bmp1();
		
		[Embed(source="textures/walls/wall_3.jpg")] private static const bmp2:Class;
		private var wallBitmap2:Bitmap = new bmp2();
		
		[Embed(source="textures/walls/wall_4.jpg")] private static const bmp3:Class;
		private var wallBitmap3:Bitmap = new bmp3();
		
		[Embed(source="textures/walls/wall_5.jpg")] private static const bmp4:Class;
		private var wallBitmap4:Bitmap = new bmp4();
		
		[Embed(source="textures/walls/wall_6.jpg")] private static const bmp5:Class;
		private var wallBitmap5:Bitmap = new bmp5();
		
		[Embed(source="textures/walls/wall_7.jpg")] private static const bmp6:Class;
		private var wallBitmap6:Bitmap = new bmp6();
		
		[Embed(source="textures/walls/wall_8.jpg")] private static const bmp7:Class;
		private var wallBitmap7:Bitmap = new bmp7();
		
		[Embed(source="textures/walls/wall_9.jpg")] private static const bmp8:Class;
		private var wallBitmap8:Bitmap = new bmp8();
		
		public function WallsTextureListBox() {
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
			
			wallBitmap5.width = SLOT_WIDTH;
			wallBitmap5.height = SLOT_HEIGHT;
			slots[5].addChild(wallBitmap5);
			
			wallBitmap6.width = SLOT_WIDTH;
			wallBitmap6.height = SLOT_HEIGHT;
			slots[6].addChild(wallBitmap6);
			
			wallBitmap7.width = SLOT_WIDTH;
			wallBitmap7.height = SLOT_HEIGHT;
			slots[7].addChild(wallBitmap7);
			
			wallBitmap8.width = SLOT_WIDTH;
			wallBitmap8.height = SLOT_HEIGHT;
			slots[8].addChild(wallBitmap8);
			
		}
		
	}
}