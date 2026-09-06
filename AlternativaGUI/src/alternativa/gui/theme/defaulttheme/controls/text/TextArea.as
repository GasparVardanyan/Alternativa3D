package alternativa.gui.theme.defaulttheme.controls.text {

	import alternativa.gui.theme.defaulttheme.controls.scrollBar.ScrollBar;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.controls.text.TextArea;

	import flash.display.DisplayObject;

	import alternativa.gui.alternativagui;
	use namespace alternativagui;

	public class TextArea extends alternativa.gui.controls.text.TextArea {
		
		// RU: фон
        // EN: background
		protected var background:WhiteBG;
		
		// RU: толщина рамки фона
        // EN: background frame thickness
		protected var borderThickness:int = NumericConst.borderThickness;

		public function TextArea() {
			super();

			textInput.color = NumericConst.textColor;

			background = new WhiteBG();
			addChildAt(background, 0);
			
			// RU: создаем и добавляем scrollBar
            // EN: create and add scrollBar
			scrollBar = new ScrollBar();
			(scrollBar as ScrollBar).stepScroll = NumericConst.textAreaStepScroll;
			(scrollBar as ScrollBar).mouseDelta = NumericConst.textAreaMouseDelta;
			addChild(scrollBar);
			// RU: задаем слушателей для scrollBar
            // EN: set listeners for the scrollBar
			configureScrollBarListeners(scrollBar);
		}
		
		// RU: позиционирование и задание размеров
        // EN: set position and sizes
		override protected function redrawGraphiсs():void {
			background.resize(_width, _height);
			textInput.x = textInput.y = _padding + borderThickness;
			textInput.resize((_width - _padding * 2 - borderThickness * 2), (_height - _padding * 2 - borderThickness * 2));
			scrollBar.x = _width - scrollBar.width;
			scrollBar.height = _height;
			if (textInput.tf.maxScrollV > 1) {
				scrollBar.visible = true;
				textInput.resize((_width - _padding * 2 - scrollBar.width + 2 - borderThickness * 2), (_height - _padding * 2 - borderThickness * 2));
			} else {
				scrollBar.visible = false;
			}
		}
	}
}
