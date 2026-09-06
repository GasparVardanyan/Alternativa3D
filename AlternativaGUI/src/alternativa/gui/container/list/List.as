package alternativa.gui.container.list {

    import alternativa.gui.alternativagui;
    import alternativa.gui.base.GUIobject;
    import alternativa.gui.controls.scrollBar.ScrollBar;
    import alternativa.gui.controls.text.Label;
    import alternativa.gui.data.DataProvider;
    import alternativa.gui.event.ListEvent;
    import alternativa.gui.event.ScrollBarEvent;
    import alternativa.gui.layout.LayoutManager;
    import alternativa.gui.mouse.MouseManager;
    
    import flash.display.DisplayObject;
    import flash.display.DisplayObjectContainer;
    import flash.display.InteractiveObject;
    import flash.events.Event;
    import flash.events.MouseEvent;

    use namespace alternativagui;
	
	/**
	 * Ленивый контейнер со списком элементов.
	 * <p>Отрисовывает только те элементы, которые видны в данный момент.</p> 
	 * <p>Позволяет выбрать только один элемент из списка.</p>
	 */	
    public class List extends GUIobject implements IList {
				
		/**
		 * Контейнер элементов.
		 */		
		protected var _container:IItemContainer;
		
		/**
		 * Скроллбар. 
		 */		
		protected var _scrollBar:ScrollBar;
		
		/**
		 * Отступ контейнера от краев. 
		 */		
		protected var _padding:int = 0;
		
		/**
		 * Зазор между элементами. 
		 */		
		protected var _space:int = 1;
		
		/**
		 * Зазор между контентом и скроллбар. 
		 */		
		protected var _scrollBarSpace:int = 1;
		
		/**
		 * Фон. 
		 */		
        protected var _background:DisplayObject;
		
		/**
		 * Флаг на фокус компоненты. 
		 */		
        protected var listFocus:Boolean = false;

        public function List() {
            addEventListener(MouseEvent.CLICK, focusIn);
        }

		/**
		 * @inheritDoc
		 * 
		 */		
		public function focusIn(e:Event = null):void {
			if (!listFocus) {
				listFocus = true;
				_container.activate = true;
				removeEventListener(MouseEvent.CLICK, focusIn);
				LayoutManager.stage.addEventListener(MouseEvent.MOUSE_DOWN, focusOut);
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function focusOut(e:Event = null):void {

			if (listFocus) {
				listFocus = false;
				_container.activate = false;
				addEventListener(MouseEvent.CLICK, focusIn);
				LayoutManager.stage.removeEventListener(MouseEvent.MOUSE_DOWN, focusOut);
			}
		}
		
		/**
		 * Обновление листа.
		 * 
		 */		
		public function update(e:Event = null):void {
			if(_container!=null) {
				_container.update();
			}
			draw();
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
		 * @inheritDoc
		 * 
		 */
		public function get dataProvider():DataProvider {
			return _container.dataProvider;
		}
        public function set dataProvider(value:DataProvider):void {
			if (_scrollBar!=null) _scrollBar.scrollPosition = 0;
            _container.dataProvider = value;
        }
		
		/**
		 * @inheritDoc
		 * 
		 */
		public function set itemRenderer(value:Class):void {
			_container.itemRenderer = value;
		}

		/**
		 * @inheritDoc
		 * 
		 */		
        public function get selectedIndex():int {
            return _container.selectedIndex;
        }
        public function set selectedIndex(value:int):void {
            _container.selectedIndex = value;
        }
		
		/**
		 * @inheritDoc
		 * 
		 */	
        public function get selectedItem():Object {
            return _container.selectedItem;
        }
		
		/**
		 * Высота контейнера элементов.
		 * 
		 */		
		public function get contentHeight():Number {
			return _container.contentHeight;
		}
		
		/**
		 * Фон.
		 * 
		 */		
        public function get background():DisplayObject {
            return _background;
        }
        public function set background(value:DisplayObject):void {
            if (_background != null) {
                if (contains(_background)) {
                    removeChild(_background);
                }
                _background = null;
            }
            if (value!=null) {
                _background = value;
                addChildAt(_background, 0);
            }
            draw();
        }
		
		
		/**
		 * Контейнер элементов. 
		 * 
		 */
        public function get container():IItemContainer {
            return _container;
        }
        public function set container(value:IItemContainer):void {
			if (_container != null) {
				(_container as InteractiveObject).removeEventListener(Event.CHANGE, updateMaxScrollPosition);
				(_container as InteractiveObject).removeEventListener(ListEvent.REMOVE_DATA, update);
				(_container as InteractiveObject).removeEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				(_container as InteractiveObject).removeEventListener(ListEvent.CHANGE_POSITION, updateScrollPosition);
				(_container as InteractiveObject).removeEventListener(ListEvent.REDRAW, redraw);
				(_container as InteractiveObject).removeEventListener(ListEvent.CLICK_ITEM, selectedHandler);
				(_container as InteractiveObject).removeEventListener(ListEvent.SELECT_ITEM, selectedHandler);
				if (contains(_container as DisplayObject)) {
					removeChild(_container as DisplayObject);
				}
				_container = null;
			}
			
			if (value != null) {
	            _container = value;
	            (_container as InteractiveObject).mouseEnabled = true;
				(_container as InteractiveObject).addEventListener(Event.CHANGE, updateMaxScrollPosition);
				(_container as InteractiveObject).addEventListener(ListEvent.REMOVE_DATA, update);
				(_container as InteractiveObject).addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
				(_container as InteractiveObject).addEventListener(ListEvent.CHANGE_POSITION, updateScrollPosition);
				(_container as InteractiveObject).addEventListener(ListEvent.REDRAW, redraw);
				(_container as InteractiveObject).addEventListener(ListEvent.CLICK_ITEM, selectedHandler);
				(_container as InteractiveObject).addEventListener(ListEvent.SELECT_ITEM, selectedHandler);
	            addChild(_container as DisplayObject);
			}
            draw();
        }
		
		protected function selectedHandler(e:Event):void {
			drawChildren();
		}
		
		/**
		 * Скроллбар.
		 * 
		 */
        public function get scrollBar():ScrollBar {
            return _scrollBar;
        }
        public function set scrollBar(value:ScrollBar):void {
			if (_scrollBar != null) {
				if(contains(_scrollBar)) {
					removeChild(_scrollBar);
				}
				_scrollBar.removeEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollPosition);
				_scrollBar = null;
			}
			if (value != null) {
            	_scrollBar = value;
            	_scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, changeScrollPosition);
            	addChild(_scrollBar);
			}
        }
		
		/**
		 * Зазор между элементами.
		 * 
		 */
        public function get space():int {
            return _space;
        }
        public function set space(value:int):void {
            _space = value;
			if (container != null && DisplayObjectContainer(container).hasOwnProperty("space")) {
				container["space"] = _space;
			}
        }
		
		/**
		 * Зазор между контентом и скроллбар.
		 * 
		 */
        public function get scrollBarSpace():int {
            return _scrollBarSpace;
        }
        public function set scrollBarSpace(value:int):void {
			_scrollBarSpace = value;
        }
		
		/**
		 * Вызов отрисовки.
		 * 
		 */		
		protected function redraw(e:Event=null):void {
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
        override protected function draw():void {
            super.draw();
            if (_background!=null) {
                _background.x = _background.y = 0;
                _background.width = _width;
                _background.height = _height;
            }
            if (_container!=null) {
                (_container as DisplayObject).x = (_container as DisplayObject).y = _padding;
                (_container as DisplayObject).height = _height - _padding*2;
				if (_scrollBar == null || (_scrollBar != null && !_container.showScrollBar)) {
                	(_container as DisplayObject).width = _width - _padding*2;
				}
            }
            if (_scrollBar!=null) {
                if (_container!=null && _container.showScrollBar) {
                    (_container as DisplayObject).width = _width - _padding*2 - _scrollBar.width - _scrollBarSpace;
                    _scrollBar.maxScrollPosition = Math.abs((_container as DisplayObject).height - _container.contentHeight);
                    _scrollBar.x = _width - _scrollBar.width;
                    _scrollBar.y = 0;
                    _scrollBar.height = _height;
                    _scrollBar.visible = true;
                } else {
                    _scrollBar.visible = false;
                }
            }
        }
		
        protected function mouseWheelHandler(e:MouseEvent):void {
            if (_scrollBar != null && _scrollBar.visible) {
                _scrollBar.onMouseWheel(e);
            }
            MouseManager.update();
        }
		
		/**
		 * Скролирование контейнера.
		 * 
		 */		
        protected function changeScrollPosition(e:Event):void {
            _container.vertValue = _scrollBar.scrollPosition;
            MouseManager.update();
        }
		
		/**
		 * Обновление maxScrollPosition у scrollBar.
		 * 
		 */		
        protected function updateMaxScrollPosition(e:Event):void {
            _scrollBar.maxScrollPosition = Math.abs((_container as DisplayObject).height  - _container.contentHeight);
			_scrollBar.drawChildren();
        }
		
		/**
		 * Обновление scrollPosition у scrollBar.
		 * 
		 */		
        protected function updateScrollPosition(e:Event):void {
			_scrollBar.scrollPosition = _container.vertValue;
		}

		/**
		 * @inheritDoc 
		 * 
		 */		
        override protected function calculateHeight(value:int):int {
            if (_container!=null) {
                (_container as DisplayObject).height = value - _padding*2;
                var h:int = (_container as DisplayObject).height + _padding*2;
                if (_container.showScrollBar && _scrollBar != null) {
                    _scrollBar.height = value;
                    if (h < _scrollBar.height) h = _scrollBar.height;
                }

                if (value < h) value = h;
				updateMaxScrollPosition(null);
            }
            return value;
        }
    }
}
