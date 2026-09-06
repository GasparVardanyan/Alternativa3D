package alternativa.gui.theme.defaulttheme.controls.scrollBar {

	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;

	use namespace alternativagui;

	public class Track extends WhiteBG {

		public function Track() {
			super();
			
			// RU: задаем ширину
            // EN: set the width
			_width = calculateWidth(_width);
		}
		
		// RU: отдаем фиксированную ширину
        // EN: return the fixed width
		override protected function calculateWidth(value:int):int {
			return NumericConst.scrollBarWidth;
		}
	}
}
