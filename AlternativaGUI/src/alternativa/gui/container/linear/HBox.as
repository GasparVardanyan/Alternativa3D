package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.Container;
	import alternativa.gui.enum.Align;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;

	/**
	 * Горизонтальный контейнер с постоянным зазором между элементами.
	 *
	 * @see HBoxExpand
	 * @see RelativeHBox
	 */
	public class HBox extends Container {

		/**
		 * Выравнивание по вертикали.
		 *
		 */
		protected var _align:Align;

		/**
		 * Зазор между элементами.
		 *
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
		public function HBox(space:int) {
			super();
			_space = space;
			_align = Align.MIDDLE;
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
		 * Выравнивание по вертикали.
		 *
		 */
		public function get align():Align {
			return _align;
		}

		public function set align(value:Align):void {
			_align = value;
			draw();
		}

		/**
		 * @inheritDoc
		 *
		 */
		override protected function draw():void {
			if (_objects.length > 0) {
				var currX:int = 0;
				var objectsLength:int = _objects.length;
				var object:DisplayObject;
				for (var i:int = 0; i < objectsLength; i++) {
					object = _objects[i];
					switch (_align) {
						case Align.TOP:
							object.y = 0;
							break;
						case Align.MIDDLE:
							object.y = (_height - object.height) >> 1;
							break;
						case Align.BOTTOM:
							object.y = _height - object.height;
							break;
					}
					object.x = currX;
					currX += object.width + _space;
				}
			}
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0x00ff00, 1);
//			this.graphics.drawRect(0, 0, _width, _height);
		}

		/**
		 * @inheritDoc
		 *
		 */
		override protected function calculateWidth(value:int):int {
			var result:int;
			//if (value > 0) {
//			trace("HBox set width: " + value);
			var objectsLength:int = _objects.length;
			if (objectsLength > 0) {
				var summaryWidth:int = (objectsLength - 1) * _space;
				var objectWidth:int = (value - (objectsLength - 1) * _space) / objectsLength;
				var object:DisplayObject;
				
				for (var i:int = 0; i < objectsLength; i++) {
					object = _objects[i];
					object.width = objectWidth;
					summaryWidth += object.width;
				}

				if (summaryWidth < value && iterations > 0) {
					// Недобор
					var delta:int = value - summaryWidth;
					i = 0;
					// Количество проходов
					var n:int = iterations;
					var oldWidth:int;
					var add:int;
					
					objectsLength = _objects.length;
					while (n > 0 && delta > 0 && i < objectsLength) {
						add = Math.floor(delta/(objectsLength - i));
						//trace("add: " + add);
						object = _objects[i];
						oldWidth = object.width;
						object.width = oldWidth + add;
						delta -= object.width - oldWidth;
						i++;
						if (i == objectsLength) {
							i = 0;
							n--;
						}
					}
					if (iterations > 0) {
						//trace("HBox " + this + " Недобор " + delta + " px (был " + (value - summaryWidth).toString() + " px), n = " + n + ", iterations = " + iterations);
					}
					result = value - delta;
				} else if (summaryWidth > value && iterations > 0) {
					// Перебор
					delta = summaryWidth - value;
					i = 0;
					n = iterations;
					objectsLength = _objects.length;
					var remove:int;
					while (delta > 0 && i < objectsLength && n > 0) {
						remove = Math.floor(delta/(objectsLength - i));
						//trace("remove: " + remove);
						object = _objects[i];
						oldWidth = object.width;
						object.width = oldWidth - remove;
						delta -= oldWidth - object.width;
						i++;
						if (i == objectsLength) {
							i = 0;
							n--;
						}
					}
					if (iterations > 0) {
						//trace("HBox " + this + " Перебор " + delta + " px (был " + (summaryWidth - value).toString() + " px), n = " + n + ", iterations = " + iterations);
					}
					result = value + delta;
				} else {
					// Точно
					result = value;
				}
			} else {
				if (value < summaryWidth) {
					value = summaryWidth;
				}
				result = value;
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
			//trace("HBox set height: " + value);
			var objectsLength:int = _objects.length;
			var object:DisplayObject;
			var h:int;
			if (objectsLength > 0) {
				var maxHeight:int = 0;
				for (var i:int = 0; i < objectsLength; i++) {
					object = _objects[i] as DisplayObject;
					object.height = value;
					h = (_objects[i] as DisplayObject).height;
					if (maxHeight < h) {
						maxHeight = h;
					}
				}
				result = Math.max(value, maxHeight);
			} else {
				result = value;
			}
			//}
			return result;
		}

		/**
		 * Количество проходов при несоответствии размеров заданным.
		 *
		 */
		public function get iterationsNum():int {
			return iterations;
		}

		public function set iterationsNum(value:int):void {
			iterations = value;
			width = _width;
			height = _height;
		}

	}
}
