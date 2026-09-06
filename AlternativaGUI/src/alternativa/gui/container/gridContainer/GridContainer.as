package alternativa.gui.container.gridContainer {
	
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.Container;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	
	/**
	 * 
	 * Контейнер с фиксированным количеством столбцов и строк.
	 * 
	 */	
	public class GridContainer extends Container {
		/**
		 * Количество строк. 
		 */		
		protected var _rowNum:int;
		
		/**
		 * Количество столбцов. 
		 */		
		protected var _columnNum:int;
		
		/**
		 * Зазор между объектами по горизонтали.
		 */		
		protected var _spaceH:int;
		
		/**
		 * Зазор между объектами по вертикали. 
		 */		
		protected var _spaceV:int;
		
		/**
		 * Высота строк. 
		 */		
		protected var rowHeight:Vector.<int>;
		
		/**
		 * Ширина столбцов. 
		 */		
		protected var columnWidth:Vector.<int>;
		
		/**
		 * 
		 * @param columnNum Количество столбцов.
		 * @param rowNum Количество строк.
		 * @param spaceH Зазор между объектами по горизонтали.
		 * @param spaceV Зазор между объектами по вертикали.
		 * 
		 */		
		public function GridContainer(columnNum:int, rowNum:int, spaceH:int, spaceV:int) {
			_rowNum = rowNum;
			_columnNum = columnNum;
			
			_spaceH = spaceH;
			_spaceV = spaceV;
			
			rowHeight = Vector.<int>(new Array(rowNum));
			columnWidth = Vector.<int>(new Array(columnNum));
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (_objects.length > 0) {
				var x:int = 0;
				var y:int = 0;;
				// Перебор по строкам
				for (var i:int = 0; i < _rowNum; i++) {
					//trace("h" + (i+1).toString() + ": " + rowHeight[i]);
					// Перебор по столбцам
					x = 0;
					for (var j:int = 0; j < _columnNum; j++) {
						//trace("w" + (j+1).toString() + ": " + columnWidth[j]);
						if (j + i*_columnNum < _objects.length) {
							var object:DisplayObject = _objects[j + i*_columnNum];
							object.x = x;
							object.y = y;
							/*trace("width: " + object.width);
							trace("height: " + object.height);
							trace("x: " + object.x);
							trace("y: " + object.y);*/
						}
						x += columnWidth[j] + _spaceH;
					}
					y += rowHeight[i] + _spaceV;
				}
			}
			
			/*x = 0;
			y = 0;
			this.graphics.clear();
			this.graphics.lineStyle(1, 0x00cc00, 1);
			for (i = 0; i < _columnNum-1; i++) {
				x += columnWidth[i];
				this.graphics.moveTo(x, 0);
				this.graphics.lineTo(x, _height);
				x += _spaceH;
				this.graphics.moveTo(x, 0);
				this.graphics.lineTo(x, _height);
			}
			for (i = 0; i < _rowNum-1; i++) {
				y += rowHeight[i];
				this.graphics.moveTo(0, y);
				this.graphics.lineTo(_width, y);
				y += _spaceV;
				this.graphics.moveTo(0, y);
				this.graphics.lineTo(_width, y);
			}
			this.graphics.lineStyle(1, 0x0000ff, 1);
			this.graphics.drawRect(0, 0, _width, _height);
			*/
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateWidth(value:int):int {
			var w:int;
			if (_objects.length > 0) {
				var summaryWidth:int = (_columnNum-1)*_spaceH;
				var averageWidth:int = (value - summaryWidth)/_columnNum;
				var maxWidth:int = 0;
				
				// Перебор столбцов и суммирование их ширин
				for (var j:int = 0; j < _columnNum; j++) {
					// Поиск максимального элемента в столбце
					for (var i:int = 0; i < _rowNum; i++) {
						if (j + i*_columnNum < _objects.length) {
							var object:DisplayObject = _objects[j + i*_columnNum];
							object.width = averageWidth;
							if (maxWidth < object.width) {
								maxWidth = object.width;
							}
						}
					}
					columnWidth[j] = Math.max(maxWidth, averageWidth);
					summaryWidth += columnWidth[j];
					averageWidth = (value - summaryWidth)/(_columnNum - (j+1));
				}
				w = summaryWidth;
			} else {
				averageWidth = (value - (_columnNum-1)*_spaceH)/_columnNum;
				for (i = 0; i < _columnNum; i++) {
					columnWidth[i] = averageWidth;
				}
				w = value;
			}
			return w;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateHeight(value:int):int {
			var h:int;
			if (_objects.length > 0) {
				var summaryHeight:int = (_rowNum-1)*_spaceV;
				var averageHeight:int = (value - summaryHeight)/_rowNum;
				var maxHeight:int = 0;
				
				// Перебор строк и суммирование их высот
				for (var i:int = 0; i < _rowNum; i++) {
					// Поиск максимального элемента в строке
					for (var j:int = 0; j < _columnNum; j++) {
						if (j + i*_columnNum < _objects.length) {
							var object:DisplayObject = _objects[j + i*_columnNum];
							object.height = averageHeight;
							if (maxHeight < object.height) {
								maxHeight = object.height;
							}
						}
					}
					rowHeight[i] = Math.max(maxHeight, averageHeight);
					summaryHeight += rowHeight[i];
					averageHeight = (value - summaryHeight)/(_rowNum - (i+1));
				}
				h = summaryHeight;
			} else {
				averageHeight = (value - (_rowNum-1)*_spaceV)/_rowNum;
				for (i = 0; i < _rowNum; i++) {
					rowHeight[i] = averageHeight;	
				}
				h = value;
			}
			return h;
		}
		
		/**
		 * Возвращает количество столбцов.
		 * @return Количество столбцов.
		 * 
		 */		
		public function get columnNum():int {
			return _columnNum;
		}
		
		/**
		 * Возвращает количество строк. 
		 * @return Количество строк.
		 * 
		 */		
		public function get rowNum():int {
			return _rowNum;
		}
		
		/**
		 * Зазор между объектами по горизонтали. 
		 * 
		 */		
		public function get spaceH():int {
			return _spaceH;
		}
		public function set spaceH(value:int):void {
			_spaceH = spaceH;
			draw();
		}
		
		/**
		 * Зазор между объектами по вертикали. 
		 * 
		 */		
		public function get spaceV():int {
			return _spaceV;
		}
		public function set spaceV(value:int):void {
			_spaceV = spaceV;
			draw();
		}
		
		/**
		 * Задаем количество столбцов и строк. 
		 * @param columnNum Количество столбцов.
		 * @param rowNum Количество строк.
		 * 
		 */		
		public function setcolumnAndRowNum(columnNum:int, rowNum:int):void {
			if (_columnNum != columnNum || _rowNum != rowNum) {
				_columnNum = columnNum;
				_rowNum = rowNum;
				
				rowHeight = Vector.<int>(new Array(rowNum));
				columnWidth = Vector.<int>(new Array(columnNum));
				//trace("rowHeight: " + rowHeight);
				//trace("columnWidth: " + columnWidth);
				resize(_width, _height);
			}
		}
		
	}
}