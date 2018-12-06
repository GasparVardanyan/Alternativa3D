package alternativa.gui.theme.defaulttheme.skin {

    import flash.display.BitmapData;

    public class RolloutSkin  {
        [Embed(source="../resources/rollout/down.png")]
		private static const stateDownImage:Class;
		public static const stateDown:BitmapData = new stateDownImage().bitmapData;

        [Embed(source="../resources/rollout/up.png")]
		private static const stateUpImage:Class;
		public static const stateUp:BitmapData = new stateUpImage().bitmapData;

        [Embed(source="../resources/rollout/border.png")]
		private static const borderImage:Class;
		public static const border:BitmapData = new borderImage().bitmapData;

        public static const edge:int = 5;
    }
}
