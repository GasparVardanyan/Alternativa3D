package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	use namespace alternativagui;
	
	/**
	 * Резиновая растровая плашка. Уголки отрисовываются в натуральную величину, а средние кусочки растягиваются. 
	 */	
	public class StretchBitmap extends GUIobject {
		
		protected var texture:BitmapData;
		protected var leftEdgeWidth:int;
		protected var rightEdgeWidth:int;
		protected var topEdgeHeight:int;
		protected var bottomEdgeHeight:int;
		
		public var topLeft:Bitmap;
		public var topCenter:Bitmap;
		public var topRight:Bitmap;
		
		public var middleLeft:Bitmap;
		public var middleCenter:Bitmap;
		public var middleRight:Bitmap;
		
		public var bottomLeft:Bitmap;
		public var bottomCenter:Bitmap;
		public var bottomRight:Bitmap;
		
		protected var _drawMiddleCenter:Boolean;
		
		protected var matrix:Matrix = new Matrix();
		
		/**
		 * 
		 * @param texture Растровый объект.
		 * @param leftEdgeWidth Ширина левого края.
		 * @param rightEdgeWidth Ширина правого края.
		 * @param topEdgeHeight Ширина верхнего края.
		 * @param bottomEdgeHeight Ширина нижнего края.
		 * @param drawMiddleCenter Рисовать середину или нет.
		 * 
		 */		
		public function StretchBitmap(texture:BitmapData, leftEdgeWidth:int, rightEdgeWidth:int, topEdgeHeight:int, bottomEdgeHeight:int, drawMiddleCenter:Boolean = true)	{
			this.texture = texture;
			this.leftEdgeWidth = leftEdgeWidth;
			this.rightEdgeWidth = rightEdgeWidth;
			this.topEdgeHeight = topEdgeHeight;
			this.bottomEdgeHeight = bottomEdgeHeight;
			
			_drawMiddleCenter = drawMiddleCenter;
			
			topLeft = new Bitmap();
			addChild(topLeft);
			
			topCenter = new Bitmap();
			addChild(topCenter);
			
			topRight = new Bitmap();
			addChild(topRight);
			
			middleLeft = new Bitmap();
			addChild(middleLeft);
			
			if (drawMiddleCenter) {
				middleCenter = new Bitmap();
				addChild(middleCenter);
			}
			
			middleRight = new Bitmap();
			addChild(middleRight);
			
			
			bottomLeft = new Bitmap();
			addChild(bottomLeft);
			
			bottomCenter = new Bitmap();
			addChild(bottomCenter);
			
			bottomRight = new Bitmap();
			addChild(bottomRight);
			
			sliceTexture();
		}
		
		/**
		 * Отрисовка
		 */		
		override protected function draw():void {
//			//trace("\nStretchBitmap draw");
//			super.draw();
//			
//			// Масштабирование резиновых кусков	
//			/*var sx:Number = (_width - (leftEdgeWidth + rightEdgeWidth))/(texture.width - (leftEdgeWidth + rightEdgeWidth));
//			var sy:Number = (_height - (topEdgeHeight + bottomEdgeHeight))/(texture.height - (topEdgeHeight + bottomEdgeHeight));
//			
//			// Смещение до правых и нижних углов
//			var tx:Number = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
//			var ty:Number = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
//			
//			// Смещение до резиновых кусков
//			var stretchTx:Number = -leftEdgeWidth*sx + leftEdgeWidth;// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
//			var stretchTy:Number = -topEdgeHeight*sy + topEdgeHeight;
//			
//			// Ширина центральной вертикальной и средней горизонтальной полос
//			var stretchWidth:int = _width - (leftEdgeWidth + rightEdgeWidth);
//			var stretchHeight:int = _height - (topEdgeHeight + bottomEdgeHeight);
//			*/
//						
//			/*topLeft.graphics.clear();
//			topCenter.graphics.clear();
//			topRight.graphics.clear();
//			
//			middleLeft.graphics.clear();
//			middleCenter.graphics.clear();
//			middleRight.graphics.clear();
//			
//			bottomLeft.graphics.clear();
//			bottomCenter.graphics.clear();
//			bottomRight.graphics.clear();
//			*/
//			
//			//TOP-LEFT
//			/*topLeft.graphics.beginBitmapFill(texture, null, false, false);
//			topLeft.graphics.drawRect(0, 0, leftEdgeWidth, topEdgeHeight);
//			topLeft.graphics.endFill();
//			*/
//			
//			//TOP-CENTER
//			topCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//			topCenter.x = leftEdgeWidth;
//			topCenter.y = 0;
//			
//			/*var m:Matrix = new Matrix();
//			//m.createBox(sx, 1, 0, stretchTx, 0);
//			//m.scale(sx, 1);
//			m.tx = -leftEdgeWidth;
//			topCenter.graphics.beginBitmapFill(texture, m, false, false);
//			//topCenter.graphics.beginFill(0xff0000, 1);
//			//topCenter.graphics.beginBitmapFill(new BitmapData(texture.width, texture.height, false, 0x00ff00), m, false, false);
//			//topCenter.graphics.drawRect(leftEdgeWidth, 0, stretchWidth, topEdgeHeight);
//			//topCenter.graphics.drawRect(0, 0, stretchWidth, topEdgeHeight);
//			topCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, topEdgeHeight);
//			//topCenter.graphics.endFill();
//			topCenter.x = leftEdgeWidth;
//			topCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//			*/
//			
//			//TOP-RIGHT
//			topRight.x = _width - rightEdgeWidth;
//			/*m = new Matrix();
//			m.tx = -(texture.width - rightEdgeWidth);
//			topRight.graphics.beginBitmapFill(texture, m, false, false);
//			topRight.graphics.drawRect(0, 0, rightEdgeWidth, topEdgeHeight);
//			//topRight.graphics.endFill();
//			topRight.x = _width - rightEdgeWidth;
//			topRight.width = rightEdgeWidth;
//			*/
//			
//			
//			//MIDDLE-LEFT
//			middleLeft.y = topEdgeHeight;
//			middleLeft.height = _height - topEdgeHeight - bottomEdgeHeight;
//			/*m = new Matrix();
//			m.ty = -topEdgeHeight;
//			//m.createBox(1, sy, 0, 0, stretchTy);
//			middleLeft.graphics.beginBitmapFill(texture, m, false, false);
//			middleLeft.graphics.drawRect(0, 0, leftEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
//			//middleLeft.graphics.endFill();
//			middleLeft.y = topEdgeHeight;
//			middleLeft.height = _height - topEdgeHeight - bottomEdgeHeight;
//			*/
//			
//			//MIDDLE-CENTER
//			if (middleCenter != null) {
//				middleCenter.x = leftEdgeWidth;
//				middleCenter.y = topEdgeHeight;
//				middleCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//				middleCenter.height = _height - topEdgeHeight - bottomEdgeHeight;
//			}
//			/*m = new Matrix();
//			m.tx = -leftEdgeWidth;
//			m.ty = -topEdgeHeight;
//			//m.createBox(sx, sy, 0, stretchTx, stretchTy);
//			middleCenter.graphics.beginBitmapFill(texture, m, false, false);
//			middleCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
//			//middleCenter.graphics.endFill();
//			middleCenter.x = leftEdgeWidth;
//			middleCenter.y = topEdgeHeight;
//			middleCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//			middleCenter.height = _height - topEdgeHeight - bottomEdgeHeight;
//			*/
//			
//			//MIDDLE-RIGHT
//			middleRight.x = _width - rightEdgeWidth;
//			middleRight.y = topEdgeHeight;
//			middleRight.height = _height - topEdgeHeight - bottomEdgeHeight;
//			
//			/*m = new Matrix();
//			m.tx = -(texture.width - rightEdgeWidth);
//			m.ty = -topEdgeHeight;
//			//m.createBox(1, sy, 0, tx, stretchTy);
//			middleRight.graphics.beginBitmapFill(texture, m, false, false);
//			middleRight.graphics.drawRect(0, 0, rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
//			//middleRight.graphics.endFill();
//			middleRight.x = _width - rightEdgeWidth;
//			middleRight.y = topEdgeHeight;
//			middleRight.height = _height - topEdgeHeight - bottomEdgeHeight;
//			*/
//			
//			//BOTTOM-LEFT
//			bottomLeft.y = _height - bottomEdgeHeight;
//			
//			/*m = new Matrix();
//			m.ty = -(texture.height - bottomEdgeHeight);
//			bottomLeft.graphics.beginBitmapFill(texture, m, false, false);
//			bottomLeft.graphics.drawRect(0, 0, leftEdgeWidth, bottomEdgeHeight);
//			//bottomLeft.graphics.endFill();
//			bottomLeft.y = _height - bottomEdgeHeight;
//			*/
//			
//			
//			//BOTTOM-CENTER
//			bottomCenter.x = leftEdgeWidth;
//			bottomCenter.y = _height - bottomEdgeHeight;
//			bottomCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//			
//			/*m = new Matrix();
//			//m.createBox(sx, 1, 0, stretchTx, ty);
//			m.tx = -leftEdgeWidth;
//			m.ty = -(texture.height - bottomEdgeHeight);
//			bottomCenter.graphics.beginBitmapFill(texture, m, false, false);
//			bottomCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, bottomEdgeHeight);
//			//bottomCenter.graphics.endFill();
//			bottomCenter.x = leftEdgeWidth;
//			bottomCenter.y = _height - bottomEdgeHeight;
//			bottomCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
//			*/
//			
//			//BOTTOM-RIGHT
//			bottomRight.x = _width - rightEdgeWidth;
//			bottomRight.y = _height - bottomEdgeHeight;
//			
//			/*m = new Matrix();
//			m.tx = -(texture.width - rightEdgeWidth);
//			m.ty = -(texture.height - bottomEdgeHeight);
//			bottomRight.graphics.beginBitmapFill(texture, m, false, false);
//			bottomRight.graphics.drawRect(0, 0, rightEdgeWidth, bottomEdgeHeight);
//			//bottomRight.graphics.endFill();
//			bottomRight.x = _width - rightEdgeWidth;
//			bottomRight.y = _height - bottomEdgeHeight;
//			*/
		}
		
		override public function drawGraphics():void {
			//trace("\nStretchBitmap draw");
//			super.draw();
			
			// Масштабирование резиновых кусков	
			/*var sx:Number = (_width - (leftEdgeWidth + rightEdgeWidth))/(texture.width - (leftEdgeWidth + rightEdgeWidth));
			var sy:Number = (_height - (topEdgeHeight + bottomEdgeHeight))/(texture.height - (topEdgeHeight + bottomEdgeHeight));
			
			// Смещение до правых и нижних углов
			var tx:Number = -(texture.width - rightEdgeWidth) + (_width - rightEdgeWidth);// нужно сдвинуть текстуру влево, чтоб нужный кусок начинался с нуля, а потом прибавить координату x из drawRect
			var ty:Number = -(texture.height - bottomEdgeHeight) + (_height - bottomEdgeHeight);
			
			// Смещение до резиновых кусков
			var stretchTx:Number = -leftEdgeWidth*sx + leftEdgeWidth;// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
			var stretchTy:Number = -topEdgeHeight*sy + topEdgeHeight;
			
			// Ширина центральной вертикальной и средней горизонтальной полос
			var stretchWidth:int = _width - (leftEdgeWidth + rightEdgeWidth);
			var stretchHeight:int = _height - (topEdgeHeight + bottomEdgeHeight);
			*/
			
			/*topLeft.graphics.clear();
			topCenter.graphics.clear();
			topRight.graphics.clear();
			
			middleLeft.graphics.clear();
			middleCenter.graphics.clear();
			middleRight.graphics.clear();
			
			bottomLeft.graphics.clear();
			bottomCenter.graphics.clear();
			bottomRight.graphics.clear();
			*/
			
			//TOP-LEFT
			/*topLeft.graphics.beginBitmapFill(texture, null, false, false);
			topLeft.graphics.drawRect(0, 0, leftEdgeWidth, topEdgeHeight);
			topLeft.graphics.endFill();
			*/
			
			//TOP-CENTER
			topCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
			topCenter.x = leftEdgeWidth;
			topCenter.y = 0;
			
			/*var m:Matrix = new Matrix();
			//m.createBox(sx, 1, 0, stretchTx, 0);
			//m.scale(sx, 1);
			m.tx = -leftEdgeWidth;
			topCenter.graphics.beginBitmapFill(texture, m, false, false);
			//topCenter.graphics.beginFill(0xff0000, 1);
			//topCenter.graphics.beginBitmapFill(new BitmapData(texture.width, texture.height, false, 0x00ff00), m, false, false);
			//topCenter.graphics.drawRect(leftEdgeWidth, 0, stretchWidth, topEdgeHeight);
			//topCenter.graphics.drawRect(0, 0, stretchWidth, topEdgeHeight);
			topCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, topEdgeHeight);
			//topCenter.graphics.endFill();
			topCenter.x = leftEdgeWidth;
			topCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
			*/
			
			//TOP-RIGHT
			topRight.x = _width - rightEdgeWidth;
			/*m = new Matrix();
			m.tx = -(texture.width - rightEdgeWidth);
			topRight.graphics.beginBitmapFill(texture, m, false, false);
			topRight.graphics.drawRect(0, 0, rightEdgeWidth, topEdgeHeight);
			//topRight.graphics.endFill();
			topRight.x = _width - rightEdgeWidth;
			topRight.width = rightEdgeWidth;
			*/
			
			
			//MIDDLE-LEFT
			middleLeft.y = topEdgeHeight;
			middleLeft.height = _height - topEdgeHeight - bottomEdgeHeight;
			/*m = new Matrix();
			m.ty = -topEdgeHeight;
			//m.createBox(1, sy, 0, 0, stretchTy);
			middleLeft.graphics.beginBitmapFill(texture, m, false, false);
			middleLeft.graphics.drawRect(0, 0, leftEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
			//middleLeft.graphics.endFill();
			middleLeft.y = topEdgeHeight;
			middleLeft.height = _height - topEdgeHeight - bottomEdgeHeight;
			*/
			
			//MIDDLE-CENTER
			if (middleCenter != null) {
				middleCenter.x = leftEdgeWidth;
				middleCenter.y = topEdgeHeight;
				middleCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
				middleCenter.height = _height - topEdgeHeight - bottomEdgeHeight;
			}
			/*m = new Matrix();
			m.tx = -leftEdgeWidth;
			m.ty = -topEdgeHeight;
			//m.createBox(sx, sy, 0, stretchTx, stretchTy);
			middleCenter.graphics.beginBitmapFill(texture, m, false, false);
			middleCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
			//middleCenter.graphics.endFill();
			middleCenter.x = leftEdgeWidth;
			middleCenter.y = topEdgeHeight;
			middleCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
			middleCenter.height = _height - topEdgeHeight - bottomEdgeHeight;
			*/
			
			//MIDDLE-RIGHT
			middleRight.x = _width - rightEdgeWidth;
			middleRight.y = topEdgeHeight;
			middleRight.height = _height - topEdgeHeight - bottomEdgeHeight;
			
			/*m = new Matrix();
			m.tx = -(texture.width - rightEdgeWidth);
			m.ty = -topEdgeHeight;
			//m.createBox(1, sy, 0, tx, stretchTy);
			middleRight.graphics.beginBitmapFill(texture, m, false, false);
			middleRight.graphics.drawRect(0, 0, rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight);
			//middleRight.graphics.endFill();
			middleRight.x = _width - rightEdgeWidth;
			middleRight.y = topEdgeHeight;
			middleRight.height = _height - topEdgeHeight - bottomEdgeHeight;
			*/
			
			//BOTTOM-LEFT
			bottomLeft.y = _height - bottomEdgeHeight;
			
			/*m = new Matrix();
			m.ty = -(texture.height - bottomEdgeHeight);
			bottomLeft.graphics.beginBitmapFill(texture, m, false, false);
			bottomLeft.graphics.drawRect(0, 0, leftEdgeWidth, bottomEdgeHeight);
			//bottomLeft.graphics.endFill();
			bottomLeft.y = _height - bottomEdgeHeight;
			*/
			
			
			//BOTTOM-CENTER
			bottomCenter.x = leftEdgeWidth;
			bottomCenter.y = _height - bottomEdgeHeight;
			bottomCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
			
			/*m = new Matrix();
			//m.createBox(sx, 1, 0, stretchTx, ty);
			m.tx = -leftEdgeWidth;
			m.ty = -(texture.height - bottomEdgeHeight);
			bottomCenter.graphics.beginBitmapFill(texture, m, false, false);
			bottomCenter.graphics.drawRect(0, 0, texture.width - leftEdgeWidth - rightEdgeWidth, bottomEdgeHeight);
			//bottomCenter.graphics.endFill();
			bottomCenter.x = leftEdgeWidth;
			bottomCenter.y = _height - bottomEdgeHeight;
			bottomCenter.width = _width - leftEdgeWidth - rightEdgeWidth;
			*/
			
			//BOTTOM-RIGHT
			bottomRight.x = _width - rightEdgeWidth;
			bottomRight.y = _height - bottomEdgeHeight;
			
			/*m = new Matrix();
			m.tx = -(texture.width - rightEdgeWidth);
			m.ty = -(texture.height - bottomEdgeHeight);
			bottomRight.graphics.beginBitmapFill(texture, m, false, false);
			bottomRight.graphics.drawRect(0, 0, rightEdgeWidth, bottomEdgeHeight);
			//bottomRight.graphics.endFill();
			bottomRight.x = _width - rightEdgeWidth;
			bottomRight.y = _height - bottomEdgeHeight;
			*/
		}
		
		protected function sliceTexture():void {
			
			// TOP
			var bd:BitmapData = new BitmapData(leftEdgeWidth, topEdgeHeight, true, 0);
			bd.draw(texture);
			topLeft.bitmapData = bd;
			
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.tx = -leftEdgeWidth;
			bd = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, topEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			topCenter.bitmapData = bd;
			
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -(texture.width - rightEdgeWidth);
			bd = new BitmapData(rightEdgeWidth, topEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			topRight.bitmapData = bd;
			
			// MIDDLE
			//m = new Matrix();
			matrix.identity();
			matrix.ty = -topEdgeHeight;
			bd = new BitmapData(leftEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			middleLeft.bitmapData = bd;
			
			if (_drawMiddleCenter) {
				sliceMiddleCenter();
			}
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -(texture.width - rightEdgeWidth);
			matrix.ty = -topEdgeHeight;
			bd = new BitmapData(rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			middleRight.bitmapData = bd;
			
			// BOTTOM
			//m = new Matrix();
			matrix.identity();
			matrix.ty = -(texture.height - bottomEdgeHeight);
			bd = new BitmapData(leftEdgeWidth, bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			bottomLeft.bitmapData = bd;
			
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -leftEdgeWidth;
			matrix.ty = -(texture.height - bottomEdgeHeight);
			bd = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			bottomCenter.bitmapData = bd;
			
			//m = new Matrix();
			matrix.identity();
			matrix.tx = -(texture.width - rightEdgeWidth);
			matrix.ty = -(texture.height - bottomEdgeHeight);
			bd = new BitmapData(rightEdgeWidth, bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			bottomRight.bitmapData = bd;
		}
		
		protected function sliceMiddleCenter():void {
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.tx = -leftEdgeWidth;
			matrix.ty = -topEdgeHeight;
		
			var bd:BitmapData = new BitmapData(texture.width - leftEdgeWidth - rightEdgeWidth, texture.height - topEdgeHeight - bottomEdgeHeight, true, 0);
			bd.draw(texture, matrix, null, null, null, false);
			middleCenter.bitmapData = bd;
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
			sliceTexture();
		}
		
		/**
		 * Рисовать или нет середину. 
		 * 
		 */		
		public function get drawMiddleCenter():Boolean {
			return _drawMiddleCenter;
		}
		public function set drawMiddleCenter(value:Boolean):void {
			_drawMiddleCenter = value;
			if (_drawMiddleCenter) {
				if (middleCenter == null) {
					middleCenter = new Bitmap();
					addChild(middleCenter);
					
					sliceMiddleCenter();
				} else if (!contains(middleCenter)) {
					addChild(middleCenter);
				}
			} else {
				if (middleCenter != null && contains(middleCenter)) {
					removeChild(middleCenter);
				}
			}
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