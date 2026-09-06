package alternativa.gui.theme.defaulttheme.controls.dropDownMenu {
	import alternativa.gui.theme.defaulttheme.skin.DropDownMenuSkin;
	import alternativa.gui.theme.defaulttheme.skin.ItemsBackground;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.dropDownMenu.DropDownMenu;
	import alternativa.gui.primitives.stretch.StretchBitmap;

	use namespace alternativagui;

	public class DropDownMenu extends alternativa.gui.controls.dropDownMenu.DropDownMenu {
		public function DropDownMenu() {
			super();
		}

		override protected function init():void {
			super.init();
			// RU: плашка под кнопками верхнего уровня
            // EN: plate over the top-level buttons
			background = new StretchBitmap(DropDownMenuSkin.topBackgroundTexture, 1, 1, 1, 1);
			// RU: фон вертикальной панельки с кнопками ( класс )
            // EN: background of vertical panel with buttons (class)
			itemsBackground = ItemsBackground;
			// RU: рендер для топ меню
            // EN: render for top-menu
			topButtonRenderer = DropDownMenuTopButton;
			// RU: рендер для items в вертикальной панельке
            // EN: render for items in vertical panel
			panelItemRenderer = DropDownMenuItem;

			_topGap = 1;
			_rightGap = -5;
			_panelItemsSpace = 4;
			_panelPadding = 2;
			_buttonsSpace = 1;
			// RU: поправка отступа для панельки 1го уровня
            // EN: correction of the 1st-level panel indent
			_rightGapFirstPanel = 1;
		}
	}
}
