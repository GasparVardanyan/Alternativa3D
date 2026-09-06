package alternativa.gui.controls.text {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	use namespace alternativagui;
	
	/**
	 * Текстовая метка с двумя режимами, переключаемыми флагом setDimensionByText.
	 * При установленном флаге размер метки зависит только от заданного текста.
	 * В обратной ситуации метке можно задать ширину и выравнивание в заданной области.
	 * 
	 * @see Label
	 * @see TextArea
	 * @see TextInput
	 * 
	 */	
	public class LabelTF extends GUIobject {
		
		protected static var gformat:TextFormat = new TextFormat();
		protected static var _embedFonts:Boolean = true;
		protected var format:TextFormat = new TextFormat();
		
		/**
		 * Ссылка на TextField. 
		 */		
		public var tf:TextFieldUtf8;
		
		protected var setDimensionByText:Boolean;
		protected var correctRatio:Number;
		
		protected var defaultSize:Number = 18;
		
		//--- Коррекция для выравнивания по левому краю
		// Постоянная коррекция
		protected var correctConstX:Number = 1.0;
		protected var correctConstY:Number = 2.8;
		protected var correctConstW:Number = 0.0;
		protected var correctConstH:Number = 3.0;
		// Коррекция, зависящая от размера (при увеличении размера)
		protected var correctUpX:Number = 0.5;
		protected var correctUpY:Number = 2.4;
		protected var correctUpW:Number = 0.0;
		protected var correctUpH:Number = 4.0;
		// Коррекция, зависящая от размера (при увеличении размера)
		protected var correctDownX:Number = 1.0;
		protected var correctDownY:Number = 2.0;
		protected var correctDownW:Number = 0.5;
		protected var correctDownH:Number = 2.0;
		// Коррекция, зависящая от размера
		protected var correctX:Number;
		protected var correctY:Number;
		protected var correctW:Number;
		protected var correctH:Number;
		
		protected var correctColor:uint = 0x0000ff;
		
		/**
		 * 
		 * @param setDimensionByText Если true - размеры текстового поля расчитываются по текстовому контенту
		 * @param selectable Если true - можно выделять текст
		 * 
		 */		
		public function LabelTF(setDimensionByText:Boolean = true, selectable:Boolean = false) {
			super();
			this.setDimensionByText = setDimensionByText;
			
			tf = new TextFieldUtf8();
			addChild(tf);
			tf.height = 0;
			
			copyFormat();
			updateformat();
			
			tf.selectable = selectable;
			
			tf.mouseEnabled = selectable;
			tf.tabEnabled = selectable;
			
			tf.embedFonts = _embedFonts;
			
			tf.antiAliasType = AntiAliasType.ADVANCED;
			tf.gridFitType = GridFitType.SUBPIXEL;
			
			tf.autoSize = TextFieldAutoSize.LEFT;
			/*if (!setDimensionByText) {
				tf.autoSize = TextFieldAutoSize.NONE;
			} else {
				tf.autoSize = TextFieldAutoSize.LEFT;
			}*/
			
			size = format.size as Number;
		}
		
		/*public function set type(value:String):void {
			tf.type = value;
		}*/
		
		/**
		 * Многострочное поле. 
		 * 
		 */		
		public function set multiline(value:Boolean):void {
			if (!setDimensionByText) {
				tf.multiline = value;
				tf.wordWrap = value;
			}
		}
		
		/**
		 * Возможность выделения текста. 
		 * 
		 */		
		public function set selectable(value:Boolean):void {
			tf.selectable = value;
		}
		
		/**
		 * Текстовое поле является полем пароля. 
		 * @param value
		 * 
		 */		
		public function set displayAsPassword(value:Boolean):void {
			tf.displayAsPassword = value;
		}
		
		/**
		 * Содержимое текстового поля.
		 * 
		 */		
		public function get text():String {
			return tf.text;
		}
		public function set text(value : String) : void {
			tf.text = value;
			
			if (setDimensionByText) {
				updateSize();
			} else {
				width = _width;
			}
		}
		
		/**
		 * HTML-представление содержимого текстового поля. 
		 * 
		 */		
		public function set htmlText(value : String) : void {
			tf.htmlText = value;
			
			if (setDimensionByText) {
				updateSize();
			} else {
				width = _width;
			}
			tf.mouseEnabled = true;
			mouseEnabled = true;
			mouseChildren = true;
		}
		
		/*public function set autoSize(value : String) : void {
			tf.autoSize = value;
		}*/
		
		/**
		 * Определяет формат текста. 
		 * 
		 */		
		public static function get defaultFormat():TextFormat {
			return gformat;
		}
		public static function set defaultFormat(value:TextFormat):void {
			gformat = value;
		}
		
		/**
		 * 
		 * Использование встроенных шрифтов или системных. 
		 * 
		 */
		public static function get embedFonts():Boolean {
			return _embedFonts;
		}
		public static function set embedFonts(value:Boolean):void {
			_embedFonts = value;
		}
		
		
		
		/**
		 * Размер текста. 
		 * 
		 */		
		public function get size():Number {
			return format.size as Number;
		}
		public function set size(value:Number) : void {
			format.size = value;
			
			correctRatio = value/defaultSize;
			if (value >= defaultSize) {
				correctX = correctUpX;
				correctY = correctUpY;
				correctW = correctUpW;
				correctH = correctUpH;
				
				//correctColor = 0xff0000;
			} else {
				correctX = correctDownX;
				correctY = correctDownY;
				correctW = correctDownW;
				correctH = correctDownH;
				
				//correctColor = 0x0000ff;
			}
			updateformat();
		}
		
		/**
		 * Жирный текст. 
		 * 
		 */		
		public function set bold(value : Boolean) : void {
			format.bold = value;
			updateformat();
		}
		
		/**
		 * Цвет текста.
		 * 
		 */		
		public function set color(color : uint):void {
			format.color = color;
			updateformat();
		}
		
		/**
		 * Выравнивание текста в текстовом поле.
		 * 
		 */		
		public function set align(value:String):void{
			//multiline = true;// - временный костыль
			
			format.align = value;
			updateformat();
		}
		
		override public function set width(value:Number):void {
			/*if (!setDimensionByText) {
				_width = value;
				tf.width = value;
				_height = tf.textHeight - Math.round(correctConstH + correctH*correctRatio);
				
				draw();
			}*/
			if (!setDimensionByText) {
				_width = value;
				tf.width = value;
				
				/*trace(" ");
				trace("set width");
				trace("   tf.textHeight: " + tf.textHeight);
				trace("   tf.height: " + tf.height);
				*/
				_height = tf.textHeight - Math.round(correctConstH + correctH*correctRatio);
				
				draw();
			}
		}
		
		override public function set height(value:Number):void {}
		
		private function copyFormat():void {
			format.font = gformat.font;
			format.size = gformat.size;
			format.align = gformat.align;
			format.color = gformat.color;
			format.bold = gformat.bold;
		}
		
				
		protected function updateformat():void {
			tf.defaultTextFormat = format;
			tf.setTextFormat(format);
			
			if (setDimensionByText) {
				updateSize();
			}
		}
		
		protected function updateSize():void {
			_width = tf.textWidth - Math.round(correctConstW + correctW*correctRatio);
			_height = tf.textHeight - Math.round(correctConstH + correctH*correctRatio);
			
			draw();
		}
		
		protected function correctPos():void {
			tf.x -= Math.round(correctConstX + correctX*correctRatio);
			tf.y -= Math.round(correctConstY + correctY*correctRatio);
		}
		
		protected function correctSize():void {
		 	//tf.width = _width + Math.round(correctConstX + correctX*correctRatio)*2;
		 	//tf.height = _height + Math.round(correctConstY + correctY*correctRatio)*2;
		 	
		 	tf.width = _width + Math.round(correctConstX + correctX*correctRatio)*2;
			_height = tf.textHeight - Math.round(correctConstH + correctH*correctRatio);
		}
		
		override protected function draw():void {
			/*if (!setDimensionByText) {
				correctSize();
			}
			
			tf.x = 0;
			tf.y = 0;
			correctPos();
			*/
			
			tf.x = 0;
			tf.y = 0;
			
			correctPos();
			
			if (!setDimensionByText) {
				correctSize();
			}
			
			/*if (!(this is TextInput)) {
				this.graphics.clear();
				this.graphics.lineStyle(2, correctColor, 1);
				this.graphics.drawRect(0, 0, _width, _height);
			}*/
		}

	}
}
