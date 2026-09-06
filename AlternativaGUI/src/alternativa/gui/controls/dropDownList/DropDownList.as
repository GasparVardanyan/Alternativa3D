package alternativa.gui.controls.dropDownList {

    import alternativa.gui.alternativagui;
    import alternativa.gui.base.ActiveObject;
    import alternativa.gui.base.GUIobject;
    import alternativa.gui.container.list.IItemRenderer;
    import alternativa.gui.container.list.IList;
    import alternativa.gui.controls.button.ITriggerButton;
    import alternativa.gui.data.DataProvider;
    import alternativa.gui.event.ListEvent;
    import alternativa.gui.layout.LayoutManager;
    import alternativa.gui.mouse.MouseManager;
    
    import flash.display.Bitmap;
    import flash.display.BitmapData;
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.display.Stage;
    import flash.events.Event;
    import flash.events.MouseEvent;
    import flash.geom.Point;

	use namespace alternativagui;
	
	/**
	 * Контейнер с выпадающим ленивым списком.
	 * 
	 */	
	public class DropDownList extends GUIobject {
		
		/**
		 * Кнопка контейнера. 
		 */		
		protected var _button:ActiveObject;
		
		/**
		 * Выпадающий контейнер. 
		 */		
		protected var _itemPanel:DisplayObject;
		
		/**
		 * Контейнер для выпадающего меню. 
		 */		
		protected var _container:DisplayObjectContainer;
		
		/**
		 * Зазор между кнопкой и выпадающим контейнером. 
		 */		
		protected var _space:int = 3;
		
		/**
		 * Максимальная высота выпадающего контейнера.
		 */		
		protected var _panelListMaxHeight:int = 240;
		
		/**
		 * Минимальная высота выпадающего контейнера. 
		 */		
		protected var _panelListMinHeight:int = 70;
		
		/**
		 * Индекс выбранного элемента. 
		 */		
		protected var _selectedIndex:int = -1;
		
		/**
		 * Предыдущее значение индекса выбранного элемента. 
		 */		
		protected var oldSelectedIndex:int;
		
		/**
		 * Флаг залоченности контейнера. 
		 */		
		protected var _locked:Boolean = false;		
		
		/**
		 * Отображение контейнера с элементами. 
		 */		
		protected var panelListOpen:Boolean = false;
		
		/**
		 * Флаг показа выпадающего контейнера: снизу или сверху от кнопки.
		 */		
		protected var downPosItemPanel:Boolean = true;
		
		/**
		 * Количество пикселей от нижнего края до выпадающего контейнера.
		 * <p>Используется в случае, когда выпадающий контейнер достигает нижнего края экрана.</p> 
		 */		
		protected var _offsetBottom:int = 20;
		
		public function DropDownList() {
			super();
            mouseEnabled = true;
			mouseChildren = false;
            addEventListener(MouseEvent.CLICK, showItemPanel);
		}

		/**
		 * Индекс выбранного элемента.
		 * @return Индекс 
		 * 
		 */        
		public function get selectedIndex():int {
			return (_itemPanel as IList).selectedIndex;
		}

		/**
		 * Выделяем элемент с нужным индексом. 
		 * @param value Индекс
		 * 
		 */		
		public function set selectedIndex(value:int):void {
			_selectedIndex = value;
			(_itemPanel as IList).selectedIndex = value;
			if (value == -1) {
				(_button as IItemRenderer).data = null;
			}
		}
		
		/**
		 * Выделенный объект.
		 * @return Объект 
		 * 
		 */		
		public function get selectedItem():Object {
			return (_itemPanel as IList).selectedItem;
		}
		
		/**
		 * Поставщик данных. 
		 * 
		 */		
		public function get dataProvider():DataProvider {
			return (_itemPanel as IList).dataProvider;
		}
		public function set dataProvider(value:DataProvider):void {
			(_itemPanel as IList).dataProvider = value;
		}
		
		/**
		 * Флаг залоченности. 
		 * 
		 */		
        public function get locked():Boolean {
            return _locked;
        }
        public function set locked(value:Boolean):void {
            if (_locked != value) {
                _locked = value;
                _button.locked = _locked;
                if (_locked) {
                    this.mouseEnabled = false;
                    this.mouseChildren = false;
                } else {
                    this.mouseEnabled = true;
                    this.mouseChildren = true;
                }
            }
        }

		override public function set height(value:Number):void {
		}
		
		/**
		 * Выпадающий контейнер. 
		 * 
		 */		
        public function set itemPanel(value:IList):void {
            _itemPanel = value as DisplayObject;
            _itemPanel.addEventListener(ListEvent.SELECT_ITEM, selectItem);
            _itemPanel.addEventListener(ListEvent.CLICK_ITEM, listChange);
        }
		
		/**
		 * Класс визуального элемента.
		 * 
		 */		
        public function set itemRenderer(value:Class):void {
            (_itemPanel as IList).itemRenderer = value;
        }

		/**
		 * Контейнер для выпадающего меню. 
		 * 
		 */		
        public function get container():DisplayObjectContainer {
            return _container;
        }
        public function set container(value:DisplayObjectContainer):void {
            _container = value;
        }
		
		/**
		 * Зазор между кнопкой и выпадающим контейнером. 
		 * 
		 */		
        public function get space():int {
            return _space;
        }

        public function set space(value:int):void {
            _space = value;
        }
		
		/**
		 * Максимальная высота выпадающего контейнера.
		 */	
        public function get panelListMaxHeight():int {
            return _panelListMaxHeight;
        }

        public function set panelListMaxHeight(value:int):void {
            _panelListMaxHeight = value;
        }
		
		/**
		 * Минимальная высота выпадающего контейнера.
		 */	
        public function get panelListMinHeight():int {
            return _panelListMinHeight;
        }

        public function set panelListMinHeight(value:int):void {
            _panelListMinHeight = value;
        }
		
		/**
		 * Кнопка. 
		 * 
		 */		
        public function get button():IItemRenderer {
            return _button as IItemRenderer;
        }

        public function set button(value:IItemRenderer):void {
            _button = value as ActiveObject;
            _height = _button.height;
            addChild(_button);
        }
		
		/**
		 * Количество пикселей от нижнего края до выпадающего контейнера.
		 * <p>Используется в случае, когда выпадающий контейнер достигает нижнего края экрана.</p> 
		 */		
        public function get offsetBottom():int {
            return _offsetBottom;
        }

        public function set offsetBottom(value:int):void {
            _offsetBottom = value;
        }
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
            _button.resize(_width, _height);
		}

		/**
		 * Выбрали элемент.
		 * 
		 */        
		protected function selectItem(e:Event):void {
			_selectedIndex = (_itemPanel as IList).selectedIndex;
			updateButton();
		}
		
		/**
		 * Обновление кнопки. 
		 * 
		 */		
		protected function updateButton():void {
			if ((_itemPanel as IList).selectedItem) {
                (_button as IItemRenderer).data = (_itemPanel as IList).selectedItem;
			} else {
				(_button as IItemRenderer).data = null;
			}
			draw();
		}
		
		/**
		 * Показать выпадающий контейнер.
		 * 
		 */		
		protected function showItemPanel(e:Event = null):void {
//            trace("showItemPanel");
			panelListOpen = true;
			(_button as IItemRenderer).selected = true;
			downPosItemPanel = true;

			if (_container == null) {
				_container = LayoutManager.stage;
			}
			_container.addChild(_itemPanel);
//            stage.addChild(_itemPanel);
//            trace("_container: " + _container);
//            trace("contains: " + stage.contains(_itemPanel));

			(_itemPanel as IList).focusIn();

			removeEventListener(MouseEvent.CLICK, showItemPanel);

			LayoutManager.stage.addEventListener(MouseEvent.CLICK, containerClick);
			LayoutManager.stage.addEventListener(Event.RESIZE, hideItemPanel);

			addEventListener(MouseEvent.CLICK, hideItemPanel);

			posItemList();
			resizeItemList();

//            _itemPanel.x = _itemPanel.y = 50;
//            _itemPanel.width = 300;
//            _itemPanel.height = 200;
//            _itemPanel.visible = true;
			
//			trace("show _itemID: " + _itemID);
			if (_selectedIndex >= 0) {
				(_itemPanel as IList).selectedIndex = _selectedIndex;
			}
			oldSelectedIndex = -1;
		}
		
		/**
		 * Скрыть выпадающий контейнер.
		 * 
		 */		
		protected function hideItemPanel(e:Event = null):void {
//            trace("hideItemPanel");
			updateButton();
			panelListOpen = false;
			(_button as IItemRenderer).selected = false;
			(_itemPanel as IList).focusOut();
			
			//_container.removeChild(_itemPanel);
			_container.removeChild(_itemPanel as GUIobject);
//            stage.removeChild(_itemPanel as GUIobject);

			removeEventListener(MouseEvent.CLICK, hideItemPanel);
			LayoutManager.stage.removeEventListener(MouseEvent.CLICK, containerClick);
			LayoutManager.stage.removeEventListener(Event.RESIZE, hideItemPanel);
			addEventListener(MouseEvent.CLICK, showItemPanel);
			MouseManager.update();
		}

		/**
		 * Выбрали элемент.
		 * 
		 */		
		protected function listChange(e:Event):void {
//			trace("DropDownList listChange");
//			trace("     _itemID: " + _itemID);
//            trace("     oldItemID: " + oldItemID);
			
			hideItemPanel();
			if(_selectedIndex != oldSelectedIndex) {
//				trace("не равен oldItemID");
//				trace("     _itemID != oldItemID");
				dispatchEvent(new ListEvent(ListEvent.LIST_CHANGE));
				oldSelectedIndex = _selectedIndex;
				
			} else {
//				trace("равен oldItemID");
			}
		}
		
		/**
		 * Определение нажатия на контейнер или мимо.
		 * 
		 */		
		protected function containerClick(e:MouseEvent):void {
//            trace("containerClick");
			var point:Point = new Point(_itemPanel.x, _itemPanel.y);
			point = _itemPanel.parent.localToGlobal(point);
			// если попали мимо контейнера
			if ((e.stageX < point.x) || (e.stageX > (point.x + _itemPanel.width)) || (e.stageY < (point.y - (downPosItemPanel ? _height : 0))) || (e.stageY > (point.y + _itemPanel.height + (!downPosItemPanel ? _height : 0)))) {
				hideItemPanel();
			}
		}
		
		/**
		 * Изменение размеров выпадающего контейнера.
		 * 
		 */		
        private function resizeItemList():void {
			var panelHeight:int = _panelListMaxHeight;
			var delta:int = 0;
			var heightContent:int = 0;
			var listMaxHeight:int = _panelListMaxHeight;
			var listMinHeight:int = _panelListMinHeight;

			heightContent = LayoutManager.stage.stageHeight - (this.y + this.height + _offsetBottom + _space);

			if (heightContent < _panelListMinHeight) {
				heightContent = _panelListMinHeight;
			}
			if (heightContent > _panelListMaxHeight) {
				heightContent = _panelListMaxHeight;
			}
			
			if (((_itemPanel.y + heightContent + _offsetBottom) > LayoutManager.stage.stageHeight)) {
                downPosItemPanel = false;
                (_itemPanel as GUIobject).resize(_width, _panelListMaxHeight);
                posItemList();
            } else {
                (_itemPanel as GUIobject).resize(_width, heightContent);
                downPosItemPanel = true;
            }
		}
		
		/**
		 * Изменение позиции выпадающего контейнера. 
		 * 
		 */		
		protected function posItemList():void {
			var coords:Point = this.localToGlobal(new Point(0, _height));
			_itemPanel.x = coords.x;
			if (downPosItemPanel) {
				_itemPanel.y = coords.y + _space;
			} else {
				_itemPanel.y = coords.y - _space - _height - _itemPanel.height;
			}
		}
    }
}