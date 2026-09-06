package alternativa.gui.controls.text {
	import alternativa.gui.alternativagui;
	import alternativa.gui.enum.Align;
	
	import flash.display.DisplayObject;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFieldType;
	use namespace alternativagui;
	
	/**
	 * Поле ввода с возможностью задать фон и текстовую метку. 
	 * Для заголовка задается пространство labelWidth, в котором он выравнивается по правому краю на расстоянии labelMargin от самого поля ввода.
	 *  
	 */	
	public class TextInput extends LabelTF {
		
		protected var label:Label;
		protected var _labelWidth:int;
		protected var _labelMargin:int;
		protected var _labelAlign:Align;
		
		protected var _background:DisplayObject;
		
		protected var _paddingH:int;
		protected var _paddingV:int;
		
        protected var _maxChars:int;

		
		public function TextInput() {
			super(false, true);
			
			_labelAlign = Align.RIGHT;
			
			_height = 50;
			
			tf.type = TextFieldType.INPUT;
            tf.autoSize = TextFieldAutoSize.NONE;
		}
		
		/**
		 * Внутренний отступ по горизонтали 
		 * 
		 */		
		public function get paddingH():int {
            return _paddingH;
        }
		public function set paddingH(value:int):void {
			_paddingH = value;
		}
		
		/**
		 * Внутренний отступ по вертикали 
		 * 
		 */		
		public function get paddingV():int {
            return _paddingV;
        }
		public function set paddingV(value:int):void {
			_paddingV = value;
		}
		
		/**
		 * Фон 
		 * 
		 */		
		public function get background():DisplayObject {
            return _background;
        }
		public function set background(value:DisplayObject):void {
			_background = value;
			addChildAt(_background,0);
			
			draw();
		}
		
		/**
		 * Максимальное количество символов 
		 * 
		 */		
		public function get maxChars():int {
            return _maxChars;
        }
        public function set maxChars(value:int):void {
            _maxChars = value;
            tf.maxChars = _maxChars;
        }
		
		/**
		 * Содержимое текстовой метки
		 * 
		 */		
		public function get labelText():String {
            return (label != null) ? label.text : "";
        }
		public function set labelText(value:String):void {
			if (label == null) {
				label = new Label();
				label.size = this.size;
				label.align = _labelAlign;
				addChildAt(label, 0);
			}
			label.text = value;
		}
		
		/**
		 * Ширина текстовой метки 
		 * 
		 */		
		public function get labelWidth():int {
            return _labelWidth;
        }
		public function set labelWidth(value:int):void {
			_labelWidth = value;
			
			width = _width;
		}
		
		/**
		 * Отступ от текстовой метки 
		 * 
		 */		
		public function get labelMargin():int {
            return _labelMargin;
        }
		public function set labelMargin(value:int):void {
			_labelMargin = value;
			
			width = _width;
		}
		
		/**
		 * Размер шрифта текстовой метки 
		 * 
		 */		
		public function get labelSize():int {
            return label.size;
        }
		public function set labelSize(value:int):void {
			label.size = value;
			
			width = _width;
		}
		
		/**
		 * Выравнивание текста в текстовой метке
		 * 
		 */		
		public function set labelAlign(value:Align):void {
			_labelAlign = value;
			
			if (label != null) {
				label.align = value;
				width = _width;
			}
		}
		
		override public function set width(value:Number):void {
			_width = value;
			
			tf.width = _width - _paddingH*2 - ((label != null) ? (_labelWidth + _labelMargin) : 0);
			_height = tf.textHeight - Math.round(correctConstH + correctH*correctRatio) + _paddingV*2;
			
			draw();
		}
		
		override protected function correctPos():void {
			tf.x -= Math.round(correctConstX + correctX*correctRatio) - _paddingH - ((label != null) ? (_labelWidth + _labelMargin) : 0);
			tf.y -= Math.round(correctConstY + correctY*correctRatio) - _paddingV;
		}
		
		override protected function correctSize():void {
		 	tf.width = _width + Math.round(correctConstX + correctX*correctRatio)*2 - _paddingH*2 - ((label != null) ? (_labelWidth + _labelMargin) : 0);
		 	tf.height = _height + Math.round(correctConstY + correctY*correctRatio)*2 - _paddingV*2;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
			
			if (label != null) {
				label.y = paddingV;
				label.width = labelWidth;
			}
			
			if (_background != null) {
				_background.x = (label != null) ? (_labelWidth + _labelMargin) : 0;
				_background.width = _width - ((label != null) ? (_labelWidth + _labelMargin) : 0);
				_background.height = _height;
			}
		}
        
    }
}