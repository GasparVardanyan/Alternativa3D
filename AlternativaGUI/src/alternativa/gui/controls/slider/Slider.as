package alternativa.gui.controls.slider {

    import alternativa.gui.alternativagui;
    import alternativa.gui.base.GUIobject;
	import alternativa.gui.enum.Direction;
	import alternativa.gui.primitives.stretch.HorizontalBar;
	import alternativa.gui.primitives.stretch.VerticalBar;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
    import flash.geom.Matrix;

    use namespace alternativagui;
	
	/**
	 * Базовый горизонтальный слайдер с возможностью скинования (тянется по горизонтали).
	 */	
	public class Slider extends BitmapSlider {
		
		/**
		 * Минимальная ширина ячейки. 
		 */		
		private var divisionMinLength:int;
		
		/**
		 * Отображения рисок. 
		 */		
		private var showTicks:Boolean;
		
		/**
		 * Отсуп при нарезке битмапы трэка на 3 части. 
		 */		
		protected var trackBitmapEdgeWidth:int;
		
		/**
		 * Изображение трэка. 
		 */		
		protected var trackBmp:GUIobject;
		
		
		/**
		 * 
		 * @param direction Направление слайдера.
		 * @param trackBitmap Графика трэка.
		 * @param trackBitmapEdgeWidth Отступ у графики риски.
		 * @param runnerBitmap Бегунок.
		 * @param posNum Количество позиций.
		 * @param currentPos Текущая позиция.
		 * @param divisionMinLength Минимальная длина деления.
		 * @param showTicks Отображение рисок.
		 * @param tickBitmap Графика риски.
		 * @param tickMargin Ширина риски.
		 * 
		 */		
		public function Slider(direction:Boolean,
							   trackBitmap:BitmapData,
							   trackBitmapEdgeWidth:int,
							   runnerBitmap:BitmapData,
							   posNum:int,
							   currentPos:int,
							   divisionMinLength:int,
							   showTicks:Boolean,
							   tickBitmap:BitmapData = null,
							   tickMargin:int = 1) {
			
			this.trackBitmapEdgeWidth = trackBitmapEdgeWidth;
			this.divisionMinLength = divisionMinLength;
			this.showTicks = showTicks;
			
			super(direction, trackBitmap, runnerBitmap, posNum, currentPos, 0, false, true, tickBitmap, tickMargin);	
			/*if (trackBmp != null) {
				track.removeChild(trackBmp);
			}
			createTrack();*/
		}
		
		/**
		 * Создание трэка. 
		 * 
		 */		
		override protected function createTrack():void {
			if (track == null) {
				track = new GUIobject();
				(track as Sprite).mouseEnabled = false;
				(track as Sprite).mouseChildren = false;
				(track as Sprite).tabEnabled = false;
				(track as Sprite).tabChildren = false;
				addChild(track);
			}
			trackBmp = (_direction == Direction.HORIZONTAL) ? new HorizontalBar(_trackBitmap, trackBitmapEdgeWidth, trackBitmapEdgeWidth) : new VerticalBar(_trackBitmap, trackBitmapEdgeWidth);
			track.addChild(trackBmp);
		}
		
		/**
		 * Графика бегунка. 
		 * @param normal Графика состояни по умолчанию.
		 * @param over Графика состояния при наведении.
		 * @param press Графика состояния при нажатии.
		 * @param lock Графика залоченного состояния.
		 * 
		 */		
		protected function setRunnerStates(normal:BitmapData, over:BitmapData, press:BitmapData, lock:BitmapData):void {
			runner.stateUP = new Bitmap(normal);
			runner.stateOVER = new Bitmap(over);
			runner.stateDOWN = new Bitmap(press);
			runner.stateOFF = new Bitmap(lock);
		}
		
		/**
		 * Расстановка битмап, сохранение размеров. 
		 * 
		 */		
		override protected function arrangeGraphics():void {
			if (_direction == Direction.HORIZONTAL) {
				// ГОРИЗОНТАЛЬНЫЙ
				if (_trackBitmap.height > _runnerBitmap.height) {
					runner.y = Math.round((_trackBitmap.height - _runnerBitmap.height)/2);
				} else {
					track.y = Math.round((_runnerBitmap.height - _trackBitmap.height)/2);
				}
				runnerWidth = _runnerBitmap.width;
				
				if (_tickBitmap != null && showTicks) {
					ticks.x = _borderThickness;
					ticks.y = track.y + _trackBitmap.height + _tickMargin;
					// Установка высоты
					if (_trackBitmap.height > _runnerBitmap.height) {
						_height = _trackBitmap.height + _tickMargin + _tickBitmap.height;
					} else {
						_height = track.y + _trackBitmap.height + _tickMargin + _tickBitmap.height;
					}
				} else {
					// Установка высоты
					_height = Math.max(_runnerBitmap.height, _trackBitmap.height);
				}
			} else {
				// ВЕРТИКАЛЬНЫЙ
				runnerHeight = _runnerBitmap.height;
				
				if (_tickBitmap != null && showTicks) {
					ticks.y = _borderThickness;
					// Расстановка трэка и бегунка
					var trackWidth:int = _trackBitmap.width;
					if (trackWidth > _runnerBitmap.width) {
						track.x = _tickBitmap.width + _tickMargin;
						runner.x = track.x + Math.round((trackWidth - _runnerBitmap.width)/2);
					} else {
						var d:int = Math.round((_runnerBitmap.width - trackWidth)/2);
						if ((_tickBitmap.width + _tickMargin) < d) {
							track.x = d;
							ticks.x = track.x - (_tickBitmap.width + _tickMargin);
						} else {
							track.x = _tickBitmap.width + _tickMargin;
							runner.x = track.x - d;
						}
					}
					// Установка ширины
					if (trackWidth > _runnerBitmap.width) {
						_width = trackWidth + _tickMargin + _tickBitmap.width;
					} else {
						_width = runner.x + _runnerBitmap.width;
					}
				} else {
					// Расстановка трэка и бегунка
					if (_trackBitmap.width > _runnerBitmap.width) {
						runner.x = Math.round((_trackBitmap.width - _runnerBitmap.width)/2);
					} else {
						track.x = Math.round((_runnerBitmap.width - _trackBitmap.width)/2);
					}
					// Установка ширины
					_width = Math.max(_runnerBitmap.width, _trackBitmap.width);
				}
				
			}
		}
		
		/**
		 * Ширина.
		 * 
		 */		
		override public function set width(value:Number):void {
			if (_direction == Direction.HORIZONTAL) {
				// Пересчет ширины деления
				if (segmentAligned) {
					// Отступ рисок от края
					offset = 0;
					divisionLength = int((value - _borderThickness*2 - tickWidth)/(posNum-1));
					_width = 2*_borderThickness + divisionLength*posNum;
				} else {
//					offset = (runnerWidth > tickWidth) ? Math.floor((runnerWidth-tickWidth)*0.5) : 0;
//					divisionLength = int((value - offset*2 - _borderThickness*2 - tickWidth)/(posNum-1));
//					_width = divisionLength*(posNum-1) + offset*2 + _borderThickness*2 + tickWidth;
					
					divisionLength = int((value - _borderThickness*2)/(posNum-1));
					//offset = divisionLength + _borderThickness + ((value - _borderThickness*2) - (divisionLength * (posNum - 1)))*0.5;
                    //offset = _borderThickness;
                    offset = Math.floor(_borderThickness + ((value - _borderThickness*2) - (divisionLength * (posNum - 1)))*0.5);
					_width = int(value);
				}
				draw();
			} 
		}
		
		/**
		 * Высота.
		 * 
		 */		
		override public function set height(value:Number):void {
			if (_direction == Direction.VERTICAL) {
				var tickHeight:int = (_tickBitmap != null && showTicks) ?  _tickBitmap.height : 1;
				
				// Пересчет высоты деления
				if (segmentAligned) {
					// Отступ рисок от края
					offset = 0;
					divisionLength = int((value - _borderThickness*2 - tickHeight)/(posNum-1));
					_height = 2*_borderThickness + divisionLength*posNum;
				} else {
//					divisionLength = int((value - _borderThickness*2)/(posNum + 1));
//					offset = divisionLength + _borderThickness + ((value - _borderThickness*2) - (divisionLength * (posNum + 1)))*0.5;
                    divisionLength = int((value - _borderThickness*2)/(posNum-1));
                    offset = _borderThickness + ((value - _borderThickness*2) - (divisionLength * (posNum - 1)))*0.5;
					_height = int(value);
				}
				draw();
			}
		}


		/**
		 * Расстановка рисок. 
		 * 
		 */        
		override protected function drawTicks():void {
			ticks.graphics.clear();
			if (_direction == Direction.HORIZONTAL) {
				// ГОРИЗОНТАЛЬНЫЙ
				for (var i:int = 1; i < (posNum-1); i++) {
					fillMatrix.identity();
					var sx:int;
					if (segmentAligned) {
						// центровка по отрезкам
						sx = Math.floor((divisionLength - _tickBitmap.width)*0.5) + Math.floor(i*divisionLength);
					} else {
						// расстановка на всю ширину
						sx = offset + Math.floor(i*divisionLength);
					}
					Matrix(fillMatrix).createBox(1, 1, 0, sx, 0);
					ticks.graphics.beginBitmapFill(_tickBitmap, fillMatrix, false, false);
					ticks.graphics.drawRect(sx, 0, _tickBitmap.width, _tickBitmap.height);
					ticks.graphics.endFill();
				}
			} else {
				// ВЕРТИКАЛЬНЫЙ
				for (i = 1; i < (posNum-1); i++) {
					fillMatrix.identity();
					var sy:int;
					if (segmentAligned) {
						// центровка по отрезкам
						sy = Math.floor((divisionLength - _tickBitmap.height)*0.5) + Math.floor(i*divisionLength);
					} else {
						// расстановка на всю ширину
						sy = offset + Math.floor(i*divisionLength);
					}
					Matrix(fillMatrix).createBox(1, 1, 0, 0, sy);
					ticks.graphics.beginBitmapFill(_tickBitmap, fillMatrix, false, false);
					ticks.graphics.drawRect(0, sy, _tickBitmap.width, _tickBitmap.height);
					ticks.graphics.endFill();
				}
			}
		}

		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			// Резина трэка
			if (_direction == Direction.HORIZONTAL) {
				trackBmp.width = _width;
			} else {
				trackBmp.height = _height;
			}
			
			// Расстановка графики
			arrangeGraphics();
			
			// Отрисовка рисок
			if (_tickBitmap != null && showTicks) {
				drawTicks();
			}
			
			// Добавление области срабатывания
			addHitArea();
			
			// Установка бегунка
			this.currentPos = currentPos;
			
//			this.graphics.clear();
//			this.graphics.beginFill(0x009900, 0.2);
//			this.graphics.drawRect(0, 0, _width, _height);
		}
		
	}
}