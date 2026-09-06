package alternativa.gui.controls.dropDownMenu {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.container.linear.VBox;
	import alternativa.gui.data.DataProvider;
	
	import flash.display.DisplayObject;


	use namespace alternativagui;
	
	/**
	 * Выпадающая панель с пунктами 2-го(и более) уровня. 
	 * 
	 */	
	public class DropDownMenuItemContainer extends GUIobject implements IDropDownMenuItemContainer {
		
		/**
		 * Контейнер элементов.
		 */		
		protected var _container:VBox;
		
		/**
		 * Данные. 
		 */		
		protected var _data:Object;
		
		/**
		 * Визуальный класс элемента. 
		 */		
		protected var _itemRenderer:Class = DropDownMenuItem;
		
		/**
		 * Фон.
		 */		
		protected var _background:Class;
		
		/**
		 * Фон рендерера. 
		 */		
		protected var _backgroundRenderer:DisplayObject;
		
		/**
		 * Внутренний отступ. 
		 */		
		protected var _padding:int = 0;
		
		/**
		 * Флаг измненения ширины компоненты. 
		 */		
		protected var _backgroundWidthChanged:Boolean = true;
		
		/**
		 * Расчетная ширина фона. 
		 */		
		protected var _backgroundWidth:Number = 0;
		
		/**
		 * Расстояние между элементами по вертикали. 
		 */		
		protected var _space:int = 0;

		/**
		 * Флаг уничтожения. 
		 */		
		protected var _destroyed:Boolean;
		
		/**
		 * Вектор items, нужен для подсчета геометрии. 
		 */		
		protected var _items:Vector.<IDropDownMenuItem>;
		
		/**
		 * Cсылка на родительский item. 
		 */		
		protected var _parentItem:IDropDownMenuItem;
		
		/**
		 * Выбранные данные.
		 */		
		protected var _activatedItem:IDropDownMenuItem;

		/**
		 * Группа для управления items. 
		 */		
		protected var _group:DropDownItemGroup;


		/**
		 * Конструктор.
		 * @param space Расстояние между кнопками в панельке.
		 * @param parentItem Ссылка на родительскую кнопку.
		 */
		public function DropDownMenuItemContainer(space:int = 5, parentItem:IDropDownMenuItem = null) {
			super();
			this.space = space;
			_parentItem = parentItem;
			init();
			
			this.mouseEnabled = true;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function update():void {
			for each (var i:IDropDownMenuItem in _items) {
				i.update();
			}
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function clear():void {
			while (_container.numChildren) {
				var item:IDropDownMenuItem = _container.removeChildAt(0) as DropDownMenuItem;
				if (item != null) {
					item.destroy();
				}
			}
			//_items = new Vector.<IDropDownMenuItem>();
			_items.length = 0;
			_activatedItem = null;
			_group.resetSelectedButton();
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function destroy():void {
			if (_destroyed) {
				return;
			}
			clear();
			_group.destroy();
			_group = null;
			if (_backgroundRenderer && _backgroundRenderer.parent) {
				_backgroundRenderer.parent.removeChild(_backgroundRenderer);
			}
			if (_container && _container.parent) {
				_container.parent.removeChild(_container);
			}
			if (parent) {
				parent.removeChild(this);
			}
			_background = null;
			_backgroundRenderer = null;
			_container = null;
			_destroyed = true;
			_data = null;
			_itemRenderer = null;
			_items = null;
			_parentItem = null;
		}


		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get data():Object {
			return  _data;
		}
		public function set data(value:Object):void {
			_backgroundWidthChanged = true;
			_data = value;
			var dataProvider:DataProvider = value.items;

			clear();
			if (dataProvider == null || dataProvider.length < 1) {
				return;
			}
			var num:int = dataProvider.length;
			var item:IDropDownMenuItem;
			var displayObject:DisplayObject;
			for (var i:int = 0; i < num; i++) {
				item = new _itemRenderer(this);
				item.data = dataProvider.getItemAt(i);
				displayObject = item as DisplayObject;
				if (i > 0) {
					displayObject.y = Math.round(_container.height + _space);
				}
				_items.push(displayObject);
				_container.addChild(displayObject);
				_group.addButton(item);
			}
			draw();
		}

		

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get background():Class {
			return _background;
		}
		public function set background(value:Class):void {
			if (_backgroundRenderer && _backgroundRenderer.parent) {
				_backgroundRenderer.parent.removeChild(_backgroundRenderer);
			}
			if (value) {
				_background = value;
				_backgroundRenderer = addChildAt(new value(), 0);
				draw();
			}
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
			_backgroundWidthChanged = true;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get space():int {
			return _space;
		}


		public function set space(value:int):void {
			_space = value;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get parentItem():IDropDownMenuItem {
			return _parentItem;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get backgroundWidth():int {
			if(!_backgroundWidthChanged){
				return _backgroundWidth;
			}
			var num:int = _items.length;
			var i:int = 0;
			var w:Number = 0;
			var maxItemWidth:int = 0;
			for (i = 0; i < num; i++) {
				w = _items[i].width;
				maxItemWidth = w > maxItemWidth ? w : maxItemWidth;
			}

			_backgroundWidth = maxItemWidth + 2*_padding;
			_backgroundWidthChanged = false;
			return _backgroundWidth ;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function set itemRenderer(value:Class):void {
			_itemRenderer = value;
		}

		/**
		 * Вектор кнопок.
		 */
		public function get items():Vector.<IDropDownMenuItem> {
			return _items;
		}


		/**
		 * Инициализация.
		 */
		protected function init():void {
			_container = new VBox(_space);
			_group = new DropDownItemGroup();
			_items = new Vector.<IDropDownMenuItem>();
			addChild(_container);
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		override protected function draw():void {
			super.draw();
			_container.x = _padding;
			_container.y = _padding;
			_container.resize(1, 1);
			drawBackground();
			_container.drawChildren();
		}
		
		/**
		 * Отрисовка фона. 
		 * 
		 */		
		protected function drawBackground():void{
			if (_backgroundRenderer) {
				_backgroundRenderer.width = backgroundWidth;
				_backgroundRenderer.height = _container.height + 2*_padding;
				if (_backgroundRenderer is GUIobject) {
					(_backgroundRenderer as GUIobject).drawChildren();
				}
			}
		}

	}
}
