package alternativa.gui.container.list {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.data.DataProvider;
	import alternativa.gui.event.DataChangeEvent;
	import alternativa.gui.event.ListEvent;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.MouseManager;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TextEvent;
	import flash.events.TimerEvent;
	import flash.geom.Rectangle;
	import flash.text.TextField;
	import flash.text.TextFieldType;
	import flash.utils.Dictionary;
	import flash.utils.Timer;

	use namespace alternativagui;

	/**
	 *
	 * Контейнер объектов для List.
	 *
	 */
	public class ListItemContainer extends GUIobject implements IItemContainer {

		/**
		 * Массив видимых элементов.
		 */		
		protected var itemsArray:Vector.<DisplayObject>;
		
		/**
		 * Поставщик данных.
		 */		
		protected var _dataProvider:DataProvider;
		
		/**
		 * Текущий элемент. 
		 */		
		protected var curElement:int = 0;

		/**
		 * Класс визуального элемента. 
		 */		
		protected var ItemClass:Class;
		
		/**
		 * @private 
		 */		
		protected var tempObject:DisplayObject;

		/**
		 * Значение прокрутки контейнера с элементами.
		 */		
		protected var _vertValue:int = 0;

		/**
		 * Количество видимых элементов. 
		 */		
		protected var _numVisibleItems:int = 0;
		
		/**
		 * Зазор между элементами.
		 */		
		protected var _space:int = 0;

		/**
		 * Словарь, с элементами, которые на сцене. 
		 */		
		protected var visibleElementsDictionary:Dictionary;

		/**
		 * Индекс выбранного элемента. 
		 */		
		protected var _selectedIndex:int = -1;

		/**
		 * Выбранный элемент.
		 */		
		protected var _selectedItem:Object;
		
		/**
		 * @private 
		 */		
		protected var _activate:Boolean = false;

		/**
		 * @private
		 * Текстовое поля для отлова нормальных букв. 
		 */		
		protected var textField:TextField;
		
		/**
		 * @private 
		 */		
		protected var tempLetters:String = "";
		
		/**
		 * @private 
		 */
		protected var searchTimer:Timer = new Timer(700);

		/**
		 * Количество скроллируемых строк при скроллинге. 
		 */		
		protected var _numScrollLines:int = 3;

		/**
		 * Количество скроллируемых строк, при нажатии на кнопки скроллбара: вверх/вниз. 
		 */
		protected var _numStepLines:int = 1;


		/**
		 * Словарь для хранения свойств id и selected.
		 */		
		protected var dataDictionary:Dictionary;
		
		/**
		 * @private
		 * Переменная для временного хранения данных в textField.
		 */		
		private var tempText:String = "";
		
		/**
		 * @private
		 * Флаг нажатия кнопки клавиатуры: любая, кроме кнопок влево/вправо 
		 */		
		private var otherKeyBoard:Boolean = false;

		public function ListItemContainer() {
			super();

			itemsArray = new Vector.<DisplayObject>();
			addEventListener(MouseEvent.MOUSE_DOWN, clickOnItem);
			//addEventListener(MouseEvent.CLICK, clickOnItem);
			this.mouseChildren = true;

			visibleElementsDictionary = new Dictionary();
			dataDictionary = new Dictionary();

			textField = new TextField();
			textField.mouseEnabled = false;
			textField.type = TextFieldType.INPUT;
			textField.addEventListener(KeyboardEvent.KEY_UP, keyboardUpHandler);
			textField.addEventListener(TextEvent.TEXT_INPUT, textHandler);
		}
		
		/**
		 * Обновление листа.
		 * 
		 */		
		public function update():void {
			var prop:*;
			if (_dataProvider != null && _dataProvider.length > 0) {
				for (prop in visibleElementsDictionary) {
					if (prop < _dataProvider.length) {
//						trace("_dataProvider.getItemAt(prop): " + _dataProvider.getItemAt(prop));
						visibleElementsDictionary[prop].data = _dataProvider.getItemAt(prop);
					} else {
						delete visibleElementsDictionary[prop];
					}
					/*if (_dataProvider.getItemAt(prop) != null) {
						dict[prop].data = _dataProvider.getItemAt(prop);
					} else {
						delete dict[prop];
					}*/
				}
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function set itemRenderer(value:Class):void {
			ItemClass = value;
			tempObject = new ItemClass();
			if (_dataProvider != null && _dataProvider.length > 0) {
				(tempObject as IItemRenderer).data = _dataProvider.getItemAt(0);
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function get dataProvider():DataProvider {
			return _dataProvider;
		}
		public function set dataProvider(value:DataProvider):void {
			var haveDP:Boolean = false;
			var i:int = 0;
			var prop:*;
//            trace("dataProvider: " + value)
			if (_dataProvider) {
				_dataProvider.removeEventListener(DataChangeEvent.DATA_CHANGE, changeData);

				for (prop in dataDictionary) {
					dataDictionary[prop].data = null;
					delete dataDictionary[prop];
				}

				for (prop in visibleElementsDictionary) {
					(visibleElementsDictionary[prop] as IItemRenderer).data = null;
					delete visibleElementsDictionary[prop];
				}
				var itemsArrayLength:int = itemsArray.length;
				for (i = 0; i < itemsArrayLength; i++) {
					if (contains(itemsArray[i])) {
						removeChild(itemsArray[i]);
					}
				}
				_vertValue = 0;
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
				var dataProviderLength:int = dataProvider.length;
				for (i = 0; i < dataProviderLength; i++) {
					//					trace("_dataProvider.getItemAt(i): " + _dataProvider.getItemAt(i));
					//					if (_dataProvider.getItemAt(i).selected) {
					////						_selectedId = _dataProvider.getItemAt(i).id;
					////						_selectedIndex = i;
					//						selectedId = _dataProvider.getItemAt(i).id;
					//						break;
					//					}
					if (dataDictionary[i] == null) {
						dataDictionary[i] = new Object();
					}
					dataDictionary[i].data = _dataProvider.getItemAt(i);
//					trace("! dataDictionary["+i+"]: " + dataDictionary[i]);
					dataDictionary[i].id = i;
					dataDictionary[i].selected = false;
				}

				_height = calculateHeight(_height);


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
		 * @private 
		 * 
		 */		
		public function get activate():Boolean {
			return _activate;
		}
		
		// Активируем контейнер с объектами: вешаем нужные слушатели, устанавливаем фокус
		// Активируется снаружи, при нажатии на родительский объект - List
		/**
		 * @private
		 * Активируем контейнер.
		 * <p>Активируется снаружи, при нажатии на родительский объект - List.</p>
		 *
		 */
		
		/** 
		 * @inheritDoc
		 * 
		 */		
		public function set activate(value:Boolean):void {
			if (_activate != value) {
				_activate = value;
				if (_activate) {
					searchTimer.addEventListener(TimerEvent.TIMER, stopSearchTimer);
					LayoutManager.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyboardDownHandler);
					LayoutManager.stage.focus = LayoutManager.stage;
				} else {
					LayoutManager.stage.removeEventListener(KeyboardEvent.KEY_DOWN, keyboardDownHandler);
					searchTimer.removeEventListener(TimerEvent.TIMER, stopSearchTimer);
					if (LayoutManager.stage.focus == LayoutManager.stage) {
						LayoutManager.stage.focus = null;
					}
					stopSearchTimer();
				}
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get selectedItem():Object {
			return _selectedItem;
		}
		public function get selectedIndex():int {
			return _selectedIndex;
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function set selectedIndex(value:int):void { 
			selectItem(value);
		}

		/**
		 * @inheritDoc
		 * 
		 */
		public function get contentHeight():Number {
			var h:int = 0;
			if (_dataProvider != null && _dataProvider.length != 0 && tempObject) {
				h = (_dataProvider.length * ((tempObject as IItemRenderer).height)) + ((_dataProvider.length - 1) * _space);
			}
			return h;
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function get showScrollBar():Boolean {
			if (_dataProvider && _dataProvider.length > 0 && tempObject) {
				var visibleItems:int = Math.floor(_height / ((tempObject as IItemRenderer).height + _space));
				if (_dataProvider.length > visibleItems) {
					return true;
				} else {
					return false;
				}
			} else {
				return false;
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function get mouseDelta():Number {
			if (tempObject) {
				return ((tempObject as IItemRenderer).height * _numScrollLines + _space * _numScrollLines);
			} else {
				return 0;
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function get stepScroll():Number {
			if (tempObject) {
				return ((tempObject as IItemRenderer).height * _numStepLines + _space * _numStepLines);
			} else {
				return 0;
			}
		}

		/**
		 * @inheritDoc
		 *
		 */
		public function get vertValue():int {
			return _vertValue;
		}
		public function set vertValue(value:int):void {
//			trace("set _vertValue value: " + value);
			_vertValue = value;
			draw();
			MouseManager.update();
//			trace("set _vertValue: " + _vertValue);
		}
		
		/**
		 * Количество скролируемых строчек при скролле мышкой.
		 *
		 */
		public function get numScrollLines():int {
			return _numScrollLines;
		}
		public function set numScrollLines(value:int):void {
			_numScrollLines = value;
		}
		
		/**
		 * Количество скроллируемых строк, при нажатии на кнопки скроллбара: вверх/вниз.
		 *
		 */
		public function get numStepLines():int {
			return _numStepLines;
		}
		public function set numStepLines(value:int):void {
			_numStepLines = value;
		}

		/**
		 * Расстояние между элементами.
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
		override protected function draw():void {
			super.draw();
			var top:int = _vertValue;
			var prop:*;
//			trace("tempObject: " + tempObject);
			//if (tempObject!=null) trace((tempObject as IItemRenderer).getHeight());
			if (_dataProvider != null && _dataProvider.length > 0 && tempObject != null) {
				curElement = Math.abs(top) / ((tempObject as IItemRenderer).height + _space);

//				trace("curElement: " + curElement);
//				trace("_numVisibleItems: " + _numVisibleItems);
//				trace("  itemsArray.length: " + itemsArray.length);
				var itemHeight:int = (tempObject as IItemRenderer).height;
				for (prop in visibleElementsDictionary) {
					if (prop < curElement || prop > (curElement + _numVisibleItems + 1)) {
//						trace(">>>>> delete prop: " + prop);
						removeChild(visibleElementsDictionary[prop]);
//						trace("dict[prop]: " + dict[prop]);
//						trace("contains(): " + contains(dict[prop]));
						delete visibleElementsDictionary[prop];
					}
				}
				var item:DisplayObject;
				var i:int = 0;
				for (var j:int = curElement; j < (curElement + _numVisibleItems + 2); j++) {
					if (!visibleElementsDictionary[j]) {
//						trace("---");
//						trace("  none prop: " + j);
//						trace("  itemsArray.length: " + itemsArray.length);
						for (i = 0; i < itemsArray.length; i++) {
							item = itemsArray[i];
//							trace("contains(item): " + contains(item));
							if (!contains(item) || (item as IItemRenderer).data == null) {
//								trace("   contains false i: " + i);
								if (j <= (_dataProvider.length - 1)) {
//									trace("data true");
									(item as IItemRenderer).data = _dataProvider.getItemAt(j);
									(item as IItemRenderer).itemIndex = dataDictionary[j].id;
									(item as IItemRenderer).selected = dataDictionary[j].selected;
									visibleElementsDictionary[j] = item;
									addChild(item);
								} else {
//									trace("data null");
									(item as IItemRenderer).data = null;
								}
								break;
							} else {
//								trace("   contains true i: " + i);
							}
						}
					}
				}
				for (i = 0; i < itemsArray.length; i++) {
					item = itemsArray[i];
					item.height = 1;
					item.width = _width;
					for (prop in visibleElementsDictionary) {
						if (visibleElementsDictionary[prop] == item) {
							item.y = (itemHeight + _space) * prop;
//							trace(String(prop) + "item.y: " + item.y);
						}
					}
				}
				this.scrollRect = new Rectangle(0, top, _width, _height);

//				this.graphics.clear();
//				this.graphics.beginFill(0xFF0000,0.5);
//				this.graphics.drawRect(0,0,_width,_height);
			}

		}

		/**
		 * Вызывается при изменении поставщика данных.
		 * 
		 */		
		protected function changeData(e:Event):void {
			var dataProviderLength:int = _dataProvider.length; 
			if (dataProviderLength == 0) {
				for (var prop:* in visibleElementsDictionary) {
					delete visibleElementsDictionary[prop];
				}
				dispatchEvent(new Event(ListEvent.REMOVE_DATA));
				_vertValue = 0;
			} else {
				for (prop in dataDictionary) {
					dataDictionary[prop].data = null;
					delete dataDictionary[prop];
				}
				for (var i:int = 0; i < dataProviderLength; i++) {
					if (dataDictionary[i] == null) {
						dataDictionary[i] = new Object();
					}
					dataDictionary[i].data = _dataProvider.getItemAt(i);
					dataDictionary[i].id = i;
					if(selectedItem != null) {
						if (_dataProvider.getItemAt(i) == selectedItem) { 
							dataDictionary[i].selected = true;
						}
					} else {
						dataDictionary[i].selected = false;
					}
				}
				update();
				dispatchEvent(new Event(ListEvent.REDRAW));
			}
			_height = calculateHeight(_height);
			draw();
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function calculateHeight(value:int):int {
//			trace("calculateHeight: " + value);
			if (_dataProvider && tempObject) {
				_height = value;
				tempObject.height = 1;
				//_numVisibleItems = Math.round(value / ((tempObject as IItemRenderer).getHeight() + _space));
				_numVisibleItems = Math.floor(value / ((tempObject as IItemRenderer).height + _space));
				if (_numVisibleItems < 0)
					_numVisibleItems = 0;

				var numElements:int = _numVisibleItems + 4;

				if (_dataProvider.length == 0) {
					numElements = 0;
				}
				if (numElements >= _dataProvider.length) {
					numElements = _dataProvider.length;
				}
				if (_dataProvider.length <= _numVisibleItems) {
					_vertValue = 0;
				}

				var item:DisplayObject;
				
				while (itemsArray.length != numElements) {
					if (itemsArray.length < numElements) {
						item = new ItemClass();
						itemsArray.push(item);
						(item as GUIobject).mouseEnabled = true;
					} else {
						if (itemsArray.length > 0) {
							item = itemsArray.pop();
							if (contains(item)) {
								removeChild(item);
							}
							for (var prop:* in visibleElementsDictionary) {
								if (visibleElementsDictionary[prop] == item) {
									delete visibleElementsDictionary[prop];
								}
							}
						}
					}
				}
				dispatchEvent(new Event(Event.CHANGE));
				draw();
			}
			
			return _height;
		}
		
		/**
		 * Вызывается при нажатии на элемент.
		 * <p>После вызова выделяется элемент и создается событие ListEvent.CLICK_ITEM, которое содержит data.</p>
		 */		
		protected function clickOnItem(e:MouseEvent):void {
			if (e.target is IItemRenderer) {
//				_selectedIndex = (e.target as IItemRenderer).itemIndex;
				selectItem((e.target as IItemRenderer).itemIndex, true);

				dispatchEvent(new ListEvent(ListEvent.CLICK_ITEM, (e.target as IItemRenderer).data));
			}
		}
		
		/**
		 * Выбор элемента.
		 * @param _id Индекс элемента.
		 * @param showElement При значении true - выделенный элемент показывается полностью. 
		 * 
		 */				
		protected function selectItem(_id:int, showElement:Boolean = false):void {
//			trace("!1 selectItem: " + _id);
			if (_selectedIndex >= 0 && _selectedIndex <= (_dataProvider.length - 1)) {
				//_dataProvider.getItemAt(_selectedIndex).selected = false;
				dataDictionary[_selectedIndex].selected = false;
				
				if (visibleElementsDictionary[_selectedIndex]) {
					(visibleElementsDictionary[_selectedIndex] as IItemRenderer).selected = false;
				}
			}
			
//			for (var i:int = 0; i < _dataProvider.length; i++) {
//				//if (_dataProvider.getItemAt(i).id == _id) {
//				if (dataDictionary[_selectedIndex].id == _id) {
//					//_dataProvider.getItemAt(i).selected = true;
//					dataDictionary[_selectedIndex].selected = true;
//					_selectedId = _id;
//					_selectedIndex = i;
//					_selectedItem = _dataProvider.getItemAt(i);
//					break;
//				}
//			}
//			trace("!2 selectItem: " + _id);
			if (_id >= 0) {
				_selectedIndex = _id;
				_selectedItem = _dataProvider.getItemAt(_id);
				if (visibleElementsDictionary[_selectedIndex]) {
					(visibleElementsDictionary[_selectedIndex] as IItemRenderer).selected = true;
				}
				dataDictionary[_selectedIndex].selected = true;
				showItem(_selectedIndex, showElement);
				if (_selectedIndex >= 0) {
					dispatchEvent(new ListEvent(ListEvent.SELECT_ITEM, _dataProvider.getItemAt(_selectedIndex)));
				}
			}
		}
		
		/**
		 * Выделение элемента.
		 * @param num Индекс элемента.
		 * @param showElement При значении true - выделенный элемент показывается полностью.
		 * 
		 */		
		protected function showItem(num:int, showElement:Boolean = false):void {
//			trace("showItem");
//			trace("     _height: " + _height);
//			trace("     contentHeight: " + contentHeight);
//			trace("     num: " + num);

			var maxScroll:int = Math.abs(_height - contentHeight);
			var offset:int;

//			trace("     curPosObj: " + curPosObj);
//			trace("     boundBottom: " + boundBottom);
			if (showElement) {
//				trace("     num: " + num);
//				trace("     curElement: " + curElement);
//				trace("     _numVisibleItems: " + _numVisibleItems);

				if (num <= curElement) {
					offset = ((tempObject as IItemRenderer).height + _space) * num;
					vertValue = (offset > 0 ? offset : 0);
					dispatchEvent(new Event(ListEvent.CHANGE_POSITION));
				} else if ((num + 1) > (curElement + _numVisibleItems)) {
					offset = ((tempObject as IItemRenderer).height + _space) * ((num + 1) - _numVisibleItems);
					vertValue = (offset > maxScroll ? maxScroll : offset);

						//dispatchEvent(new Event(ListEvent.CHANGE_POSITION));
				}

				var curPosObj:int = ((num + 1) * (tempObject as IItemRenderer).height + _space) - _space;
				if (this.scrollRect != null) {
					var boundBottom:int = this.scrollRect.y + _height;
				} else {
					boundBottom = _height;
				}
//				trace("2");
//				trace("offset: " + offset);
//				trace("curPosObj: " + curPosObj);
//				trace("boundBottom: " + boundBottom);
//				trace("vertValue: " + vertValue);
				if (curPosObj > boundBottom) {
					offset = vertValue + (curPosObj - boundBottom);
					vertValue = (offset > maxScroll ? maxScroll : offset);
//					trace("!!  vertValue: " + vertValue);
					dispatchEvent(new Event(ListEvent.CHANGE_POSITION));
				} else {
					dispatchEvent(new Event(ListEvent.CHANGE_POSITION));
				}

//				trace("3 vertValue: " + vertValue);
			} else {
//				trace("else");
				var topItem:int = num - int(_numVisibleItems/2);
				offset = ((tempObject as IItemRenderer).height + _space) * topItem;
				if (topItem < 0) {
					topItem = 0;
					offset = ((tempObject as IItemRenderer).height + _space) * topItem;
				} else if ((topItem + _numVisibleItems) > _dataProvider.length) {
					topItem = _dataProvider.length - _numVisibleItems;
					offset = ((tempObject as IItemRenderer).height + _space) * topItem;
				}
				if (offset < 0) {
					offset = 0;
				} else if (offset > maxScroll) {
					offset = maxScroll;
				}

				vertValue = offset;

				dispatchEvent(new Event(ListEvent.CHANGE_POSITION));
			}
//			trace("");
//			trace("              num: " + num);
//			trace(" _numVisibleItems: " + _numVisibleItems);
//			trace("_dataProvider.length: " + _dataProvider.length);
//			trace("tempObject.height: " + (tempObject as IItemRenderer).height);
//			trace("           _space: " + _space);
//			trace("          topItem: " + topItem);
//			trace("        maxScroll: " + maxScroll);
//			trace("           offset: " + offset);
//			trace("        vertValue: " + vertValue);
		}

		/**
		 * @private
		 * Останавливаем таймер поиска.
		 * 
		 */		
		protected function stopSearchTimer(e:TimerEvent = null):void {
//			trace("checkTimer");
			searchTimer.stop();
			tempLetters = "";
		}

		// слушаем текстовое поле на ввод данных
		/**
		 * @private
		 * Слушатель текстового поля.
		 * 
		 */		
		protected function textHandler(e:TextEvent):void {
//			trace("textHandler: " + e.text.charAt(0));
//			trace("textHandler e.text: " + e.text);
			searchLetters(e.text.charAt(0));
			searchTimer.stop();
			searchTimer.start();
			LayoutManager.stage.focus = LayoutManager.stage;
		}

		/**
		 * @private
		 * Выборка по буквам.
		 * @param _letter Буква.
		 * 
		 */		
		protected function searchLetters(_letter:String):void {
//			trace("_letter: " + _letter);
			// переводим входящую букву в нижний регистр
			tempLetters += _letter.toLowerCase();
			var res:int = -1;
			var string:String;
			var i:int = 0;
			var prop:*;
			//for (i = 0; i < _dataProvider.length; i++) {
			for (prop in dataDictionary) {
				if (dataDictionary[prop].data.label != null) {
					string = dataDictionary[prop].data.label;
					string = string.slice(0, tempLetters.length);
					string = string.toLowerCase();
					if (string == tempLetters) {
						res = dataDictionary[prop].id;
//						trace("1 проход");
						break;
					}
				}
			}

			// если кнопка найдена - выделяем её
			if (res >= 0) {
//				trace("если кнопка найдена - выделяем её");
//				trace("res: " + res);
				selectedIndex = res;
			} else {
				//tempLetters = "";//_letter;//tempLetters.slice(0, tempLetters.length-1);
				//searchLetters(_letter);
//				trace("res false : " + tempLetters);
				// если не найдена кнопка, то ищем кнопку начинающуюся с этой буквы
//				trace("если не найдена кнопка, то ищем кнопку начинающуюся с этой буквы");
				for (prop in dataDictionary) {
					if (dataDictionary[prop].data.label != null) {
						string = dataDictionary[prop].data.label;
						string = string.slice(0, tempLetters.length);
						string = string.toLowerCase();
						if (string == tempLetters) {
							res = dataDictionary[prop].id;
//							trace("2 проход");
							break;
						}
					}
				}

				// если нашли, то идем дальше
				if (res >= 0) {
//					trace("если нашли, то идем дальше");
					tempLetters = _letter;
//					trace("res: " + res);
					selectedIndex = res;
				} else {
					
				}
			}
			
		}

		/**
		 * @private
		 * Слушатель клавиатурных событий.
		 * 
		 */		
		protected function keyboardDownHandler(e:KeyboardEvent):void {
			switch (e.keyCode) {
				// enter
				case 13:
					stopSearchTimer();
					if (_selectedItem != null)
						dispatchEvent(new ListEvent(ListEvent.CLICK_ITEM, _selectedItem));
					break;
				// вверх - 38
				case 38:
					stopSearchTimer();
					keyboardSelectItem(true);
					break;
				// вниз - 40
				case 40:
					stopSearchTimer();
					keyboardSelectItem(false);
					break;
				default:
					otherKeyBoard = true;
					tempText = textField.text;
					LayoutManager.stage.focus = textField;
			}
		}

		/**
		 * @private
		 * Слушатель клавиатурных событий у textField.
		 * 
		 */		
		protected function keyboardUpHandler(e:KeyboardEvent):void {
			if (otherKeyBoard) {
				if (tempText == textField.text) {
					LayoutManager.stage.focus = LayoutManager.stage;
				}
				otherKeyBoard = false;
			}
		}
		
		/**
		 * @private
		 * Выбор объекта с клавиатуры.
		 * @param _up Флаг на движение вверх или вниз.
		 * 
		 */		
		protected function keyboardSelectItem(_up:Boolean):void {
//			trace("keyboardSelectItem up: " + _up);
//			trace("     _selectedIndex: " + _selectedIndex);
//			trace("     _dataProvider.length: " + _dataProvider.length);
			var index:int = _selectedIndex;
			if (_up) {
				index--;
				if (index >= 0) {
					//selectItem(_dataProvider.getItemAt(index).id, true);
					selectItem(index, true);
//					trace("     index>=0");
				}
			} else {
				index++;
				if (index < _dataProvider.length) {
//					selectItem(_dataProvider.getItemAt(index).id, true);
					selectItem(index, true);
//					trace("     index < _dataProvider.length");
				} else {
//					trace("     index > _dataProvider.length");
				}
			}
//			trace("     index: " + index);
		}

	}

}
