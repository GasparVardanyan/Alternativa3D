package alternativa.gui.theme.defaulttheme.primitives.panel {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.PanelSkin;
	use namespace alternativagui;

	/**
	 * RU:
	 * Класс фона, используется в SimplePanel
     * EN:
     * background class, used at SimplePanel
	 *
	 */
	public class BackgroundPanel extends GUIobject {

		protected var bgStretch:StretchRepeatBitmap;

		protected var lineStretch:StretchRepeatHBitmap;

		// RU: минимальная высота
        // EN: minimal height
		protected var minHeight:int;

		// RU: минимальная ширина
        // EN: minimal width
		protected var minWidth:int;

		public function BackgroundPanel() {
			super();

			minHeight = NumericConst.panelMinHeight;
			minWidth = NumericConst.panelMinWidth;

			bgStretch = new StretchRepeatBitmap(PanelSkin.panelBgTexture, PanelSkin.panelEdgeH, PanelSkin.panelEdgeH, PanelSkin.panelEdgeV, PanelSkin.panelEdgeV);
			addChild(bgStretch);
		}

		override protected function draw():void {
			super.draw();
			bgStretch.x = -PanelSkin.offsetBgLeft;
			bgStretch.y = -PanelSkin.offsetBgTop;
			bgStretch.width = _width + PanelSkin.offsetBgLeft + PanelSkin.offsetBgRight;
			bgStretch.height = _height + PanelSkin.offsetBgTop + PanelSkin.offsetBgBottom;
		}

		// RU: смотрим значение высоты, если меньше заданного, отдаем минимальную высоту
        // EN: if height value is less than the specified value, then return minimal height value
		override protected function calculateHeight(value:int):int {
			if (value < minHeight) {
				return minHeight;
			} else {
				return value;
			}
		}

		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (value < minWidth) {
				return minWidth;
			} else {
				return value;
			}
		}
	}
}
