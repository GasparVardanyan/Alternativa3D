package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.Container;
	import alternativa.gui.enum.Align;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	
	/**
	 * Горизонтальный контейнер с заданной шириной элементов.
	 * Если элементов больше, чем задано, оставшееся место делится между ними поровну.
	 * Если все размеры заданы в пикселях и осталось место — увеличится зазор между элементами.
	 * 
	 * @see HBox
	 * @see HBoxExpand
	 * 
	 */	
	public class RelativeHBox extends Container {
		
		/**
		 * Ширина элементов (меньше единицы - в процентах;
		 * 					больше единицы - в пикселях;
		 *					-1 — занимает оставшееся место поровну с себе подобными.
		 * 					Также для элементов, для которых не задана ширина)
		 */		
		protected var _objectsWidth:Array;
		
		/**
		 * Минимальное пространство между элементами.
		 *  
		 */		
		protected var minSpace:int;
		
		/**
		 * Текущее пространство между элементами.
		 *  
		 */		
		protected var _space:int;
		
		/**
		 * Выравнивание по вертикали.
		 * 
		 */		
		protected var _align:Align;
		
		/**
		 * @param objectsWidth Ширина элементов.
		 * @param space Минимальное пространство между элементами.
		 * 
		 */		
		public function RelativeHBox(objectsWidth:Array, space:int) {
			super();
			
			_align = Align.TOP;
			
			_objectsWidth = objectsWidth;
			minSpace = space;
		}
		
		/**
		 * Обновление внешнего вида компоненты. 
		 * 
		 */		
        public function update():void {
            resize(_width, _height);
        }
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (_objects.length > 0) {
				var currX:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i];
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
					currX += int(object.width + _space);
				}
			}
			/*this.graphics.clear();
			this.graphics.lineStyle(1, 0x00ff00, 1);
			this.graphics.drawRect(0, 0, _width, _height);*/
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateWidth(value:int):int {
			var result:int;
			if (_objects.length > 0) {
				_space = minSpace;
				
				var summaryWidth:int = (_objects.length - 1)*_space;
				var counter:int = 0;
				
				// Установка абсолютных размеров (в пикселях)
				for (var i:int = 0; i < _objectsWidth.length; i++) {
					var objectWidth:Number = _objectsWidth[i];
					if (objectWidth >= 1) {
						var object:DisplayObject = _objects[i];
						object.width = objectWidth;
						summaryWidth += object.width;
						counter++;
					}
				}
				
				// Установка относительных размеров (в процентах)
				for (i = 0; i < _objectsWidth.length; i++) {
					objectWidth = _objectsWidth[i];
					if (objectWidth < 1 && objectWidth != -1) {
						objectWidth = int(objectWidth*value);
						object = _objects[i];
						object.width = objectWidth;
						summaryWidth += object.width;
						counter++;
					}
				}
				
				var remains:int = _objects.length - counter;
				objectWidth = Math.floor((value - summaryWidth)/remains);
				
				// Установка не заданных размеров
				for (i = 0; i < _objects.length; i++) {
					if (_objectsWidth.length <= i || _objectsWidth[i] == -1) {
						object = _objects[i];
						object.width = objectWidth;
						summaryWidth += object.width;
					}
				}
				
				// Сохранение ширины
				if (summaryWidth < value) {
					var add:int = Math.floor((value - summaryWidth)/(_objects.length - 1));
					_space += add;
					
					result = int(summaryWidth + add*(_objects.length - 1));
				} else if (summaryWidth > value) {
					result = int(summaryWidth);
				} else {
					result = int(value);
				}
			} else {
				result = int(value);
			}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateHeight(value:int):int {
			var result:int;
			if (_objects.length > 0) {
				// Нахождение максимальной высоты
				var maxHeight:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i] as DisplayObject;
					object.height = value;
					var h:int = (_objects[i] as DisplayObject).height;
					if (maxHeight < h) {
						maxHeight = h;
					}
				}
				// Сохранение высоты
				result = int(Math.max(value, maxHeight));
			} else {
				result = int(value);
			}
			return result;
		}
		
		/**
		 * Зазоры между элементами.
		 */
		public function get space():int {
			return _space;
		}
		public function set space(value:int):void {
			minSpace = value;
			_space = minSpace;
			draw();
		}
		
		/**
		 * Выравнивание по вертикали.
		 */
		public function get align():Align {
			return _align;
		}
		public function set align(value:Align):void {
			_align = value;
			draw();			
		}
		
		/**
		 * Ширина элементов.
		 * 
		 */		
		public function get objectsWidth():Array {
			return _objectsWidth;
		}
		public function set objectsWidth(value:Array):void {
			_objectsWidth = value;
			//width = _width;
		}

	}
}