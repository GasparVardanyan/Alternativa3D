package alternativa.gui.theme.defaulttheme.controls.text {
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;


	public class Label extends alternativa.gui.controls.text.Label {
		public function Label(autosize:Boolean=true) {
			super(autosize);

			size = NumericConst.textSize;
			color = NumericConst.textColor;
		}

	}
}
