package alternativa.gui.theme.defaulttheme.container.list {

	import alternativa.gui.theme.defaulttheme.controls.scrollBar.ScrollBar;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.container.list.List;
	import alternativa.gui.container.list.ListItemContainer;

	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;

	use namespace alternativagui;
	
	public class List extends alternativa.gui.container.list.List {

		public function List() {
			super();
			// RU: задаем фон листа
			// EN: set the list background
			background = new WhiteBG();
			// RU: внутренний отступ
            // EN: padding
			_padding = NumericConst.basePadding;
			// RU: зазор между элементами
            // EN: distance between the elements
			_space = NumericConst.basePadding;
			
			// RU: зазор между контентом и скроллбар.
			// EN: distance between content and scrollbar
			_scrollBarSpace = NumericConst.basePadding;
			
			// RU: задаем контейнер элементов для List
            // EN: List items container
			container = new ListItemContainer();
			// RU: задаем scrollBar
            // EN: set the Scrollbar
			scrollBar = new ScrollBar();
		}
		// RU: задаем визуальный класс элемента
        // EN: visual class of the item
		override public function set itemRenderer(value:Class):void {
			// RU: передаем его контейнеру элементов
            // EN: send it to items container
			container.itemRenderer = value;
			// RU: задаем количество пикселей для скроллирования колесом мыши
            // EN: number of pixels for scrolling the mouse wheel
			(scrollBar as ScrollBar).mouseDelta = container.mouseDelta;
			// RU: сколько пикселей в одном шаге - нажатие на кнопку вверх/вниз у scrollBar
            // EN: how many pixels in a single step - click on scroll up / down button
			(scrollBar as ScrollBar).stepScroll = container.stepScroll;
		}
		
		
		// RU: переписываем метод отрисовки. Позиционируем контейнер элементов и scrollBar
        // EN: override the draw method. Position the items container and the scrollBar
		override protected function draw():void {
			super.draw();
			if (_container != null) {
				(_container as DisplayObject).x = (_container as DisplayObject).y = padding + NumericConst.borderThickness;
				(_container as DisplayObject).height = _height - _padding * 2 - NumericConst.borderThickness * 2;
				if (_scrollBar != null && _scrollBar.visible) {
					(_container as DisplayObject).width = _width - _padding - _scrollBar.width - _scrollBarSpace - NumericConst.borderThickness;
				} else {
					(_container as DisplayObject).width = _width - _padding * 2 - NumericConst.borderThickness * 2;
				}
			}
		}
		
		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (value < NumericConst.listMinWidth)
				value = NumericConst.listMinWidth;
			return value;
		}
	}
}
