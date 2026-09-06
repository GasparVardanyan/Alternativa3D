package alternativa.gui.container.scrollArea {
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
	 * Скролируемый контейнер с возможностью задания контента. Вертикальный и горизонтальный скроллбар задается извне.
	 * <p>Имеется возможность скролировать с помощью внешнего Rectangle, для этого надо воспользоваться contentScrollRect.</p>
	 *
	 * @see alternativa.gui.container.scrollPane.ScrollPane
	 *
	 */
	public class ScrollArea extends GUIobject {

		/**
		 * Отступ сверху.
		 *
		 */
		protected var _paddingTop:int = 0;

		/**
		 * Отступ справа.
		 *
		 */
		protected var _paddingRight:int = 0;

		/**
		 * Отступ слева.
		 *
		 */
		protected var _paddingLeft:int = 0;

		/**
		 * Отступ снизу.
		 *
		 */
		protected var _paddingBottom:int = 0;

		/**
		 * Вертикальный скроллбар.
		 *
		 */
		protected var _scrollBarV:ScrollBar;

		/**
		 * Горизонтальный скроллбар.
		 *
		 */
		protected var _scrollBarH:ScrollBar;

		/**
		 * Отображение горизонтального скроллбара.
		 */
		protected var _scrollBarHlocked:Boolean;

		/**
		 * Отображение вертикального скроллбара.
		 */
		protected var _scrollBarVlocked:Boolean;

		/**
		 * Содержимое контейнера. 
		 */
		protected var _content:DisplayObject;
		
		/**
		 * Контейнер, в котором лежит контент. 
		 */		
		protected var contentContainer:Sprite;
		
		/**
		 * Внешний contentScrollRect.
		 *
		 */
		protected var _contentScrollRect:Rectangle;

		/**
		 * Фон.
		 *
		 */
		protected var _background:DisplayObject;

		/**
		 * Контейнер с фоном. 
		 */		
		protected var backgroundContainer:Sprite;

		/**
		 * Флаг на использование внешнего ScrollRect.
		 *
		 */
		protected var _extScrollRect:Boolean = false;

		public function ScrollArea() {
			super();

			mouseChildren = true;
			mouseEnabled = true;

			backgroundContainer = new Sprite();
			addChild(backgroundContainer);

			contentContainer = new Sprite();
			addChild(contentContainer);

			addEventListener(MouseEvent.MOUSE_WHEEL, mouseWheelHandler);
		}

		private function mouseWheelHandler(e:MouseEvent):void {
			if (_scrollBarV != null) {
				_scrollBarV.onMouseWheel(e);
			}
		}

		/**
		 * Вертикальный скроллбар.
		 *
		 */
		public function get scrollBarV():ScrollBar {
			return _scrollBarV;
		}

		public function set scrollBarV(value:ScrollBar):void {
			_scrollBarV = value;
			_scrollBarV.addEventListener(ScrollBarEvent.SCROLL_CHANGE, scrollBarHandler);
			_scrollBarV.addEventListener(ScrollBarEvent.SCROLL_START, scrollBarHandler);
			_scrollBarV.addEventListener(ScrollBarEvent.SCROLL_STOP, scrollBarHandler);

			draw();
		}

		/**
		 * Горизонтальный скроллбар.
		 *
		 */
		public function get scrollBarH():ScrollBar {
			return _scrollBarH;
		}

		public function set scrollBarH(value:ScrollBar):void {
			_scrollBarH = value;
			_scrollBarH.addEventListener(ScrollBarEvent.SCROLL_CHANGE, scrollBarHandler);
			_scrollBarH.addEventListener(ScrollBarEvent.SCROLL_START, scrollBarHandler);
			_scrollBarH.addEventListener(ScrollBarEvent.SCROLL_STOP, scrollBarHandler);

			draw();
		}

		/**
		 * Отображение горизонтального скроллбара.
		 */
		public function get scrollBarHlocked():Boolean {
			return _scrollBarHlocked;
		}

		public function set scrollBarHlocked(value:Boolean):void {
			_scrollBarHlocked = value;
		}

		/**
		 * Отображение вертикального скроллбара.
		 */
		public function get scrollBarVlocked():Boolean {
			return _scrollBarVlocked;
		}

		public function set scrollBarVlocked(value:Boolean):void {
			_scrollBarVlocked = value;
		}

		private function scrollBarHandler(e:Event):void {
			switch (e.type) {
				case ScrollBarEvent.SCROLL_CHANGE:
					changeScrollRect();
					break;
				case ScrollBarEvent.SCROLL_START:
					//
					break;
				case ScrollBarEvent.SCROLL_STOP:
					//
					break;
			}
		}

		/**
		 * Изменение scrollRect.
		 *
		 */
		public function changeScrollRect():void {
			var maxVerScroll:int = 0;
			var maxHorScroll:int = 0;
			var contentWidth:int = _width;
			var contentHeight:int = _height;

			if (_scrollBarV != null) {
				maxVerScroll = _content.height - _height + _paddingTop + _paddingBottom;
			}
			if (_scrollBarH != null) {
				maxHorScroll = _content.width - _width + _paddingLeft + _paddingRight;
			}

			if (!_extScrollRect) {
				_contentScrollRect = new Rectangle((_scrollBarH != null ? _scrollBarH.scrollPosition : 0), (_scrollBarV != null ? _scrollBarV.scrollPosition : 0), contentWidth, contentHeight);
			}
			contentContainer.scrollRect = _contentScrollRect;
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
			if (_content != value) {
				if (_content != null) {
					contentContainer.removeChild(_content);
				}
				_content = value;

				if (_content != null) {
					contentContainer.addChild(_content);

					if (_scrollBarV != null) {
						_scrollBarV.maxScrollPosition = _content.height - _height + _paddingTop + _paddingBottom;
						_scrollBarV.scrollPosition = 0;
					}
					if (_scrollBarH != null) {
						_scrollBarH.maxScrollPosition = _content.width - _width + _paddingLeft + _paddingRight;
						_scrollBarH.scrollPosition = 0;
					}
					draw();
				}
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		override protected function draw():void {
			//super.draw();

			var maxVerScroll:int = 0;
			var maxHorScroll:int = 0;
			var contentWidth:int = _width;
			var contentHeight:int = _height;

			if (_content != null) {
				_content.x = _paddingLeft;
				_content.y = _paddingTop;
				maxVerScroll = _content.height - _height + _paddingTop + _paddingBottom;
				maxHorScroll = _content.width - _width + _paddingLeft + _paddingRight;

				if (_scrollBarV != null) {
					if (!_scrollBarVlocked) {
						_scrollBarV.visible = maxVerScroll > 0;
					}
					_scrollBarV.maxScrollPosition = maxVerScroll;
				}
				if (_scrollBarH != null) {
					if (!_scrollBarHlocked) {
						_scrollBarH.visible = maxHorScroll > 0;
					}
					_scrollBarH.maxScrollPosition = maxHorScroll;
				}
			}

			if (!_extScrollRect) {
				_contentScrollRect = new Rectangle((_scrollBarH != null ? _scrollBarH.scrollPosition : 0), (_scrollBarV != null ? _scrollBarV.scrollPosition : 0), contentWidth, contentHeight);
			}
			contentContainer.scrollRect = _contentScrollRect;
			contentContainer.x = 0;
			contentContainer.y = 0;


			if (_background != null) {
				_background.width = _width;
				_background.height = _height;
			}

//			graphics.clear();
//			graphics.beginFill(0x0000ff, 0.5);
//			graphics.drawRect(0, 0, _width, _height);
		}

		/**
		 * Обновление.
		 * <p>Перерисовка компоненты.</p>
		 *
		 */
		public function update():void {
			draw();
		}

		/**
		 * Внешний contentScrollRect.
		 *
		 */
		public function get contentScrollRect():Rectangle {
			return _contentScrollRect;
		}

		public function set contentScrollRect(object:Rectangle):void {
			_contentScrollRect = object;
			_extScrollRect = true;
			draw();
		}


		/**
		 * Флаг на использование внешнего ScrollRect.
		 *
		 */
		public function get extScrollRect():Boolean {
			return _extScrollRect;
		}

		public function set extScrollRect(value:Boolean):void {
			_extScrollRect = value;
			draw();
		}


		/**
		 * Отступ сверху.
		 *
		 */
		public function get paddingTop():Number {
			return _paddingTop;
		}

		public function set paddingTop(value:Number):void {
			_paddingTop = value;
			draw();
		}

		/**
		 * Отступ слева.
		 *
		 */
		public function get paddingLeft():Number {
			return _paddingLeft;
		}

		public function set paddingLeft(value:Number):void {
			_paddingLeft = value;
			draw();
		}

		/**
		 * Отступ справа.
		 *
		 */
		public function get paddingRight():Number {
			return _paddingRight;
		}

		public function set paddingRight(value:Number):void {
			_paddingRight = value;
			draw();
		}

		/**
		 * Отступ снизу.
		 *
		 */
		public function get paddingBottom():Number {
			return _paddingBottom;
		}

		public function set paddingBottom(value:Number):void {
			_paddingBottom = value;
			draw();
		}

		/**
		 * Фон.
		 *
		 */
		public function set background(value:DisplayObject):void {
			if (_background != null) {
				backgroundContainer.removeChild(_background);
			}

			_background = value;
			backgroundContainer.addChild(_background);
			draw();
		}

	}
}
