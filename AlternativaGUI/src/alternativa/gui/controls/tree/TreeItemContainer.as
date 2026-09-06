package alternativa.gui.controls.tree {

	import alternativa.gui.alternativagui;
	import alternativa.gui.container.list.IItemRenderer;
	import alternativa.gui.container.list.ListItemContainer;
	import alternativa.gui.data.DataProvider;
	import alternativa.gui.event.DataChangeEvent;
	import alternativa.gui.event.ListEvent;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.events.Event;
	import flash.events.MouseEvent;

	use namespace alternativagui;
	
	/**
	 * Контейнер элементов для Tree
	 * 
	 */	
	public class TreeItemContainer extends ListItemContainer {
		
		/**
		 * Оригинальный поставщик данных.
		 * <p>Используется для извлечения данных, которые отображаются</p> 
		 */		
		protected var _origDataProvider:DataProvider;
		
		
		public function TreeItemContainer() {
			super();
		}
		
		/**
		 * Нажатие на элемент.
		 * <p>При нажатии на элемент, происходит проверка: является ли элемент носителем детей или нет, если да, то ветка раскрывается.</p>
		 * 
		 */		
		override protected function clickOnItem(e:MouseEvent):void {
			super.clickOnItem(e);
			
			if (e.target is IItemRenderer) {
				
				/** поля в dataProvider
				 * id 
				 * parentId
				 * label
				 * icon
				 * opened
				 * level
				 * hasChildren
				 * canExpand
				 **/ 
				var tempIndex:int = _origDataProvider.getItemIndex(selectedItem);
				if (_origDataProvider != null && _origDataProvider.length > 0) {
					if (_origDataProvider.getItemAt(tempIndex).canExpand && _origDataProvider.getItemAt(tempIndex).hasChildren) {
						_origDataProvider.getItemAt(tempIndex).opened = !_origDataProvider.getItemAt(tempIndex).opened;
						updateDataProvider();
						draw();
					}
					
				}
			}
			MouseManager.update();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function set dataProvider(value:DataProvider):void {
			_origDataProvider = value;
			updateDataProvider();
		}
		
		/**
		 * Обновление поставщика данных.
		 * <p>Создается новый поставщик данных, в него добавляются только открытые ветки, все что закрыто - не попадает в него.</p> 
		 * 
		 */		
		protected function updateDataProvider():void {
			var dp:DataProvider = new DataProvider();
			var arr:Array = new Array();
			var levelsArray:Array = new Array();
			var tempLevel:int = 1000;
			var tempRootParentID:String = "-1";
			var tempParentID:String = "-1";
			var rootOpened:Boolean = false;
			var opened:Boolean = false;
			var b:Boolean = false;
			
			var obj:Object = new Object();
			
			var openedPastLevels:Boolean;
			
			for (var i:int = 0; i < _origDataProvider.length; i++) {
				
				obj = new Object();
				obj.opened = _origDataProvider.getItemAt(i).opened;
				obj.parentId = _origDataProvider.getItemAt(i).parentId;
				obj.level = _origDataProvider.getItemAt(i).level;
				levelsArray[_origDataProvider.getItemAt(i).level] = obj;
				if (_origDataProvider.getItemAt(i).parentId != null) {
					for (var k:int = (_origDataProvider.getItemAt(i).level - 1); k >= 0; k--) {
						openedPastLevels = levelsArray[k].opened; 
					} 
					if (levelsArray[_origDataProvider.getItemAt(i).level - 1].opened && openedPastLevels && (_origDataProvider.getItemAt(i).level <= tempLevel)) {
						tempParentID = _origDataProvider.getItemAt(i).itemId;
						opened = _origDataProvider.getItemAt(i).opened;
						tempLevel = 1000;
						arr[arr.length] = _origDataProvider.getItemAt(i);
					} else {
						tempLevel = _origDataProvider.getItemAt(i).level - 1;
					}
				} else {
					tempParentID = _origDataProvider.getItemAt(i).itemId;
					opened = _origDataProvider.getItemAt(i).opened;
					if (_origDataProvider.getItemAt(i).opened) {
						tempLevel = 1000;
					} else {
						tempLevel = 0;
					}
					arr[arr.length] = _origDataProvider.getItemAt(i);
				}
				
				
			}
			
			dp.addItems(arr);
			changeDataProvider(dp); 
		}
		
		/**
		 * Изменились данные в поставщике данных.
		 * 
		 */		
		protected function changeDataProvider(value:DataProvider):void {
			var haveDP:Boolean = false;
			var i:int = 0;
			var prop:*;
			if (_dataProvider) {
				
				for (prop in dataDictionary) {
					delete dataDictionary[prop];
				}
				
				for (prop in visibleElementsDictionary) {
					(visibleElementsDictionary[prop] as IItemRenderer).data = null;
					delete visibleElementsDictionary[prop];
				}
				for (i = 0; i < itemsArray.length; i++) {
					if (contains(itemsArray[i])) {
						removeChild(itemsArray[i]);
					}
				}
				haveDP = true;
			}
			_dataProvider = value;
			
			if (_dataProvider != null) {
				
				if (tempObject == null) {
					tempObject = new ItemClass();
				}
				if (_dataProvider && _dataProvider.length > 0) {
					(tempObject as IItemRenderer).data = _dataProvider.getItemAt(0);
				}
				for (i = 0; i < _dataProvider.length; i++) {
					if (dataDictionary[i] == null) {
						dataDictionary[i] = new Object();
					}
					dataDictionary[i].data = _dataProvider.getItemAt(i);
					dataDictionary[i].id = i;
					dataDictionary[i].selected = false;
				}

				if (_selectedItem!=null) {
					for (prop in dataDictionary) {
						if (dataDictionary[prop] == _selectedItem) {
							dataDictionary[prop].selected = true;
							break;
						}
					}
				}
				_height = calculateHeight(_height);	
			}
			
			if (_selectedIndex!=-1){ 
				selectItem(_selectedIndex, true);
			}
			
			draw();
			
			if (_dataProvider != null) {
				_dataProvider.addEventListener(DataChangeEvent.DATA_CHANGE, changeData);
				dispatchEvent(new Event(ListEvent.REDRAW));
			} else {
				dispatchEvent(new Event(ListEvent.REDRAW));
			}
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function changeData(e:Event):void {
			_height = calculateHeight(_height);
			if (_dataProvider.length == 0) {
				dispatchEvent(new Event(ListEvent.REMOVE_DATA));
			}
			draw();
		}
	}
}
