package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.Container;
	import alternativa.gui.enum.Align;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Вертикальный контейнер с заданной высотой элементов.
	 * Если объектов больше, чем задано, оставшееся место делится между ними поровну.
	 * Если все размеры заданы в пикселях и осталось место — увеличится зазор между элементами.
	 * 
	 * @see VBox
	 * @see VBoxExpand
	 */	
	public class RelativeVBox extends Container	{
		
		/**
		 * Высота элементов (меньше единицы - в процентах;
		 * 					больше единицы - в пикселях;
		 *					-1 — занимает оставшееся место поровну с себе подобными.
		 * 					Также для объектов, для которых не задана высота).
		 */		
		protected var _objectsHeight:Array;
		
		/**
		 * Минимальное пространство между элементами.
		 */		
		protected var minSpace:int;
		
		/**
		 * Текущее пространство между элементами. 
		 */		
		protected var _space:int;
		
		/**
		 * Выравнивание по горизонтали.
		 */		
		protected var _align:Align;
		
		
		/**
		 * @param objectsHeight Высота элементов.
		 * @param space Минимальное пространство между элементами.
		 */	
		public function RelativeVBox(objectsHeight:Array, space:int) {
			super();
			
			_align = Align.LEFT;
			
			_objectsHeight = objectsHeight;
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
			/*this.graphics.clear();
			this.graphics.lineStyle(1, 0x0000ff, 1);
			this.graphics.drawRect(0, 0, _width, _height);*/
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function calculateHeight(value:int):int {
			var result:int;
			if (_objects.length > 0) {
				_space = minSpace;
				
				var summaryHeight:int = (_objects.length - 1)*_space;
				var counter:int = 0;
				
				// Установка абсолютных размеров (в пикселях)
				for (var i:int = 0; i < _objectsHeight.length; i++) {
					var objectHeight:Number = _objectsHeight[i];
					if (objectHeight >= 1) {
						var object:DisplayObject = _objects[i];
						object.height = objectHeight;
						summaryHeight += object.height;
						counter++;
					}
				}
				
				// Установка относительных размеров (в процентах)
				for (i = 0; i < _objectsHeight.length; i++) {
					objectHeight = _objectsHeight[i];
					if (objectHeight < 1 && objectHeight != -1) {
						objectHeight = int(objectHeight*value);
						object = _objects[i];
						object.height = objectHeight;
						summaryHeight += object.height;
						counter++;
					}
				}
				
				var remains:int = _objects.length - counter;
				objectHeight = Math.floor((value - summaryHeight)/remains);
				
				// Установка не заданных размеров
				for (i = 0; i < objects.length; i++) {
					if (_objectsHeight.length <= i || _objectsHeight[i] == -1) {
						object = objects[i];
						object.height = objectHeight;
						summaryHeight += object.height;
					}
				}
				
				// Сохранение ширины
				if (summaryHeight < value) {
					var add:int = Math.floor((value - summaryHeight)/(_objects.length - 1));
					_space += add;
					
					result = summaryHeight + add*(_objects.length - 1);
				} else if (summaryHeight > value) {
					result = summaryHeight;
				} else {
					result = value;
				}
			} else {
				result = value;
			}
			return result;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */	
		override protected function calculateWidth(value:int):int {
			var result:int;
			if (_objects.length > 0) {
				// Нахождение максимальной ширины
				var maxWidth:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i] as DisplayObject;
					object.width = value;
					var w:int = (_objects[i] as DisplayObject).width;
					if (maxWidth < w) {
						maxWidth = w;
					}
				}
				// Сохранение ширины
				result = Math.max(value, maxWidth);
			} else {
				result = value;
			}
			return result;
		}
		
		/**
		 * Текущее пространство между элементами.
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
		 * Выравнивание по горизонтали.
		 */
		public function get align():Align {
			return _align;
		}
		public function set align(value:Align):void {
			_align = value;
			draw();			
		}
		
		/**
		 * Высота объектов. 
		 * 
		 */		
		public function get objectsHeight():Array {
			return _objectsHeight;
		}
		public function set objectsHeight(value:Array):void {
			_objectsHeight = value;
			//height = _height;
		}

	}
}