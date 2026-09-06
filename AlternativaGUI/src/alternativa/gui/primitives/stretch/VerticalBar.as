package alternativa.gui.primitives.stretch {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.layout.LayoutManager;
	
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	use namespace alternativagui;
	
	
	/**
	 * Тянущаяся по горизонтали резиновая растровая плашка. 
	 * <p>Верхняя и нижняя сторона отрисовывается в натуральную величину, середина растягивается.</p>  
	 * 
	 */		
	public class VerticalBar extends GUIobject {
		
		protected var texture:BitmapData;
		protected var _edge:int;
		
		protected var matrix:Matrix = new Matrix();
		
		/**
		 * 
		 * @param texture Растровый объект.
		 * @param edge Ширина краев, которые не будут изменяться.
		 * 
		 */		
		public function VerticalBar(texture:BitmapData, edge:int) {
			this.texture = texture;
			this._edge = edge;
			
			_width = texture.width;
		}
		
		override public function set width(value:Number):void {}
		
		/**
		 * Отрисовка
		 */		
		override protected function draw():void {
//			super.draw();
//			
//			
//			
//			this.graphics.clear();
//			
//			// TOP
//			this.graphics.beginBitmapFill(texture, null, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, 0, texture.width, _edge);
//			
//			// BOTTOM
//			var m:Matrix = new Matrix();
//			m.ty = +(_height - _edge) - (texture.height - _edge); 
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, _height - _edge, texture.width, _edge);
//			
//			// MIDDLE
//			m = new Matrix();
//			var sy:Number = (_height - 2*_edge)/(texture.height - 2*_edge);
//			m.createBox(1, sy, 0, 0, -_edge*sy + _edge);// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
//			this.graphics.beginBitmapFill(texture, m, false, false);
////			LayoutManager.decCalls();
//			this.graphics.drawRect(0, _edge, texture.width, _height - 2*_edge);
		}
		
		override public function drawGraphics():void {
//			super.draw();
			
			
			
			this.graphics.clear();
			
			// TOP
			this.graphics.beginBitmapFill(texture, null, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, 0, texture.width, _edge);
			
			// BOTTOM
			//var m:Matrix = new Matrix();
			matrix.identity();
			matrix.ty = +(_height - _edge) - (texture.height - _edge); 
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, _height - _edge, texture.width, _edge);
			
			// MIDDLE
			//m = new Matrix();
			matrix.identity();
			var sy:Number = (_height - 2*_edge)/(texture.height - 2*_edge);
			matrix.createBox(1, sy, 0, 0, -_edge*sy + _edge);// сначала применяется ресайз, а потом сдвиг (поэтому при сдвиге нужно учитывать ресайз)
			this.graphics.beginBitmapFill(texture, matrix, false, false);
//			LayoutManager.decCalls();
			this.graphics.drawRect(0, _edge, texture.width, _height - 2*_edge);
		}
		
		/**
		 * Ширина краев, которые не будут изменяться.
		 * 
		 */		
		public function set edge(value:int):void {
			_edge = value;
			draw();
		}
		
		/**
		 * Растровый объект. 
		 * 
		 */		
		public function set bitmapData(value:BitmapData):void {
			texture = value;
			draw();
		}
		
	}
}