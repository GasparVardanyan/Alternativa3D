package alternativa.editor {
	import alternativa.editor.eventjournal.EventJournal;
	import alternativa.editor.eventjournal.EventJournalItem;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.scene.CursorScene;
	import alternativa.editor.scene.EditorScene;
	import alternativa.editor.scene.MainScene;
	import alternativa.editor.scene.OccupyMap;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.utils.KeyboardUtils;
	
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.ui.Keyboard;
	import flash.utils.setTimeout;
	
	import mx.controls.Alert;
	import mx.core.UIComponent;
	import mx.events.CloseEvent;

	public class SceneContainer extends UIComponent {
		// Сцена с курсором
		public var cursorScene:CursorScene;
		// Сцена уровня
		public var mainScene:MainScene;
		// Индикатор вертикального движения
		private var verticalMoving:Boolean = false;
		//
		private var copy:Boolean = false;
		//
		private var mouseDown:Boolean;
		// Журнал событий
		private var eventJournal:EventJournal;
		// Индикатор режима вставки пропов			
		public var multiplePropMode:int = 1;
		//
		private var cameraTransformation:Matrix3D;
		//
		private var _snapMode:Boolean = true;
		
		private var cameraDistance:Number;
		
		private var shape:Shape;
		
		private var keyMapper:KeyMapper;
		
		public function SceneContainer() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initKeyMapper();
		}
		
		private function initKeyMapper():void {
			keyMapper = new KeyMapper();
			keyMapper.mapKey(0, KeyboardUtils.N);
			keyMapper.mapKey(1, KeyboardUtils.M);
			keyMapper.mapKey(2, Keyboard.NUMPAD_4);
			keyMapper.mapKey(3, Keyboard.NUMPAD_6);
			keyMapper.mapKey(4, Keyboard.NUMPAD_8);
			keyMapper.mapKey(5, Keyboard.NUMPAD_2);
			keyMapper.mapKey(6, Keyboard.NUMPAD_9);
			keyMapper.mapKey(7, Keyboard.NUMPAD_3);
		}
		
		private function onAddedToStage(e:Event):void {

			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
			keyMapper.startListening(stage);
			
			cursorScene = new CursorScene(stage);
			mainScene = new MainScene();
			cursorScene.occupyMap = mainScene.occupyMap;
		
			addChild(mainScene.view);
			addChild(cursorScene.view);
			shape = new Shape();
			addChild(shape);
			
			initListeners();
			eventJournal = new EventJournal();
			
			var cameraCoords:Point3D = cursorScene.camera.coords;
			cameraDistance = Math.sqrt(cameraCoords.x*cameraCoords.x + cameraCoords.y*cameraCoords.y + cameraCoords.z*cameraCoords.z); 
		}
		
		/**
		 * Установка обработчиков. 
		 */		
		protected function initListeners():void {
			
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			parent.addEventListener(Event.RESIZE, onResize);
			parent.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			parent.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			parent.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			parent.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			parent.addEventListener(MouseEvent.MIDDLE_MOUSE_DOWN, onMiddleMouseDown);
			parent.addEventListener(MouseEvent.MIDDLE_MOUSE_UP, onMiddleMouseUp); 
			parent.addEventListener(MouseEvent.ROLL_OUT, onMouseOut);
			onResize();
		}
		
		
		// Точка клика
		private var mouseDownPoint:Point = new Point();
		// Координаты выделенного пропа на момент выделения 
		private var startSelCoords:Point3D;
		
		private function onMouseDown(e:MouseEvent):void {
			if (mainScene.propMouseDown) {
				
				var selProp:Prop = mainScene.selectedProp; 
				if (selProp) {
					// Запоминаем исходные координаты
					startSelCoords = selProp.coords;
					cursorScene.visible = false;
				}
			} 
			
			mouseDown = true;
			mouseDownPoint.x = mainScene.view.mouseX;
			mouseDownPoint.y = mainScene.view.mouseY;
		}
		
		
		
		private function onMouseUp(e:MouseEvent):void {
			var selProp:Prop = mainScene.selectedProp;
			var selectedProps:Set = mainScene.selectedProps;
		
			if (mainScene.propMouseDown) {
				if (selProp) {
					var move:Boolean = false;
					if (copy) {
						// Заносим в журнал
						eventJournal.addEvent(EventJournal.COPY, selectedProps.clone());
					} else 	{	
						// Проверка на перемещение
						if (!startSelCoords.equals(selProp.coords)) {
							var delta:Point3D = selProp.coords;
							delta.difference(delta, startSelCoords);
							// Заносим в журнал
							eventJournal.addEvent(EventJournal.MOVE, selectedProps.clone(), delta);
							move = true;
						}
					}
						
					if (_snapMode && (copy || move)) {
						checkConflict();
					}
							
					copy = false;
					
				}
				mainScene.propMouseDown = false;
				
			} else {
				// Проверка на клик
				var deltaX:Number = mouseDownPoint.x - mainScene.view.mouseX;
				var deltaY:Number = mouseDownPoint.y - mainScene.view.mouseY;
				deltaX = deltaX < 0 ? -deltaX : deltaX;
				deltaY = deltaY < 0 ? -deltaY : deltaY;
				if ((deltaX < 3) && (deltaY < 3)) {
					// Перемещаем курсор туда, куда кликнули мышью
					if (propDown) {
						if (cursorScene.object) {
							cursorScene.object.z = clickZ;
						}
						propDown = false;
					} 
					cursorScene.moveCursorByMouse();
					
					if (!cursorScene.visible) {
						mainScene.deselectProps();
						cursorScene.visible = true;
						
					}
				} else {
					// выделяем/снимаем выделение с пропов под прямоугольником
					if (e.shiftKey) {
						for (var p:* in rectProps) {
							var prop:Prop = p;
							if (e.altKey) {
								if (selectedProps.has(prop)) {
									mainScene.deselectProp(prop);
								}
							} else {
								if (!selectedProps.has(prop)) {
									mainScene.selectProp(prop);
								}
							}
						} 
					}
				}
				
			}
					
			mouseDown = false;
			shape.graphics.clear();
		}
		
		private function alertConflict(e:CloseEvent):void {
			if (e.detail == Alert.NO) {
				// Отменяем 
				mainScene.undo(eventJournal.undo(true));
			}
			setFocus();
		}
		
		private function checkConflict():void {
		
			if (multiplePropMode != 0) {
				// Ищем пересекающие пропы
				var selectedProps:Set = mainScene.selectedProps;
				var occupyMap:OccupyMap = mainScene.occupyMap;
				for (var p:* in selectedProps) {
					var prop:Prop = p;
					if ((multiplePropMode == 2 && occupyMap.isConflict(prop)) || (multiplePropMode == 1 && occupyMap.isConflictGroup(prop))) {
						Alert.show("This location is occupied. Continue?", "", Alert.YES|Alert.NO, this, alertConflict, null, Alert.YES);
						break;
					} 
				}	 
						
			}
		}
		
		private var prevMoveX:Number;
		private var prevMoveY:Number;
		private var rectProps:Set = new Set();
		
		private function onMouseMove(e:MouseEvent):void {
			var p:*;
			var prop:Prop;
			var selProp:Prop = mainScene.selectedProp;
			var selectedProps:Set = mainScene.selectedProps; 
			
			if (mainScene.propMouseDown && selProp) {
				// Проверка на необходимость копирования
				if (e.shiftKey && !copy) {
					// Проверка на перемещение
					if (!startSelCoords.equals(selProp.coords)) {
						var delta:Point3D = selProp.coords;
						delta.difference(delta, startSelCoords);
						// Заносим в журнал
						eventJournal.addEvent(EventJournal.MOVE, selectedProps.clone(), delta);
					}
					// Копируем пропы
					var copyProps:Set = new Set();
					for (p in selectedProps) {
						prop = p as Prop;
						var copyProp:Prop = mainScene.addProp(prop, prop.coords, prop.rotationZ);
						if (prop == selProp) {
							selProp = copyProp;
						}
						copyProps.add(copyProp);	
					} 
					// Выделяем копии
					mainScene.selectProps(copyProps);
					mainScene.selectedProp = selProp;
					// Запоминаем исходные координаты
					startSelCoords = selProp.coords;
					copy = true;
				}
				
				// Перемещаем проп
				mainScene.moveSelectedProps(verticalMoving);
			
			} else {
				// Проверка на паннинг
				if (middleDown) {
					var matrix:Matrix3D = cursorScene.camera.transformation;
					var axisX:Point3D = new Point3D(matrix.a, matrix.e, matrix.i);
					var axisY:Point3D = new Point3D(matrix.b, matrix.f, matrix.j);
					axisX.multiply(10*(prevMoveX - e.stageX));
					axisY.multiply(10*(prevMoveY - e.stageY));
					
					var coords:Point3D = new Point3D(matrix.d, matrix.h, matrix.l);
					coords.add(axisX); 
					coords.add(axisY);
					cursorScene.cameraController.coords = cursorScene.container.globalToLocal(coords); 
					
				} else if (mouseDown) {
					var dx:Number = mouseDownPoint.x - mainScene.view.mouseX;
					dx = dx > 0 ? dx : -dx;
					var dy:Number = mouseDownPoint.y - mainScene.view.mouseY;
					dy = dy > 0 ? dy : -dy;
					if (dx > 3 && dy > 3) {
						// Отрисовка прямоугольника выделения
						var point:Point = new Point(Math.min(mainScene.view.mouseX, mouseDownPoint.x), Math.min(mainScene.view.mouseY, mouseDownPoint.y));
						var gfx:Graphics = shape.graphics; 
						gfx.clear();
						gfx.lineStyle(0, 0x000000);
						gfx.moveTo(point.x, point.y);
						
						gfx.lineTo(point.x + dx, point.y);
						gfx.lineTo(point.x + dx, point.y + dy);
						gfx.lineTo(point.x, point.y + dy);
						gfx.lineTo(point.x, point.y);
						
						// Выделяем пропы, попавшие под прямоугольник
						if (e.shiftKey) {
							var prevRectProps:Set = rectProps.clone();
							if (e.altKey) {
								// Снимаем выделение
								rectProps = mainScene.getPropsUnderRect(point, dx, dy, false);
								for (p in prevRectProps) {
									prop = p;
									if (!rectProps.has(prop) && selectedProps.has(prop)) {
										prop.select();
									}
								}
							} else {
								// Выделяем
								rectProps = mainScene.getPropsUnderRect(point, dx, dy, true);
								for (p in prevRectProps) {
									prop = p;
									if (!rectProps.has(prop) && !selectedProps.has(prop)) {
										prop.deselect();
									}
								}
								
							}
							
						} else {
							mainScene.selectProps(mainScene.getPropsUnderRect(point, dx, dy, true));	
						}
						
						cursorScene.visible = false;
					}	
				}				
			}
			prevMoveX = e.stageX;
			prevMoveY = e.stageY;
		}
		
		private var cameraPoint:Point3D = new Point3D(0, 0, 1000);
		/**
		 * Зум. 
		 */				
		private function onMouseWheel(e:MouseEvent):void {
			zoom(e.delta);
		}
		
		/**
		 * @param delta
		 */
		private function zoom(delta:int):void {
			var point:Point3D = mainScene.selectedProp ? mainScene.selectedProp.coords : cursorScene.camera.localToGlobal(cameraPoint);
			var coords:Point3D = cursorScene.container.localToGlobal(cursorScene.cameraController.coords);
			var old:Point3D = coords.clone();
			coords.x = (point.x + delta*coords.x)/(1 + delta);
			coords.y = (point.y + delta*coords.y)/(1 + delta);
			coords.z = (point.z + delta*coords.z)/(1 + delta);
			cursorScene.cameraController.coords = cursorScene.container.globalToLocal(coords);
			coords.difference(coords, old);
			if (delta > 0) cameraDistance -= Math.sqrt(coords.x*coords.x + coords.y*coords.y + coords.z*coords.z);
			else cameraDistance += Math.sqrt(coords.x*coords.x + coords.y*coords.y + coords.z*coords.z);
		}
		
		private var outDown:Boolean = false;
		private function onMouseOut(e:MouseEvent):void {
			if (e.buttonDown) {
				parent.addEventListener(MouseEvent.ROLL_OVER, onMouseOver);
				cursorScene.containerController.setMouseLook(false);
			}
				
		}
		
		private function onMouseOver(e:MouseEvent):void {
			parent.removeEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
			if (!e.buttonDown) {
				onMouseUp(e);
			} else {
				onMouseDown(e);
			}
		}
		
		private var middleDown:Boolean = false;
		private function onMiddleMouseDown(e:MouseEvent):void {
			var coords:Point3D; 
			
			if (e.altKey) {
				var selProp:Prop = mainScene.selectedProp;
				if (selProp) {
					var centre:Point = mainScene.getCentrePropsGroup();
					coords = new Point3D(centre.x, centre.y, selProp.z);
				} else {
					coords = cursorScene.camera.localToGlobal(new Point3D(0, 0, cameraDistance));
				}
 				var offset:Point3D = cursorScene.containerController.coords.clone();
				offset.subtract(coords);
				var cameraCoords:Point3D = cursorScene.container.localToGlobal(cursorScene.cameraController.coords); 
				cameraCoords.add(offset);
				cursorScene.cameraController.coords = cursorScene.container.globalToLocal(cameraCoords);
				cursorScene.containerController.coords = coords;
				cursorScene.containerController.setMouseLook(true);
			} else {
				middleDown = true;
			}
				
		}
		
		private function onMiddleMouseUp(e:MouseEvent):void {
			middleDown = false;
			cursorScene.containerController.setMouseLook(false);
		}
		
		
		private var cameraOffset:Point3D = new Point3D;
		
		/**
		 * Покадровая обработка.
		 */		
		private function onEnterFrame(e:Event):void {
			
			cursorScene.containerController.yawLeft(keyMapper.keyPressed(0));
			cursorScene.containerController.yawRight(keyMapper.keyPressed(1));
			cursorScene.containerController.pitchDown(keyMapper.keyPressed(6));
			cursorScene.containerController.pitchUp(keyMapper.keyPressed(7));

			cursorScene.containerController.speed = 2000;
			cursorScene.containerController.moveLeft(keyMapper.keyPressed(2));
			cursorScene.containerController.moveRight(keyMapper.keyPressed(3));
			cursorScene.containerController.moveForward(keyMapper.keyPressed(4));
			cursorScene.containerController.moveBack(keyMapper.keyPressed(5));
			
			cursorScene.cameraController.processInput();
			cursorScene.containerController.processInput();
			
			cursorScene.calculate();
			
			cameraTransformation = cursorScene.camera.transformation;
			cameraOffset.x = cameraTransformation.d;
			cameraOffset.y = cameraTransformation.h;
			cameraOffset.z = cameraTransformation.l;
			// Рисуем оси
			cursorScene.drawAxis(cameraTransformation);
			var rotation:Point3D = cameraTransformation.getRotations();
			// Синхронизируем камеру главной сцены
			mainScene.synchronize(cameraOffset, rotation.x, rotation.y, rotation.z);
			mainScene.calculate();
		}
		
		/**
		 * Корректировка размеров и положения объектов при изменении окна плеера.
		 */	
		private function onResize(e:Event = null):void {
			
			cursorScene.viewResize(parent.width - 20, parent.height - 40); 
			mainScene.viewResize(parent.width - 20, parent.height - 40);
			 
		}
		
//		override protected function updateDisplayList(unscaledWidth:Number, unscaledHeight:Number):void {
//			if (cursorScene == null) return; 
//				
//			cursorScene.viewResize(unscaledWidth, unscaledHeight); 
//			mainScene.viewResize(unscaledWidth, unscaledHeight);
//			
//		}
	
		
		/**
		 * Обработка нажатия клавиш. 
		 */		
		private function onKeyDown(event:KeyboardEvent):void {
			
			var selProp:Prop;
			var p:*;
			var delta:Point3D;
			var oldCoords:Point3D;
			
			switch (event.keyCode) {
				case KeyboardUtils.UP:
				case KeyboardUtils.DOWN:
				case KeyboardUtils.LEFT:
				case KeyboardUtils.RIGHT:
					var sector:int = mainScene.getCameraSector();
					if (cursorScene.visible) {
						cursorScene.moveByArrows(event.keyCode, sector);
					} else {
						selProp = mainScene.selectedProp;
						oldCoords = selProp.coords;
						// Перемещаем
						mainScene.moveByArrows(event.keyCode, sector);
						// Вычисляем перемещение
						delta = selProp.coords;
						delta.difference(delta, oldCoords);
						// Заносим в журнал
						eventJournal.addEvent(EventJournal.MOVE, mainScene.selectedProps, delta);						
					}
					
					break;
				case KeyboardUtils.V:
					verticalMoving = true;
					break;	
				case KeyboardUtils.W:
					if (cursorScene.visible) {
						cursorScene.object.z += EditorScene.vBase;
						cursorScene.updateMaterial();
					} else {
						selProp = mainScene.selectedProp; 
						if (selProp) {
							oldCoords = selProp.coords;
							mainScene.verticalMove(false);
							delta = selProp.coords;
							delta.difference(delta, oldCoords);
							// Заносим в журнал
							eventJournal.addEvent(EventJournal.MOVE, mainScene.selectedProps, delta);
						}
						
					}
					break;
				case KeyboardUtils.S:
					if (!event.ctrlKey) {
						if (cursorScene.visible) {
							cursorScene.object.z -= EditorScene.vBase;
							cursorScene.updateMaterial();
						} else {
							selProp = mainScene.selectedProp; 
							if (selProp) {
								oldCoords = selProp.coords;
								mainScene.verticalMove(true);
								delta = selProp.coords;
								delta.difference(delta, oldCoords);
								// Заносим в журнал
								eventJournal.addEvent(EventJournal.MOVE, mainScene.selectedProps, delta);
							}
						}
						
					}
					break;	
							
				case KeyboardUtils.DELETE:
				case KeyboardUtils.C:
					selProp = mainScene.selectedProp;
					if (selProp) {
						var cursor:Prop = cursorScene.object; 
						if (cursor) {
							cursor.coords = selProp.coords;
							if (snapMode) {
								cursor.snapCoords();
							}
						}
						eventJournal.addEvent(EventJournal.DELETE, mainScene.deleteProps());
						cursorScene.visible = true;
						
					}
					break;
				case KeyboardUtils.Z:
					if (cursorScene.visible) {
						cursorScene.rotateProps(true);
						cursorScene.updateMaterial();
					} else {
						eventJournal.addEvent(EventJournal.ROTATE, mainScene.selectedProps.clone(), false);
						mainScene.rotateProps(true);						
					}
					break;	
				case KeyboardUtils.X:
					if (cursorScene.visible) {
						cursorScene.rotateProps(false);
						cursorScene.updateMaterial();
					} else {
						eventJournal.addEvent(EventJournal.ROTATE, mainScene.selectedProps.clone(), true);
						mainScene.rotateProps(false);
					}
					break;
				case KeyboardUtils.ESCAPE:
					selProp = mainScene.selectedProp; 
					if (selProp) {
						if (cursorScene.object) {
							cursorScene.object.coords = selProp.coords; 
							cursorScene.object.snapCoords();
						}
						mainScene.deselectProps();
						cursorScene.visible = true;
					}
					break;	
				case Keyboard.NUMPAD_ADD:
					zoom(3);
					break;
				case Keyboard.NUMPAD_SUBTRACT:
					zoom(-3);
					break;
				case Keyboard.F:
					mainScene.mirrorTextures();
					break;	
				case Keyboard.Q:
					mainScene.selectConflictProps();
					break;	
			}
		}
		
		/**
		 * 
		 */
		private function onKeyUp(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case KeyboardUtils.V:	
					verticalMoving = false;
					break;				
			}
		}
		
		/**
		 * Очистка сцен.
		 */		
		public function clear():void {
			
			mainScene.clear();
			cursorScene.clear();
		}
		
		/**
		 * 
		 */		
		public function set snapMode(value:Boolean):void {
			_snapMode = value;
			mainScene.snapMode = value;
			cursorScene.snapMode = value;
		}
		
		/**
		 * 
		 */		
		public function get snapMode():Boolean {
			return _snapMode;
		}
			
		/**
		 * Добавление пропа. 
		 * @param sourceProp исходный проп
		 */		
		public function addProp(sourceProp:Prop):void {

			var prop:Prop = mainScene.addProp(sourceProp, cursorScene.object.coords, cursorScene.object.rotationZ);
			var props:Set = new Set();
			props.add(prop);
			eventJournal.addEvent(EventJournal.ADD, props); 
			setTimeout(cursorScene.updateMaterial, 200);
			prop.addEventListener(MouseEvent3D.MOUSE_DOWN, onPropMouseDown);
			
//			if (_snapMode && !cursorScene.freeState && ((multiplePropMode == 2) || (multiplePropMode == 1 && cursorScene.occupyMap.isConflictGroup(cursorScene.object)))) {
				
			if (_snapMode && !cursorScene.freeState && ((multiplePropMode == 2 && cursorScene.occupyMap.isConflict(prop)) || (multiplePropMode == 1 && cursorScene.occupyMap.isConflictGroup(prop)))) {
				Alert.show("This location is occupied. Continue?", "", Alert.YES|Alert.NO, this, alertConflict, null, Alert.YES);
				
			}
			 
				
		}
		
		private var clickZ:Number;
		private var propDown:Boolean = false;
		private function onPropMouseDown(e:MouseEvent3D):void {
			clickZ = e.object.z;
			propDown = true;
			
		}
		
				
		public function undo():void {
			var e:EventJournalItem = eventJournal.undo(); 
			if (e) {
				mainScene.undo(e);
				if (cursorScene.visible) {
					cursorScene.updateMaterial();
				}
			}	
		}

		public function redo():void {
			var e:EventJournalItem = eventJournal.redo();
			if (e) {
				mainScene.redo(e);
				if (cursorScene.visible) {
					cursorScene.updateMaterial();
				}
			}
		}
		
		
		
		
	}
}