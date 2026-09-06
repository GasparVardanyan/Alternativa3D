package alternativa.gui.controls.text {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;
	use namespace alternativagui;
	
	/**
	 * Кнопка: текстовая метка с иконкой
	 * 
	 */	
	public class LabelButton extends BaseButton {
		
		protected var _label:Label;
		protected var _icon:DisplayObject; 
		protected var _iconMargin:int = 4;
		
		protected var iconCorrect:int;

		/**
		 * 
		 * @param labelText Текст.
		 * 
		 */		
		public function LabelButton(labelText:String = "") {
			super();
			
			_label = new Label();
			_label.mouseEnabled = false;
			_label.tabEnabled = false;
			//_label.tf.multiline = true;
			addChild(_label);
			
		//	_label.align = TextAlign.CENTER;
			_label.text = labelText;
			
	        mouseChildren = false;
	        tabChildren = false;
		}
		
		/**
		 * Текстовый контент. 
		 * 
		 */		
		public function get label():String {
			return _label.text;
		}
		public function set label(value:String):void {
			_label.text = value;
			draw();
		}
		
		/**
		 * Цвет текста. 
		 * 
		 */		
		public function set labelColor(value:uint):void {
			_label.color = value;
		}
		
		
		/**
		 * Иконка. 
		 * 
		 */		
		public function get icon():BitmapData {
			return (_icon is Bitmap) ? (_icon as Bitmap).bitmapData : null;
		}
		public function set icon(icoBMP:BitmapData):void {
			_icon = new Bitmap();
			addChild(_icon);
			
			if (icoBMP != null) {
				_icon.visible = true;
			} else {
				_icon.visible = false;
			}
			(_icon as Bitmap).bitmapData = icoBMP;
			draw();
		}
		
		/**
		 *  Смещение иконки по оси Y.
		 * 
		 */		
		public function set iconYcorrect(value:int):void {
			iconCorrect = value;
			draw();
		}
		
		/**
		 * Зазор между иконкой и текстовым контентом. 
		 * @param value Зазор.
		 * 
		 */		
		public function set iconMargin(value:int):void {
			_iconMargin = value;
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			super.draw();
			
			_label.y = (_height - _label.height) >> 1;
			
			if (_icon == null) {
				_label.x = (_width - _label.width) >> 1;
			} else {
				var w:int = _icon.width + _iconMargin + _label.width;
				
				_icon.x = (_width - w) >> 1;
				_icon.y = ((_height - _icon.height) >> 1) + iconCorrect;
				
				_label.x = _icon.x + _icon.width + _iconMargin;
			}
//			this.graphics.clear();
//			this.graphics.lineStyle(1, 0x0000ff, 1);
//			this.graphics.drawRect(0, 0, _width, _height);
		}
		
		/**
		 * Размер текст. 
		 * 
		 */		
		public function set labelFontSize(value:Number):void {
			_label.size = value;
			draw();
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function calculateHeight(value:int):int {
			var contentHeight:int = Math.max((_icon!=null ? _icon.height : 0), (_label!=null ? int(_label.height) : 0));
			
			return contentHeight;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function calculateWidth(value:int):int {
			var contentWidth:int = (_icon!=null ? (_icon.width + _iconMargin) : 0) + (_label!=null ? int(_label.width) : 0);
			if (value < contentWidth) {
				value = contentWidth;
			}
			return value;
		}
	}
}