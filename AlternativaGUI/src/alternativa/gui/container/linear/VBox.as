package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.Container;
	import alternativa.gui.enum.Align;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Вертикальный контейнер с постоянным зазором между элементами.
	 * 
	 * @see VBoxExpand
	 * @see RelativeVBox
	 */	
	public class VBox extends Container {
		
		/**
		 * Выравнивание по горизонтали.
		 */		
		protected var _align:Align;
		
		/**
		 * Зазор между элементами.
		 */		
		protected var _space:int;
		
		/**
		 * Количество проходов при несоответствии размеров заданным. 
		 */		
		protected var iterations:int = 3;
		
		/**
		 * 
		 * @param space Зазор между элементами.
		 * 
		 */		
		public function VBox(space:int) {
			super();
			_space = space;
			_align = Align.CENTER;
		}
		
		/**
		 * Обновление внешнего вида компоненты. 
		 * 
		 */	
        public function update():void {
            resize(_width, _height);
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
		}
		
		/**
		 * Выравнивание по горизонтали. 
		 * 
		 */		
		public function get align():Align {
			return _align;
		}
		public function set align(value:Align):void {
			_align = value;
			width = _width;			
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (_objects.length > 0) {
				var y:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i];
					switch (_align) {
						case Align.LEFT:
							object.x = 0;
							break;
						case Align.CENTER:
							object.x = (_width - object.width) >> 1;
							break;
						case Align.RIGHT:
							object.x = _width - object.width;
							break;
					}
					object.y = y;
					y += object.height + _space;
				}
			}
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0x0000ff, 1);
//			this.graphics.drawRect(0, 0, _width, _height);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateWidth(value:int):int {
			var result:int;
			//if (value > 0) {
				if (_objects.length > 0) {
					var maxWidth:int = 0;
					for (var i:int = 0; i < _objects.length; i++) {
						var object:DisplayObject = _objects[i] as DisplayObject;
						object.width = value;
						var w:int = (_objects[i] as DisplayObject).width;
						if (maxWidth < w) {
							maxWidth = w;
						}
					}
					result = Math.max(value, maxWidth);
				} else {
					result = Math.max(0, value);
				}
			//}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateHeight(value:int):int {
			var result:int;
			//if (value > 0) {
				if (_objects.length > 0) {
					//trace("VBox set height: " + value);
					var summaryHeight:int = (_objects.length-1)*_space;
					var objectHeight:int = Math.max(0, Math.floor((value - summaryHeight)/_objects.length));
					for (var i:int = 0; i < _objects.length; i++) {
						var object:DisplayObject = _objects[i] as DisplayObject;
						object.height = objectHeight;
						summaryHeight += object.height;
					}
					
					if (summaryHeight < value && iterations > 0) {
//						trace("summaryHeight < value");
						// Недобор
						var delta:int = value - summaryHeight;
						i = 0;
						// Количество проходов
						var n:int = iterations;
						while (delta > 0 && i < _objects.length && n > 0) {
							var add:int = Math.floor(delta/(_objects.length - i));
							//trace("add: " + add);
							object = _objects[i] as DisplayObject;
							var oldHeight:int = object.height;
							object.height = oldHeight + add;
							delta -= object.height - oldHeight;
							i++;
							if (i == _objects.length) {
								i = 0;
								n--;
							}
//							trace("n: " + n);
						}
						if (iterations > 0) {
							//trace("VBox " + this + " Недобор " + delta + " px (был " + (value - summaryHeight).toString() + " px), n = " + n + ", iterations = " + iterations);
						}
						result = value - delta;
					} else if (summaryHeight > value && iterations > 0) {
						// Перебор
						delta = summaryHeight - value;
						i = 0;
						n = iterations;
						while (delta > 0 && i < _objects.length && n > 0) {
							var remove:int = Math.floor(delta/(_objects.length - i));
							//trace("remove: " + remove);
							object = _objects[i] as DisplayObject;
							oldHeight = object.height;
							object.height = oldHeight - remove;
							delta -= oldHeight - object.height;
							i++;
							if (i == _objects.length) {
								i = 0;
								n--;
							}
//							trace("n: " + n);
						}
						/*if (iterations > 0) {
							//trace("VBox " + this + " Перебор " + delta + " px (был " + (summaryHeight - value).toString() + " px), n = " + n + ", iterations = " + iterations);
						}*/
						result = value + delta;
					} else {
						// Точно
						if (value < summaryHeight) {
							value = summaryHeight;
						}
						result = value;
					}
				} else {
					result = Math.max(0, value);
				}
			//}
			return result;
		}
		
		/**
		 * Количество проходов при несоответствии размеров заданным.
		 */
		public function get iterationsNum():int {
			return iterations;
		}
		public function set iterationsNum(value:int):void {
			iterations = value;
		}

	}
}