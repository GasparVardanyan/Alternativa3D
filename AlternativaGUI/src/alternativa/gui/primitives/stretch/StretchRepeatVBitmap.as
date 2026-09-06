package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	use namespace alternativagui;

	/**
	 * Резиновая растровая плашка с фиксированной шириной. Средние кусочки повторяются (если не хватает размера исходной текстуры).
	 *
	 */
	public class StretchRepeatVBitmap extends GUIobject {

		protected var texture:BitmapData;

		protected var middleBitmap:BitmapData;

		protected var topEdgeHeight:int;

		protected var bottomEdgeHeight:int;
		
		protected var matrix:Matrix = new Matrix();
		
		/**
		 * 
		 * @param texture Растровый объект.
		 * @param topEdgeHeight Ширина верхнего края.
		 * @param bottomEdgeHeight Ширина нижнего края.
		 * 
		 */		
		public function StretchRepeatVBitmap(texture:BitmapData, topEdgeHeight:int, bottomEdgeHeight:int) {
			super();

			this.topEdgeHeight = topEdgeHeight;
			this.bottomEdgeHeight = bottomEdgeHeight;

			this.bitmapData = texture;
		}

		override public function set width(value:Number):void {
		}

		/**
		 * Отрисовка
		 */
		override protected function draw():void {
//			super.draw();
//
//			this.graphics.clear();
//
//			// TOP
//			this.graphics.beginBitmapFill(texture, null, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, 0, texture.width, topEdgeHeight);
//
//			// MIDDLE
//			this.graphics.beginBitmapFill(middleBitmap, null, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, topEdgeHeight, texture.width, _height - topEdgeHeight - bottomEdgeHeight);
//
//			// BOTTOM
//			var m:Matrix = new Matrix();
//			m.ty = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
//			this.graphics.beginBitmapFill(texture, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, _height - bottomEdgeHeight, texture.width, bottomEdgeHeight);
		}
		
		override public function drawGraphics():void {
//			super.draw();
			
			this.graphics.clear();
			
			// TOP
			this.graphics.beginBitmapFill(texture, null, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, 0, texture.width, topEdgeHeight);
			
			// MIDDLE
			this.graphics.beginBitmapFill(middleBitmap, null, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, topEdgeHeight, texture.width, _height - topEdgeHeight - bottomEdgeHeight);
			
			// BOTTOM
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.ty = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
			this.graphics.beginBitmapFill(texture, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, _height - bottomEdgeHeight, texture.width, bottomEdgeHeight);
		}
		
		/**
		 * Растровый объект. 
		 * 
		 */		
		public function set bitmapData(value:BitmapData):void {
			texture = value;

			_width = texture.width;

			// MIDDLE
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.ty = -topEdgeHeight;
			middleBitmap = new BitmapData(texture.width, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			middleBitmap.draw(texture, matrix);

			draw();
		}
		
		/**
		 * Ширина верхнего края. 
		 * 
		 */		
		public function set edgeSizeTop(value:int):void {
			topEdgeHeight = value;
		}

		/**
		 * Ширина нижнего края.
		 * 
		 */		
		public function set edgeSizeBottom(value:int):void {
			bottomEdgeHeight = value;
		}

	}
}
