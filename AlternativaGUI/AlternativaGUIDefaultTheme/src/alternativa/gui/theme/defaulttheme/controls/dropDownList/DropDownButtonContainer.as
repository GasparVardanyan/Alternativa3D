package alternativa.gui.theme.defaulttheme.controls.dropDownList {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.container.list.IItemRenderer;
	import alternativa.gui.theme.defaulttheme.controls.text.LabelWithIcon;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	use namespace alternativagui;
	
	/**
	 * 
	 * RU: контейнер для кнопки DropDownList. Содержит кнопку со стрелкой, текстовую метку с иконкой.
     * EN: container for DropDownList button. Contains the button with an arrow, a text label with an icon
	 * 
	 */	
	public class DropDownButtonContainer extends ActiveObject implements IItemRenderer {
		
		// RU: фон кнопки
        // EN: button nackground
		protected var bg:WhiteBG;
		
		// RU: высота кнопки со стрелкой
        // EN: height of the button with an arrow
		protected var butHeight:int = 24;
		
		// RU: ширина кнопки со стрелкой
        // EN: width of the button with an arrow
		protected var butWidth:int = 19;
		
		// RU: флаг выделения
        // EN: flag of selection
		protected var _selected:Boolean = false;
		
		// RU: кнопка со стрелкой
        // EN: button with an arrow
		protected var button:DropDownButton;
		
		// RU: текстовая метка
        // EN: text label
		protected var label:LabelWithIcon;
		
		// RU: внутренний отступ
        // EN: padding
		protected var padding:int = NumericConst.basePadding + NumericConst.borderThickness;
		
		// RU: данные
        // EN: data
		protected var _data:Object;
		
		protected var _itemIndex:int = 0;

		public function DropDownButtonContainer() {
			super();
			
			// RU: задаем фон
            // EN: set the background
			bg = new WhiteBG();
			addChild(bg);

			// RU: задаем кнопку со стрелкой
            // EN: set the button with an arrow
			button = new DropDownButton();
			addChild(button);

			button.width = butWidth;
			button.height = butHeight;
			
			// RU: задаем текстовую метку с иконкой
            // EN: set text label with an arrouw
			label = new LabelWithIcon();
			addChild(label);
			
			// RU: задаем ширину и высоту
            // EN: set width and height
			_height = calculateHeight(_height);
			_width = calculateWidth(_width);
		}

		public function get itemIndex():int {
			return _itemIndex;
		}

		public function set itemIndex(value:int):void {
			_itemIndex = value;
		}

		public function set selected(value:Boolean):void {
			_selected = value;
			if (_selected) {
				button.pressed = true;
			} else {
				button.pressed = false;
			}
		}

		public function get selected():Boolean {
			return _selected;
		}

		public function get data():Object {
			return _data;
		}
		
		// RU: отдаем данные кнопке
        // EN: set the data to the button
		public function set data(value:Object):void {
			if (value != null) {
				_data = value;
				// RU: текст
                // EN: text
				label.text = _data.label;
				// RU: иконка
                // EN: icon
				if (_data.icon != null) {
					label.icon = new Bitmap((_data.icon as Bitmap).bitmapData.clone());
				}
				draw();
			}
		}

		public function getHeight():int {
			return _height;
		}

		public function getWidth():int {
			return _width;
		}

		public function set text(value:String):void {
			label.text = value;
			draw();
		}

		public function set icon(value:DisplayObject):void {
			label.icon = value;
			draw();
		}
	
		// RU: позиционирование и задание размеров текстовой метки с иконкой, фона, кнопки со стрелкой. Заливаем все прозрачным фоном, чтобы реагировала мышь
        // EN: set position, sizes of text label, background and button. Fill all transparent background in order to mouse respond to events.
		override protected function draw():void {
			super.draw();
			bg.resize(_width, _height);
			label.x = padding;
			label.y = (_height - label.height) >> 1;
			label.height = 1;
			label.width = _width - button.width - padding * 2;
			if (label.width > (_width - button.width - padding * 2)) {
				label.scrollRect = new Rectangle(0,0, (_width - button.width - padding * 2), _height);
			} else {
				label.scrollRect = null;
			}
			button.width = butWidth;
			button.x = _width - button.width;
			
		}
		
		override public function drawGraphics():void {
			this.graphics.clear();
			this.graphics.beginFill(0,0);
			this.graphics.drawRect(0, 0, _width, _height);
		}
		
		// RU: высота фиксированная
        // EN: fixed height
		override protected function calculateHeight(value:int):int {
			return butHeight;
		}
		
		// RU: смотрим значение ширины , если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
//			var w:int = label.width + button.width + padding;
			if (value < NumericConst.listMinWidth) {
				return NumericConst.listMinWidth;
			} else {
				return value;
			}
		}
		
		// RU: при наведении, у кнопки со стрелочкой тоже вызываем over
        // EN: call over from button with arrow on mouseon
		override public function set over(value:Boolean):void {
			super.over = value;
			if (_over) {
				button.over = true;
			} else {
				button.over = false;
			}
		}

		override public function set locked(value:Boolean):void {
			super.locked = value;
			button.locked = value;
		}

	}
}
