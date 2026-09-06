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
	 * Резиновая растровая плашка с фиксированной шириной. 
	 * Состоит из трех частей: top, middle, bottom.
	 *
	 */
	public class VerticalSlicedBar extends GUIobject {

		protected var top:BitmapData;
		protected var middle:BitmapData;
		protected var bottom:BitmapData;
		
		protected var matrix:Matrix = new Matrix();

		public function VerticalSlicedBar() {
			super();
		}
		
		override public function set width(value:Number):void {}
		
		override protected function draw():void {
//			var g:Graphics = this.graphics;
//			var matrix:Matrix;
//
//			var topWidth:int = top.width;
//			var topHeight:int = top.height;
//			var bottomHeight:int = bottom.height;
//
//			g.clear();
//
//			g.beginBitmapFill(top);
////			LayoutManager.decCalls();
//			g.drawRect(0, 0, topWidth, topHeight);
//			g.endFill();
//
//			matrix = new Matrix();
//			matrix.translate(0, topHeight);
//
//			g.beginBitmapFill(middle, matrix);
////			LayoutManager.decCalls();
//			g.drawRect(0, topHeight, topWidth, _height - topHeight -bottomHeight);
//			g.endFill();
//
//			matrix = new Matrix();
//			matrix.translate(0, _height - bottomHeight);
//
//			g.beginBitmapFill(bottom, matrix);
////			LayoutManager.decCalls();
//			g.drawRect(0, _height - bottomHeight, topWidth, bottomHeight);
//			g.endFill();
		}
		
		override public function drawGraphics():void {
			var g:Graphics = this.graphics;
			//var matrix:Matrix;
			
			var topWidth:int = top.width;
			var topHeight:int = top.height;
			var bottomHeight:int = bottom.height;
			
			g.clear();
			
			g.beginBitmapFill(top);
//			LayoutManager.decCalls();
			g.drawRect(0, 0, topWidth, topHeight);
			g.endFill();
			
			//matrix = new Matrix();
			matrix.identity();
			matrix.translate(0, topHeight);
			
			g.beginBitmapFill(middle, matrix);
//			LayoutManager.decCalls();
			g.drawRect(0, topHeight, topWidth, _height - topHeight -bottomHeight);
			g.endFill();
			
			//matrix = new Matrix();
			matrix.identity();
			matrix.translate(0, _height - bottomHeight);
			
			g.beginBitmapFill(bottom, matrix);
//			LayoutManager.decCalls();
			g.drawRect(0, _height - bottomHeight, topWidth, bottomHeight);
			g.endFill();
		}

	}
}