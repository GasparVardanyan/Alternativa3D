package alternativa.gui.controls.slider {
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.event.SliderEvent;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Point;
	 
	/**
	 * Бегунок слайдера.
	 * 
	 */	
	public class SliderRunnerButton extends BaseButton {
		
		/**
		 * Слайдер 
		 */		
		protected var _slider:BitmapSlider;
		
		/**
		 * Флаг таскания. 
		 */		
		protected var _dragON:Boolean = false;
		
		/**
		 * Точка хватания мышью. 
		 */		
		protected var _dragPoint:Point;
		
		/**
		 * 
		 * @param normalBitmap Графика кнопки
		 * 
		 */		
		public function SliderRunnerButton(normalBitmap:BitmapData) {
			super();
			
			stateUP = new Bitmap(normalBitmap);
			/*stateOVER = new Bitmap(normalBitmap);
			stateDOWN = new Bitmap(normalBitmap);
			stateOFF = new Bitmap(normalBitmap);*/
			
			// Инициализация фокуса
			tabEnabled = false;
		}
		
		
		/*override public function set over(value:Boolean):void {
			/*if (!_dragON) {
				super.over = value;
				draw();
			}*/
			/*super.over = value;
			trace("SliderRunnerButton over: " + _over);
		}*/
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set over(value:Boolean):void {
			super.over = value;
			/*if (!_over) {
				if (!_pressed) {
					MouseManager.hideHint();
				}
			}*/
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set pressed(value:Boolean):void {
			super.pressed = value;
			if (_pressed) {
				MouseManager.showHint(this.hint, null, false, false, false);
				_dragON = true;
				// Сохранение точки захвата бегунка
				_dragPoint = globalToLocal(MouseManager.pressCoords);//MouseUtils.localCoords(this);
//				trace("this.hint");
				//trace("SliderRunnerButton global mouse coords: " + MouseUtils.globalCoords(false));
				//trace("SliderRunnerButton press coords: " + MouseManager.pressCoords);
				//trace("SliderRunnerButton dragPoint: " + _dragPoint);
				MouseManager.addMouseCoordListener(_slider);
				
				// Генерация события
				_slider.dispatchEvent(new SliderEvent(SliderEvent.START_DRAG, _slider.currentPos));
			} else {
				MouseManager.removeMouseCoordListener(_slider);
				MouseManager.hideHint();

				
				_dragON = false;
				_dragPoint = null;
				
				// Генерация события
				_slider.dispatchEvent(new SliderEvent(SliderEvent.STOP_DRAG, _slider.currentPos));
			}
		}
		
		/**
		 * Слайдер.
		 * @param s Слайдер.
		 * 
		 */		
		public function set slider(s:BitmapSlider):void {
			_slider = s;
		}
		
		/**
		 * Флаг таскания.  
		 * 
		 */		
		public function get dragON():Boolean {
			return _dragON;
		}
		
		/**
		 * Точка хватания мышью.
		 * 
		 */		
		public function get dragPoint():Point {
			return _dragPoint;
		}
		
	}
}