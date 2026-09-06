package alternativa.gui.container.scrollPane {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.scrollBar.ScrollBar;
	import alternativa.gui.event.ScrollBarEvent;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	use namespace alternativagui;
	
	/**
	 * Скролируемый контейнер с возможностью задания контента и скроллбара. Для корректной работы контейнера, надо сначало задать ScrollBar.
	 * 
	 * @see alternativa.gui.container.scrollArea.ScrollArea
	 * 
	 */	
	public class ScrollPane extends GUIobject {

		/**
		 * Внутренний отступ.
		 * 
		 */	
		protected var _padding:int = 0;
		
		/**
		 * Скроллбар.
		 * 
		 */	
		protected var _scrollBar:ScrollBar;
		
		/**
		 * Содержимое контейнера.
		 * 
		 */
		protected var _content:DisplayObject;
		
		/**
		 * Контейнер для контента. 
		 */		
		protected var _contentContainer:Sprite;
		
		/**
		 * ScrollRect контента. 
		 */		
		protected var _contentScrollRect:Rectangle;
		
		/**
		 * Фон.
		 * 
		 */	
		protected var _background:DisplayObject;

		public function ScrollPane() {
			super();
			mouseChildren = true;
			mouseEnabled = true;
			_contentContainer = new Sprite();
			addChild(_contentContainer);
		}

		/**
		 * Вызывается при изменение позиции scrollBar.
		 * 
		 */		
		protected function redraw(e:Event = null):void {
			//trace(_scrollBar.scrollPosition);
			switch (e.type) {
				case ScrollBarEvent.SCROLL_CHANGE:
					changeScrollRect();
					break;
				case ScrollBarEvent.SCROLL_START:
					//_content.cacheAsBitmap = true;
					break;
				case ScrollBarEvent.SCROLL_STOP:
					//_content.cacheAsBitmap = false;
					break;
			}
		}
		
		/**
		 * Обновление scrollRect.
		 * 
		 */		
		public function changeScrollRect():void {
			var contentWidth:int = _width - ((maxScroll && _scrollBar!=null) > 0 ? _scrollBar.width : 0) - _padding * (maxScroll > 0 ? 3 : 2)
			var maxScroll:int = 0

			if (_content != null) {
				maxScroll = _content.height - _height + _padding * 2;
			}

			if (_scrollBar != null) {
				_contentScrollRect = new Rectangle(0, _scrollBar.scrollPosition, contentWidth, _height - _padding * 2);
				_contentContainer.scrollRect = _contentScrollRect;
			}
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			//super.draw();

			var maxScroll:int = 0

			if (_content != null) {
				
				maxScroll = _content.height - _height + _padding * 2;
				if (_scrollBar != null) {
					_scrollBar.visible = maxScroll > 0;
					_scrollBar.maxScrollPosition = maxScroll;
				}
			}

			
			var contentWidth:int = _width - ((maxScroll && _scrollBar!=null) > 0 ? _scrollBar.width : 0) - _padding * (maxScroll > 0 ? 3 : 2)
			if (_scrollBar != null) {
				_scrollBar.x = contentWidth + _padding * 2;
				_scrollBar.y = _padding;
				_scrollBar.height = _height - _padding * 2;

				_contentScrollRect = new Rectangle(0, _scrollBar.scrollPosition, contentWidth, _height - _padding * 2);
				_contentContainer.scrollRect = _contentScrollRect;
				_contentContainer.x = _contentContainer.y = _padding;
				//_scrollBar.draw();
			}
			if (_background != null) {
				_background.width = _width;
				_background.height = _height;
			}

		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override public function drawGraphics():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}

		/**
		 * Содержимое контейнера.
		 * @param value Контент.
		 * 
		 */
		public function get content():DisplayObject {
			return _content;
		}
		public function set content(value:DisplayObject):void {
            if (_content != null) {
                _contentContainer.removeChild(_content);
            }
			_content = value;
			_contentContainer.addChild(_content);
            if (_scrollBar!=null) {
			    _scrollBar.maxScrollPosition = _content.height - _height + _padding * 2;
            }
			draw();
		}
		
		/**
		 * Скроллбар.
		 * 
		 */		
		public function get scrollBar():ScrollBar {
			return _scrollBar;
		}
		public function set scrollBar(value:ScrollBar):void {
			_scrollBar = value;
			addChild(_scrollBar);
			_scrollBar.addEventListener(ScrollBarEvent.SCROLL_CHANGE, redraw);
			_scrollBar.addEventListener(ScrollBarEvent.SCROLL_START, redraw);
			_scrollBar.addEventListener(ScrollBarEvent.SCROLL_STOP, redraw);
			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
			//draw();
		}
		
		protected function mouseWheelHandler(e:MouseEvent):void {
			if (_scrollBar!=null) {
				_scrollBar.onMouseWheel(e);
			}
		}
		
		/**
		 * Фон.
		 * 
		 */		
		public function set background(value:DisplayObject):void {
			_background = value;
			addChildAt(_background, 0);
			//draw();
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
			//draw();
		}
	}
}