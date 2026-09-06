package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	use namespace alternativagui;

	/**
	 * Резиновая растровая плашка с фиксированной высотой. Средние кусочки повторяются (если не хватает размера исходной текстуры).
	 *
	 */
	public class StretchRepeatHBitmap extends GUIobject {

		protected var texture:BitmapData;

		protected var centerBitmap:BitmapData;

		protected var leftEdgeWidth:int;

		protected var rightEdgeWidth:int;
		
		protected var matrix:Matrix = new Matrix();

		/**
		 * 
		 * @param texture Растровый объект.
		 * @param leftEdgeWidth Ширина левого края.
		 * @param rightEdgeWidth Ширина правого края.
		 * 
		 */		
		public function StretchRepeatHBitmap(texture:BitmapData, leftEdgeWidth:int, rightEdgeWidth:int) {
			super();
			
			this.leftEdgeWidth = leftEdgeWidth;
			this.rightEdgeWidth = rightEdgeWidth;
			this.bitmapData = texture;
		}

		override public function set height(value:Number):void {
		}

		/**
		 * Отрисовка
		 */
		override protected function draw():void {
//////			super.draw();
////
////			var wCont:int = _width;
////			var hCont:int = _height;
////			//vertices = Vector.<Number>([0,100, 0,0, 100,0, 100,100]);
////			verticesCenter[1] = hCont;
////			verticesCenter[4] = wCont-(leftEdgeWidth + rightEdgeWidth);
////			verticesCenter[6] = wCont-(leftEdgeWidth + rightEdgeWidth);
////			verticesCenter[7] = hCont;
////			//			
////			//			//uvtData = Vector.<Number>([0,1,1, 0,0,1, 1,0,1, 1,1,1]);
////			uvtDataCenter[6] = (wCont * 0.5) / centerBitmap.width;
////			uvtDataCenter[9] = (hCont * 0.5) / centerBitmap.width;
////			
////			vertices[4] = wCont - (leftEdgeWidth + rightEdgeWidth);
////			vertices[6] = wCont;
////			vertices[9] = hCont;
////			vertices[11] = hCont;
////			vertices[12] = wCont - (leftEdgeWidth + rightEdgeWidth);
////			vertices[14] = wCont;
////			
////			
////			this.graphics.clear();
////			
////			this.graphics.beginBitmapFill(centerBitmap, null, true);
////			this.graphics.drawTriangles(verticesCenter, indicesCenter, uvtDataCenter);
////			
////			this.graphics.beginBitmapFill(texture, null, false);
////			this.graphics.drawTriangles(vertices, indices, uvtData);
//			
//			this.graphics.clear();
//
//			// LEFT
//			this.graphics.beginBitmapFill(texture, null, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, 0, leftEdgeWidth, texture.height);
//
//			// CENTER
//			this.graphics.beginBitmapFill(centerBitmap, null, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(leftEdgeWidth, 0, _width - leftEdgeWidth - rightEdgeWidth, texture.height);
//
//			// RIGHT
//			var m:Matrix = new Matrix();
//			m.tx = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);
//			this.graphics.beginBitmapFill(texture, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(_width - rightEdgeWidth, 0, rightEdgeWidth, texture.height);
		}

		override public function drawGraphics():void {
			this.graphics.clear();
			
			// LEFT
			this.graphics.beginBitmapFill(texture, null, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, 0, leftEdgeWidth, texture.height);
			
			// CENTER
			this.graphics.beginBitmapFill(centerBitmap, null, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(leftEdgeWidth, 0, _width - leftEdgeWidth - rightEdgeWidth, texture.height);
			
			// RIGHT
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.tx = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);
			this.graphics.beginBitmapFill(texture, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(_width - rightEdgeWidth, 0, rightEdgeWidth, texture.height);
		}
		
		/**
		 * Растровый объект.
		 *
		 */
		public function get bitmapData():BitmapData {
			return texture;
		}

		public function set bitmapData(value:BitmapData):void {
			texture = value;

			_height = texture.height;

			// CENTER
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.tx = -leftEdgeWidth;
			centerBitmap = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, texture.height, true, 0);
			centerBitmap.draw(texture, matrix);

			draw();
		}

		/**
		 * Ширина левого края.
		 *
		 */
		public function set edgeSizeLeft(value:int):void {
			leftEdgeWidth = value;
		}

		/**
		 * Ширина правого края.
		 *
		 */
		public function set edgeSizeRight(value:int):void {
			rightEdgeWidth = value;
		}

	}
}
