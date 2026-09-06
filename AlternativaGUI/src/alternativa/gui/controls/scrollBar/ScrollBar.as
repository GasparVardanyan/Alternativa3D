package alternativa.gui.controls.scrollBar {
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.event.ScrollBarEvent;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.display.InteractiveObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.system.Capabilities;
	
	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 * Если данные не помещаются на экране целиком, то с помощью компонента ScrollBar пользователь может управлять отображаемой частью данных. 
	 * Полоса прокрутки состоит из четырех частей: двух кнопок со стрелками, дорожки и бегунка. 
	 * Положение бегунка и отображение кнопок зависят от текущего состояния полосы прокрутки. 
	 * 
	 */	
	public class ScrollBar extends GUIobject {
		
		/**
		 * Дорожка.
		 */		
		protected var _track:InteractiveObject;
		
		/**
		 * Бегунок.
		 */		
		protected var _thumb:InteractiveObject;
		
		/**
		 * Внутренний отступ. 
		 */		
		protected var _padding:int = 0;
		
		/**
		 * Максимальное значение, которое может принять scrollPosition. 
		 */		
		protected var _maxScrollPosition:int = 0;
		
		/**
		 * Позиция бегунка. 
		 */		
		protected var _scrollPosition:Number = 0;
		
		/**
		 * Старое значение scrollPosition. 
		 */		
		protected var _oldScrollPosition:Number = 0;
		
		/**
		 * Значение на которое увеличивается/уменьшается scrollPosition при листании страницы. 
		 */		
		protected var _pageScrollSize:Number = 0;
		
		/**
		 *  Текущее положение курсора по оси Y.
		 */		
		protected var _currentCursorY:Number;
		
		/**
		 * Максимальный размер бегунка. 
		 */		
		protected var thumbMaxSize:int;
			
		/**
		 * Отношение суммы maxScrollPosition и высота на максимальный размер бегунка.  
		 */		
		protected var ratio:Number;

		public function ScrollBar() {
			super();
			mouseChildren = true;
			mouseEnabled = true;
			addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel,true);
		}
		
		/**
		 * Событие гененируемое при изменение позиции скролирования. 
		 * 
		 */		
		protected function generateChangePositionEvent():void {
			if (_scrollPosition < 1)
				_scrollPosition = 0;

			if (_scrollPosition > _maxScrollPosition)
				_scrollPosition = _maxScrollPosition;

			_thumb.y = _padding + int(_scrollPosition * (thumbMaxSize - _thumb.height) / _maxScrollPosition);

			if (_scrollPosition != _oldScrollPosition) {
				dispatchEvent(new Event(ScrollBarEvent.SCROLL_CHANGE));
				_oldScrollPosition = _scrollPosition;
			}
		}
		
		/**
		 * Изменение позиции скролирования.
		 * 
		 */		
		protected function changeScrollPosition(e:MouseEvent):void {
			_scrollPosition += (_thumb.mouseY - _currentCursorY)*ratio;
			generateChangePositionEvent();
		}
		
		/**
		 * Обработчик события при прокрутке колеса мыши.
		 * 
		 */		
		public function onMouseWheel(e:MouseEvent):void {
			_scrollPosition -= e.delta * (Boolean(Capabilities.os.search("Linux") != -1)  ? 10 : 2);
			MouseManager.update();
			//trace('_maxScrollPosition >>> whww',_maxScrollPosition,'_scrollPosition',_scrollPosition);
			if (_maxScrollPosition > 0 ) generateChangePositionEvent();
		}
		
		/**
		 * Начало перетаскивания бегунка.
		 * 
		 */		
		protected function doStartDrag(e:MouseEvent):void {
			_currentCursorY = _thumb.mouseY;
			dispatchEvent(new Event(ScrollBarEvent.SCROLL_START));
			stage.addEventListener(MouseEvent.MOUSE_MOVE, changeScrollPosition);
			stage.addEventListener(MouseEvent.MOUSE_UP, doStopDrag);
		}
		
		/**
		 * Завершение перетаскивания бегунка.
		 * 
		 */		
		protected function doStopDrag(e:MouseEvent):void {
			dispatchEvent(new Event(ScrollBarEvent.SCROLL_STOP));
			stage.removeEventListener(MouseEvent.MOUSE_UP, doStopDrag);
			stage.removeEventListener(MouseEvent.MOUSE_MOVE, changeScrollPosition);
		}
		
		/**
		 * Постраничное скролирование.
		 * 
		 */		
		protected function pageScroll(e:MouseEvent):void {
			_scrollPosition += (_track.mouseY < _thumb.y ? -_pageScrollSize : _pageScrollSize);
			generateChangePositionEvent();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			//super.draw();

			thumbMaxSize = _height - _padding * 2;
			ratio = (_maxScrollPosition + _height) / thumbMaxSize;
			_track.width = _width;
			_track.height = _height;

			_thumb.width = _width - _padding * 2;
			_thumb.x = _padding;
			_thumb.height = int(thumbMaxSize / ratio)

			_thumb.y = _padding + int(_scrollPosition * (thumbMaxSize - _thumb.height) / _maxScrollPosition);

			_pageScrollSize = _thumb.height * ratio + _padding * 2;

			//_track.draw();
			//_thumb.draw();
			generateChangePositionEvent();

			//trace("draw scrollBar");
		}
		
		/**
		 * Максимальное значение, которое может принять scrollPosition. 
		 * 
		 */		
		public function get maxScrollPosition():int {
			return _maxScrollPosition;
		}
		public function set maxScrollPosition(value:int):void {
			_maxScrollPosition = value;
			//trace("_maxScrollPosition ",_maxScrollPosition);
			if (_maxScrollPosition <= 0) _maxScrollPosition = 0; 

			draw();
			drawChildren();
		}
		
		/**
		 * Позиция бегунка.  
		 * 
		 */		
		public function get scrollPosition():int {
			return _scrollPosition;
		}
		public function set scrollPosition(value:int):void {
			_scrollPosition = value;
			draw();
		}
		
		/**
		 * Внутренний отступ.
		 * 
		 */		
		public function set padding(value:int):void {
			_padding = value;
		}
		
		/**
		 * Бегунок.
		 * 
		 */		
		public function set thumb(value:InteractiveObject):void {
			_thumb = value;
			addChild(_thumb);
			_thumb.addEventListener(MouseEvent.MOUSE_DOWN, doStartDrag);
		}
		
		/**
		 * Дорожка.
		 * 
		 */		
		public function set track(value:InteractiveObject):void {
			_track = value;
			addChildAt(_track, 0);
			_track.addEventListener(MouseEvent.CLICK, pageScroll)
		}

	}
}