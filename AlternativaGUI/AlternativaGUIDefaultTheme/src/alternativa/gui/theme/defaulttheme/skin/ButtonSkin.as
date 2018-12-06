package alternativa.gui.theme.defaulttheme.skin {
	import flash.display.BitmapData;

	
    public class ButtonSkin	{
		
		[Embed(source="../resources/button/up/bg.png")] 
		private static const stateUpBg:Class;
		public static const stateUpBgTexture:BitmapData = new stateUpBg().bitmapData;
		
		[Embed(source="../resources/button/up/bottomGradient.png")] 
		private static const stateUpBottomGradient:Class;
		public static const stateUpBottomGradientTexture:BitmapData = new stateUpBottomGradient().bitmapData;
		
		[Embed(source="../resources/button/up/topGradient.png")] 
		private static const stateUpTopGradient:Class;
		public static const stateUpTopGradientTexture:BitmapData = new stateUpTopGradient().bitmapData;
		
		[Embed(source="../resources/button/up/topLineGradient.png")] 
		private static const stateUpTopLineGradient:Class;
		public static const stateUpTopLineGradientTexture:BitmapData = new stateUpTopLineGradient().bitmapData;
		
		[Embed(source="../resources/button/over/bg.png")] 
		private static const stateOverBg:Class;
		public static const stateOverBgTexture:BitmapData = new stateOverBg().bitmapData;
		
		[Embed(source="../resources/button/over/bottomGradient.png")] 
		private static const stateOverBottomGradient:Class;
		public static const stateOverBottomGradientTexture:BitmapData = new stateOverBottomGradient().bitmapData;
		
		[Embed(source="../resources/button/down/bg.png")] 
		private static const stateDownBg:Class;
		public static const stateDownBgTexture:BitmapData = new stateDownBg().bitmapData;
		
		[Embed(source="../resources/button/down/bottomGradient.png")]
		private static const stateDownBottomGradient:Class;
		public static const stateDownBottomGradientTexture:BitmapData = new stateDownBottomGradient().bitmapData;
		
		[Embed(source="../resources/button/down/borders.png")] 
		private static const stateDownBorder:Class;
		public static const stateDownBorderTexture:BitmapData = new stateDownBorder().bitmapData;

	}
}