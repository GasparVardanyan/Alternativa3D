package alternativa.gui.theme.defaulttheme.skin {

    import flash.display.BitmapData;

    public class ProgressBarSkin {
        [Embed(source="../resources/progressBar/mask.png")]
		private static const maskImage:Class;
		public static const maskTexture:BitmapData = new maskImage().bitmapData;

        [Embed(source="../resources/progressBar/lineFull.png")]
		private static const lineFullImage:Class;
		public static const lineFullTexture:BitmapData = new lineFullImage().bitmapData;

        [Embed(source="../resources/progressBar/lineBG.png")]
		private static const lineBGImage:Class;
		public static const lineBGTexture:BitmapData = new lineBGImage().bitmapData;

        public static const edge:int = 5;
        public static const lineFullEdge:int = 0;

    }
}
