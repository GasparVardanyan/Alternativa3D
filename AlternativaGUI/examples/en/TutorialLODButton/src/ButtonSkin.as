package {
	import flash.display.BitmapData;

	public class ButtonSkin {

		// Graphics on the highest LOD index.
		[Embed(source = "../assets/button/stateUp_lod0.png")]
		private static const stateUpLod0:Class;
		public static const stateUpLod0Texture:BitmapData = new stateUpLod0().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod0.png")]
		private static const stateOverLod0:Class;
		public static const stateOverLod0Texture:BitmapData = new stateOverLod0().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod0.png")]
		private static const stateDownLod0:Class;
		public static const stateDownLod0Texture:BitmapData = new stateDownLod0().bitmapData;

		// Graphics on middle LOD index.
		[Embed(source = "../assets/button/stateUp_lod1.png")]
		private static const stateUpLod1:Class;
		public static const stateUpLod1Texture:BitmapData = new stateUpLod1().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod1.png")]
		private static const stateOverLod1:Class;
		public static const stateOverLod1Texture:BitmapData = new stateOverLod1().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod1.png")]
		private static const stateDownLod1:Class;
		public static const stateDownLod1Texture:BitmapData = new stateDownLod1().bitmapData;

		// Graphics on the smallest LOD index.
		[Embed(source = "../assets/button/stateUp_lod2.png")]
		private static const stateUpLod2:Class;
		public static const stateUpLod2Texture:BitmapData = new stateUpLod2().bitmapData;

		[Embed(source = "../assets/button/stateOver_lod2.png")]
		private static const stateOverLod2:Class;
		public static const stateOverLod2Texture:BitmapData = new stateOverLod2().bitmapData;

		[Embed(source = "../assets/button/stateDown_lod2.png")]
		private static const stateDownLod2:Class;
		public static const stateDownLod2Texture:BitmapData = new stateDownLod2().bitmapData;

		// Style data for the biggest LOD
		// Skin edge width
		public static const edge0:int = 15;

		// Button height
		public static const buttonHeight0:int = 54;

		// Padding
		public static const padding0:int = 12;

		// Distance between an icon and a text label.
		public static const space0:int = 8;

		// Minimal button width
		public static const minWidth0:int = 60;

		// Text size
		public static const fontSize0:int = 20;


		// Style data for the middle LOD
		// Skin edge width
		public static const edge1:int = 12;

		// Button height
		public static const buttonHeight1:int = 36;

		// Padding
		public static const padding1:int = 10;

		// Distance between an icon and a text label.
		public static const space1:int = 6;

		// Minimal button width
		public static const minWidth1:int = 50;

		// Text size
		public static const fontSize1:int = 16;

		// Style data for the smallest LOD
		// Skin edge width
		public static const edge2:int = 12;

		// Button height
		public static const buttonHeight2:int = 28;

		// Padding
		public static const padding2:int = 8;

		// Distance between an icon and a text label.
		public static const space2:int = 5;

		// Minimal button width
		public static const minWidth2:int = 50;

		// Text size
		public static const fontSize2:int = 13;

	}

}
