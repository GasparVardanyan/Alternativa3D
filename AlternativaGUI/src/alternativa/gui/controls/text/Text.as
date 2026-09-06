package alternativa.gui.controls.text {
	import alternativa.gui.alternativagui;
	
	import flash.text.TextFieldAutoSize;
	use namespace alternativagui;
	
	/**
	 * Текстовое поле без фона с возможностью установки ширины и высоты и выравнивания по горизонтали.
	 * 
	 */	
	public class Text extends LabelTF {
		
		protected var _indent:int=0;
		
		/**
		 * 
		 * @param selectable Если true - можно выделять текст.
		 * 
		 */		
		public function Text(selectable:Boolean) {
			super(false, selectable);
			tf.autoSize = TextFieldAutoSize.NONE;
			multiline = true;
		}
		
		/**
		 * Ширина.
		 * <p>Задается ширина текстовому полю, потом происходит отрисовка</p>
		 * 
		 */		
		override public function set width(value:Number):void {
			_width = value;
			tf.width = _width;
			draw();
		}
		
		/**
		 * Высота.
		 * <p>Задается высота текстовому полю, потом происходит отрисовка</p>
		 * 
		 */		
		override public function set height(value:Number):void {
			_height = value;
			tf.height = _height;
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override protected function correctSize():void {
			tf.width = _width + Math.round(correctConstX + correctX*correctRatio)*2;
		 	tf.height = _height + Math.round(correctConstY + correctY*correctRatio)*2;
		}

        public function set indent(value:int):void {
            _indent = value;
            format.tabStops = [_indent];
            updateformat();
        }

        public function get indent():int {
            return _indent;
        }
    }
}