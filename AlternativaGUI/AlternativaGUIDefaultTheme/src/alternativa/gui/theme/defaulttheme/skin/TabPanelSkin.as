package alternativa.gui.theme.defaulttheme.skin {

    import flash.display.BitmapData;

    public class TabPanelSkin {
        [Embed(source="../resources/tabPanel/contentBg.png")]
		private static const contentBgImage:Class;
		public static const contentBgBD:BitmapData = new contentBgImage().bitmapData;

        [Embed(source="../resources/tabPanel/tabSelected.png")]
		private static const stateDownImage:Class;
		public static const stateDownBD:BitmapData = new stateDownImage().bitmapData;

        [Embed(source="../resources/tabPanel/tabOver.png")]
		private static const stateOverImage:Class;
		public static const stateOverBD:BitmapData = new stateOverImage().bitmapData;

        [Embed(source="../resources/tabPanel/tabUp.png")]
		private static const stateUpImage:Class;
		public static const stateUpBD:BitmapData = new stateUpImage().bitmapData;

        public static const buttomTopOffset:int = 1;
        public static const buttomHorOffset:int = 2;
        public static const buttomEdge:int = 8;

		public static const bgEdge:int = 8;
        public static const bgTopOffset:int = 1;
        public static const bgHorOffset:int = 2;
        public static const bgBottomOffset:int = 3;
    }
}
