package alternativa.gui.theme.defaulttheme.controls.dropDownList {

	import alternativa.gui.theme.defaulttheme.container.list.ListObject;
	import alternativa.gui.theme.defaulttheme.controls.scrollBar.ScrollBar;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.list.ListItemContainer;
	import alternativa.gui.controls.dropDownList.DropDownItemContainer;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	public class DropDownItemContainer extends alternativa.gui.controls.dropDownList.DropDownItemContainer {
		public function DropDownItemContainer() {
			
			// RU: задаем фон
            // EN: set the background
			background = new WhiteBG();
			
			// RU: внутренний отступ
            // EN: padding
			_padding = NumericConst.basePadding;
			
			// RU: зазор между элементами
            // EN: distance between items
			_space = NumericConst.basePadding;
			
			// RU: контейнер элементов
            // EN: items container
			container = new ListItemContainer();
			
			scrollBar = new ScrollBar();
			
			// RU: класс вихуального элемента
            // EN: class of visual item
			itemRenderer = ListObject;

			super();
		}

		// RU: задаем визуальный класс элемента
        // EN: set the visual class of an item
		override public function set itemRenderer(value:Class):void {
			// RU: передаем его контейнеру элементов
            // EN: pass it to the items container
			container.itemRenderer = value;
			// RU: задаем количество пикселей для скроллирования колесом мыши
            // EN: set the pixels number for mouse scroll
			(scrollBar as ScrollBar).mouseDelta = container.mouseDelta;
			// RU: сколько пикселей в одном шаге - нажатие на кнопку вверх/вниз у scrollBar
            // EN: how many pixels in a single step - for scroll up / down
			(scrollBar as ScrollBar).stepScroll = container.stepScroll;
		}
		// RU: позиционирование и задание размеров объектов
        // EN: set position and objects sizes
		override protected function draw():void {
			super.draw();
			if (_container != null) {
				(_container as DisplayObject).x = (_container as DisplayObject).y = padding + NumericConst.borderThickness;
				(_container as DisplayObject).height = _height - _padding * 2;
				if (_scrollBar != null && _scrollBar.visible) {
					(_container as DisplayObject).width = _width - _padding * 2 - _scrollBar.width - _space;
				} else {
					(_container as DisplayObject).width = _width - _padding * 2 - NumericConst.borderThickness * 2;
				}
			}
		}
	}
}
