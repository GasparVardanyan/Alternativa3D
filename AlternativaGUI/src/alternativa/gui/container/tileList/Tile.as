package alternativa.gui.container.tileList {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.Container;
	use namespace alternativagui;	
	
	/**
	 * Тайл-контейнер с фиксированной шириной и высотой у ячейки. 
	 * 
	 */	
	public class Tile extends Container {

		protected var _space:int;
		protected var _padding:int;
		protected var _rowHeight:int = 50;
		protected var _columnWidth:int = 50;
		
		protected var _numColumns:int=0;
		protected var _numRows:int=0;

		/**
		 *  
		 * @param space Зазор между элементами.
		 * 
		 */		
		public function Tile(space:int = 3) {
			super();
			_space = space;
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
			calculateSize();
			draw();
		}
		
		/**
		 * Внутренний отступ. 
		 * 
		 */		
		public function get padding():int {
			return _padding;
		}
		public function set padding(value:int):void {
			_padding = value;
			calculateSize();
			draw();
		}
		
		/**
		 * Высота строки. 
		 * 
		 */		
		public function get rowHeight():int {
			return _rowHeight;
		}
		public function set rowHeight(value:int):void {
			_rowHeight = value;
		}	
		
		/**
		 * Ширина столбца. 
		 * 
		 */		
		public function get columnWidth():int {
			return _columnWidth;
		}	
		public function set columnWidth(value:int):void {
			_columnWidth = value;
		}

		/**
		 * Пересчет размеров контейнера. 
		 * 
		 */		
		protected function calculateSize():void {
			var fullRow:int;
			//trace("tile width = ",_width);
			_numColumns = int ((_width - padding*2)/(_columnWidth+_space));
			fullRow = int (_objects.length / _numColumns)
			_numRows = fullRow + ((fullRow == _objects.length / _numColumns) ? 0 : 1);
			
			//_minSize.x = _width; 
			//_height = _minSize.y = _padding*2 + (_rowHeight+_space )*_numRows- _space;
			_height = _padding*2 + (_rowHeight+_space )*_numRows- _space;
			
//			trace(" _numColumns",_numColumns);
//			trace(" _numRows",_numRows);
			//trace(" _objects.length",_objects.length);
			draw();
		}
		
		/**
		 * Ширина. После выполняется calculateSize(). 
		 * @param value
		 * 
		 */		
		override public function set width(value:Number):void {
			_width = value;
			calculateSize();
		}


		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
			drawLayout();
		}
		
		/**
		 * Перерисовка контейнера. 
		 * 
		 */		
		public function drawLayout():void {
			var currX:int = _padding;
			var currY:int = _padding;
			var currentRow:int=0;
			var currentColumn:int=1;
			for (var i:int = 0; i < _objects.length; i++) {
				var object:GUIobject = _objects[i] as GUIobject;
				object.x = currX;
				object.y = currY;
				
				currentColumn+=1;
				if (currentColumn>_numColumns){
					currentRow+=1;
					currentColumn = 1;
					currX = _padding;
					currY += _rowHeight+_space;
				} else {
					currX += _columnWidth+_space;
				}
			}
			
//			this.graphics.clear();
//			this.graphics.beginFill(0xff0000,0.1);
//			this.graphics.drawRect(0,0,_width,_height);
//			this.graphics.endFill();	
//			
//			trace("tile draw");		
			
		}

	}
}