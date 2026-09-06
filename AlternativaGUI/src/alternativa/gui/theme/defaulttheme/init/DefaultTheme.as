package alternativa.gui.theme.defaulttheme.init {
	import alternativa.gui.theme.defaulttheme.fonts.Fonts;
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.controls.text.LabelTF;

	import flash.display.Stage;
	import flash.text.TextFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	
	
	public class DefaultTheme {
		
		public static function init():void {
			Fonts.init();
			LabelTF.embedFonts = false;
			LabelTF.defaultFormat = new TextFormat("Tahoma", 12, 0xffffff, false);
			Label.fontDescription = new FontDescription("Tahoma");
			Label.fontDescription.fontLookup = FontLookup.DEVICE;
		}

	}
}