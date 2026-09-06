package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	use namespace alternativagui;
	
	/**
	 * Тянущаяся по горизонтали резиновая растровая плашка. 
	 * <p>Левая и правая сторона отрисовывается в натуральную величину, середина растягивается.</p> 
	 * 
	 */	
	public class HorizontalBar extends GUIobject {
		
		protected var texture:BitmapData;
		protected var _leftEdgeWidth:int;
		protected var _rightEdgeWidth:int;
		
		protected var matrix:Matrix = new Matrix();
		
		/**
		 * 
		 * @param texture Растровый объект.
		 * @param leftEdgeWidth Ширина левого края.
		 * @param rightEdgeWidth Ширина правого края.
		 * 
		 */		
		public function HorizontalBar(texture:BitmapData, leftEdgeWidth:int, rightEdgeWidth:int) {
			_leftEdgeWidth = leftEdgeWidth;
			_rightEdgeWidth = rightEdgeWidth;
			
			if (texture != null) {
				bitmapData = texture;
			}
		}
		
		override protected function calculateWidth(value:int):int {
			return Math.max(_leftEdgeWidth + _rightEdgeWidth, value);
		}
		
		override protected function calculateHeight(value:int):int {
			return _height;
		}
		
		override public function set height(value:Number):void {}
		
		/**
		 * Отрисовка
		 */		
		override protected function draw():void {
//			super.draw();
			
//			if (texture != null) {
//				var m:Matrix = new Matrix();
//				
//				this.graphics.clear();
//				
//				// LEFT
//				this.graphics.beginBitmapFill(texture, m, false, false);
//				//				LayoutManager.decCalls();
//				this.graphics.drawRect(0, 0, _leftEdgeWidth, texture.height);
//				
//				// RIGHT
//				// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
//				m.tx = +(_width - _rightEdgeWidth) - (texture.width - _rightEdgeWidth); 
//				this.graphics.beginBitmapFill(texture, m, false, false);
//				//				LayoutManager.decCalls();
//				this.graphics.drawRect(_width - _rightEdgeWidth, 0, _rightEdgeWidth, texture.height);
//				
//				// CENTER
//				// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
//				var sx:Number = (_width - (_leftEdgeWidth + _rightEdgeWidth))/(texture.width - (_leftEdgeWidth + _rightEdgeWidth));
//				m.createBox(sx, 1, 0, -_leftEdgeWidth*sx + _leftEdgeWidth, 0);
//				this.graphics.beginBitmapFill(texture, m, false, false);
//				//				LayoutManager.decCalls();
//				this.graphics.drawRect(_leftEdgeWidth, 0, _width - (_leftEdgeWidth + _rightEdgeWidth), texture.height);
//			}
		}
		
		override public function drawGraphics():void {
			if (texture != null) {
				//var m:Matrix = new Matrix();
				matrix.identity();
				this.graphics.clear();
				
				// LEFT
				this.graphics.beginBitmapFill(texture, matrix, false, false);
//				LayoutManager.decCalls();
				this.graphics.drawRect(0, 0, _leftEdgeWidth, texture.height);
				
				// RIGHT
				// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
				matrix.tx = +(_width - _rightEdgeWidth) - (texture.width - _rightEdgeWidth); 
				this.graphics.beginBitmapFill(texture, matrix, false, false);
//				LayoutManager.decCalls();
				this.graphics.drawRect(_width - _rightEdgeWidth, 0, _rightEdgeWidth, texture.height);
				
				// CENTER
				// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
				var sx:Number = (_width - (_leftEdgeWidth + _rightEdgeWidth))/(texture.width - (_leftEdgeWidth + _rightEdgeWidth));
				matrix.createBox(sx, 1, 0, -_leftEdgeWidth*sx + _leftEdgeWidth, 0);
				this.graphics.beginBitmapFill(texture, matrix, false, false);
//				LayoutManager.decCalls();
				this.graphics.drawRect(_leftEdgeWidth, 0, _width - (_leftEdgeWidth + _rightEdgeWidth), texture.height);
			}
		}
		
		public function redraw():void {
			draw();
		}
		
		/**
		 * Ширина левого края. 
		 * 
		 */		
		public function set leftEdgeWidth(value:int):void {
			_leftEdgeWidth = value;
		}
		
		/**
		 * Ширина правого края. 
		 * 
		 */		
		public function set rightEdgeWidth(value:int):void {
			_rightEdgeWidth = value;
		}
		
		/**
		 * Растровый объект. 
		 * 
		 */		
		public function set bitmapData(value:BitmapData):void {
			texture = value;
			_height = texture.height;
		}
		
	}
}