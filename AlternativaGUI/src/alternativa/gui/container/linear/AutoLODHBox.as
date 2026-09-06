package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.auto.AutoLODContainer;
	import alternativa.gui.lod.auto.IAutoLODobject;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Лодируемый горизонтальный контейнер с постоянным зазором между элементами. 
	 */
	public class AutoLODHBox extends AutoLODContainer {
		
		
		/**
		 * Зазор между элементами. 
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
		public function AutoLODHBox(limitsH:Array, spaces:Array) {
			super();
			this.spaces = spaces;
			
			this.limitsH.push(Vector.<int>(limitsH));
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
		override public function set LODindexH(index:int):void {
			indexH = index;
			_space = spaces[index];
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (_objects.length > 0) {
				var x:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = DisplayObject(_objects[i]);
					object.x = x;
					x += object.width + _space;
					
					object.y = (_height - object.height) >> 1;
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
				
				// space LOD
				if (limitsH != null) {
					indexH = getIntervalIndex(limitsH[indexV], value);
					_space = spaces[indexH];
				}
				
				var summaryWidth:int = (_objects.length-1)*_space;
				var averageWidth:int = (value - (_objects.length-1)*_space)/_objects.length;
				//trace("averageWidth: " + averageWidth);
				
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i] as DisplayObject;
					object.width = averageWidth;
					summaryWidth += object.width;
				}
				if (summaryWidth < value) {
					// Недобор
					var delta:int = value - summaryWidth;
					i = 0;
					// Количество проходов
					var n:int = 10;
					while (delta > 0 && i < _objects.length && n > 0) {
						object = _objects[i] as DisplayObject;
						var oldWidth:int = object.width;
						object.width = oldWidth + 1;
						if (object.width == oldWidth + 1) {
							delta--;
						}	
						i++;
						if (i == _objects.length) {
							i = 0;
							n--;
						}
					}
					_width = value - delta;
				} else if (summaryWidth > value) {
					// Перебор
					delta = summaryWidth - value;
					i = 0;
					n = 10;
					while (delta > 0 && i < _objects.length && n > 0) {
						object = _objects[i] as DisplayObject;
						oldWidth = object.width;
						object.width = oldWidth - 1;
						if (object.width == oldWidth - 1) {
							delta--;
						}	
						i++;
						if (i == _objects.length) {
							i = 0;
							n--;
						}
					}
					_width = value + delta;
				} else {
					// Точно
					_width = value;
				}
				
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
				var maxHeight:int = 0;
				for (var i:int = 0; i < _objects.length; i++) {
					var object:DisplayObject = _objects[i] as DisplayObject;
					object.height = value;
					var h:int = (_objects[i] as DisplayObject).height;
					if (maxHeight < h) {
						maxHeight = h;
					}
				}
				_height = Math.max(value, maxHeight);
				
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