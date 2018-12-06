package alternativa.gui.theme.defaulttheme.container.panel {

	import alternativa.gui.theme.defaulttheme.primitives.panel.BackgroundPanel;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;

	import flash.display.DisplayObject;
	use namespace alternativagui;

	/**
	 *  
	 * RU: примитивная панель содержащая в себе внутренний отступ, фон и контент
     * EN: simple panel, which contains padding, background and content
	 * 
	 */	
	public class SimplePanel extends GUIobject {
		protected var bg:DisplayObject;

		protected var _padding:int = NumericConst.panelPadding;

		protected var _content:DisplayObject;

		public function SimplePanel() {
			bg = new BackgroundPanel();
			addChild(bg);
		}

		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
			draw();
		}

		public function get content():DisplayObject {
			return _content;
		}

		public function set content(value:DisplayObject):void {
			// RU: делаем проверку. Если есть контент - удаляем его
            // EN: if content is not empty then clear it
			if (_content != null) {
				if (contains(_content)) {
					removeChild(_content);
				}
				_content = null;
			}
			// RU: добавляем новый контент
            // EN: add a new content
			if (value != null) {
				_content = value;
				addChild(_content);
			}
			draw();
		}
		
		// RU: позиционирование и задание размеров контенту
        // EN: set position and sizes
		override protected function draw():void {
			super.draw();
			if (_content != null) {
				_content.x = _padding;
				_content.y = _padding;
				_content.width = _width - _padding * 2;
				_content.height = _height - _padding * 2;
				if (_width < (_content.width + _padding * 2)) {
					_width = (_content.width + _padding * 2);
				}
				if (_height < (_content.height + _padding * 2)) {
					_height = (_content.height + _padding * 2);
				}
			}
			// RU: Если фон является GUIobject вызываем метод resize, если нет - изменяем поочередно ширину и высоту
            // EN: If background is GUIobject, then call resize method, else change width and height
			if (bg is GUIobject) {
				GUIobject(bg).resize(_width, _height);
			} else {
				bg.width = _width;
				bg.height = _height;
			}
		}

	}

}
