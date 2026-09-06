package alternativa.gui.controls {
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 * Примитивный объект с фиксированной шириной и высотой.
	 * 
	 */	
	public class Dummy extends GUIobject {
		
		/**
		 * 
		 * @param w Ширина.
		 * @param h Высота.
		 * 
		 */		
		public function Dummy(w:int, h:int) {
			super();
			
			_width = w;
			_height = h;
		}
		
		/**
		 * Изменение ширины.
		 * @param value Ширина.
		 * 
		 */		
		public function setConstWidth(value:int):void {
			_width = value;
		}
		
		/**
		 * Изменение высоты.
		 * @param value Высота.
		 * 
		 */		
		public function setConstHeight(value:int):void {
			_height = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override protected function draw():void {
	    	super.draw();
	    	
	    	this.graphics.clear();
	    	this.graphics.beginFill(0xff0000, 0.25);
	    	this.graphics.drawRect(0, 0, width, height);
	 	}

		override protected function calculateWidth(value:int):int {
			return _width;
		}

		override protected function calculateHeight(value:int):int {
			return _height;
		}
		
		override public function get width():Number {
			return _width;
		}
		override public function set width(value:Number):void {}
		
		override public function get height():Number {
			return _height;
		}
		override public function set height(value:Number):void {}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function resize(width:int, height:int):void {}

	}
}