package alternativa.gui.theme.defaulttheme.controls.text {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;

	import flash.display.DisplayObject;
	use namespace alternativagui;

	/**
	 *
	 * RU: компонента с текстовой меткой и иконкой. Выводим наружу основные методы текстовой метки: цвет, размер, жирное начертание
     * EN: component with a label and an icon. Derive the basic methods of text label outside: color, size, bold typing
	 *
	 */
	public class LabelWithIcon extends GUIobject {

		// RU: текстовая метка
        // EN: text label
		protected var _label:Label;

		// RU: иконка
        // EN: icon
		protected var _icon:DisplayObject;

		// RU: зазор между иконкой и текстовой меткой
        // EN: distance between an icon and a text label
		protected var _space:int = NumericConst.baseIconPadding;

		public function LabelWithIcon() {
			super();
			_label = new Label();
			addChild(_label);
		}

		public function get space():int {
			return _space;
		}

		public function set space(value:int):void {
			_space = value;
			draw();
		}

		public function get icon():DisplayObject {
			return _icon;
		}

		public function set icon(value:DisplayObject):void {
			if (_icon != null) {
				if (contains(_icon)) {
					removeChild(_icon);
				}
				_icon = null;
			}
			if (value != null) {
				_icon = value;
				addChild(_icon);
			}
			_height = calculateHeight(_height);
			draw();
		}

		public function get text():String {
			return _label.text;
		}

		public function set text(value:String):void {
			_label.text = value;
			draw();
		}

		public function get size():Number {
			return _label.size;
		}

		public function set size(value:Number):void {
			_label.size = value;
			draw();
		}

		public function get color():Number {
			return _label.color;
		}

		public function set color(value:Number):void {
			_label.color = value;
			draw();
		}

		public function get bold():Boolean {
			return _label.bold;
		}

		public function set bold(value:Boolean):void {
			_label.bold = value;
			draw();
		}

		override protected function draw():void {
			super.draw();
			_label.x = 0;
			_label.y = 0;
			if (_icon != null) {
				_label.x = _icon.x + _space + _icon.width;
				_label.y = (_height - int(_label.height)) >> 1;
				_icon.y = (_height - _icon.height) >> 1;
			}
		}

		// RU: смотрим значение высоты, если меньше заданного, отдаем минимальную высоту
        // EN: if height value is less than the specified value, then return minimal height value
		override protected function calculateHeight(value:int):int {
			return Math.max((_icon != null ? _icon.height : 0), int(_label.height));
		}

		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			return ((_icon != null ? (_icon.width + _space) : 0) + int(_label.width));
		}

	}
}
