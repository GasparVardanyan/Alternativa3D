package alternativa.gui.primitives {
	import alternativa.gui.base.GUIobject;
	
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	
	import alternativa.gui.alternativagui;
	use namespace alternativagui;
	
	/**
	 * Рисует прямоугольник с округленными краями. 
	 * 
	 */	
	public class RoundRect extends GUIobject {
		
		protected var _color:uint = 0;
		public var outlineColor:uint = 0;
		public var roundR:Number = 5;
		public var outlineEnabled:Boolean = false;
		public var _alpha:Number = 1;
		public var outlineAlpha:Number = 1;
		public var outlineThickness:int;
		
		/**
		 * 
		 * @param roundR Радуис скругления. 
		 * @param color Цвет заливки прямоугольника.
		 * @param alpha Прозрачность.
		 * @param outlineEnabled Флаг отображения обводки.
		 * @param outlineColor Цвет обводки.
		 * @param outlineAlpha Цвет прозрачности.
		 * @param outlineThickness Толщина обводки.
		 * 
		 */		
		public function RoundRect(roundR:Number, color:uint, alpha:Number, outlineEnabled:Boolean = false, outlineColor:uint = 0, outlineAlpha:Number = 1, outlineThickness:int = 1) {
			super();
			this.roundR = roundR;
			this._color = color;
			this.outlineEnabled = outlineEnabled;
			this.outlineColor = outlineColor;
			this._alpha = alpha;
			this.outlineAlpha = outlineAlpha;
			this.outlineThickness = outlineThickness;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw() : void {
			graphics.clear();
			graphics.beginFill(_color, _alpha);
			if (outlineEnabled) {
				graphics.lineStyle(outlineThickness, outlineColor, outlineAlpha, true, LineScaleMode.NONE, CapsStyle.NONE, JointStyle.ROUND);
			}
			graphics.drawRoundRect(outlineThickness*0.5, outlineThickness*0.5, _width - outlineThickness, _height - outlineThickness, roundR*2, roundR*2);
		}
		
		/**
		 * Прозрачность. 
		 * 
		 */		
		override public function set alpha(value:Number):void {
			_alpha = value;
			
			draw();
		}
		
		/**
		 * Цвет заливки прямоугольника. 
		 * 
		 */		
        public function get color():uint {
            return _color;
        }
        public function set color(value:uint):void {
            _color = value;
            draw();
        }
    }
}