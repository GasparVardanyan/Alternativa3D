package alternativa.gui.mouse {

	import alternativa.gui.controls.text.Label;
	import alternativa.gui.enum.EventPriority;
	import alternativa.gui.event.DragEvent;
	import alternativa.gui.event.HintEvent;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.dnd.IDrag;
	import alternativa.gui.mouse.dnd.IDragObject;
	import alternativa.gui.mouse.dnd.IDrop;
	import alternativa.gui.utils.MouseUtils;
	import alternativa.init.GUI;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.InteractiveObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.system.Capabilities;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;

	
	/**
	 * Класс MouseManager отслеживает мышиные действия: нажатие, наведение, драг'н'дроп, смена курсора.
	 * <p>Если на объект GUIObject навешан слушатель MouseEvent.CLICK, то его вызовет MouseManager. 
	 * Если вам нужно использовать метод browse() класса FileReference, придется повесить слушатель на stage, и остлеживать куда нажали. 
	 * Или положить в объект обычный Sprite и на него повесить слушателя.
	 * </p> 
	 * 
	 */	
	public class MouseManager extends Sprite {

//	[Inject]
//	public static var clientLog:IClientLog;
//	private static var CHANNEL:String = "MouseManager";

		// Единственный экземпляр
		private static var instance:MouseManager;
		
		private static var _stage:Stage;

		// Нужно проверить на что навели
		private var mouseMoved:Boolean = true;
		
		// вторая проверка, для второго EnterFrame
		private var mouseMovedPost:Boolean = false;

		// Нужно проверить на что навели
		private var mouseUnderStage:Boolean = true;

		// Список объектов под курсором, начиная с нижнего
		private var _objectsUnderCursor:Array;

		// Хинт
		private var hint:IHint;

		private var hintText:String;

		private var hintObject:DisplayObject;

		private var newHintObject:DisplayObject;
		
		// Контейнер для хинта
		private static var hintContainer:DisplayObjectContainer;

		// showHint вызвали внутри менеджера
		private var internalHintStart:Boolean;

		// Хинт принудительно показан
		private var forcedHintShow:Boolean;

		// Скрывание хинта по таймеру
		private var hideHintByTimeout:Boolean;

		// Скрывание хинта по нажатию клавиши на клавиатуре
		private var hideHintByKeyPress:Boolean;

		// Скрывание хинта по нажатию клавиши на клавиатуре
		private var hideHintByMouseClick:Boolean;

		private var showHintDelayTimer:Timer;

		private var hintTimeoutTimer:Timer;

		private static const hintOffsetLeft:int = 2;

		private static const hintOffsetRight:int = 12;

		private static const hintOffsetTop:int = 2;

		private static const hintOffsetBottom:int = 24;

		/**
		 * Объект, над которым находится курсор. 
		 */		
		public static var overed:DisplayObject;

		/**
		 * Объект, с которого перевели курсор на overed. 
		 */		
		internal static var oldOvered:DisplayObject;

		/**
		 * Иерархия объектов с установленным флагом over. 
		 */		
		internal static var overedTree:Array;

		/**
		 * Нажатый объект. 
		 */		
		public static var pressed:DisplayObject;
		
		/**
		 * Координаты курсора при нажатии. 
		 */		
		public static var pressCoords:Point;

		// Объект, на котором щёлкнули (устанавливается с задержкой после pressed)
		private var clicked:DisplayObject;

		// Подписчики на изменение координат мыши
		private var mouseCoordListeners:Array;

		// Подписчики на прокрутку колёсика
		private var mouseWheelListeners:Array;

		// Интервал для ожидания 2-го щелчка
		private var doubleClickInt:int = -1;

		// DnD

		// Расстояние от места клика, после которого включается перетаскивание
		private static const dragEnableDistance:Number = 2;

		private var dragged:IDrag;

		private var dropped:IDrop;

		private var dragOffset:Point;

		private var dragObject:IDragObject;

		// KEYBOARD

		private static var _ctrlKey:Boolean;

		private static var _altKey:Boolean;

		private static var _shiftKey:Boolean;
		
		// обычный комп или устройство тачскрин
		private var touch:Boolean = false;
		
		protected static var _enabled:Boolean = true;

		//public function MouseManager(container:DisplayObjectContainer) {
		public function MouseManager() {
			super();
			
			mouseCoordListeners = new Array();
			mouseWheelListeners = new Array();
			overedTree = new Array();

			_stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove, false, EventPriority.CURSOR_MANAGEMENT, false);
			_stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown, false, EventPriority.CURSOR_MANAGEMENT, false);
			_stage.addEventListener(Event.MOUSE_LEAVE, onMouseLeave, false, EventPriority.CURSOR_MANAGEMENT, false);
			_stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel, false, EventPriority.CURSOR_MANAGEMENT, false);

			_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);


		}

		private function writeToConsole(text:String):void {
			//clientLog.log(CHANNEL, text);
//        trace("Cursor " + text);
		}

		private function onKeyDown(e:KeyboardEvent):void {
			_ctrlKey = e.ctrlKey;
			_shiftKey = e.shiftKey;
			_altKey = e.altKey;

			// Скрываем хинт
			if (instance.hideHintByKeyPress) {
				_hideHint();

			}
		}

		private function onKeyUp(e:KeyboardEvent):void {
			_ctrlKey = e.ctrlKey;
			_shiftKey = e.shiftKey;
			_altKey = e.altKey;
		}

		/**
		 * Инициализация.
		 * @param stage Сцена. 
		 * 
		 */		
		public static function init(stage:Stage):void {
			if (instance == null) {
				// Создаём экземпляр курсора
				//instance = new MouseManager(container);
				_stage = stage;
				
				instance = new MouseManager();
				instance.mouseEnabled = false;
				instance.mouseChildren = false;
//				MouseManager.container = container;
				// проверка на тач экран
				if (Capabilities.touchscreenType != "none") {
					instance.touch = true;
				}
			
				// Установить координаты курсора
				var mx:int = _stage.mouseX;
				var my:int = _stage.mouseY;
				var coord:Point = instance.globalToLocal(new Point(mx, my));
				instance.x += coord.x;
				instance.y += coord.y;
	
				if (mx > 0 && mx < _stage.stageWidth && my > 0 && my < _stage.stageHeight) {
					instance.mouseMoved = true;
				}
			}
			//Mouse.hide();
		}

		/**
		 * Перепроверить список объектов под курсором.
		 */
		public static function update():void {
			instance.mouseMoved = true;
			instance.mouseMovedPost = true;
//			instance.onEnterFrame();
		}

		//   H I N T
		/**
		 * 
		 * @param container Контейнер для хинта. Данный контейнер должен использоваться только для хинта, в него нельзя добавлять элементы интерфейса.
		 * @param hint Графический объект хинта.
		 * 
		 */		
		public static function setHintImaging(container:DisplayObjectContainer, hint:IHint):void {
			if (instance != null && container != null && hint != null) {
				hintContainer = container;
				hintContainer.mouseEnabled = false;
				hintContainer.mouseChildren = false;
				hintContainer.tabEnabled = false;
				hintContainer.tabChildren = false;
				hintContainer.addChild(instance);
				
				if (instance.showHintDelayTimer == null) {
					instance.showHintDelayTimer = new Timer(CursorDelay.SHOW_HINT_DELAY, 1);
					instance.showHintDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, instance.hintDelayComplete);
				}
				
				if (instance.hintTimeoutTimer == null) {
					instance.hintTimeoutTimer = new Timer(CursorDelay.HINT_TIMEOUT, 1);
					instance.hintTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, instance.hintTimeout);
				}
				
				instance.hint = hint;
			}
		}

		// Запуск таймера для показа хинта
		private function startHintDelay():void {
//    	writeToConsole("startHintDelay");
			if (hint != null) {

				stopHintTimers();

				if (DisplayObject(hint).parent == null) {
					if (ICursorActive(hintObject).hint != "" && ICursorActive(hintObject).hint != null) {
						showHintDelayTimer.reset();
						showHintDelayTimer.start();
					}
				} else {
					if (ICursorActive(hintObject).hint != "" && ICursorActive(hintObject).hint != null) {
						updateHint(ICursorActive(hintObject).hint);
					} else {
						_hideHint();
					}
				}
			}
		}

		// Задержка показа хинта прошла
		private function hintDelayComplete(e:TimerEvent = null):void {
//    	writeToConsole("hintDelayComplete");
			internalHintStart = true;
			showHint(ICursorActive(hintObject).hint, hintObject, true, true, true);
		}

		/**
		 * Показать хинт принудительно. 
		 * @param text Текст хинта.
		 * @param object Объект, у которого показать хинт.
		 * @param hideByTimeout Прятать хинт после окончания времени.
		 * @param hideByKeyPress Прятать хинт при нажатии на клавишу клавиатуры.
		 * @param hideByMouseClick Прятать хинт при нажатии на клавижу мыши.
		 * 
		 */		
		public static function showHint(text:String, object:DisplayObject = null, hideByTimeout:Boolean = true, hideByKeyPress:Boolean = false, hideByMouseClick:Boolean = true):void {
//		instance.writeToConsole("showHint");
//		instance.writeToConsole("     text: " + text);
//		instance.writeToConsole("     object: " + object);
//		instance.writeToConsole("     hideByTimeout: " + hideByTimeout);
//		instance.writeToConsole("     hideByKeyPress: " + hideByKeyPress);
//		instance.writeToConsole("     hideByMouseClick: " + hideByMouseClick);
//		instance.writeToConsole("     internalHintStart: " + instance.internalHintStart);

			instance.forcedHintShow = !instance.internalHintStart;
			instance.internalHintStart = false;

			instance.stopHintTimers();

			if (instance.hint != null) {

				instance.hintObject = object;
				instance.hideHintByTimeout = hideByTimeout;
				instance.hideHintByKeyPress = hideByKeyPress;
				instance.hideHintByMouseClick = hideByMouseClick;
				instance.hint.text = (text != null) ? text : "";

				if (text != null && text != "") {

					instance.hint.visible = false;

					var hintDisplayObject:DisplayObject = DisplayObject(instance.hint);

					if (object == null || !instance.forcedHintShow) {
						if (!instance.contains(hintDisplayObject)) {
							if (hintDisplayObject.parent != null) {
								hintDisplayObject.parent.removeChild(hintDisplayObject);
							}
							instance.addChild(hintDisplayObject);
						}
					} else {
						if (!hintContainer.contains(hintDisplayObject)) {
							if (hintDisplayObject.parent != null) {
								hintDisplayObject.parent.removeChild(hintDisplayObject);
							}
							//IClientLog(OSGi.getInstance().getService(IClientLog)).log(CHANNEL, "hint added to %1", container);
							hintContainer.addChild(hintDisplayObject);
						}
					}
					instance.posHint();

					instance.hint.visible = true;

					// Скрываем по таймеру
					if (hideByTimeout) {
						instance.hintTimeoutTimer.reset();
						instance.hintTimeoutTimer.start();
					}
				} else {
					_hideHint();
				}
			}
		}

		/**
		 * Скрыть хинт. 
		 * @param forced Мгновенно или по окончанию времени.
		 * 
		 */		
		public static function hideHint(forced:Boolean = false):void {
			if (forced || (instance.forcedHintShow && instance.hint != null && !instance.hideHintByTimeout)) {
				_hideHint();
			}
		}

		private static function _hideHint():void {
//		instance.writeToConsole("hideHint");
			if (instance.hint != null) {

				instance.stopHintTimers();

				var hintDisplayObject:DisplayObject = DisplayObject(instance.hint);
				var hintContainer:DisplayObjectContainer = hintDisplayObject.parent;
				if (hintContainer != null) {
					hintContainer.removeChild(hintDisplayObject);
				}
				instance.hintObject = null;

				if (instance.forcedHintShow) {
					instance.forcedHintShow = false;
					update();
				}

				// Рассылка события
				if (instance.hint is EventDispatcher) {
					if (EventDispatcher(instance.hint).hasEventListener(HintEvent.HIDE)) {
						EventDispatcher(instance.hint).dispatchEvent(new HintEvent(HintEvent.HIDE));
					}
				}
			}
		}

		/**
		 * Обновить хинт. 
		 * @param text Текст хинта.
		 * 
		 */		
		public static function updateHint(text:String):void {
//		instance.writeToConsole("updateHint: " + text);
			if (instance.hint != null) {
				instance.hint.text = text;
				instance.posHint();
			}
		}

		// Время показа хинта вышло
		private function hintTimeout(e:TimerEvent = null):void {
//    	writeToConsole("hintTimeout");
			stopHintTimers();

			_hideHint();
		}

		private function stopHintTimers():void {
//    	writeToConsole("stopHintTimers");
			showHintDelayTimer.stop();
			hintTimeoutTimer.stop();
		}

		// Позиционирование хинта
		private function posHint():void {
//    	writeToConsole("posHint");
			if (hint != null) {
				if (forcedHintShow && hintObject != null) {
//        		writeToConsole("   posByObject");
					// Позиционирование по объекту
					var object:DisplayObject = DisplayObject(hintObject);
					var objectCenter:Point = object.localToGlobal(new Point(object.width >> 1, object.height >> 1));
					var hintCoord:Point = new Point();

					if (hint.width + objectCenter.x > _stage.stageWidth) {
						hintCoord.x = objectCenter.x - hint.width;
					} else {
						hintCoord.x = objectCenter.x;
					}
					if (hint.height + objectCenter.y > _stage.stageHeight) {
						hintCoord.y = objectCenter.y - hint.height;
					} else {
						hintCoord.y = objectCenter.y;
					}
					hintCoord = hintContainer.globalToLocal(hintCoord);

					hint.x = hintCoord.x;
					hint.y = hintCoord.y;
				} else {
//        		writeToConsole("   posByCursor");
					// Позиционирование по курсору
					var hintSize:Point = localToGlobal(new Point(hint.width, hint.height));
					if (hintSize.x + hintOffsetRight > _stage.stageWidth) {
						hint.x = -hintOffsetLeft - hint.width;
					} else {
						hint.x = hintOffsetRight;
					}
					if (hintSize.y + hintOffsetBottom > _stage.stageHeight) {
						hint.y = -hintOffsetTop - hint.height;
					} else {
						hint.y = hintOffsetBottom;
					}
				}
					//IClientLog(OSGi.getInstance().getService(IClientLog)).log(CHANNEL, "hint coords: %1, %2", DisplayObject(hint).x, DisplayObject(hint).y);
			}
		}

		//   L I S T E N E R S
		/**
		 * Добавить слушателя хинта.  
		 * @param eventType Тип хинта.
		 * @param eventHandler Метод, вызывающийся при получении события.
		 * 
		 */		
		public static function addHintListener(eventType:String, eventHandler:Function):void {
			if (instance.hint != null && instance.hint is EventDispatcher) {
				EventDispatcher(instance.hint).addEventListener(eventType, eventHandler);
			}
		}
		
		/**
		 * Убрать слушателя хинта.  
		 * @param eventType Тип хинта.
		 * @param eventHandler Метод, вызывающийся при получении события.
		 * 
		 */		
		public static function removeHintListener(eventType:String, eventHandler:Function):void {
			if (instance.hint != null && instance.hint is EventDispatcher) {
				EventDispatcher(instance.hint).removeEventListener(eventType, eventHandler);
			}
		}

		/**
		 * Добавить слушателя изменения координат мыши.
		 */
		public static function addMouseCoordListener(listener:IMouseCoordListener):void {
			if (instance.mouseCoordListeners.indexOf(listener) == -1) {
				instance.mouseCoordListeners.push(listener);
			}
		}

		/**
		 * Удалить слушателя изменения координат мыши.
		 */
		public static function removeMouseCoordListener(listener:IMouseCoordListener):void {
			var index:int = instance.mouseCoordListeners.indexOf(listener);
			if (index != -1) {
				instance.mouseCoordListeners.splice(index, 1);
			}
		}

		/**
		 * Добавить слушателя прокрутки колесика мыши.
		 * 
		 */
		public static function addMouseWheelListener(listener:IMouseWheelListener):void {
			if (instance.mouseWheelListeners.indexOf(listener) == -1) {
				instance.mouseWheelListeners.push(listener);
			}
		}

		/**
		 * Удалить слушателя прокрутки колесика мыши.
		 * 
		 */
		public static function removeMouseWheelListener(listener:IMouseWheelListener):void {
			var index:int = instance.mouseWheelListeners.indexOf(listener);
			if (index != -1) {
				instance.mouseWheelListeners.splice(index, 1);
			}
		}

		private function onMouseMove(e:MouseEvent):void {
			//writeToConsole("onMouseMove");
			//trace("onMouseMove");
			mouseMoved = true;
			mouseUnderStage = true;

			//onEnterFrame();
		}

		// При перемещении
		private function onEnterFrame(e:Event = null):void {
			newHintObject = null;

			if (mouseMoved || mouseMovedPost) {
//			if (mouseMoved) {
//				writeToConsole(" ");
//				writeToConsole("mouseMoved");

				mouseMovedPost = mouseMoved && mouseMovedPost;
				mouseMoved = false;

				// Курсор в пределах Stage
				if (mouseUnderStage) {
					// Установить координаты курсора
					var coord:Point = globalToLocal(new Point(_stage.mouseX, _stage.mouseY));
					x += coord.x;
					y += coord.y;

					// Изменяем координаты хинта
					if (hint != null) {
						if (DisplayObject(hint).parent != null) {
							posHint();
						}
					}

					// Сбор объектов под курсором
					var objectsUnderPoint:Array = _stage.getObjectsUnderPoint(new Point(x, y));
//					var objectsUnderPoint:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));


					// Удаление из списка графики хинта
					var index:int = objectsUnderPoint.indexOf(hint);
					if (index != -1)
						objectsUnderPoint.splice(index, 1);
				} else {
					objectsUnderPoint = [];
				}

				_objectsUnderCursor = objectsUnderPoint;



				var newTree:Array;
				var diffTree:Array;
				// Анализ объектов под курсором
				if (objectsUnderPoint.length > 0) {
					writeToConsole("objectsUnderPoint: " + objectsUnderPoint);
					index = objectsUnderPoint.length - 1;
					var activeObject:DisplayObject;

					while (activeObject == null && index >= 0) {
						if (objectsUnderPoint[index] is ICursorActive) {
							writeToConsole("   is ICursorActive: " + objectsUnderPoint[index]);
							// Сохранение объекта для показа хинта
							if (!instance.forcedHintShow) {
								newHintObject = objectsUnderPoint[index];
							}

							if (ICursorActive(objectsUnderPoint[index]).cursorActive) {
								// активный объект найден
								activeObject = objectsUnderPoint[index];
							} else {
								// поиск активного объекта среди родителей текущего
								activeObject = findActiveParent(DisplayObject(objectsUnderPoint[index]));
							}
						} else if (objectsUnderPoint[index] is InteractiveObject) {
							writeToConsole("   is InteractiveObject: " + objectsUnderPoint[index]);
							if (InteractiveObject(objectsUnderPoint[index]).mouseEnabled) {
								// активный объект найден
								activeObject = objectsUnderPoint[index];
							} else {
								// поиск активного объекта среди родителей текущего
								activeObject = findActiveParent(DisplayObject(objectsUnderPoint[index]));
							}
						} else {
							// поиск активного объекта среди родителей текущего
							activeObject = findActiveParent(DisplayObject(objectsUnderPoint[index]));
						}
						index--;
					}
					if (activeObject != null) {
					}
//					              trace("activeObject: " + activeObject);
//								  trace("overed: " + overed);
//              writeToConsole("activeObject: " + activeObject);
//			  writeToConsole("overed: " + overed);
					if (activeObject != null) {

						if (overed == null) {
							// over
							newTree = arrangeOveredTree(activeObject);
							diffTree = getDifferenceTree(newTree, overedTree);
							overedTree = newTree;
							over(diffTree, activeObject);
						} else {
							if (overed != activeObject) {
								// out-over
								var oldTree:Array = overedTree.concat();

								newTree = arrangeOveredTree(activeObject);
								diffTree = getDifferenceTree(overedTree, newTree);
								overedTree = newTree;
								out(diffTree, activeObject);

								diffTree = getDifferenceTree(newTree, oldTree);
								over(diffTree, activeObject);
							}
						}
					} else {
						if (overed != null) {
							// out
							diffTree = getDifferenceTree(overedTree, new Array());
							overedTree = new Array();
							out(diffTree);
						}
					}
					// Рассылка наведения
					if (overed != null) {
						if (overed is EventDispatcher && overed is ICursorActive) {
							if ((overed as EventDispatcher).hasEventListener(MouseEvent.MOUSE_MOVE)) {
								var localCoords:Point = (overed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
								(overed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_MOVE, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true));
							}
						}
					}

				} else {
					// Навели на пустое место
					/*writeToConsole("   Навели на пустое место");
					// Скрываем хинт
					writeToConsole("        hideHintByTimeout: " + hideHintByTimeout);
					if (instance.hideHintByTimeout && instance.hintObject == null) {
						_hideHint();
					}*/
					if (overed != null) {
						// out
						diffTree = getDifferenceTree(overedTree, new Array());
						overedTree = new Array();
						out(diffTree);
					}
				}

				if (!instance.forcedHintShow) {
					// Запуск хинта
					if (newHintObject != null) {
//            		writeToConsole("newHintObject: " + newHintObject);
//            	 	writeToConsole("hintObject: " + hintObject);
						if (hintObject != newHintObject) {
							hintObject = newHintObject;
							startHintDelay();
						}
					} else {
						_hideHint();
					}
				}

				// Рассылка изменения координат мыши
				for (var i:int = 0; i < mouseCoordListeners.length; i++) {
					var mouseCoordListener:IMouseCoordListener = IMouseCoordListener(mouseCoordListeners[i]);
					mouseCoordListener.mouseMove(new Point(_stage.mouseX, _stage.mouseY));
				}
					//writeToConsole("overed: " + overed);
			}
		}

		// Поиск активного объекта среди родителей заданного (ICursorActive и InteractiveObject)
		private function findActiveParent(object:DisplayObject):DisplayObject {
			writeToConsole("findActiveParent");
			var activeObject:DisplayObject;
			var currentParent:DisplayObject = object.parent;
			writeToConsole("   target object: " + object);



			// Перебираем родителей
			while (currentParent != null && currentParent != _stage && activeObject == null) {
				writeToConsole("   currentParent: " + currentParent);
				// Если активный
				if (currentParent is ICursorActive) {
					// Сохранение объекта для показа хинта
					if (!instance.forcedHintShow) {
						newHintObject = currentParent;
					}

					if (ICursorActive(currentParent).cursorActive) {
						if (dragged != null) {
							if (currentParent != dragged)
								activeObject = currentParent;
						} else {
							activeObject = currentParent;
						}
					}
				} else if (currentParent is InteractiveObject) {
					if (InteractiveObject(currentParent).mouseEnabled) {
						if (dragged != null) {
							if (currentParent != dragged)
								activeObject = currentParent;
						} else {
							activeObject = currentParent;
						}
					}
				}
				currentParent = currentParent.parent;
			}
			return activeObject;
		}

		/**
		 * Составить иерархию активных объектов от объекта получившего наведение
		 * @param overObject объект под курсором
		 * @return иерархия объектов (ICursorActive и InteractiveObject)
		 */
		private function arrangeOveredTree(overObject:DisplayObject):Array {
			var tree:Array = new Array(overObject);
			var currentParent:DisplayObject = DisplayObject(overObject).parent;
			// Перебираем родителей
			while (currentParent != null) {
				// Если активный
				if (currentParent is ICursorActive) {
					if (ICursorActive(currentParent).cursorActive) {
						tree.push(currentParent);
					}
				} else if (currentParent is InteractiveObject) {
					if (InteractiveObject(currentParent).mouseEnabled) {
						tree.push(currentParent);
					}
				}
				currentParent = currentParent.parent;
			}
			return tree;
		}

		/**
		 * Составить дерево объектов из tree1, которых нет в tree2
		 * @param tree1 дерево объектов 1
		 * @param tree2 дерево объектов 2
		 * @return дерево разницы между tree1 и tree2
		 */
		private function getDifferenceTree(tree1:Array, tree2:Array):Array {
			var tree:Array = new Array();
			var i:int = 0;
			var stop:Boolean = false;
			while (i < tree1.length && !stop) {
				if (tree2.indexOf(tree1[i]) == -1) {
					tree.push(tree1[i]);
				} else {
					stop = true;
				}
				i++;
			}
			return tree;
		}

		private function over(diffTree:Array, overObject:DisplayObject):void {
			writeToConsole("over: " + overObject);
//        trace("over: " + overObject);
			// Сохранение наведения
			if (overed != null) {
				oldOvered = overed;
			}
			overed = overObject;

//        trace("dragged: " + dragged);
			if (dragged != null) {
				// Ищем и устанавливаем дроп-объект вверх от наведённого
				var newDropped:IDrop = getDropObject(overed as ICursorActive);

				// Если найден новый
				if (newDropped != dropped) {
					// Сохраняем новый дроп
					dropped = newDropped;
//                    trace("dropped: " + dropped);
					// Устанавливаем дроп курсор
					//change(DROP);
					// Отсылаем событие о затаскивании
					var local:Point = MouseUtils.localCoords(DisplayObject(dropped));
					EventDispatcher(dropped).dispatchEvent(new DragEvent(DragEvent.OVER, dragObject, local.x, local.y));
				}
			} else {
				// Смена курсора
//				change(overed.cursorOverType);
			}

			// Запускаем хинт объекта, если есть
			/*if (overed != null && overed is ICursorActive) {
				startHint(ICursorActive(overed));
			}*/ /*else {
				_hideHint();
			}*/
			
			if(overed != null) {
				if (overed is ICursorActive) {
					if (ICursorActive(overed).cursorActive) {
						CursorManager.cursorType = (overed as ICursorActive).cursorType;
						
					}
				}
			}
			
			// Рассылка события
			/* При вложенности элементов, события рассылается родителям данного объекта
			 * */
			if (!touch) {
				for (var t:int = 0; t < diffTree.length; t++) {
					if (diffTree[t] is ICursorActive && ICursorActive(diffTree[t]).cursorActive) {
						var listeners:Array = ICursorActive(diffTree[t]).cursorListeners;
						for (var i:int = 0; i < listeners.length; i++) {
							var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
							if (listener.over != true) {
								listener.over = true;
							}
						}
					}
				}
			}
			if (overed is EventDispatcher && overed is ICursorActive) {
				if ((overed as EventDispatcher).hasEventListener(MouseEvent.ROLL_OVER)) {
					var localCoords:Point = (overed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
					(overed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.ROLL_OVER, true, false, localCoords.x, localCoords.y, oldOvered as InteractiveObject, _ctrlKey, _altKey, _shiftKey, true));
				}
			}
		}

		private function out(diffTree:Array, overObject:DisplayObject = null):void {
			writeToConsole("out: " + overed);

			// Отмена запуска хинта
			//hintTimeout();

			// Рассылка события
			if (!touch) {
				for (var t:int = 0; t < diffTree.length; t++) {
					if (diffTree[t] is ICursorActive && ICursorActive(diffTree[t]).cursorActive) {
						var listeners:Array = ICursorActive(diffTree[t]).cursorListeners;
						for (var i:int = 0; i < listeners.length; i++) {
							var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
							if (listener.over != false) {
								listener.over = false;
								CursorManager.reset();
							}
						}
					}
				}
			}
			if (overed is EventDispatcher && overed is ICursorActive) {
				if ((overed as EventDispatcher).hasEventListener(MouseEvent.ROLL_OUT)) {
					var localCoords:Point = (overed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
					(overed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.ROLL_OUT, true, false, localCoords.x, localCoords.y, overObject as InteractiveObject, _ctrlKey, _altKey, _shiftKey, true));
				}
			}

			oldOvered = overed;

			overed = null;

			// Если есть дроп
			if (dropped != null) {
				// Ищем дроп над объектом куда сводимся
				var newDropped:IDrop = getDropObject(overObject as ICursorActive);

				// Если дроп сменился или его вообще нет
				if (newDropped != dropped) {
					// Восстанавливаем курсор драга
					//change(DRAG);

					// Отсылаем событие о стаскивании
					var local:Point = MouseUtils.localCoords(DisplayObject(dropped));
					EventDispatcher(dropped).dispatchEvent(new DragEvent(DragEvent.OUT, dragObject, local.x, local.y));

					// Очищаем дроп
					dropped = null;
				}
			}
		}

		// Нахождение дроп-объекта выше начиная с текущего
		// null, если не найден
		private function getDropObject(object:ICursorActive):IDrop {
			var drop:IDrop = null;
			if (object != null) {
				// Проверяем с текущего вверх на функционал дропа
				var current:DisplayObject = DisplayObject(object);
				while (current != null) {
					// Если объект может принимать объекты и объект не тащим сам на себя
					if (current is IDrop && current != dragged) {
						//if (current is IDrop) {
						// Проверяем возможность приёма
						if (IDrop(current).canDrop(dragObject)) {
							// Нашли
							drop = IDrop(current);
							break;
						}
					}
					current = current.parent;
				}
			}
			return drop;
		}


		private function notDoubleClick():void {
			clearInterval(doubleClickInt);
			doubleClickInt = -1;

			if (clicked != null && pressed == null) {
				onClick();
			}
		}

		// Двойной щелчок (по 2-му нажатию)
		private function onDoubleClick():void {
			if (clicked is ICursorActive) {
				// Рассылка события
				if (ICursorActive(clicked).cursorActive) {
					var listeners:Array = (clicked as ICursorActive).cursorListeners;
					for (var i:int = 0; i < listeners.length; i++) {
						var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
						listener.doubleClick();
					}
				}
				if (clicked is EventDispatcher) {
					if ((clicked as EventDispatcher).hasEventListener(MouseEvent.DOUBLE_CLICK)) {
						var localCoords:Point = (clicked as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
						(clicked as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.DOUBLE_CLICK, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true));
					}
				}
			}
			clicked = null;

		}

		// Рассылка клика
		private function onClick():void {
			writeToConsole("onClick clicked: " + clicked);
			if (clicked != null) {
				// Рассылка события
				if (clicked is ICursorActive) {
					if (ICursorActive(clicked).cursorActive) {
						var listeners:Array = (clicked as ICursorActive).cursorListeners;
						for (var i:int = 0; i < listeners.length; i++) {
							var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
							listener.click();
						}
					}
					var dispatch:Boolean;
					if (clicked is InteractiveObject) {
						if (!InteractiveObject(clicked).mouseEnabled) {
							if ((clicked as EventDispatcher).hasEventListener(MouseEvent.CLICK)) {
								dispatch = true;
							}
						}
					} else if (clicked is EventDispatcher) {
						if ((clicked as EventDispatcher).hasEventListener(MouseEvent.CLICK)) {
							dispatch = true;
						}
					}
					if (dispatch) {
						writeToConsole("onClick dispatchEvent from " + clicked);
						var localCoords:Point = (clicked as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
						(clicked as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.CLICK, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true));
					}
				}
				clicked = null;
			}
		}

		// При нажатии
		private function onMouseDown(e:MouseEvent):void {
			//writeToConsole("onMouseDown target: " + e.target);
			//trace("onMouseDown target: " + e.target);
			
			// Если тачдисплей, то делаем обновление, чтобы объект выделился, на который нажали
			if (touch) {
				update();
				onEnterFrame(null);
			}
			
			pressCoords = new Point(e.localX, e.localY);
			
			if (pressed == null) { // && pressed != overed) {
				// Сохраняем нажатый объект
				pressed = overed;
				writeToConsole("pressed: " + pressed);
				if (pressed is ICursorActive) {
					writeToConsole("pressed hint: " + (pressed as ICursorActive).hint);
				}

				// Если есть активный объект
				if (pressed != null) {
					// Смена фокуса
					/*if (pressed is InteractiveObject) {
					 if ((pressed as InteractiveObject).tabEnabled) {
					 stage.focus = pressed as InteractiveObject;
					 }
					 }*/

					// Рассылка нажатия
					if (pressed is ICursorActive) {
						var listeners:Array = ICursorActive(pressed).cursorListeners;
						for (var i:int = 0; i < listeners.length; i++) {
							var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
							listener.pressed = true;
						}
						var dispatch:Boolean;
						if (clicked is InteractiveObject) {
							if (!InteractiveObject(clicked).mouseEnabled) {
								if ((clicked as EventDispatcher).hasEventListener(MouseEvent.MOUSE_DOWN)) {
									dispatch = true;
								}
							}
						} else if (clicked is EventDispatcher) {
							if ((clicked as EventDispatcher).hasEventListener(MouseEvent.MOUSE_DOWN)) {
								dispatch = true;
							}
						}
						if (dispatch) {
							writeToConsole("onMouseDown dispatchEvent from " + pressed);
							var localCoords:Point = (pressed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
							(pressed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_DOWN, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true));
						}
					}
					
					// проверка на двойной клик - doubleClickEnabled
					if (pressed is InteractiveObject) {
						if ((pressed as InteractiveObject).doubleClickEnabled) {
							// 1-й щелчок
							if (doubleClickInt == -1) {
								clicked = pressed;
								// Установка ожидания 2-го щелчка
								clearInterval(doubleClickInt);
								doubleClickInt = -1;
								doubleClickInt = setInterval(notDoubleClick, CursorDelay.DOUBLE_CLICK_DELAY);
							} else {
								// 2-й щелчок
								clearInterval(doubleClickInt);
								doubleClickInt = -1;
								// Рассылка двойного щелчка
								onDoubleClick();
							}
						} else {
							clicked = pressed;
						}
					} 
					
					/*// 1-й щелчок
					if (doubleClickInt == -1) {
						clicked = pressed;
						// Установка ожидания 2-го щелчка
						clearInterval(doubleClickInt);
						doubleClickInt = -1;
						doubleClickInt = setInterval(notDoubleClick, CursorDelay.DOUBLE_CLICK_DELAY);
					} else {
						// 2-й щелчок
						clearInterval(doubleClickInt);
						doubleClickInt = -1;
						// Рассылка двойного щелчка
						onDoubleClick();
					}*/
					// Если объект таскаемый, сохраняем точку привязки
					if (pressed is IDrag) {
						if (IDrag(pressed).isDragable()) {
							dragOffset = MouseUtils.localCoords(DisplayObject(pressed));
							// Переподписывание обработчиков
							_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
							_stage.addEventListener(MouseEvent.MOUSE_MOVE, onStartDrag);
						}
					}

					// Подписываемся на отжатие
					_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				}
				// Скрываем хинт
				if (hideHintByMouseClick) {
					_hideHint();
				}
			}
		}

		// При отпускании
		private function onMouseUp(e:MouseEvent):void {
//    	trace("onMouseUp target: " + e.target);
			// Отписываемся от события мыши
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			// Если было включено перетаскивание
//        trace("dragOffset: " + dragOffset);
			if (dragOffset != null) {
				// Сбрасываем точку привязки
				dragOffset = null;
				// Переподписывание обработчиков
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStartDrag);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			}

			// Проверка на клик
			if (overed == pressed && clicked != null) {
				if (doubleClickInt == -1) {
					onClick();
				}
			} else {
				clicked = null;
			}

			// Рассылка события
			if (pressed != null) {
				if (pressed is ICursorActive) {
					if (ICursorActive(pressed).cursorActive) {
						var listeners:Array = ICursorActive(pressed).cursorListeners;
						for (var i:int = 0; i < listeners.length; i++) {
							var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
							listener.pressed = false;
						}
					}
					if (pressed is EventDispatcher) {
						if ((pressed as EventDispatcher).hasEventListener(MouseEvent.MOUSE_UP)) {
							var localCoords:Point = (pressed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
							(pressed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true));
						}
					}
				}
				// Удаляем информацию о нажатом объекте
				pressed = null;
			}
		}

		// Начать перетаскивание
		private function onStartDrag(e:MouseEvent):void {
			onMouseMove(e);

			// Ищем расстояние от точки привязки
			var dist:Number = Point.distance(dragOffset, MouseUtils.localCoords(DisplayObject(pressed)));
			// Если расстояние больше указанного, включаем перетаскивание
			if (dist > dragEnableDistance) {
				//trace("startDrag");
				// Переподписываем движение мыши
				_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onStartDrag);
				_stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				_stage.addEventListener(MouseEvent.MOUSE_MOVE, onDrag);
				_stage.addEventListener(MouseEvent.MOUSE_UP, onDrop);

				// Сохраняем перетаскиваемый объект
				dragged = IDrag(pressed);

				// Разблокируем курсор
//            unlock();
				// Включаем курсор перетаскивания
				CursorManager.showCursor(CursorManager.HAND);

				//Сбрасываем флаг нажатия для объекта
				var listeners:Array = (pressed as ICursorActive).cursorListeners;
				for (var i:int = 0; i < listeners.length; i++) {
					var listener:ICursorActiveListener = ICursorActiveListener(listeners[i]);
					if (listener.pressed != false) {
						listener.pressed = false;
					}
					if (listener.over != false) {
						listener.over = false;
					}
				}

				// Сохраняем драг-объект
				dragObject = dragged.getDragObject();

				// Добавляем вид перетаскиваемого объекта
				addChildAt(dragObject.graphicObject, 0);

				// Смещаем графику
				dragObject.graphicObject.x -= dragOffset.x;
				dragObject.graphicObject.y -= dragOffset.y;

				// Сообщаем о начале перетаскивания
				EventDispatcher(dragged).dispatchEvent(new DragEvent(DragEvent.START, dragObject, dragOffset.x, dragOffset.y));

				// Подписываемся на отмену драга по Esc
//            if (IOInterfaces.keyboardAvailable) {
//                _keyFiltersConfig.addKeyUpFilter(escFilter, KEY_ACTION_CANCEL_DRAG);
//                IOInterfaces.keyboardManager.addKeyboardListener(this);
//            }

				// Сбрасываем нажатый объект
				pressed = null;
				overed = null;
				// Сбрасываем точку привязки
				dragOffset = null;
			}
		}

		// Тащим объект
		private function onDrag(e:MouseEvent):void {
			onMouseMove(e);
		}

		// Бросаем перетаскиваемый объект
		private function onDrop(e:MouseEvent = null):void {
//        trace("onDrop");
			// Если есть дроп-объект
//        trace("dropped: " + dropped);
			if (dropped != null) {
				// Рассылаем от таскаемого объекта, что его утащили
				EventDispatcher(dragged).dispatchEvent(new DragEvent(DragEvent.STOP, dragObject));
				// Рассылаем от дропа о приёмке объекта
				var local:Point = MouseUtils.localCoords(DisplayObject(dropped));
				// передаем объекту данные
				dropped.drop(dragObject);
				EventDispatcher(dropped).dispatchEvent(new DragEvent(DragEvent.DROP, dragObject, local.x, local.y));

				// Скрываем хинт
				// hideHint();



				// Удаляем информацию о дроп-объекте
				dropped = null;
				overed = null;
				update();
			} else {
				// Рассылаем отмену драга
				EventDispatcher(dragged).dispatchEvent(new DragEvent(DragEvent.CANCEL, dragObject));
			}

			// Удаляем графику таскаемого объекта
			if (dragObject.graphicObject != null) {
				if (contains(dragObject.graphicObject)) {
					removeChild(dragObject.graphicObject);
				}
				// Удаляем драг-объект
				dragObject = null;
			}

			// Удаляем информацию о таскаемом объекте
			dragged = null;

			// Разблокируем курсор
//        unlock();
			CursorManager.hideCursor();
			// Меняем курсор на наведенный
			if (overed != null && overed is ICursorActive) {
				CursorManager.cursorType = ICursorActive(overed).cursorType;
			} else {
				CursorManager.cursorType = CursorManager.ARROW;
			}

			// Переподписываем движение мыши
			_stage.removeEventListener(MouseEvent.MOUSE_MOVE, onDrag);
			_stage.removeEventListener(MouseEvent.MOUSE_UP, onDrop);
			_stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			_stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);

			// Отписываемся от отмены драга по Esc
//        if (IOInterfaces.keyboardAvailable) {
//            IOInterfaces.keyboardManager.removeKeyboardListener(this);
//            _keyFiltersConfig.removeKeyUpFilter(escFilter);
//        }
		}

		private function cancelDrag():void {
			dropped = null;
			onDrop();
		}

		// Прокрутка колёсика
		private function onMouseWheel(e:MouseEvent):void {
			writeToConsole("onMouseWheel target: " + e.target);
			// Рассылка слушателям
			for (var i:int = 0; i < mouseWheelListeners.length; i++) {
				var mouseWheelListener:IMouseWheelListener = IMouseWheelListener(mouseWheelListeners[i]);
				mouseWheelListener.mouseWheel(e.delta);
			}
			if (overed != null) {
				if (overed is EventDispatcher && overed is ICursorActive && ICursorActive(overed).cursorActive) {
					if ((overed as EventDispatcher).hasEventListener(MouseEvent.MOUSE_WHEEL)) {
						var localCoords:Point = (overed as DisplayObject).globalToLocal(new Point(mouseX, mouseY));
						(overed as EventDispatcher).dispatchEvent(new MouseEvent(MouseEvent.MOUSE_WHEEL, true, false, localCoords.x, localCoords.y, null, _ctrlKey, _altKey, _shiftKey, true, e.delta));
					}
				}
			}
			update();
			onEnterFrame();
			writeToConsole("onMouseWheel end!!!!!");
		}



		// При уходе мыши со сцены
		private function onMouseLeave(e:Event):void {
			writeToConsole("onMouseLeave");
			mouseMoved = true;
			mouseUnderStage = false;
			onEnterFrame();
		}

		/**
		 * Объекты под курсором.
		 */
		public static function get objectsUnderCursor():Array {
			return instance._objectsUnderCursor;
		}

		public static function get ctrlKey():Boolean {
			return _ctrlKey;
		}

		public static function get altKey():Boolean {
			return _altKey;
		}

		public static function get shiftKey():Boolean {
			return _shiftKey;
		}
		
		/**
		 * Включение/отключение MouseManager. 
		 * 
		 */
		public static function get enabled():Boolean {
			return _enabled;
		}
		public static function set enabled(value:Boolean):void {
			if (value != _enabled) {
				if (_enabled) {
					_stage.removeEventListener(Event.ENTER_FRAME, instance.onEnterFrame);
					
					_stage.removeEventListener(MouseEvent.MOUSE_MOVE, instance.onMouseMove, false);
					_stage.removeEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown, false);
					_stage.removeEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave, false);
					_stage.removeEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel, false);
					
					_stage.removeEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
					_stage.removeEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);
					
					if (hintContainer != null) {
						instance.showHintDelayTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, instance.hintDelayComplete);
						instance.hintTimeoutTimer.removeEventListener(TimerEvent.TIMER_COMPLETE, instance.hintTimeout);
					}
					
				} else {
					_stage.addEventListener(Event.ENTER_FRAME, instance.onEnterFrame);
					
					_stage.addEventListener(MouseEvent.MOUSE_MOVE, instance.onMouseMove, false, EventPriority.CURSOR_MANAGEMENT, false);
					_stage.addEventListener(MouseEvent.MOUSE_DOWN, instance.onMouseDown, false, EventPriority.CURSOR_MANAGEMENT, false);
					_stage.addEventListener(Event.MOUSE_LEAVE, instance.onMouseLeave, false, EventPriority.CURSOR_MANAGEMENT, false);
					_stage.addEventListener(MouseEvent.MOUSE_WHEEL, instance.onMouseWheel, false, EventPriority.CURSOR_MANAGEMENT, false);
					
					_stage.addEventListener(KeyboardEvent.KEY_DOWN, instance.onKeyDown);
					_stage.addEventListener(KeyboardEvent.KEY_UP, instance.onKeyUp);
					if (hintContainer != null) {
						instance.showHintDelayTimer.addEventListener(TimerEvent.TIMER_COMPLETE, instance.hintDelayComplete);
						instance.hintTimeoutTimer.addEventListener(TimerEvent.TIMER_COMPLETE, instance.hintTimeout);
					}
				}
				_enabled = value;
			}
		}
	}
}
