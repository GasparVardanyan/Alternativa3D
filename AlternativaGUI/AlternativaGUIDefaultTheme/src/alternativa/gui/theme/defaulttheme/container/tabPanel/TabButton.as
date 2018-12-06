package alternativa.gui.theme.defaulttheme.container.tabPanel {

	import alternativa.gui.theme.defaulttheme.controls.buttons.ToggleButton;
	import alternativa.gui.theme.defaulttheme.primitives.base.StretchBitmapOffset;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.TabPanelSkin;
	import alternativa.gui.alternativagui;

	use namespace alternativagui;

	/**
	 *
	 * RU: Кнопка - вкладка для TabPanel
     * EN: Button-tab for TabPanel
	 *
	 */
	public class TabButton extends ToggleButton {
		public function TabButton() {
			// RU: задаем состояния кнопки
            // EN: set the button states
			stateDOWN = new StretchBitmapOffset(TabPanelSkin.stateDownBD, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, true, TabPanelSkin.buttomTopOffset, TabPanelSkin.buttomHorOffset, TabPanelSkin.buttomHorOffset);
			stateOVER = new StretchBitmapOffset(TabPanelSkin.stateOverBD, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, true, TabPanelSkin.buttomTopOffset, TabPanelSkin.buttomHorOffset, TabPanelSkin.buttomHorOffset);
			stateUP = new StretchBitmapOffset(TabPanelSkin.stateUpBD, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, TabPanelSkin.buttomEdge, true, TabPanelSkin.buttomTopOffset, TabPanelSkin.buttomHorOffset, TabPanelSkin.buttomHorOffset);

			// RU: задаем высоту кнопки
            // EN: ste the button height
			_height = NumericConst.tabButtonHeight;
		}

		// RU: отдаем фикисированную высоту
        // EN: return the fixed height
		override protected function calculateHeight(value:int):int {
			return _height;
		}
	}
}
