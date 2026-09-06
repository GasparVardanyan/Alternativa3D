package alternativa.gui.container.gridContainer {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.auto.AutoLODContainer;
	
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Лодируемый GridContainer.
	 * <p>С фиксированным количеством столбцов и строк. Сам выбирает лод в зависимости от ширины и высоты.</p>
	 */	
	public class AutoLODGridContainer extends AutoLODContainer {
		
		/**
		 * Количество столбцов. 
		 */
		protected var _columnNum:int;
		
		/**
		 * Количество строк. 
		 */
		protected var _rowNum:int;
		
		/**
		 * Столбцы. 
		 */		
		protected var columns:Vector.<int>;
		
		/**
		 * Зазоры между объектами по горизонтали. 
		 */		
		protected var spacesH:Vector.<int>;
		
		/**
		 * Зазоры между объектами по вертикали. 
		 */
		protected var spacesV:Vector.<int>;
		
		/**
		 * Высота строк. 
		 */	
		protected var rowHeight:Vector.<int>;
		
		/**
		 * Ширина столбцов. 
		 */	
		protected var columnWidth:Vector.<int>;
		
		/**
		 * Зазор между объектами по горизонтали.
		 */		
		protected var _spaceH:int;
		
		/**
		 * Зазор между объектами по вертикали. 
		 */		
		protected var _spaceV:int;
		
		//private var _alignH:int;
		//private var _alignV:int;
		
		/**
		 *  
		 * @param limitsH Границы переключения лодов.
		 * @param spacesH Зазоры между объектами по горизонтали.
		 * @param spacesV Зазоры между объектами по вертикали.
		 * @param columns Количество столбцов.
		 * 
		 */		
		public function AutoLODGridContainer(limitsH:Vector.<int>,
										 spacesH:Vector.<int>,
										 spacesV:Vector.<int>,
										 columns:Vector.<int>) {
			
			this.limitsH.push(Vector.<int>(limitsH));
			
			this.spacesH = spacesH;
			this.spacesV = spacesV;
			
			this.columns = columns;
			
			rowHeight = new Vector.<int>();
			columnWidth = new Vector.<int>();
		}
		
		/**
		 * Индекс уровня детализации по горизонтали.
		 */		
		override public function set LODindexH(index:int):void {
			indexH = index;
			_spaceH = spacesH[index];
			_spaceV = spacesV[index];
			_columnNum = columns[index];
			draw();
		}
		/**
		 * Индекс уровня детализации по вертикали.
		 */
		override public function set LODindexV(index:int):void {}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
//			trace(" ");
//			trace("h: " + indexV);
//			trace("w: " + indexH);
			
			if (_objects.length > 0) {
				var x:int = 0;
				var y:int = 0;;
				// Перебор по строкам
				for (var i:int = 0; i < _rowNum; i++) {
					// Перебор по столбцам
					x = 0;
					for (var j:int = 0; j < _columnNum; j++) {
						if (j + i*_columnNum < _objects.length) {
							var object:DisplayObject = _objects[j + i*_columnNum];
							object.x = x;
							object.y = y;
							object.width = columnWidth[j];
							object.height = rowHeight[i];
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
		override public function set width(value:Number):void {
			//trace("LODgridContainer set width: " + value); 
			if (_objects.length > 0) {
				
				// LOD
				if (limitsH != null && limitsH.length > 0) {
					indexH = getIntervalIndex(limitsH[indexV], value);
					_spaceH = spacesH[indexH];
					_spaceV = spacesV[indexH];
					_columnNum = columns[indexH];
					
					_rowNum = Math.floor(_objects.length/_columnNum);
					if ((_objects.length/_columnNum) - _rowNum > 0) {
						_rowNum++;
					}
//					columnWidth = new Vector.<int>();
//					rowHeight = new Vector.<int>();
					columnWidth.length = 0;
					rowHeight.length = 0;
					
					var columnWidthLength:int = 0;
					var rowHeightLength:int = 0;
					
					for (var n:int = 0; n < _columnNum; n++) {
						//columnWidth.push(0);
						columnWidth[columnWidthLength] = 0;
						columnWidthLength++;
					}
					for (n = 0; n < _rowNum; n++) {
						//rowHeight.push(0);
						rowHeight[rowHeightLength] = 0;
						rowHeightLength++;
					}
				}
				
				//trace("columnNum: " + _columnNum); 
				
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
					columnWidth[j] = maxWidth;//Math.max(maxWidth, averageWidth);
					summaryWidth += columnWidth[j];
					averageWidth = (value - summaryWidth)/(_columnNum - (j+1));
				}
				_width = summaryWidth;
			} else {
				averageWidth = value/_columnNum;
				for (i = 0; i < _columnNum; i++) {
					columnWidth[i] = averageWidth;
				}
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
				var summaryHeight:int = (_rowNum-1)*_spaceV;
				var averageHeight:int = (value - summaryHeight)/_rowNum;
				var maxHeight:int = 0;
				
				// Перебор строк и суммирование их высот
				for (var j:int = 0; j < _rowNum; j++) {
					// Поиск максимального элемента в строке
					for (var i:int = 0; i < _columnNum; i++) {
						if (j + i*_columnNum < _objects.length) {
							var object:DisplayObject = _objects[j + i*_columnNum];
							object.height = averageHeight;
							if (maxHeight < object.height) {
								maxHeight = object.height;
							}
						}
					}
					rowHeight[j] = maxHeight;//Math.max(maxHeight, averageHeight);
					summaryHeight += rowHeight[j];
					averageHeight = (value - summaryHeight)/(_rowNum - (j+1));
				}
				_height = summaryHeight;
			} else {
				averageHeight = value/_rowNum;
				for (i = 0; i < _rowNum; i++) {
					rowHeight[i] = averageHeight;
				}
				_height = value;
			}
			draw();
		}
		
	}
}