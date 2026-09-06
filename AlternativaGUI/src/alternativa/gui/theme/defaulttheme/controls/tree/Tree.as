package alternativa.gui.theme.defaulttheme.controls.tree {

	import alternativa.gui.theme.defaulttheme.controls.scrollBar.ScrollBar;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.tree.TreeItemContainer;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	public class Tree extends alternativa.gui.controls.tree.Tree {
		public function Tree() {
			// RU: задаем фон
            // EN: set a background
			background = new WhiteBG();
			// RU: внутренний отступ
            // EN: padding
			_padding = NumericConst.basePadding;
			// RU: зазор между элементами
            // EN: distance between the components
			_space = NumericConst.basePadding;
			// RU: контейнер элементов
            // EN: items container
			container = new TreeItemContainer();
			scrollBar = new ScrollBar();
			// RU: визуальный класс элемента
            // EN: visual class of the item
			itemRenderer = TreeObject;
			super();
		}

		// RU: задаем визуальный класс элемента
        // EN: set the visual class of the item
		override public function set itemRenderer(value:Class):void {
			// RU: передаем его контейнеру элементов
            // EN: pass it to items container
			container.itemRenderer = value;
			// RU: задаем количество пикселей для скроллирования колесом мыши
            // EN: set the number of pixels for the mouse wheel scroll
			(scrollBar as ScrollBar).mouseDelta = container.mouseDelta;
			// RU: сколько пикселей в одном шаге - нажатие на кнопку вверх/вниз у scrollBar
            // EN: Number of pixels in one step when you press the up/down scrollBar button
			(scrollBar as ScrollBar).stepScroll = container.stepScroll;
		}

		// RU: переписываем метод отрисовки. Позиционируем контейнер элементов и scrollBar
        // EN: override the draw method. Set position to items container and to scrollBar
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

		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (value < NumericConst.listMinWidth)
				value = NumericConst.listMinWidth;
			return value;
		}
	}
}
