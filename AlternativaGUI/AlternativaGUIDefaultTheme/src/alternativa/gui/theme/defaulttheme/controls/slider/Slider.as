package alternativa.gui.theme.defaulttheme.controls.slider {

	import alternativa.gui.theme.defaulttheme.skin.SliderSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.slider.Slider;
	import alternativa.gui.enum.Direction;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.primitives.stretch.HorizontalBar;
	import alternativa.gui.primitives.stretch.VerticalBar;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.external.ExternalInterface;
	import flash.geom.Matrix;

	use namespace alternativagui;

	public class Slider extends alternativa.gui.controls.slider.Slider {

		// RU: графика левого диапазона
        // EN: left range graphic
		protected var leftRangeGraphic:DisplayObject;

		// RU: массив хинтов
        // EN: hints array
		protected var _hintsArray:Vector.<String>;
		
		protected var matrix:Matrix = new Matrix();

		public function Slider(posNum:int, currentPos:int, divisionMinLength:int, direction:Boolean = Direction.HORIZONTAL) {
			
			// RU: создание скина для слайдера
            // EN: create skin for the slider
			var tm:int = -int(SliderSkin.tickBD.height/2 + SliderSkin.trackBD.height/2);
			var trackBD:BitmapData;
			var runnerBD:BitmapData;
			var runnerOverBD:BitmapData;
			var tickBD:BitmapData;
			
			// RU: горизонтальный слайдер
            // EN: horizontal slider
			if (direction == Direction.HORIZONTAL) {
				trackBD = SliderSkin.trackBD;
				runnerBD = SliderSkin.runnerBD;
				runnerOverBD = SliderSkin.runnerOverBD;
				tickBD = SliderSkin.tickBD;
				leftRangeGraphic = new HorizontalBar(SliderSkin.trackFullBD, 5, 5);
			} else {
				// RU: вертикальный слайдер
                // EN: vertical slider
				matrix.identity();
				matrix.rotate(Math.PI/2);
				matrix.tx = SliderSkin.trackBD.height;
				trackBD = new BitmapData(SliderSkin.trackBD.height, SliderSkin.trackBD.width, true, 0x00FFFFFF);
				trackBD.draw(SliderSkin.trackBD, matrix);
				matrix.identity();
				matrix.rotate(Math.PI/2);
				matrix.tx = SliderSkin.runnerBD.height;
				runnerBD = new BitmapData(SliderSkin.runnerBD.height, SliderSkin.runnerBD.width, true, 0x00FFFFFF);
				runnerBD.draw(SliderSkin.runnerBD, matrix);
				matrix.identity();
				matrix.rotate(Math.PI/2);
				matrix.tx = SliderSkin.runnerOverBD.height;
				runnerOverBD = new BitmapData(SliderSkin.runnerOverBD.height, SliderSkin.runnerOverBD.width, true, 0x00FFFFFF);
				runnerOverBD.draw(SliderSkin.runnerOverBD, matrix);
				matrix.identity();
				matrix.rotate(Math.PI/2);
				matrix.tx = SliderSkin.tickBD.height;
				tickBD = new BitmapData(SliderSkin.tickBD.height, SliderSkin.tickBD.width, true, 0x00FFFFFF);
				tickBD.draw(SliderSkin.tickBD, matrix);

				matrix.identity();
				matrix.rotate(-Math.PI/2);
				matrix.ty = SliderSkin.trackFullBD.width;
				var trackFullBD:BitmapData = new BitmapData(SliderSkin.trackFullBD.height, SliderSkin.trackFullBD.width, true, 0x00FFFFFF);
				trackFullBD.draw(SliderSkin.trackFullBD, matrix);
				leftRangeGraphic = new VerticalBar(trackFullBD, 5);
			}
			super(direction, trackBD, SliderSkin.edge, runnerBD, posNum, currentPos, divisionMinLength, true, tickBD, tm);

			setRunnerStates(runnerBD, runnerOverBD, runnerOverBD, runnerBD);
			addChildAt(leftRangeGraphic, getChildIndex(runner));
			_borderThickness = 1;
		}

		override public function set currentPos(num:int):void {
			super.currentPos = num;

			if (leftRangeGraphic != null) {
				if (_direction == Direction.HORIZONTAL) {
					leftRangeGraphic.x = _borderThickness;
					leftRangeGraphic.y = track.y + _borderThickness;
					if ((_width - (_width - runner.x - _borderThickness * 2)) < 4) {
						leftRangeGraphic.visible = false;
					} else {
						leftRangeGraphic.visible = true;
						leftRangeGraphic.width = _width - (_width - runner.x - _borderThickness * 2);
					}
				} else {
					leftRangeGraphic.x = track.x + _borderThickness;
					leftRangeGraphic.y = runner.y;
					if ((_height - runner.y - _borderThickness * 2) < 4) {
						leftRangeGraphic.visible = false;
					} else {
						leftRangeGraphic.visible = true;
						leftRangeGraphic.height = _height - runner.y - _borderThickness * 2;
					}
				}
			}

			if ((_hintsArray != null) && ((_currentPos - 1) < _hintsArray.length)) {
				if ((_currentPos - 1) < 0) {
					runner.hint = _hintsArray[0];
				} else {
					runner.hint = _hintsArray[_currentPos - 1];
				}
			} else {
				runner.hint = String(num);
			}
			
			// RU: если кнопка слайдера зажата, то изменяем хинт у кнопки
            // EN: if button is held, then change the button hint
			if (runner.pressed) {
				MouseManager.updateHint(runner.hint);
			}
			this.drawChildren();
		}

		// RU: задаем хинты для бегунка
        // EN: set the hints for the scroller
		public function set hints(value:Array):void {
			_hintsArray = Vector.<String>(value);
			currentPos = _currentPos;
		}
	}
}
