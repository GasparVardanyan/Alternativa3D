package alternativa.gui.container.tileList {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.Container;
	import alternativa.gui.container.scrollPane.ScrollPane;
	import alternativa.gui.enum.Align;
	import alternativa.gui.event.ListEvent;

	use namespace alternativagui;
	
	
	/**
	 * 
	 * Тайл лист. Возможность задавать оптимальную ширину ячейки(optimalWidth). Определение ширины ячейки смотрится по первому элементу в контейнере, 
	 * если ширина элемента меньше чем оптимальная, то ему отдается оптимальная, если ширина элемента больше оптимальной, то оптимальная 
	 * ширина становится как ширина элемента.
	 * <p>Можно задавать вертикальное(columnAlign) и горизонтальное(rowAlign) выравнивание элементов в ячейке.</p>
	 * 
	 * */
	
	public class TileList extends Container {
		
		/**
		 * Зазор между ячейками. 
		 */		
		protected var _space:int = 5;
		
		/**
		 * Внутренний отступ. 
		 */		
		protected var _padding:int = 5;
//		protected var _optimalHeight:int = 50;
		
		/**
		 * Оптимальная ширина ячейки. 
		 */		
		protected var _optimalWidth:int = 50;
		
		/**
		 * Текущая ширина элемента. 
		 */		
		protected var elementWidth:int = 0;
		
		/**
		 * Текущая высота элемента.
		 */		
		protected var elementHeight:int = 0;
		
		/**
		 * Текущее количество строк. 
		 */		
		protected var rowCount:int = 0;
		
		/**
		 * Текущее количество столбцов. 
		 */		
		protected var columnCount:int = 0;
		
		/**
		 * Вертикальное выравниание элемента в ячейке. 
		 * 
		 */		
		protected var _columnAlign:Align;
		
		/**
		 * Горизонтальное выравнивание элемента в ячейке. 
		 * 
		 */			
		protected var _rowAlign:Align;
		
		/**
		 *  
		 * @param space Зазор между элементами.
		 * 
		 */		
		public function TileList(space:int = 0) {
			super();
			_space = space;
			_columnAlign = Align.MIDDLE;
			_rowAlign = Align.CENTER;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
			
			if (objects.length > 0) {
				var offsetX:int = _padding;
				var offsetY:int = _padding;
				var tempElementHeight:int = 0;
				var tempArr:Array = new Array();
				for (var i:int = 0; i < objects.length; i++) {
					objects[i].x = offsetX;
					objects[i].y = offsetY;
					objects[i].width = elementWidth;
					objects[i].height = elementHeight;
					
					
					if (_rowAlign == Align.CENTER) {
						objects[i].x += (elementWidth - objects[i].width) >> 1;
					} else if (_rowAlign == Align.RIGHT) {
						objects[i].x += elementWidth - objects[i].width;
					}
					
					if ((objects[i].x + objects[i].width) <= (_width - _padding)) {
						if (tempElementHeight < objects[i].height) {
							tempElementHeight = objects[i].height;
						} 
						tempArr.push(objects[i]);
					}
					
					if ((objects[i].x + objects[i].width) > (_width - _padding)) {
						offsetX = _padding;
						offsetY += _space + tempElementHeight;
						for (var j:int = 0; j < tempArr.length; j++) {
							tempArr[j].height = tempElementHeight;
							if (_columnAlign == Align.MIDDLE) {
								tempArr[j].y += (tempElementHeight - tempArr[j].height) >> 1;
							} else if (_columnAlign == Align.BOTTOM) {
								tempArr[j].y += tempElementHeight - tempArr[j].height;
							}
						} 
						tempArr.length = 0;
						objects[i].x = offsetX;
						objects[i].y = offsetY;
						tempElementHeight = objects[i].height;
						
						if (_rowAlign == Align.CENTER) {
							objects[i].x += (elementWidth - objects[i].width) >> 1;
						} else if (_rowAlign == Align.RIGHT) {
							objects[i].x += elementWidth - objects[i].width;
						}
						
						tempArr.push(objects[i]);
					} else if (i == (objects.length - 1)) {
						for (j = 0; j < tempArr.length; j++) {
							tempArr[j].height = tempElementHeight;
							if (_columnAlign == Align.MIDDLE) {
								tempArr[j].y += (tempElementHeight - tempArr[j].height) >> 1;
							} else if (_columnAlign == Align.BOTTOM) {
								tempArr[j].y += tempElementHeight - tempArr[j].height;
							}
						}
					}
				
					offsetX += elementWidth + _space;
					
				} 
			}
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xFF0000, 1);
//			this.graphics.drawRect(0,0,_width,_height);
		}
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateWidth(value:int):int {
			var contentWidth:int = value - _padding*2;
			elementWidth = _optimalWidth;
			if (objects.length > 0) {
				objects[0].width = _optimalWidth;
				if (objects[0].width > _optimalWidth) {
					elementWidth = objects[0].width; 
				}
				columnCount = (contentWidth + _space) / (elementWidth + _space);
				if (contentWidth < elementWidth) {
					value = elementWidth + _padding*2;
					columnCount = 1;
				} else {
					elementWidth = Math.floor((value - _padding*2 - (_space  * (columnCount-1)))/ columnCount);
				}
			}
			return value;
		}
		
		/**
		 * 
		 * @inheritDoc 
		 * 
		 */
		override protected function calculateHeight(value:int):int {
//			trace("calculateHeight");
			if (objects.length > 0) {
				rowCount = Math.ceil(objects.length / columnCount);
//				trace("   rowCount: " + rowCount);
				elementHeight = Math.floor((value - _padding*2 - (rowCount-1) * _space)/rowCount);
//				trace("   elementHeight: " + elementHeight);
//				trace("   value: " + value);
				var contentHeight:int = 0;
				var lineHeight:int = 0;
				var count:int = 0;
				for (var i:int = 0; i < objects.length; i++) {
					objects[i].height = elementHeight;
//					trace(i + ": " + objects[i].height);
					count++;
//					trace("count: " + count);
//					trace("columnCount: " + columnCount);
					if (lineHeight < objects[i].height) {
						lineHeight = objects[i].height;
					}
					if (count >= columnCount) {
						contentHeight += lineHeight;
//						trace(">>> lineHeight:  " + lineHeight);
						lineHeight = 0;
						count = 0;
					}
					if (i == (objects.length-1)) {
						if (count < columnCount) {
							contentHeight += lineHeight;							
						}
					}
					
				} 
			}
//			trace("calculateHeight: " + contentHeight);
//			trace("rowCount: " + rowCount);
			return (contentHeight + (rowCount-1) * _space + _padding*2);
		}
		
		/**
		 * Зазор между ячейками. 
		 * 
		 */		
		public function get space():int
		{
			return _space;
		}

		public function set space(value:int):void
		{
			_space = value;
		}
		
		/**
		 * Внутренний отступ. 
		 * 
		 */		
		public function get padding():int
		{
			return _padding;
		}

		public function set padding(value:int):void
		{
			_padding = value;
		}

//		public function get optimalHeight():int
//		{
//			return _optimalHeight;
//		}
//
//		public function set optimalHeight(value:int):void
//		{
//			_optimalHeight = value;
//		}
		
		/**
		 * Оптимальная ширина ячейки. 
		 * 
		 */		
		public function get optimalWidth():int
		{
			return _optimalWidth;
		}

		public function set optimalWidth(value:int):void
		{
			_optimalWidth = value;
		}
		
		/**
		 * Вертикальное выравниание элемента в ячейке. 
		 * 
		 */		
		public function get columnAlign():Align
		{
			return _columnAlign;
		}

		public function set columnAlign(value:Align):void
		{
			_columnAlign = value;
		}
		
		/**
		 * Горизонтальное выравнивание элемента в ячейке. 
		 * 
		 */		
		public function get rowAlign():Align
		{
			return _rowAlign;
		}

		public function set rowAlign(value:Align):void
		{
			_rowAlign = value;
		}


	}
}