package alternativa.gui.theme.defaulttheme.controls.scrollBar {
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.ScrollBarSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.scrollBar.ScrollBar;
	import alternativa.gui.event.ScrollBarEvent;
	import alternativa.gui.mouse.MouseManager;

	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	use namespace alternativagui;

	public class ScrollBar extends alternativa.gui.controls.scrollBar.ScrollBar {

		// RU: кнопка "вверх"
        // EN: button "up"
		protected var upButton:ScrollButton;

		// RU: кнопка "вниз"
        // EN: button "down"
		protected var downButton:ScrollButton;

		// RU: значение смещения при скролле колесом мыши (в пикселях)
        // EN: shift value on mouse wheel scroll (pixels)
		protected var _mouseDelta:int = 15;

		// RU: значение смещения при нажатии на кнопки вверх/вниз (в пикселях)
        // EN: shift value on button up/down click (pixels)
		protected var _stepButtonScroll:int = 5;

		// RU: флаг скроллирования вверх при нажатии на кнопки вверх/вниз
        // EN: scroll up flag (when you press the up/down button)
		protected var scrollUp:Boolean = false;

		// RU: таймер задержки при скролле колесом мышки
        // EN: delay timer on mouse wheel scroll
		private var timer:Timer;

		// RU: смещение позиции скроллирования
        // EN: shift of scroll position
		private var offsetScrollPosition:Number = 0;

		// RU: зазор между кнопками и бегунком
        // EN: distance between buttons and the scroller
		private var space:int = 1;

		// RU: таймер ожидания для последующей прокрутки при нажатии на кнопки вверх/вниз
        // EN: wait a timer for subsequent scroll (when you press the up/down button)
		private var stepTimer:Timer;

		// RU: прокрутка при зажатой кнопке вверх/вниз
        // EN: scroll holding the up/down button
		private var stepStopTimer:Timer;

		public function ScrollBar() {

			timer = new Timer(2);
			timer.addEventListener(TimerEvent.TIMER, updateScrollPosition);

			stepTimer = new Timer(145);
			stepStopTimer = new Timer(50);
			stepTimer.addEventListener(TimerEvent.TIMER, startStepScroll);
			stepStopTimer.addEventListener(TimerEvent.TIMER, updateStepScroll);

			super();

			// RU: бегунок
            // EN: scroller
			var scroller:ScrollButton = new ScrollButton();
			scroller.autoHeight = false;
			scroller.icon = new Bitmap(ScrollBarSkin.iconLineBD);
			scroller.mouseEnabled = true;
			thumb = scroller;

			this.track = new Track();
			_track.mouseEnabled = true;

			// RU: кнопка "вверх"
            // EN: button "up"
			upButton = new ScrollButton();
			upButton.icon = new Bitmap(ScrollBarSkin.iconUpBD);
			upButton.mouseEnabled = true;
			upButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			upButton.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(upButton);

			// RU: кнопка "вниз"
            // EN: button "down"
			downButton = new ScrollButton();
			downButton.icon = new Bitmap(ScrollBarSkin.iconDownBD);
			downButton.mouseEnabled = true;
			downButton.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			downButton.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			addChild(downButton);

			// RU: задаем ширину
            // EN: set the width
			_width = calculateWidth(_width);
		}

		public function get stepScroll():int {
			return _stepButtonScroll;
		}

		public function set stepScroll(value:int):void {
			_stepButtonScroll = value;
		}

		override public function onMouseWheel(e:MouseEvent):void {
			var value:int = Math.floor(Math.abs(e.delta)/2);
			var delta:int = (e.delta < 0 ? -1 : 1) * (value > 0 ? value : 1);
			offsetScrollPosition = delta * _mouseDelta;
			timer.stop();
			timer.start();
		}

		public function get mouseDelta():int {
			return _mouseDelta;
		}

		public function set mouseDelta(value:int):void {
			_mouseDelta = value;
		}

		protected function updateScrollPosition(e:Event):void {
			timer.stop();

			_scrollPosition -= offsetScrollPosition;
			if (_maxScrollPosition > 0)
				generateChangePositionEvent();
			MouseManager.update();
		}

		// RU: отдаем фиксированную ширину
        // EN: return fixed width
		override protected function calculateWidth(value:int):int {
			return NumericConst.scrollBarWidth;
		}

		// RU: смотрим значение высоты, если меньше заданного, отдаем минимальную высоту
        // EN: if height value is less than the specified value, then return minimal height value
		override protected function calculateHeight(value:int):int {
			if (value < 60) {
				return 60;
			} else {
				return value;
			}
		}
		
		override protected function generateChangePositionEvent():void {
			if (_scrollPosition < 1)
				_scrollPosition = 0;

			if (_scrollPosition > _maxScrollPosition)
				_scrollPosition = _maxScrollPosition;

			_thumb.y = space + upButton.height + _padding + int(_scrollPosition * (thumbMaxSize - _thumb.height) / _maxScrollPosition);

			if (_scrollPosition != _oldScrollPosition) {
				dispatchEvent(new Event(ScrollBarEvent.SCROLL_CHANGE));
				_oldScrollPosition = _scrollPosition;
			}
		}

		/**
         *
		 * RU: Отрисовка
         * EN: Draw
         *
		 */
		override protected function draw():void {
			upButton.y = _padding;
			downButton.y = _height - _padding - downButton.height;

			thumbMaxSize = _height - space * 2 - _padding * 2 - upButton.height - downButton.height;
			ratio = (_maxScrollPosition + (_height - space * 2 - upButton.height - downButton.height)) / thumbMaxSize;
			_track.x = 0;
			_track.height = _height;

			_thumb.width = _width - _padding * 2;
			_thumb.x = _padding;

			var thumbHeight:int = int(thumbMaxSize / ratio);
			if (thumbHeight < NumericConst.scrollBarWidth) {
				_thumb.height = NumericConst.scrollBarWidth;
			} else {
				_thumb.height = thumbHeight;
			}
			_thumb.y = space + upButton.height + _padding + int(_scrollPosition * (thumbMaxSize - _thumb.height) / _maxScrollPosition);

			_pageScrollSize = _thumb.height * ratio + _padding * 2;

			generateChangePositionEvent();
		}

		protected function onMouseDown(e:MouseEvent):void {
			if (e.currentTarget == upButton) {
				scrollUp = true;
			} else {
				scrollUp = false;
			}
			// RU: обновляем позицию scrollBar
            // EN update scrollBar position
			updateStepScroll();
			// RU: запускаем таймер. Если кнопка еще будет зажата, то происходит скроллинг дальше до момента отжатия
            // EN: start a timer. While the button is pressed, scrolling occurs until the key up
			stepTimer.start();
		}

		protected function onMouseUp(e:MouseEvent):void {
			stepTimer.stop();
			stepStopTimer.stop();
		}
		
		// RU: запускает таймер скроллирования при зажатой кнопке вверх/вниз
        // EN: start a timer when pressed scrolling up/down button
		protected function startStepScroll(e:Event):void {
			stepTimer.stop();
			stepStopTimer.stop();
			stepStopTimer.start();
		}
		
		// RU: скролирование при зажатой кнопке вверх/вниз
        // EN: scrolling when pressed scrolling up/down button
		protected function updateStepScroll(e:Event = null):void {
			if (scrollUp) {
				_scrollPosition -= _stepButtonScroll;
			} else {
				_scrollPosition += _stepButtonScroll;
			}
			generateChangePositionEvent();
		}
	}
}
