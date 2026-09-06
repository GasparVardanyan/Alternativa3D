package alternativa.gui.theme.defaulttheme.skin {

    import flash.display.BitmapData;

    public class NumericStepperSkin {

        [Embed(source="../resources/numericStepper/decStateDown.png")]
		private static const decStateDownImage:Class;
		public static const decStateDown:BitmapData = new decStateDownImage().bitmapData;

        [Embed(source="../resources/numericStepper/decStateOver.png")]
		private static const decStateOverImage:Class;
		public static const decStateOver:BitmapData = new decStateOverImage().bitmapData;

        [Embed(source="../resources/numericStepper/decStateUp.png")]
		private static const decStateUpImage:Class;
		public static const decStateUp:BitmapData = new decStateUpImage().bitmapData;

        [Embed(source="../resources/numericStepper/incStateDown.png")]
		private static const incStateDownImage:Class;
		public static const incStateDown:BitmapData = new incStateDownImage().bitmapData;

        [Embed(source="../resources/numericStepper/incStateOver.png")]
		private static const incStateOverImage:Class;
		public static const incStateOver:BitmapData = new incStateOverImage().bitmapData;

        [Embed(source="../resources/numericStepper/incStateUp.png")]
		private static const incStateUpImage:Class;
		public static const incStateUp:BitmapData = new incStateUpImage().bitmapData;

		public static const edge:int = 1;
    }
}
