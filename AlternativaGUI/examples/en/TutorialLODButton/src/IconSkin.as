package {
	import flash.display.BitmapData;

	public class IconSkin {

		[Embed(source = "../assets/button/icon0.png")]
		private static const iconLod0:Class;
		public static const iconLod0Texture:BitmapData = new iconLod0().bitmapData;

		[Embed(source = "../assets/button/icon1.png")]
		private static const iconLod1:Class;
		public static const iconLod1Texture:BitmapData = new iconLod1().bitmapData;

		[Embed(source = "../assets/button/icon2.png")]
		private static const iconLod2:Class;
		public static const iconLod2Texture:BitmapData = new iconLod2().bitmapData;

	}

}
