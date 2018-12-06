package alternativa.gui.theme.defaulttheme.container.rollout {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.scrollPane.ScrollPane;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.theme.defaulttheme.container.scrollPane.ScrollPaneWithScrollBar;
	import alternativa.gui.theme.defaulttheme.skin.RolloutSkin;

	import flash.display.DisplayObject;
	import flash.geom.Rectangle;

	use namespace alternativagui;

	/**
	 *
	 * RU: ScrollPane c рамкой в качестве фона
	 * EN: ScrollPane with frame as background
	 *
	 */
	public class RolloutScrollPane extends ScrollPaneWithScrollBar {

		protected var border:StretchRepeatBitmap;

		// RU: предыдущее значение ширины
		// EN: previous value of width
		protected var oldWidth:int = -1;

		// RU: предыдущее значение видимости скроллбара
		// EN: previous value of scrollbar visibility
		protected var oldScrollBar:Boolean = true;

		public function RolloutScrollPane() {
			super();
			background = new StretchRepeatBitmap(RolloutSkin.border, RolloutSkin.edge, RolloutSkin.edge, RolloutSkin.edge, RolloutSkin.edge);
		}

		// RU: позиционирование и задание размеров контенту и фону(рамке)
		// EN: set position and sizes to content and to background(frame)
		override protected function draw():void {
			var maxScroll:int = 0;

			if (_content != null) {
				maxScroll = _content.height - _height + _padding * 2;
				if (_scrollBar != null) {
					_scrollBar.visible = maxScroll > 0;
					_scrollBar.maxScrollPosition = maxScroll;
				}
			}

			var contentWidth:int = _width - (maxScroll > 0 ? _scrollBar.width : 0) - _padding * 2 - (maxScroll > 0 ? 1 : 0);
			if (_scrollBar != null) {
				_scrollBar.x = _width - _scrollBar.width;
				_scrollBar.y = 0;
				_scrollBar.height = _height;

				_contentScrollRect = new Rectangle(0, _scrollBar.scrollPosition, contentWidth, _height - _padding * 2);
				_contentContainer.scrollRect = _contentScrollRect;
				_contentContainer.x = _contentContainer.y = _padding;
			}

			if (_background != null) {
				_background.width = _width;
				_background.height = _height;
			}

		}

		override public function drawGraphics():void {
			graphics.clear();
			graphics.beginFill(0, 0);
			graphics.drawRect(0, 0, _width, _height);
			graphics.endFill();
		}

		// RU: смотрим значение высоты, если меньше заданного, отдаем минимальную высоту
		// EN: if height value is less than the specified value, then return minimal height value
		override protected function calculateHeight(value:int):int {
			if (_content != null) {
				_content.height = value - _padding * 2;
			}

			if (_scrollBar != null) {
				_scrollBar.height = value;
				if ((_content.height + _padding * 2) > _scrollBar.height) {
					if (value < _scrollBar.height && _scrollBar.visible)
						value = _scrollBar.height;
				} else {
					if ((_content.height + _padding * 2) > value) {
						value = _content.height + _padding * 2;
					}
				}
			}
			return value;
		}

		override public function set content(value:DisplayObject):void {
			super.content = value;
			// RU: при добавлении контента, сбрасываем предудыщее значение ширины
			// EN: when content is added, reset previous value of width
			oldWidth = -1;
			calculateWidth(_width);
			if (_scrollBar != null) {
				_scrollBar.scrollPosition = 0;
			}
		}

		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
		// EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (_content != null) {
				var contentWidth:int = 0;
				_content.height = _height - _padding * 2;
				_scrollBar.visible = (_content.height - _height + _padding * 2) > 0;

				if (_scrollBar != null && _scrollBar.visible) {
					// RU: Если ширина изменилась, или появился/скрылся скроллбар, то идет пересчет ширины контента
					// EN: If width is changed or scrollbar is showed/hidden, then recalculation of content width is performed
					if (oldWidth != value || (oldScrollBar != _scrollBar.visible)) {
						// RU: если у контента заморожена ширина, то значение ширины не изменить, если ее не разморозить
						// EN: If content has "frozen" width, then you can't change value of width
						if ((_content is GUIobject) && (_content as GUIobject).freezeWidth) {
							(_content as GUIobject).freezeWidth = false;
							_content.width = value - _padding * 2 - _scrollBar.width - 1;
							(_content as GUIobject).freezeWidth = true;
						} else {
							_content.width = value - _padding * 2 - _scrollBar.width - 1;
						}
					}
					oldScrollBar = true;
//					_content.width = value - _padding * 2 - _scrollBar.width - 1;
					if (value < (_content.width + _padding * 2 + _scrollBar.width + 1))
						value = (_content.width + _padding * 2 + _scrollBar.width + 1);
				} else {
					if (oldWidth != value || (oldScrollBar != _scrollBar.visible)) {
						if ((_content is GUIobject) && (_content as GUIobject).freezeWidth) {
							(_content as GUIobject).freezeWidth = false;
							_content.width = value - _padding * 2;
							(_content as GUIobject).freezeWidth = true;
						} else {
							_content.width = value - _padding * 2;
						}
					}
					oldScrollBar = false;
//					_content.width = value - _padding * 2;
					if (value < (_content.width + _padding * 2))
						value = (_content.width + _padding * 2);
				}


			}
			oldWidth = value;
			return value;
		}

		override public function resize(width:int, height:int):void {
			_height = calculateHeight(height);
			_width = calculateWidth(width);
			draw();
		}
	}
}
