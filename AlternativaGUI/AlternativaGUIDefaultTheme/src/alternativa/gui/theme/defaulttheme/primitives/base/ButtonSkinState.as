package alternativa.gui.theme.defaulttheme.primitives.base {

	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;
	import alternativa.gui.theme.defaulttheme.skin.ButtonSkin;

	import flash.display.BitmapData;

	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 *  
	 * RU: класс создания скина состояния для кнопки
     * EN: skin of state creation class for the button
	 * 
	 */	
	public class ButtonSkinState extends GUIobject {
		
		// RU: фон
        // EN: background
		private var bgStretch:StretchRepeatBitmap;

		// RU: верхний градиент
        // EN: upper gradient
		private var topGradientStretch:StretchRepeatHBitmap;

		// RU: нижний градиент
        // EN: lower gradient
		private var bottomGradientStretch:StretchRepeatHBitmap;

		// RU: линия градиента
        // EN: gradient line
		private var lineGradientStretch:StretchRepeatHBitmap;

		// RU: рамка
        // EN: frame
		private var borderStretch:StretchRepeatBitmap;
		
		/**
		 * RU:
		 * @param bg - Текстура фона
		 * @param bottomGradient - Текстура нижнего градиента
		 * @param border - Текстура рамки
         * EN:
         * @param bg background - texture
         * @param bottomGradient - lower gradient texture
         * @param border - border texture
		 * 
		 */		
		public function ButtonSkinState(bg:BitmapData, bottomGradient:BitmapData, border:BitmapData = null) {
			super();

			bgStretch = new StretchRepeatBitmap(bg, 5, 5, 5, 5);
			addChild(bgStretch);

			topGradientStretch = new StretchRepeatHBitmap(ButtonSkin.stateUpTopGradientTexture, 5, 5);
			addChild(topGradientStretch);

			bottomGradientStretch = new StretchRepeatHBitmap(bottomGradient,5,5);
			addChild(bottomGradientStretch);

			if (border != null) {
				borderStretch = new StretchRepeatBitmap(border, 5, 5, 5, 5);
				addChild(borderStretch);
			} else {
				lineGradientStretch = new StretchRepeatHBitmap(ButtonSkin.stateUpTopLineGradientTexture, 5, 5);
				addChild(lineGradientStretch);
			}
		}
		
		// RU: позиционирование и изменение размеров
        // EN: set position and change sizes
		override protected function draw():void {
			super.draw();
			bgStretch.width = _width + 2;
			bgStretch.height = _height + 2;
			bgStretch.x = bgStretch.y = -1;

			topGradientStretch.width = _width + 2;
			topGradientStretch.x = topGradientStretch.y = -1;

			bottomGradientStretch.width = _width + 2;
			bottomGradientStretch.x = -1;
			bottomGradientStretch.y = _height - bottomGradientStretch.height + 1;

			if (borderStretch != null) {
				borderStretch.width = _width + 2;
				borderStretch.height = _height + 2;
				borderStretch.x = borderStretch.y = -1;
			} else {
				lineGradientStretch.width = _width + 2;
				lineGradientStretch.x = lineGradientStretch.y = -1;
			}
		}

	}
}
