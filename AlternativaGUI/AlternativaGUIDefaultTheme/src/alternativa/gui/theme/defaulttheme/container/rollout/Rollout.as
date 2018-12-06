package alternativa.gui.theme.defaulttheme.container.rollout {

	import alternativa.gui.alternativagui;
	import alternativa.gui.container.rollout.Rollout;
	import alternativa.gui.container.scrollPane.ScrollPane;
	import alternativa.gui.theme.defaulttheme.controls.scrollBar.ScrollBar;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	use namespace alternativagui;

	/**
	 *
	 * RU: реализация раскрывающегося контейнера с заголовком
     * EN: implementation of the drop container with a title
	 *
	 */
	public class Rollout extends alternativa.gui.container.rollout.Rollout {

		// RU: кнопка-заголовок. При нажатии показывается или скрывается контент
        // ENL button-title. Show or hide content on click
		protected var titleButton:RolloutButton;

		public function Rollout() {
			// RU: задаем высоту заголовка и зазор от него до контента
            // EN: Set title height and distance between title and content
			super(19, 2);
		}

		public function get label():String {
			return titleButton.label;
		}

		public function set label(value:String):void {
			if (titleButton != null)
				titleButton.label = value;
			draw();
		}

		public function get padding():int {
			if (contentContainer != null && contentContainer.hasOwnProperty("padding")) {
				return contentContainer["padding"];
			} else {
				return 0;
			}
		}

		public function set padding(value:int):void {
			if (contentContainer != null && contentContainer.hasOwnProperty("padding")) {
				contentContainer["padding"] = value + NumericConst.borderThickness;
			}
		}
		
		// RU: создание заголовка компоненты
        // EN: create a component title
		override protected function createTitle():DisplayObject {
			titleButton = new RolloutButton();
			return titleButton;
		}
		
		// RU: создание контента контейнера
        // EN: create container content
		override protected function createContentContainer():DisplayObjectContainer {
			var scrollPane:RolloutScrollPane = new RolloutScrollPane();
			scrollPane.padding = NumericConst.basePadding + NumericConst.borderThickness;
//			scrollPane.scrollBar = new ScrollBar();
			return scrollPane;
		}
		
		// RU: вызывается при нажатии на кнопку-заголовок - показываем контент
        // EN: call when click on button-title - show content
		override protected function maximize():void {
			super.maximize();
			if (contentContainer != null) {
				if (!_minimized && titleButton != null)
					titleButton.selected = true;
			}
		}
		
		// RU: вызывается при нажатии на кнопку-заголовок - скрыть контент
        // EN: call when click on button-title - hide content
		override protected function minimize():void {
			super.minimize();
			if (contentContainer != null) {
				if (_minimized && titleButton != null)
					titleButton.selected = false;
			}
		}
		
		// RU: флаг неактивности компоненты
        // EN: flag of component inactivity
		public function get titleButtonLocked():Boolean {
			return titleButton.locked;
		}

		public function set titleButtonLocked(value:Boolean):void {
			titleButton.locked = value;
		}

	}
}
