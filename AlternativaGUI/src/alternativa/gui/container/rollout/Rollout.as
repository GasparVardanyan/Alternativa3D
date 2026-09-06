package alternativa.gui.container.rollout {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.Container;
	import alternativa.gui.container.linear.RelativeVBox;
	import alternativa.gui.container.scrollPane.ScrollPane;
	import alternativa.gui.event.RolloutEvent;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.events.MouseEvent;
	
	use namespace alternativagui;
	
	/**
	 * Базовый класс контейнера, который умеет сворачиваться и разворачиваться.
	 * 
	 */	
	public class Rollout extends GUIobject {
		
		/**
		 * Текущее пространство между элементами. 
		 */		
		protected var _space:int;
		
		/**
		 * Высота заголовка. 
		 */	
		protected var _titleHeight:int = 10;
		
		/**
		 * Контейнер заголовка.
		 * 
		 */		
		protected var title:DisplayObject;
		
		/**
		 * Контейнер контента.
		 * 
		 */	
		protected var contentContainer:DisplayObjectContainer;
		
		/**
		 * Флаг сворачивания.
		 * 
		 */		
		protected var _minimized:Boolean;
		
		/**
		 * 
		 * @param titleHeight Высота заголовка контейнера.
		 * @param space Зазор между заголовком и контентом.
		 * 
		 */		
		public function Rollout(titleHeight:int, space:int) {
			_titleHeight = titleHeight;
			_space = space;
			
			_minimized = true;
			
			title = createTitle();
			addChild(title);
			title.addEventListener(MouseEvent.CLICK, onTitleClick);
			
			contentContainer = createContentContainer();
		}
		
		
		/**
		 * Обновление внешнего вида компоненты.
		 * 
		 */	
		public function update():void {
			resize(_width, _height);
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function draw():void {
			if (title != null) {
				title.x = 0;
				title.y = 0;
				title.width = _width;
				title.height = _titleHeight;
				
				if (!_minimized && contentContainer!=null) {
					contentContainer.x = 0; 
					contentContainer.y = _titleHeight + _space;
					if (contentContainer is GUIobject) {
						(contentContainer as GUIobject).resize(_width, (_height - _titleHeight - _space));
					} else {
						contentContainer.height = _height - _titleHeight - _space;
						contentContainer.width = _width;
					}
				}
			}
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function calculateHeight(value:int):int {
			if(_minimized) {
				value = _titleHeight;
			} else {
				contentContainer.height = value - _titleHeight - _space;
				if (value < (contentContainer.height + _space + _titleHeight)) {
					value = (contentContainer.height + _space + _titleHeight);
				}
			}
			
			return value;
		}
		
		/**
		 * @inheritDoc
		 */		
		override protected function calculateWidth(value:int):int {
			var a:int = 0;
			var b:int = 0;
			if (title != null) {
				title.width = value;
				a = title.width; 
			}
			if (contentContainer != null) {
				contentContainer.width = value;
				b = contentContainer.width; 
			}
			if (a < b) {
				value = b; 
			} else { 
				value = a;
			}
			return value;
		}
		
		/**
		 * Контент контейнера.
		 * Если есть свойство content у контейнера, то отдается его содержимое.
		 * Иначе отдается объект, который находится на самом нижнем слое.
		 * При добавление контента контейнеру, если нет свойства content, то все дети удаляются у контейнера и добавляется объект.
		 * 
		 */		
        public function get content():DisplayObject {
			if (contentContainer.hasOwnProperty("content")) {
				return contentContainer["content"];
			} else {
				return contentContainer.getChildAt(0);
			}
		}

		public function set content(value:DisplayObject):void {
			if (contentContainer.hasOwnProperty("content")) {
				contentContainer["content"] = value;
			} else {
				while (contentContainer.numChildren > 0) {
					contentContainer.removeChildAt(0);
				}
				contentContainer.addChild(value);
			}
		}
		
		/**
		 * Текущее пространство между элементами.
		 */
		public function get space():int {
			return _space;
		}
		public function set space(value:int):void {
			_space = value;
			draw();
		}
		
		/**
		 * Флаг сворачивания.
		 */
		public function get minimized():Boolean {
			return _minimized;
		}	
		public function set minimized(value:Boolean):void {
			if (value != _minimized) {
				if (value) {
					minimize();
				} else {
					maximize()
				}
			}
		}
		
		/**
		 * Создание заголовка. 
		 * 
		 */		
		protected function createTitle():DisplayObject {
			return null;
		}
		
		/**
		 * Создание контейнера для контента.  
		 * 
		 */		
		protected function createContentContainer():DisplayObjectContainer {
			return null;
		}
		
		/**
		 * Разворачивание.
		 * 
		 */		
		protected function maximize():void {
			if (contentContainer != null) {
				_minimized = false;
				if (!contains(contentContainer)) {
					addChild(contentContainer);
				}
				dispatchEvent(new RolloutEvent(RolloutEvent.MAXIMIZE, this));
				
				MouseManager.update();
			}
		}
		
		/**
		 * Сворачивание.
		 * 
		 */
		protected function minimize():void {
			if (contentContainer != null) {
				_minimized = true;
				if (contains(contentContainer)) {
					removeChild(contentContainer)
				}
				dispatchEvent(new RolloutEvent(RolloutEvent.MINIMIZE, this));
				
				MouseManager.update();
			}
		}
		
		/**
		 * Нажатие на заголовок. 
		 * 
		 */		
		private function onTitleClick(e:MouseEvent):void {
			if (_minimized) {
				maximize();
			} else {
				minimize();
			}
		}

		/**
		 * Высота заголовка. 
		 */
		public function get titleHeight():int
		{
			return _titleHeight;
		}

		/**
		 * @private
		 */
		public function set titleHeight(value:int):void
		{
			_titleHeight = value;
		}


	}
}