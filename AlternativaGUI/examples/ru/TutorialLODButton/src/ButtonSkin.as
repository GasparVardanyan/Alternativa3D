package {
	import flash.display.BitmapData;

	public class ButtonSkin {

		// Графика для большого лода кнопки	
		[Embed(source = "../assets/button/stateUp_lod0.png")]
		private static const stateUpLod0:Class;
		public static const stateUpLod0Texture:BitmapData = new stateUpLod0().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod0.png")]
		private static const stateOverLod0:Class;
		public static const stateOverLod0Texture:BitmapData = new stateOverLod0().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod0.png")]
		private static const stateDownLod0:Class;
		public static const stateDownLod0Texture:BitmapData = new stateDownLod0().bitmapData;

		// Графика для среднего лода кнопки	
		[Embed(source = "../assets/button/stateUp_lod1.png")]
		private static const stateUpLod1:Class;
		public static const stateUpLod1Texture:BitmapData = new stateUpLod1().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod1.png")]
		private static const stateOverLod1:Class;
		public static const stateOverLod1Texture:BitmapData = new stateOverLod1().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod1.png")]
		private static const stateDownLod1:Class;
		public static const stateDownLod1Texture:BitmapData = new stateDownLod1().bitmapData;

		// Графика для малого лода кнопки	
		[Embed(source = "../assets/button/stateUp_lod2.png")]
		private static const stateUpLod2:Class;
		public static const stateUpLod2Texture:BitmapData = new stateUpLod2().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod2.png")]
		private static const stateOverLod2:Class;
		public static const stateOverLod2Texture:BitmapData = new stateOverLod2().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod2.png")]
		private static const stateDownLod2:Class;
		public static const stateDownLod2Texture:BitmapData = new stateDownLod2().bitmapData;

		// Данные стиля для большого лода
		// Ширина краев у скина
		public static const edge0:int = 15;

		// Высота кнопки
		public static const buttonHeight0:int = 54;

		// Внутренний отступ
		public static const padding0:int = 12;

		// Зазор между иконокой и текстовой меткой
		public static const space0:int = 8;

		// Минимальная ширина кнопки
		public static const minWidth0:int = 60;

		// Размер текста
		public static const fontSize0:int = 20;


		// Данные стиля для среднего лода
		// Ширина краев у скина
		public static const edge1:int = 12;

		// Высота кнопки
		public static const buttonHeight1:int = 36;

		// Внутренний отступ
		public static const padding1:int = 10;

		// Зазор между иконокой и текстовой меткой
		public static const space1:int = 6;

		// Минимальная ширина кнопки
		public static const minWidth1:int = 50;

		// Размер текста
		public static const fontSize1:int = 16;

		// Данные стиля для малого лода
		// Ширина краев у скина
		public static const edge2:int = 12;

		// Высота кнопки
		public static const buttonHeight2:int = 28;

		// Внутренний отступ
		public static const padding2:int = 8;

		// Зазор между иконокой и текстовой меткой
		public static const space2:int = 5;

		// Минимальная ширина кнопки
		public static const minWidth2:int = 50;

		// Размер текста
		public static const fontSize2:int = 13;

	}

}
