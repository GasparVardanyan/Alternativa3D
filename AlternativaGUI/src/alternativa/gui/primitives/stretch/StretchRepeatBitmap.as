package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	import flash.geom.Matrix;

	use namespace alternativagui;
	
	/**
	 * Резиновая растровая плашка. Средние кусочки повторяются (если не хватает размера исходной текстуры).
	 *  
	 * @see StretchBitmap
	 * 
	 */	
	public class StretchRepeatBitmap extends StretchBitmap {
		
		protected var topCenterBitmap:BitmapData;
		protected var middleCenterBitmap:BitmapData;
		protected var bottomCenterBitmap:BitmapData;
		protected var middleLeftBitmap:BitmapData;
		protected var middleRightBitmap:BitmapData;
		
		/**
		 * 
		 * @inheritDoc
		 * 
		 */		
		public function StretchRepeatBitmap(texture:BitmapData, leftEdgeWidth:int, rightEdgeWidth:int, topEdgeHeight:int, bottomEdgeHeight:int, drawMiddleCenter:Boolean = true) {
			super(texture, leftEdgeWidth, rightEdgeWidth, topEdgeHeight, bottomEdgeHeight, drawMiddleCenter);
			
			
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function sliceTexture():void {
			//var m:Matrix = new Matrix();
			matrix.identity();
			
			//TOP-CENTER
			matrix.tx = -leftEdgeWidth;
			topCenterBitmap = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, topEdgeHeight, true, 0);
			topCenterBitmap.draw(texture, matrix);
			
			//MIDDLE-CENTER
			if (_drawMiddleCenter) {
				sliceMiddleCenter();
			}
			//BOTTOM-CENTER
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -leftEdgeWidth;
			matrix.ty = -(texture.height - bottomEdgeHeight);
			bottomCenterBitmap = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, bottomEdgeHeight, true, 0);
			bottomCenterBitmap.draw(texture, matrix);
			
			//MIDDLE-LEFT
			//m = new Matrix();
			matrix.identity();
			matrix.ty = -topEdgeHeight;
			middleLeftBitmap = new BitmapData(leftEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			middleLeftBitmap.draw(texture, matrix);
			
			//MIDDLE-RIGHT
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -(texture.width - rightEdgeWidth);
			matrix.ty = -topEdgeHeight;
			middleRightBitmap = new BitmapData(rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			middleRightBitmap.draw(texture, matrix);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function sliceMiddleCenter():void {
			matrix.identity();
			//var m:Matrix = new Matrix();
			matrix.tx = -leftEdgeWidth;
			matrix.ty = -topEdgeHeight;
			middleCenterBitmap = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			middleCenterBitmap.draw(texture, matrix);
		}
		/**
		 * Отрисовка
		 */		
		override protected function draw():void {
//			//super.draw();
//			
////			var wCont:int = _width;
////			var hCont:int = _height;
////			//vertices = Vector.<Number>([0,100, 0,0, 100,0, 100,100]);
////			verticesCenter[1] = hCont - (topEdgeHeight + bottomEdgeHeight);
////			verticesCenter[4] = wCont-(leftEdgeWidth + rightEdgeWidth);
////			verticesCenter[6] = wCont-(leftEdgeWidth + rightEdgeWidth);
////			verticesCenter[7] = hCont - (topEdgeHeight + bottomEdgeHeight);
////			//			
////			//			//uvtData = Vector.<Number>([0,1,1, 0,0,1, 1,0,1, 1,1,1]);
////			uvtDataCenter[6] = (wCont * 0.5) / middleCenterBitmap.width;
////			uvtDataCenter[9] = (hCont * 0.5) / middleCenterBitmap.width;
////			
////			vertices[4] = wCont - rightEdgeWidth;
////			vertices[6] = wCont;
////			vertices[12] = wCont - rightEdgeWidth;
////			vertices[14] = wCont;
////			vertices[20] = wCont - rightEdgeWidth;
////			vertices[22] = wCont;
////			vertices[28] = wCont - rightEdgeWidth;
////			vertices[30] = wCont;
////			
////			vertices[17] = hCont - bottomEdgeHeight;
////			vertices[19] = hCont - bottomEdgeHeight;
////			vertices[21] = hCont - bottomEdgeHeight;
////			vertices[23] = hCont - bottomEdgeHeight;
////			
////			vertices[25] = hCont;
////			vertices[27] = hCont;
////			vertices[29] = hCont;
////			vertices[31] = hCont;
////			
////			
////			this.graphics.clear();
////			
////			this.graphics.beginBitmapFill(middleCenterBitmap, null, true);
////			this.graphics.drawTriangles(verticesCenter, indicesCenter, uvtDataCenter);
////			
////			this.graphics.beginBitmapFill(texture, null, false);
////			this.graphics.drawTriangles(vertices, indices, uvtData);
//			
//			// Смещение до правых и нижних углов
//			var tx:Number = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
//			var ty:Number = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
//			
//			// Смещение до резиновых кусков
//			var stretchTx:Number = -leftEdgeWidth;
//			var stretchTy:Number = -topEdgeHeight;
//			
//			// Ширина центральной вертикальной и средней горизонтальной полос
//			var stretchWidth:int = _width - (leftEdgeWidth + rightEdgeWidth);
//			var stretchHeight:int = _height - (topEdgeHeight + bottomEdgeHeight);
//						
//			this.graphics.clear();
//			var m:Matrix = new Matrix();
//			
//			//TOP-LEFT
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, 0, leftEdgeWidth, topEdgeHeight);
//			
//			//TOP-CENTER
//			m.tx = leftEdgeWidth;
//			this.graphics.beginBitmapFill(topCenterBitmap, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(leftEdgeWidth, 0, stretchWidth, topEdgeHeight);
//			
//			//TOP-RIGHT
//			m = new Matrix();
//			m.tx = tx;
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(_width - rightEdgeWidth, 0, rightEdgeWidth, topEdgeHeight);
//			
//			//MIDDLE-LEFT
//			m = new Matrix();
//			m.ty = topEdgeHeight;
//			this.graphics.beginBitmapFill(middleLeftBitmap, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, topEdgeHeight, leftEdgeWidth, stretchHeight);
//			
//			//MIDDLE-CENTER
//			if (_drawMiddleCenter) {
//				m = new Matrix();
//				m.tx = leftEdgeWidth;
//				m.ty = topEdgeHeight;
//				this.graphics.beginBitmapFill(middleCenterBitmap, m, true, false);
////				LayoutManager.decCalls();
//				this.graphics.drawRect(leftEdgeWidth, topEdgeHeight, stretchWidth, stretchHeight);
//			}
//			//MIDDLE-RIGHT
//			m = new Matrix();
//			m.tx = _width - rightEdgeWidth;
//			m.ty = topEdgeHeight;
//			this.graphics.beginBitmapFill(middleRightBitmap, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(_width - rightEdgeWidth, topEdgeHeight, rightEdgeWidth, stretchHeight);
//			
//			//BOTTOM-LEFT
//			m = new Matrix();
//			m.ty = ty;
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, _height - bottomEdgeHeight, leftEdgeWidth, bottomEdgeHeight);
//			
//			//BOTTOM-CENTER
//			m = new Matrix();
//			m.tx = leftEdgeWidth;
//			m.ty = _height - bottomEdgeHeight;
//			this.graphics.beginBitmapFill(bottomCenterBitmap, m, true, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(leftEdgeWidth, _height - bottomEdgeHeight, stretchWidth, bottomEdgeHeight);
//			
//			//BOTTOM-RIGHT
//			m = new Matrix();
//			m.tx = tx;
//			m.ty = ty;
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(_width - rightEdgeWidth, _height - bottomEdgeHeight, rightEdgeWidth, bottomEdgeHeight);
		}
		
		override public function drawGraphics():void {
			
			// Смещение до правых и нижних углов
			var tx:Number = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
			var ty:Number = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
			
			// Смещение до резиновых кусков
			var stretchTx:Number = -leftEdgeWidth;
			var stretchTy:Number = -topEdgeHeight;
			
			// Ширина центральной вертикальной и средней горизонтальной полос
			var stretchWidth:int = _width - (leftEdgeWidth + rightEdgeWidth);
			var stretchHeight:int = _height - (topEdgeHeight + bottomEdgeHeight);
			
			this.graphics.clear();
			//var m:Matrix = new Matrix();
			matrix.identity();
			//TOP-LEFT
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, 0, leftEdgeWidth, topEdgeHeight);
			
			//TOP-CENTER
			matrix.tx = leftEdgeWidth;
			this.graphics.beginBitmapFill(topCenterBitmap, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(leftEdgeWidth, 0, stretchWidth, topEdgeHeight);
			
			//TOP-RIGHT
			//m = new Matrix();
			matrix.identity();
			matrix.tx = tx;
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(_width - rightEdgeWidth, 0, rightEdgeWidth, topEdgeHeight);
			
			//MIDDLE-LEFT
			//m = new Matrix();
			matrix.identity();
			matrix.ty = topEdgeHeight;
			this.graphics.beginBitmapFill(middleLeftBitmap, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, topEdgeHeight, leftEdgeWidth, stretchHeight);
			
			//MIDDLE-CENTER
			if (_drawMiddleCenter) {
				//m = new Matrix();
				matrix.identity();
				matrix.tx = leftEdgeWidth;
				matrix.ty = topEdgeHeight;
				this.graphics.beginBitmapFill(middleCenterBitmap, matrix, true, false);
//				LayoutManager.decCalls();
				this.graphics.drawRect(leftEdgeWidth, topEdgeHeight, stretchWidth, stretchHeight);
			}
			//MIDDLE-RIGHT
			//m = new Matrix();
			matrix.identity();
			matrix.tx = _width - rightEdgeWidth;
			matrix.ty = topEdgeHeight;
			this.graphics.beginBitmapFill(middleRightBitmap, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(_width - rightEdgeWidth, topEdgeHeight, rightEdgeWidth, stretchHeight);
			
			//BOTTOM-LEFT
			//m = new Matrix();
			matrix.identity();
			matrix.ty = ty;
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, _height - bottomEdgeHeight, leftEdgeWidth, bottomEdgeHeight);
			
			//BOTTOM-CENTER
			//m = new Matrix();
			matrix.identity();
			matrix.tx = leftEdgeWidth;
			matrix.ty = _height - bottomEdgeHeight;
			this.graphics.beginBitmapFill(bottomCenterBitmap, matrix, true, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(leftEdgeWidth, _height - bottomEdgeHeight, stretchWidth, bottomEdgeHeight);
			
			//BOTTOM-RIGHT
			//m = new Matrix();
			matrix.identity();
			matrix.tx = tx;
			matrix.ty = ty;
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(_width - rightEdgeWidth, _height - bottomEdgeHeight, rightEdgeWidth, bottomEdgeHeight);
		}
		
		/*override public function toString():String {
			var s:String = "[StretchRepeatBitmap]]";
			var currentParent:DisplayObject = this.parent;
	        // Перебираем родителей
	        while (currentParent != null && currentParent != stage) {
				s = currentParent.toString() + "/" + s;
				currentParent = currentParent.parent;
			}
			return "[" + s;
		}*/

	}
}