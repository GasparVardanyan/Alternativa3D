package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.linear.HBox;
	import alternativa.gui.data.DataProvider;
	import alternativa.gui.enum.Align;
	import alternativa.gui.event.DropDownMenuEvent;
	import alternativa.gui.event.RadioButtonGroupEvent;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.IEventDispatcher;
	import flash.events.MouseEvent;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;

	use namespace alternativagui;
	
	/**
	 * Базовый класс выпадающего многоуровневого меню.
	 * 
	 */	
	public class DropDownMenu extends GUIobject {
		
		/**
		 * Группа управления кнопками верхнего уровня. 
		 */		
		protected var group:DropDownMenuGroup;
		
		/**
		 * Поставщик данных. 
		 */		
		protected var _dataProvider:DataProvider;
		
		/**
		 * Контейнер для кнопок верхнего уровня. 
		 */		
		protected var buttonsBox:HBox;
		
		/**
		 * Зазор между кнопками верхнего уровня. 
		 */		
		protected var _buttonsSpace:int = 5;
		
		/**
		 * Высота контейнера с кнопками.
		 */		
		protected var _buttonsHeight:int = 30;
		
		/**
		 * Общий отступ для кнопок верхнего уровня со всех сторон. 
		 */		
		protected var _padding:int = 5;
		
		/**
		 * Фон под кнопками верхнего уровня. 
		 */		
		protected var _background:DisplayObject;
		
		/**
		 * Фон под контейнером элементов. 
		 */		
		protected var _itemsBackground:Class;

		/**
		 * Вертикальный разрыв контейнера (отсчитывается от выделенной кнопки). 
		 */		
		protected var _topGap:int = 1;
		
		/**
		 * Горизонтальный разрыв. 
		 */		
		protected var _rightGap:int = 1;
		
		/**
		 * Горизонтальный отступ 1го контейнера. 
		 */		
		protected var _rightGapFirstPanel:int = 0;
		
		/**
		 * Класс визуального элемента для кнопок верхнего уровня. 
		 */		
		protected var _topButtonRenderer:Class;
		
		/**
		 * Класс визуального элемента для кнопок в панельке. 
		 */		
		protected var _panelItemRenderer:Class;
		
		/**
		 * Зазор между элементами в контейнере. 
		 */		
		protected var _panelItemsSpace:int = 3;
		
		/**
		 * Класс визуального элемента для контейнера. 
		 */		
		protected var _panelRenderer:Class;
		
		/**
		 * Отступ для container.  
		 */		
		protected var _panelPadding:int = 3;
		
		/**
		 * Выделенная кнопка верхнего уровня.
		 */		
		protected var selectedButton:DropDownMenuTopButton;
		protected var _selectedNode:Object;
		
		/**
		 * Вектор контейнеров. 
		 */		
		protected var _containers:Vector.<IDropDownMenuItemContainer>;
		
		/**
		 * Ссылка на stage. 
		 */		
		protected var  __stage:Stage;
		
		/**
		 * Объект, куда добавляеются все панельки. 
		 */		
		protected var _panelsContainer:DisplayObjectContainer;
		
		/**
		 * Задержка появления панельки.
		 */		
		protected var _openPanelDelay:uint = 400;
		protected var _openPanelTimeout:uint;
		
		/**
		 * @private 
		 */		
		protected var removeVector:Vector.<IDropDownMenuItemContainer>;

		/**
		 * Конструктор.
		 * <p>Контейнеры добавляются на stage, для визуального перекрытия.</p>
		 *
		 */
		public function DropDownMenu() {
			super();
			init();
		}
		
		/**
		 * Обновление компоненты, вызывается при изменении поставщика данных.
		 */
		public function update():void {
			var button:DropDownMenuTopButton;
			var num:int = buttonsBox.numChildren;
			for (var i:int = 0; i < num; i++) {
				button = buttonsBox.getChildAt(i) as DropDownMenuTopButton;
				if (button != null) {
					button.update();
				}
			}
			// текущие контейнеры
			for each (var container:IDropDownMenuItemContainer in _containers) {
				container.update();
			}
		}

		/**
		 * Полное уничтожение компоненты.
		 */
		public function destroy():void {
			clear();
			_containers = null;
			_dataProvider = null;
			removeChild(buttonsBox);
			buttonsBox = null;
			group.destroy();
			group = null;
			panelsContainer = null;
			clearTimeout(_openPanelTimeout);
			if(__stage){
				__stage.removeEventListener(MouseEvent.CLICK, onStageClick);
				__stage = null;
			}
			if (parent) {
				parent.removeChild(this);
			}
		}

		/**
		 * Очистка компоненты:
		 * <p>
		 * <listing>
		 * <ul>Cброс выделенной кнопки верхнего уровня.</ul>
		 * <ul>Уничтожение всех открытых панелек.</ul>
		 * </listing></p>
		 */
		public function clear():void {
			group.resetSelectedButton();
			clearAllContainers();
		}

		/**
		 * Поставщик данных.
		 * <p>Необходимые поля:
		 * <listing>
		 * <ul>items:DataProvider (дочерние разделы) </ul>
		 * <ul> parent:Object ссылка на родителя </ul>
		 * <ul> label:String </ul>
		 * </listing></p>
		 *
		 * <p> Необязательные поля:
		 * <pre> locked : Boolean </pre> </p>
		 *
		 * <p> Зарезервированные поля:
		 * <pre> opened:Boolean </pre> </p>
		 */
		public function set dataProvider(value:DataProvider):void {
			if (value != null &&
					value.length > 0 &&
					value != _dataProvider) {
				_dataProvider = value;
				var topButton:DropDownMenuTopButton;
				var object:Object;
				for (var i:int = 0; i < dataProvider.length; i++) {
					object = dataProvider.getItemAt(i);
					topButton = new _topButtonRenderer();
					topButton.data = object;
					group.addButton(topButton);
					buttonsBox.addChild(topButton);
				}
				draw();
			}
		}

		public function get dataProvider():DataProvider {
			return _dataProvider;
		}

		/**
		 * Фон для кнопок верхнего уровня.
		 */
		public function set background(value:DisplayObject):void {
			if (_background && _background.parent) {
				_background.parent.removeChild(_background);
			}
			_background = addChildAt(value, 0);
			draw();
		}

		public function get background():DisplayObject {
			return _background;
		}

		//	расстояние между горизонтальными кнопками
		/**
		 * Расстояние между кнопками верхнего уровня.
		 */
		public function get buttonsSpace():int {
			return _buttonsSpace;
		}
		public function set buttonsSpace(value:int):void {
			_buttonsSpace = value;
			buttonsBox.space = value;
		}

		/**
		 * Высота кнопок верхнего уровня (padding учитывается).
		 */
		public function get buttonsHeight():int {
			return _buttonsHeight;
		}
		public function set buttonsHeight(value:int):void {
			_buttonsHeight = value;
		}

		/**
		 * Вертикальное расстояние между кнопками на панельках.
		 */
		public function get panelItemsSpace():int {
			return _panelItemsSpace;
		}

		public function set panelItemsSpace(value:int):void {
			_panelItemsSpace = value;
		}

		/**
		 * Внутренний отступ для кнопок верхнего уровня.
		 */
		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
			draw();
		}

		/**
		 * Фон для панельки.
		 */
		public function set itemsBackground(value:Class):void {
			_itemsBackground = value;
		}

		/**
		 * Рендер для кнопки верхнего уровня.
		 */
		public function get topButtonRenderer():Class {
			return _topButtonRenderer;
		}
		public function set topButtonRenderer(value:Class):void {
			_topButtonRenderer = value;
		}

		/**
		 * Рендер для кнопки в панельке.
		 */
		public function get panelItemRenderer():Class {
			return _panelItemRenderer;
		}
		public function set panelItemRenderer(value:Class):void {
			_panelItemRenderer = value;
		}

		/**
		 * Разрыв между кнопками верхнего уровня и панелькой.
		 */
		public function get topGap():int {
			return _topGap;
		}
		public function set topGap(value:int):void {
			_topGap = value;
			alignContainers();
		}

		/**
		 * Вертикальный разрыв между панельками.
		 */
		public function get rightGap():int {
			return _rightGap;
		}

		public function set rightGap(value:int):void {
			_rightGap = value;
			alignContainers();
		}

		/**
		 * Внутренний отступ в панельках.
		 */
		public function get panelPadding():int {
			return _panelPadding;
		}

		public function set panelPadding(value:int):void {
			_panelPadding = value;
		}

		/**
		 * Инициализация компоненты.
		 */
		protected function init():void {
			_containers = new Vector.<IDropDownMenuItemContainer>();
			removeVector = new Vector.<IDropDownMenuItemContainer>();
			
			_topButtonRenderer = DropDownMenuTopButton;
			_panelItemRenderer = DropDownMenuItem;
			_panelRenderer = DropDownMenuItemContainer;

			//настройка бокса с кнопками
			buttonsBox = new HBox(_buttonsSpace);
			buttonsBox.align = Align.LEFT;
			addChild(buttonsBox);

			group = new DropDownMenuGroup();
			group.addEventListener(RadioButtonGroupEvent.SELECTED, onTopButtonSelect);

			//клик вне компоненты
			panelsContainer = _panelsContainer || LayoutManager.stage;
			__stage = LayoutManager.stage;
//			__stage.addEventListener(MouseEvent.CLICK, onStageClick);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
			//	учет отступов
			var measuredHeight:int = buttonsHeight - 2*_padding;

			buttonsBox.x = _padding;
			buttonsBox.y = _padding;
			buttonsBox.resize(1, measuredHeight);

			drawBackground();

			alignContainers();
		}
		
		/**
		 * Отрисовка фона. 
		 * 
		 */		
		protected function drawBackground():void{
			if (_background) {
				_background.width = Math.max(buttonsBox.width, _width) + 2*_padding;
				_background.height = buttonsBox.height + 2*_padding;
			}
		}


		/**
		 * Выравнивание контейнеров.
		 */
		protected function alignContainers():void {
			if (_containers != null) {
				var container:IDropDownMenuItemContainer;
				var buttonBoxHeight:int = buttonsBox.height;
				var posX:int;
				var posY:int;
				var dx:Number = 0;
				for (var i:int = 0; i < _containers.length; i++) {
					container = _containers[i];
					if (i == 0) {
						posX = buttonsBox.x + selectedButton.x + _rightGapFirstPanel;
						posY = buttonsBox.height + _topGap + _padding;

						if(__stage){
							dx =  posX + container.backgroundWidth-__stage.stageWidth;
							if( dx > 0){
								posX -= dx;
							}
						}
						container.x = posX;
						container.y = posY;
					} else {

						posX = int(_containers[i - 1].x + _containers[i - 1].backgroundWidth + _rightGap);
						if(__stage){
							 dx =  posX + container.backgroundWidth-__stage.stageWidth;
							if( dx > 0 ){
								posX = int(_containers[i - 1].x - container.backgroundWidth - _topGap);

							}
						}
						container.x = posX;
						// если есть родительская кнопка ( может и не быть )...
						if (container.parentItem) {
							container.y = int(container.parentItem.y + _containers[i - 1].y);
						} else {
							container.y = int(buttonBoxHeight + _topGap);
						}
					}
				}
			}
		}

		/**
		 * Установка состояние узла данных: закрыт/открыт.
		 */
		protected function setNodeState(node:Object, opened:Boolean):void {
			if (node) {
				node.opened = opened;
				var i:int = 0;
				var num:int = 0;
				if (node.items) {
					num = node.items.length;
					for (i = 0; i < node.items.length; i++) {
						// уходим на рекурсию
						setNodeState(node.items.getItemAt(i), false);
					}
				}
			}
		}

		/**
		 * 	Уничтожение всех контейнеров.
		 */
		protected function clearAllContainers():void {
			clearTimeout(_openPanelTimeout);
			while (_containers.length > 0) {
				removeContainer(_containers[0]);
			}
			//_containers = new Vector.<IDropDownMenuItemContainer>();
			_containers.length = 0;
		}

		/**
		 * Проверка контейнеров на факт удаления, проверка проводится по полю data.opened=false.
		 */
		protected function checkContainers():void {
			//var remove:Vector.<IDropDownMenuItemContainer> = new Vector.<IDropDownMenuItemContainer>();
			removeVector.length = 0;
			var item:IDropDownMenuItemContainer;
			var removeVectorCount:int = 0; 
			for each (item in _containers) {
				if (item.data && !item.data.opened) {
					//removeVector.push(item);
					removeVector[removeVectorCount] = item; 
					removeVectorCount++;
				}
			}

			// удаляем только НЕнужное
			for each (item in removeVector) {
				removeContainer(item);
			}
		}

		/**
		 * Удаление панельки.
		 * @param container Контейнер.
		 */
		protected function removeContainer(container:IDropDownMenuItemContainer):void {
			if (!container) {
				return;
			}
			if (container.data) {
				container.data.opened = false;
			}
			container.destroy();
			(container as IEventDispatcher).removeEventListener(DropDownMenuEvent.CREATE_CONTAINER, onCreateContainer);
			(container as IEventDispatcher).removeEventListener(DropDownMenuEvent.CHANGE_ITEM, onChangeItem);
			_containers.splice(_containers.indexOf(container), 1);
		}

		/**
		 * Открытие панельки.
		 * @param node Узел.
		 * @param button Кнопка.
		 */
		protected function createContainer(node:Object, button:DisplayObject):IDropDownMenuItemContainer {
			_selectedNode = node;
			setNodeState(_selectedNode, true);
			checkContainers();

			if (!node ||
				!node.items ||
				node.items.length == 0) {
				return null;
			}

			// панелька
			var container:IDropDownMenuItemContainer = new _panelRenderer(_panelItemsSpace, button as IDropDownMenuItem);
			container.itemRenderer = _panelItemRenderer;
			container.background = _itemsBackground;
			container.padding = _panelPadding;
			(container as IEventDispatcher).addEventListener(DropDownMenuEvent.CREATE_CONTAINER, onCreateContainer);
			(container as IEventDispatcher).addEventListener(DropDownMenuEvent.CHANGE_ITEM, onChangeItem);
			container.data = node;
			if(_panelsContainer){
				// 	проверка на выход из границ

				_panelsContainer.addChild(container as DisplayObject);
			}

			_containers.push(container);

			alignContainers();
			return container;
		}

		/**
		 * Клик на stage.
		 */
		protected function onStageClick(event:MouseEvent):void {
			var objects:Array = MouseManager.objectsUnderCursor;
			// т.к. панели сидят на stage проверяем есть ли objects в панельках
			for each (var obj:DisplayObject in objects) {
				if (this.contains(obj)) {
					return;
				}
				for each (var i:IDropDownMenuItemContainer in _containers) {
					if (obj == i || (i as DisplayObjectContainer).contains(obj)) {
						return;
					}
				}
			}
			clear();
			clearTimeout(_openPanelTimeout);
			CursorManager.reset();
			__stage.removeEventListener(MouseEvent.CLICK, onStageClick);
		}

		/**
		 * Клик на элементе.
		 */
		protected function onChangeItem(event:DropDownMenuEvent):void {
			clear();
			dispatchEvent(new DropDownMenuEvent(DropDownMenuEvent.SELECT, event.button, event.data));
			CursorManager.reset();
			MouseManager.update();
		}

		protected function onTopButtonSelect(event:RadioButtonGroupEvent):void {
			selectedButton = event.button as DropDownMenuTopButton;
			clearAllContainers();
			if (selectedButton) {
				createContainer(selectedButton.data, selectedButton);
				__stage.addEventListener(MouseEvent.CLICK, onStageClick);
			}
		}

		protected function onCreateContainer(event:DropDownMenuEvent):void {
			// делаем задержку на появление
			var currentNode:Object = event.data;
			var button:DisplayObject = event.button as DisplayObject;
			clearTimeout(_openPanelTimeout);
			_openPanelTimeout = setTimeout(executeOnCreateContainer, _openPanelDelay, currentNode, button);
		}

		private function executeOnCreateContainer(currentNode:Object, button:DisplayObject):void {
			if (_selectedNode) {
				// если выделенный совпадает с текущим выходим
				if (_selectedNode == currentNode) {
					return;
				}

				// если одинаковый родитель
				if (currentNode.parent == _selectedNode.parent) {
					// закрываем узел
					setNodeState(_selectedNode, false);

				} else {
					// если родители разные, необходимо закрыть все узлы в родителе
					if (currentNode &&
							currentNode.parent &&
							currentNode.parent.items) {
						var items:DataProvider = currentNode.parent.items;
						var num:int = items.length;
						var i:int = 0;
						var object:Object
					}
					for (i = 0; i < num; i++) {
						object = items.getItemAt(i);
						setNodeState(object, false);
					}
					// и потом снова открыть наведенный
					setNodeState(currentNode, true);
				}
			}
			// открываем контейнер
			createContainer(currentNode, button);
		}
		
		/**
		 * Класс визуального элемента для контейнера. 
		 */
		public function get panelRenderer():Class {
			return _panelRenderer;
		}
		public function set panelRenderer(value:Class):void {
			_panelRenderer = value;
		}
		
		/**
		 * Объект, куда добавляеются все панельки. 
		 */
		public function get panelsContainer():DisplayObjectContainer {
			return _panelsContainer;
		}
		public function set panelsContainer(value:DisplayObjectContainer):void {
			if(_panelsContainer){
				_panelsContainer.removeEventListener(MouseEvent.CLICK, onStageClick);
			}
			_panelsContainer = value;
			if( _panelsContainer){
				_panelsContainer.addEventListener(MouseEvent.CLICK, onStageClick);
			}
		}

		/**
		 * Задержка появления панельки.
		 */
		public function get openPanelDelay():uint {
			return _openPanelDelay;
		}
		public function set openPanelDelay(value:uint):void {
			_openPanelDelay = value;
		}
		
		/**
		 * Горизонтальный отступ 1го контейнера. 
		 */
		public function get rightGapFirstPanel():int {
			return _rightGapFirstPanel;
		}
		public function set rightGapFirstPanel(value:int):void {
			_rightGapFirstPanel = value;
		}
	}
}
