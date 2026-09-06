package alternativa.gui.theme.defaulttheme.container.panel {

	import alternativa.gui.theme.defaulttheme.controls.text.LabelWithIcon;
	import alternativa.gui.theme.defaulttheme.event.PanelEvent;
	import alternativa.gui.theme.defaulttheme.primitives.panel.BackgroundPanel;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.PanelSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.primitives.stretch.HorizontalBar;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;

	use namespace alternativagui;

	/**
	 * 
	 * RU: Панель с заголовком, с кнопкой "закрыть панель", горизонтальной линией разделяющая заголовок и контент. 
	 * С возможностью перетаскивания (drag&drop) за заголовок.
     * EN: panel, which contains: title, button "close", horizontal line separated title and content
	 * 
	 */	
	public class Panel extends SimplePanel {

		// RU: текстовая метка заголовка панели
        // EN: text label of panel title
		protected var label:LabelWithIcon;
		
		// RU: флаг видимости кнопки "закрыть"
        // EN: flag of button "close" visibility
		protected var _closeButtonShow:Boolean = false;
		
		// RU: кнопка "Закрыть"
        // EN: button "close"
		protected var closeBtn:BaseButton;
		
		// RU: разделительная линия
        // EN: separation line
		protected var line:HorizontalBar;
		
		// RU: смещение сверху разделительной линии
        // EN: swift over the separation line
		protected var offsetLine:int = NumericConst.panelOffsetLine;
		
		// RU: высота заголовка
        // EN: title height
		protected var titleHeight:int = NumericConst.panelTitleHeight;
		
		// RU: область, за которую можно хвататься
        // EN: Drag area
		protected var dragArea:Sprite;
		
		// RU: флаг включения перетаскивания
        // EN: flag for enable drag and drop
		protected var _dragEnabled:Boolean = false;

		public function Panel() {
			
			// RU: добавляем горизонтальную линию
            // EN: add a horizontal line
			line = new HorizontalBar(PanelSkin.panelLineTexture, PanelSkin.edgeLine, PanelSkin.edgeLine);
			addChild(line);
			
			// RU: добавляем текстовую метку - заголовок
            // EN: add a text label - title
			label = new LabelWithIcon();
			addChild(label);
			
			// RU: область за которую хватаются при перетаскивании
            // EN: create drag area
			dragArea = new Sprite();
			dragArea.tabEnabled = false;
			dragArea.mouseChildren = false;
			dragArea.graphics.beginFill(0xFF0000, 0);
			dragArea.graphics.drawRect(0, 0, 10, 10);
			addChild(dragArea);
			
			// RU: создаем кнопку "закрыть"
            // EN: add button "close"
			closeBtn = new BaseButton();
			closeBtn.mouseEnabled = false;
			// RU: задаем состояния для кнопки "закрыть"
            // EN: set states for button "close"
			closeBtn.stateUP = new Bitmap(PanelSkin.closeStateUp);
			closeBtn.stateOVER = new Bitmap(PanelSkin.closeStateOver);
			closeBtn.stateDOWN = new Bitmap(PanelSkin.closeStateOver);
			closeBtn.width = PanelSkin.closeStateUp.width;
			closeBtn.height = PanelSkin.closeStateUp.height;
			
			// RU: при добавлении компоненты на сцену, создаем слушателей
            // EN: add listener for ADDED_TO_STAGE event
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
		}

		public function get closeButtonShow():Boolean {
			return _closeButtonShow;
		}

		public function set closeButtonShow(value:Boolean):void {
			_closeButtonShow = value;
			if (_closeButtonShow) {
				if (!contains(closeBtn))
					addChild(closeBtn);
			} else {
				if (contains(closeBtn))
					removeChild(closeBtn);
			}
			draw();
		}

		public function get title():String {
			return label.text;
		}

		public function set title(value:String):void {
			label.text = value;
			draw();
		}

		public function get titleIcon():DisplayObject {
			return label.icon;
		}

		public function set titleIcon(object:DisplayObject):void {
			label.icon = object;
			draw();
		}

		// RU: позиционирование и установка размеров
        // EN: set position and sizes
		override protected function draw():void {
			if (_content != null) {
				_content.x = _padding;
				_content.y = titleHeight + _padding;
				_content.width = _width - _padding * 2;
				_content.height = _height - _padding * 2 - titleHeight;
				if (_width < (_content.width + _padding * 2)) {
					_width = (_content.width + _padding * 2);
				}
				if (_height < (_content.height + _padding * 2 + titleHeight)) {
					_height = (_content.height + _padding * 2 + titleHeight);
				}
			}

			if (bg is GUIobject) {
				GUIobject(bg).resize(_width, _height);
			} else {
				bg.width = _width;
				bg.height = _height;
			}

			line.x = 0;
			line.y = titleHeight - offsetLine;
			line.width = _width;

			label.height = 1;
			label.width = 1;

			label.x = _padding;
			label.y = ((titleHeight - int(label.height)) >> 1) - 1;


			if (closeButtonShow) {
				closeBtn.x = _width - closeBtn.width - _padding;
				closeBtn.y = (titleHeight - closeBtn.height) >> 1;
			}

			dragArea.width = _width;
			dragArea.height = titleHeight;
		}
		
		private function addedHandler(event:Event):void {
			closeBtn.addEventListener(MouseEvent.CLICK, closeBtn_clickHandler);
			removeEventListener(Event.ADDED_TO_STAGE, addedHandler);
			addEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}

		private function removedHandler(event:Event):void {
			closeBtn.removeEventListener(MouseEvent.CLICK, closeBtn_clickHandler);
			addEventListener(Event.ADDED_TO_STAGE, addedHandler);
			removeEventListener(Event.REMOVED_FROM_STAGE, removedHandler);
		}

		private function closeBtn_clickHandler(event:MouseEvent):void {
			dispatchEvent(new PanelEvent(PanelEvent.CLOSE));
		}
		
		// RU: при нажатии на dragArea активируем перетаскивание. При перемещении панель занимает самый верхний уровень видимости в главном контейнере.
        // EN: activate the drag when you click on dragArea. Panel goes onTop (visible layer) in the main container on dragging
		private function dragArea_mouseDownHandler(event:MouseEvent):void {
			this.startDrag();
			if (parent != null) {
				if (parent.getChildIndex(this) != (parent.numChildren - 1)) {
					parent.swapChildrenAt((parent.numChildren - 1), parent.getChildIndex(this));
				}
			}

			LayoutManager.stage.addEventListener(MouseEvent.MOUSE_UP, dragArea_mouseUpHandler);
			dispatchEvent(new PanelEvent(PanelEvent.MOUSE_DOWN));
		}

		private function dragArea_mouseUpHandler(event:MouseEvent):void {
			this.stopDrag();

			LayoutManager.stage.removeEventListener(MouseEvent.MOUSE_UP, dragArea_mouseUpHandler);
			dispatchEvent(new PanelEvent(PanelEvent.MOUSE_UP));
		}

		public function get dragEnabled():Boolean {
			return _dragEnabled;
		}

		public function set dragEnabled(value:Boolean):void {
			_dragEnabled = value;
			if (_dragEnabled) {
				if (!dragArea.hasEventListener(MouseEvent.MOUSE_DOWN)) {
					dragArea.addEventListener(MouseEvent.MOUSE_DOWN, dragArea_mouseDownHandler);
				}
			} else {
				dragArea.removeEventListener(MouseEvent.MOUSE_DOWN, dragArea_mouseDownHandler);
			}
		}
		
		// RU: проверка на минимальную высоту панели
        // EN: check for minimal panel width
		override protected function calculateHeight(value:int):int {
			if (value < NumericConst.tabMinHeight) {
				value = NumericConst.tabMinHeight;
			}
			return value;
		}

		// RU: проверка на минимальную ширину панели
        // EN: check for minimal panel width
		override protected function calculateWidth(value:int):int {
			if (value < (_padding * 2 + label.width)) {
				value = _padding * 2 + label.width;
			}
			return value;
		}
	}
}

