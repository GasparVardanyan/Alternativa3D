package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.display.Graphics;
	import flash.geom.Matrix;

	use namespace alternativagui;
	
	/**
	 * Базовый класс.
	 * Резиновая растровая плашка с фиксированной высотой. 
	 * Состоит из трех частей: left, middle, right.
	 *
	 */
	public class HorizontalSlicedBar extends GUIobject {

		protected var left:BitmapData;
		protected var middle:BitmapData;
		protected var right:BitmapData;
		
		protected var matrix:Matrix = new Matrix();

		public function HorizontalSlicedBar() {
			super();
		}

		override public function set height(value:Number):void {}
		
		override protected function draw():void {
//			var g:Graphics = this.graphics;
//			var matrix:Matrix;
//
//			var leftWidth:int = left.width;
//			var leftHeight:int = left.height;
//			var rightWidth:int = right.width;
//
//			g.clear();
//
//			g.beginBitmapFill(left);
////			LayoutManager.decCalls();
//			g.drawRect(0, 0, leftWidth, leftHeight);
//			g.endFill();
//
//			matrix = new Matrix();
//			matrix.translate(leftWidth, 0);
//
//			g.beginBitmapFill(middle, matrix);
////			LayoutManager.decCalls();
//			g.drawRect(leftWidth, 0, _width - rightWidth - leftWidth, leftHeight);
//			g.endFill();
//
//			matrix = new Matrix();
//			matrix.translate(_width - rightWidth, 0);
//
//			g.beginBitmapFill(right, matrix);
////			LayoutManager.decCalls();
//			g.drawRect(_width - rightWidth, 0, rightWidth, leftHeight);
//			g.endFill();
		}
		
		override public function drawGraphics():void {
			var g:Graphics = this.graphics;
			//var matrix:Matrix;
			
			var leftWidth:int = left.width;
			var leftHeight:int = left.height;
			var rightWidth:int = right.width;
			
			g.clear();
			
			g.beginBitmapFill(left);
//			LayoutManager.decCalls();
			g.drawRect(0, 0, leftWidth, leftHeight);
			g.endFill();
			
			//matrix = new Matrix();
			matrix.identity();
			matrix.translate(leftWidth, 0);
			
			g.beginBitmapFill(middle, matrix);
//			LayoutManager.decCalls();
			g.drawRect(leftWidth, 0, _width - rightWidth - leftWidth, leftHeight);
			g.endFill();
			
			//matrix = new Matrix();
			matrix.identity();
			matrix.translate(_width - rightWidth, 0);
			
			g.beginBitmapFill(right, matrix);
//			LayoutManager.decCalls();
			g.drawRect(_width - rightWidth, 0, rightWidth, leftHeight);
			g.endFill();
		}

	}
}