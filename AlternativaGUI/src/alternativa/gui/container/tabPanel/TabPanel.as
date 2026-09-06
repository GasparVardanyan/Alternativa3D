package alternativa.gui.container.tabPanel {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.button.ITriggerButton;
	import alternativa.gui.controls.button.RadioButtonGroup;
	import alternativa.gui.event.RadioButtonGroupEvent;
	import alternativa.gui.event.TabPanelEvent;
	import alternativa.gui.layout.LayoutManager;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	/**
	 * Контейнер с навигацией по вкладкам.
	 * <p>Для добавления разделов, надо воспользоваться <code>TabData</code>. Добавление элементов с помощью <code>addTab</code>.</p>
	 *
	 * @see TabData
	 *
	 */
	public class TabPanel extends GUIobject {

		protected var _padding:int = 5;

		protected var _space:int = 5;

		protected var _tabSpace:int = 5;

		protected var tabData:Vector.<TabData>;

		protected var selectedTabIndex:int = -1;

		protected var radioGroup:RadioButtonGroup;

		protected var contentContainer:DisplayObject;

		public function TabPanel() {
			tabData = new Vector.<TabData>();
			radioGroup = new RadioButtonGroup();
			radioGroup.addEventListener(RadioButtonGroupEvent.SELECTED, RadioButtonSelectedHandler)
		}

		/**
		 * Добавить вкладку с контентом.
		 *
		 */
		public function addTab(object:TabData):void {
			tabData.push(object);
			radioGroup.addButton((object.button as ITriggerButton));
			if (tabData.length == 1)
				selectTab = 0;
		}

		/**
		 * Добавить вкладку с контентом. Вкладка добавляется к указанной позиции индекса.
		 *
		 */
		public function addTabAt(object:TabData, index:int):void {
			var temp:TabData = tabData[selectedTabIndex];
			tabData.splice(index, 0, object);
			radioGroup.addButton((object.button as ITriggerButton));
			if (tabData.length == 1)
				selectTab = 0;
			selectTab = tabData.indexOf(temp);
		}

		/**
		 *
		 * Удалить вкладку с контентом.
		 *
		 */
		public function removeTab(object:TabData):void {
			var index:int = tabData.indexOf(object);
			//if (index >= 0) {
			try {
				var temp:TabData = tabData[selectedTabIndex];
				tabData.splice(index, 1);
				radioGroup.removeButton(object.button as ITriggerButton);
				if (index > 0 && index == selectedTabIndex) {
					selectTab = selectedTabIndex - 1;
				} else if (index == 0) {
					selectTab = 0;
				} else {
					selectTab = tabData.indexOf(temp);
				}
//			} else {
//				return;
//			}
			}
			catch (e:Error) {
				throw new Error("Предоставленный TabData должен быть элементом вызывающего объекта.");
			}
		}

		/**
		 *
		 * Удалить вкладку с контентом из заданной позиции индекса.
		 *
		 */
		public function removeTabAt(index:int):TabData {
//			if (index >= 0 && index < tabData.length) {
			try {
				var temp:TabData = tabData[selectedTabIndex];
				var tb:TabData = tabData.splice(index, 1)[0];
				radioGroup.removeButton(tb.button as ITriggerButton);
				if (index > 0 && index == selectedTabIndex) {
					selectTab = selectedTabIndex - 1;
				} else if (index == 0) {
					selectTab = 0;
				} else {
					selectTab = tabData.indexOf(temp);
				}

//			} else {
//				return null;
//			}
			}
			catch (e:Error) {
				throw new Error("Предоставленный индекс выходит за допустимые пределы.");
			}
			return tb;
		}

		/**
		 *
		 * Возвращает экземпляр объекта TabData из заданной позиции индекса.
		 *
		 */
		public function getTabAt(index:int):TabData {
			if (index >= 0 && index < tabData.length) {
				return tabData[index];
			} else {
				return null;
			}
		}


		/**
		 * Возвращает позицию индекса для экземпляра TabData.
		 * @return Возвращает индекс объекта TabData. Возвращает -1 если не найдень объект TabData.
		 *
		 */
		public function getTabIndex(object:TabData):int {
			var index:int = tabData.indexOf(object);
			if (index >= 0) {
				return index;
			} else {
				return -1;
			}
		}

		/**
		 * Обновление панели.
		 *
		 */
		public function update():void {
			resize(_width, _height);
			draw();
			drawChildren();
		}

		/**
		 *
		 * Возвращает TabData текущей вкладки.
		 *
		 */
		public function getCurrentTab():TabData {
			return tabData[selectedTabIndex];
		}

		/**
		 *
		 * Возвращает количество вкладок.
		 *
		 */
		public function get numTabs():int {
			return tabData.length;
		}

		/**
		 * Выбрать вкладку.
		 * @param index Индекс вкладки.
		 *
		 */
		public function get selectTab():int {
			return selectedTabIndex;
		}

		public function set selectTab(index:int):void {
			try {
				//if (index >= 0 && index <= tabData.length) {
				tabData[index].button.selected = true;
				//}
				changeContent(index);
			}
			catch (e:Error) {
				throw new Error("Предоставленный индекс выходит за допустимые пределы.");
			}
		}

		/**
		 * Изменение контента.
		 * @param index Индекс вкладки.
		 *
		 */
		protected function changeContent(index:int):void {
			if (contentContainer != null) {
				if (contains(contentContainer))
					removeChild(contentContainer);
			}
			contentContainer = tabData[index].content;
			addChild(contentContainer);
			resize(_width, _height);
			draw();
			selectedTabIndex = index;
			dispatchEvent(new TabPanelEvent(TabPanelEvent.SELECTED, index));
		}

		/**
		 * Внутренний отступ.
		 *
		 */
		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
		}

		/**
		 * Зазор между вкладками и контентом.
		 *
		 */
		public function get space():int {
			return _space;
		}

		public function set space(value:int):void {
			_space = value;
		}

		/**
		 * Зазор между вкладками.
		 *
		 */
		public function get tabSpace():int {
			return _tabSpace;
		}

		public function set tabSpace(value:int):void {
			_tabSpace = value;
		}

		/**
		 * Слушатель группы кнопок. Вызывается, когда выбрана вкладка.
		 *
		 */
		protected function RadioButtonSelectedHandler(event:RadioButtonGroupEvent):void {
			for (var i:int = 0; i < tabData.length; i++) {
				if (tabData[i].button == event.button) {
					changeContent(i);
					break;
				}
			}
		}
	}
}
