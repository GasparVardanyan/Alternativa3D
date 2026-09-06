package alternativa.gui.theme.defaulttheme.primitives.base {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatVBitmap;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.TextInputSkin;

	use namespace alternativagui;
	
	/**
	 * RU:
	 * Объект с белой подложкой, используется в качестве фона
     * EN:
     * Object with white substrate, used as backgound
	 * 
	 */	
	public class WhiteBG extends GUIobject {

		private var bg:StretchRepeatBitmap;

		public function WhiteBG() {
			super();
			bg = new StretchRepeatBitmap(TextInputSkin.bgTexture, TextInputSkin.edge, TextInputSkin.edge, TextInputSkin.edge, TextInputSkin.edge);
			addChild(bg);

		}

		override protected function draw():void {
			super.draw();
			bg.x = bg.y = -TextInputSkin.offset;
			bg.width = _width + TextInputSkin.offset * 2;
			bg.height = _height + TextInputSkin.offset * 2;
		}



	}
}
