package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.auto.AutoLODContainer;
	import alternativa.gui.lod.auto.IAutoLODobject;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Лодируемый вертикальный контейнер с постоянным зазором между элементами. 
	 */	
	public class AutoLODVBox extends AutoLODContainer {
		
		/**
		 * Минимальное пространство между элементами. 
		 */		
		protected var _space:int;
		
		/**
		 * Зазоры между элементами для разной ширины контейнера (в зависимости от лода).
		 */
		protected var spaces:Array;
		
		/**
		 * @param limits Границы переключения величины зазора между элементами.
		 * @param spaces Значения зазоров между элементами при разной ширине (длина массива на 1 больше, чем количество границ).
		 */		
		public function AutoLODVBox(limits:Vector.<int>, spaces:Array) {
			super();
			this.spaces = spaces;
			
			this.limitsV = limits;
		}
		
		/**
		 * Текущий зазор между элементами.
		 * 
		 */		
		public function get space():int {
			return _space;
		}
		public function set space(value:int):void {
			_space = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		override public function set LODindexV(index:int):void {
			index = index;
			_space = spaces[index];
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (_objects.length > 0) {
				var y:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = DisplayObject(_objects[i]);
					object.x = (_width - object.width) >> 1;
					object.y = y;
					y += object.height + _space;
				}
			}
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x0000ff, 1);
			this.graphics.drawRect(0, 0, _width, _height);
		}
		
		/**
		 * Корректировка LOD индекса по горизонтали для одновременной смены детализации объектов внутри контейнера.
		 */		
		private function equalizeLODindexH():void {
			var maxLODindex:int = 0; 
			for (var i:int = 0; i < _objects.length; i++) {
				var object:DisplayObject = DisplayObject(_objects[i]);
				if (object is IAutoLODobject) {
					if (IAutoLODobject(object).LODindexH > maxLODindex) {
						maxLODindex = IAutoLODobject(object).LODindexH;
					}
				}
			}
			if (maxLODindex > 0) {
				for (i = 0; i < _objects.length; i++) {
					object = DisplayObject(_objects[i]);
					if (object is IAutoLODobject) {
						if (IAutoLODobject(object).LODindexH < maxLODindex) {
							IAutoLODobject(object).LODindexH = maxLODindex;
						}
					}
				}
			}
		}
		
		/**
		 * Корректировка LOD индекса по вертикали для одновременной смены детализации объектов внутри контейнера.
		 */		
		private function equalizeLODindexV():void {
			var maxLODindex:int = 0; 
			for (var i:int = 0; i < _objects.length; i++) {
				var object:DisplayObject = DisplayObject(_objects[i]);
				if (object is IAutoLODobject) {
					if (IAutoLODobject(object).LODindexV > maxLODindex) {
						maxLODindex = IAutoLODobject(object).LODindexV;
					}
				}
			}
			if (maxLODindex > 0) {
				for (i = 0; i < _objects.length; i++) {
					object = DisplayObject(_objects[i]);
					if (object is IAutoLODobject) {
						if (IAutoLODobject(object).LODindexV < maxLODindex) {
							IAutoLODobject(object).LODindexV = maxLODindex;
						}
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set width(value:Number):void {
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
				_width = Math.max(value, maxWidth);
				
				equalizeLODindexH();
			} else {
				_width = value;
			}
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set height(value:Number):void {
			if (_objects.length > 0) {
				
				// LOD
				if (limitsH != null) {
					indexV = getIntervalIndex(limitsV, value);
					_space = spaces[indexV];
				}
				
				var summaryHeight:int = (_objects.length-1)*_space;
				var averageHeight:int = (value - (_objects.length-1)*_space)/_objects.length;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i] as DisplayObject;
					object.height = averageHeight;
					summaryHeight += object.height;
				}
				
				if (summaryHeight < value) {
					// Недобор
					var delta:int = value - summaryHeight;
					i = 0;
					// Количество проходов
					var n:int = 10;
					while (delta > 0 && i < _objects.length && n > 0) {
						object = _objects[i] as DisplayObject;
						var oldHeight:int = object.height;
						object.height = oldHeight + 1;
						if (object.height == oldHeight + 1) {
							delta--;
						}	
						i++;
						if (i == _objects.length) {
							i = 0;
							n--;
						}
					}
					_height = value - delta;
				} else if (summaryHeight > value) {
					// Перебор
					delta = summaryHeight - value;
					i = 0;
					n = 10;
					while (delta > 0 && i < _objects.length && n > 0) {
						object = _objects[i] as DisplayObject;
						oldHeight = object.height;
						object.height = oldHeight - 1;
						if (object.height == oldHeight - 1) {
							delta--;
						}	
						i++;
						if (i == _objects.length) {
							i = 0;
							n--;
						}
					}
					_height = value + delta;
				} else {
					// Точно
					_height = value;
				}
				
				equalizeLODindexV();
				equalizeLODindexH();
			} else {
				_height = value;
			}
			draw();
		}
		
		override public function get width():Number {
			return _width;
		}
		override public function get height():Number {
			return _height;
		}
	}
}