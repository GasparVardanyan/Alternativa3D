package alternativa.gui.mouse.resizableObject {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.event.ResizableObjectEvent;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.ICursorActive;
	
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;

	use namespace alternativagui;
	
	/**
	 * Класс ResizableObject позволяет растягивать или сжимать объект.
	 * <p>Если _resizableContainer задан, то он будет автоматически резиниться.</p>
	 * <p>Для использования данного класса, надо положить экземпляр класса в объект, в котором будет использоваться.</p>
	 * 
	 * @see #ResizableObjectEvent
	 * @see #IResizableObject
	 * 
	 */	
	public class ResizableObject extends GUIobject implements IResizableObject {

		protected var _border:int = 10;

		protected var topLeftButton:ActiveObject;

		protected var topBorderButton:ActiveObject;

		protected var topRightButton:ActiveObject;

		protected var bottomLeftButton:ActiveObject;

		protected var bottomBorderButton:ActiveObject;

		protected var bottomRightButton:ActiveObject;

		protected var leftBorderButton:ActiveObject;

		protected var rightBorderButton:ActiveObject;

		protected var selectObject:GUIobject;

		protected var _dragMode:Boolean = false;

		protected var offsetX:Number;

		protected var offsetY:Number;
		
//		private var colors:Array;
		
		protected var _resizableContainer:DisplayObject;
		
		protected var mouseMove:Boolean = false;
		
		protected var oldX:Number = 0;
		
		protected var oldY:Number = 0;
		
		public function ResizableObject() {
			super();
			
//			colors = [0xFF0000,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF,Math.random()*0xFFFFFF]
			/**
			 * Названия типов курсоров для ResizableObject.
			 * ResizableCursorAngle - курсор для ресайза за углы (левый верхний и правый нижний) \
			 * ResizableCursorBackAngle - курсор для ресайза за углы (левый нижний и правый верхний) /
			 * ResizableCursorHor - курсор для ресайза за сторону (левый и правый)
			 * ResizableCursorVer - курсор для ресайза за сторону (верхний и нижний)		
			 * */
			topLeftButton = new ActiveObject();
			topLeftButton.cursorType = CursorManager.SIZE_NESW;
			topLeftButton.mouseEnabled = true;
			addChild(topLeftButton);
			
			topBorderButton = new ActiveObject();
			topBorderButton.cursorType = CursorManager.SIZE_NS;
			topBorderButton.mouseEnabled = true;
			addChild(topBorderButton);
			
			topRightButton = new ActiveObject();
			topRightButton.cursorType = CursorManager.SIZE_NWSE;
			topRightButton.mouseEnabled = true;
			addChild(topRightButton);
			
			bottomLeftButton = new ActiveObject();
			bottomLeftButton.cursorType = CursorManager.SIZE_NWSE;
			bottomLeftButton.mouseEnabled = true;
			addChild(bottomLeftButton);
			
			bottomBorderButton = new ActiveObject();
			bottomBorderButton.cursorType = CursorManager.SIZE_NS;
			bottomBorderButton.mouseEnabled = true;
			addChild(bottomBorderButton);
			
			bottomRightButton = new ActiveObject();
			bottomRightButton.cursorType = CursorManager.SIZE_NESW;
			bottomRightButton.mouseEnabled = true;
			addChild(bottomRightButton);
			
			leftBorderButton = new ActiveObject();
			leftBorderButton.cursorType = CursorManager.SIZE_WE;
			leftBorderButton.mouseEnabled = true;
			addChild(leftBorderButton);
			
			rightBorderButton = new ActiveObject();
			rightBorderButton.cursorType = CursorManager.SIZE_WE;
			rightBorderButton.mouseEnabled = true;
			addChild(rightBorderButton);

			redrawBorder();

			topLeftButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			topBorderButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			topRightButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			bottomLeftButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			bottomBorderButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			bottomRightButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			leftBorderButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);
			rightBorderButton.addEventListener(MouseEvent.MOUSE_DOWN, buttonMouseDown);

			
		}
		
		/**
		 * Слушаем клик на сцене.
		 * 
		 */		
		protected function stageMouseUp(e:MouseEvent):void {
			LayoutManager.stage.removeEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			_dragMode = false;
			removeEventListener(Event.ENTER_FRAME, updateDrag);
			selectObject = null;
			CursorManager.hideCursor();
			dispatchEvent(new ResizableObjectEvent(ResizableObjectEvent.STOP, getPoints()));
		}
		
		/**
		 *
		 * Клик на уголке или рамке.
		 * 
		 */		
		protected function buttonMouseDown(e:MouseEvent):void {
			LayoutManager.stage.addEventListener(MouseEvent.MOUSE_UP, stageMouseUp);
			
			selectObject = (e.currentTarget as GUIobject);
			offsetX = mouseX - selectObject.x;
			offsetY = mouseY - selectObject.y;
			_dragMode = true;
			if (selectObject is ICursorActive) {
				CursorManager.showCursor((selectObject as ICursorActive).cursorType);
			}
			addEventListener(Event.ENTER_FRAME, updateDrag);
			dispatchEvent(new ResizableObjectEvent(ResizableObjectEvent.START, getPoints()));
		}
		
		/**
		 * 
		 * @return Rectangle с новыми координатами.
		 * 
		 */		
		protected function getPoints():Rectangle {
			var localToGlobalPoint:Point = this.localToGlobal(new Point(topLeftButton.x, topLeftButton.y));
			var globalToLocalPoint:Point;
			
			// если есть resizableContainer, то делаем проверку, есть ли у объекта _parent или он сам являетс яим 
			if (_resizableContainer!=null) {
				if (_resizableContainer.parent!=null) {
					globalToLocalPoint = _resizableContainer.parent.globalToLocal(new Point(localToGlobalPoint.x, localToGlobalPoint.y));
				} else {
					globalToLocalPoint = _resizableContainer.globalToLocal(new Point(localToGlobalPoint.x, localToGlobalPoint.y));
				}
				return new Rectangle(globalToLocalPoint.x, globalToLocalPoint.y, (topRightButton.x + _border - topLeftButton.x), (bottomLeftButton.y + _border - topLeftButton.y));
			} else {
				return new Rectangle(localToGlobalPoint.x, localToGlobalPoint.y, (topRightButton.x + _border - topLeftButton.x), (bottomLeftButton.y + _border - topLeftButton.y));
			}
		}
		
		/**
		 *  Изменение размеров контейнера.
		 * 
		 */		
		protected function resizeContainer(e:MouseEvent = null):void {
			var rect:Rectangle = getPoints();
			if (_resizableContainer != null) {
				_resizableContainer.x = rect.x;
				_resizableContainer.y = rect.y;
				_resizableContainer.width = rect.width;
				_resizableContainer.height = rect.height;
				if (_resizableContainer is GUIobject) {
					(_resizableContainer as GUIobject).drawChildren();
				}
			}
			dispatchEvent(new ResizableObjectEvent(ResizableObjectEvent.CHANGE, rect));
		}
		
		/**
		 * Обновление координат объектов. 
		 * 
		 */		
		protected function updateDrag(e:Event):void {
			if (_dragMode) {
				switch (selectObject) {
					case topLeftButton:
					case topRightButton:
					case bottomRightButton:
					case bottomLeftButton:
						selectObject.x = mouseX - offsetX;
						selectObject.y = mouseY - offsetY;
						break;
					
					case leftBorderButton:
					case rightBorderButton:
						selectObject.x = mouseX - offsetX;
						break;
					
					case topBorderButton:
					case bottomBorderButton:
						selectObject.y = mouseY - offsetY;
						break;
					
					default:
						break;
				}
				
				
				
				if (oldX != mouseX || oldY != mouseY) {
					draw();
					mouseMove = false;
					resizeContainer();
					oldX = mouseX;
					oldY = mouseY;
				}
			}
		}
		
		/**
		 * Перерисовка рамки. 
		 * 
		 */		
		protected function redrawBorder():void {
			topLeftButton.graphics.clear();
			topLeftButton.resize(_border, _border);
			topLeftButton.graphics.clear();
			topLeftButton.graphics.beginFill(0xFFFFFF, 0);
			topLeftButton.graphics.drawRect(0,0,topLeftButton.width,topLeftButton.height);

			topRightButton.graphics.clear();
			topRightButton.resize(_border, _border);
			topRightButton.graphics.clear();
			topRightButton.graphics.beginFill(0xFFFFFF, 0);
			topRightButton.graphics.drawRect(0,0,topRightButton.width,topRightButton.height);

			bottomLeftButton.graphics.clear();
			bottomLeftButton.resize(_border, _border);
			bottomLeftButton.graphics.clear();
			bottomLeftButton.graphics.beginFill(0xFFFFFF, 0);
			bottomLeftButton.graphics.drawRect(0,0,bottomLeftButton.width,bottomLeftButton.height);

			bottomRightButton.graphics.clear();
			bottomRightButton.resize(_border, _border);
			bottomRightButton.graphics.beginFill(0xFFFFFF, 0);
			bottomRightButton.graphics.drawRect(0, 0, bottomRightButton.width, bottomRightButton.height);

			topBorderButton.graphics.clear();
			topBorderButton.graphics.clear();
			topBorderButton.graphics.beginFill(0xFFFFFF, 0);
			topBorderButton.graphics.drawRect(0, 0, topBorderButton.width, topBorderButton.height);

			bottomBorderButton.graphics.clear();
			bottomBorderButton.graphics.clear();
			bottomBorderButton.graphics.beginFill(0xFFFFFF, 0);
			bottomBorderButton.graphics.drawRect(0, 0, bottomBorderButton.width, bottomBorderButton.height);

			leftBorderButton.graphics.clear();
			leftBorderButton.graphics.clear();
			leftBorderButton.graphics.beginFill(0xFFFFFF, 0);
			leftBorderButton.graphics.drawRect(0, 0, leftBorderButton.width, leftBorderButton.height);

			rightBorderButton.graphics.clear();
			rightBorderButton.graphics.clear();
			rightBorderButton.graphics.beginFill(0xFFFFFF, 0);
			rightBorderButton.graphics.drawRect(0, 0, rightBorderButton.width, rightBorderButton.height);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			
			switch (selectObject) {
				case topLeftButton:
					bottomLeftButton.x = topLeftButton.x;
					topRightButton.y = topLeftButton.y;
					
					leftBorderButton.x = topLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, (bottomLeftButton.y - topLeftButton.y - _border));
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topLeftButton.y;
					topBorderButton.resize((topRightButton.x - topLeftButton.x - _border), _border);
						
					rightBorderButton.x = topRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, leftBorderButton.height);
					
					bottomBorderButton.x = topBorderButton.x;
					bottomBorderButton.y = bottomLeftButton.y;
					bottomBorderButton.resize(topBorderButton.width, _border);
					
					break;
				
				case topRightButton:
					topLeftButton.y = topRightButton.y;
					bottomRightButton.x = topRightButton.x;
					
					rightBorderButton.x = topRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, (bottomRightButton.y - topRightButton.y - _border));
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topRightButton.y;
					topBorderButton.resize((topRightButton.x - topLeftButton.x - _border), _border);
					
					bottomBorderButton.x = topBorderButton.x;
					bottomBorderButton.y = bottomRightButton.y;
					bottomBorderButton.resize(topBorderButton.width, _border);
					
					leftBorderButton.x = topLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, rightBorderButton.height);
					
					break;
				
				case bottomRightButton:
					topRightButton.x = bottomRightButton.x;
					bottomLeftButton.y = bottomRightButton.y;
					
					rightBorderButton.x = bottomRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, (bottomRightButton.y - topRightButton.y - _border));
					
					bottomBorderButton.x = bottomLeftButton.x + _border;
					bottomBorderButton.y = bottomRightButton.y;
					bottomBorderButton.resize((bottomRightButton.x - bottomLeftButton.x - _border), _border);
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topLeftButton.y;
					topBorderButton.resize(bottomBorderButton.width, _border);
					
					leftBorderButton.x = topLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, rightBorderButton.height);
					
					break;
				
				case bottomLeftButton:
					topLeftButton.x = bottomLeftButton.x;
					bottomRightButton.y = bottomLeftButton.y;
					
					leftBorderButton.x = bottomLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, (bottomLeftButton.y - topLeftButton.y - _border));
					
					bottomBorderButton.x = bottomLeftButton.x + _border;
					bottomBorderButton.y = bottomLeftButton.y;
					bottomBorderButton.resize((bottomRightButton.x - bottomLeftButton.x - _border),_border);
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topLeftButton.y;
					topBorderButton.resize(bottomBorderButton.width, _border);
					
					rightBorderButton.x = topRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, leftBorderButton.height);
					
					break;
				
				case leftBorderButton:
					topLeftButton.x = leftBorderButton.x;
					bottomLeftButton.x = leftBorderButton.x;
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topLeftButton.y;
					topBorderButton.resize((topRightButton.x - topLeftButton.x - _border), _border);
					
					bottomBorderButton.x = bottomLeftButton.x + _border;
					bottomBorderButton.y = bottomLeftButton.y;
					bottomBorderButton.resize(topBorderButton.width, _border);
					
					break;
				
				case topBorderButton:
					topLeftButton.y = topBorderButton.y;
					topRightButton.y = topBorderButton.y;
					
					leftBorderButton.x = topLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, (bottomLeftButton.y - topLeftButton.y - _border));
					
					rightBorderButton.x = topRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, leftBorderButton.height);
					
					break;
				
				case rightBorderButton:
					topRightButton.x = rightBorderButton.x;
					bottomRightButton.x = rightBorderButton.x;
					
					topBorderButton.x = topLeftButton.x + _border;
					topBorderButton.y = topLeftButton.y;
					topBorderButton.resize((topRightButton.x - topLeftButton.x - _border), _border);
					
					bottomBorderButton.x = bottomLeftButton.x + _border;
					bottomBorderButton.y = bottomLeftButton.y;
					bottomBorderButton.resize(topBorderButton.width, _border);
					
					break;
				
				case bottomBorderButton:
					bottomLeftButton.y = bottomBorderButton.y;
					bottomRightButton.y = bottomBorderButton.y;
					
					leftBorderButton.x = topLeftButton.x;
					leftBorderButton.y = topLeftButton.y + _border;
					leftBorderButton.resize(_border, (bottomRightButton.y - topRightButton.y - _border));
					
					rightBorderButton.x = topRightButton.x;
					rightBorderButton.y = topRightButton.y + _border;
					rightBorderButton.resize(_border, leftBorderButton.height);
					
					break;

			}
			
			redrawBorder();
		}

		
		/**
		 * Сброс рамки. Рамка растягивается по контенту. 
		 * 
		 */		
		protected function reset():void {
			topLeftButton.x = 0;
			topLeftButton.y = 0;
			
			topRightButton.x = _width - _border;
			topRightButton.y = 0;
			
			bottomRightButton.x = topRightButton.x;
			bottomRightButton.y = _height - _border;
			
			bottomLeftButton.x = 0;
			bottomLeftButton.y = bottomRightButton.y;
			
			topBorderButton.x = topLeftButton.x + _border;
			topBorderButton.y = topLeftButton.y;
			topBorderButton.resize((topRightButton.x - topLeftButton.x - _border), _border);
			
			rightBorderButton.x = topRightButton.x;
			rightBorderButton.y = topRightButton.y + _border;
			rightBorderButton.resize(_border, (bottomRightButton.y - topRightButton.y - _border));
			
			bottomBorderButton.x = bottomLeftButton.x + _border;
			bottomBorderButton.y = bottomLeftButton.y;
			bottomBorderButton.resize(topBorderButton.width, _border);
			
			leftBorderButton.x = 0;
			leftBorderButton.y = topLeftButton.y + _border;
			leftBorderButton.resize(_border, rightBorderButton.height);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override public function resize(width:int, height:int):void {
			_width = calculateWidth(width);
			_height = calculateWidth(height);
			reset();
			draw();
		}
		
		/**
		 *  Размер рамки. 
		 * 
		 */		
		public function get border():int {
			return _border;
		}
		
		public function set border(value:int):void {
			_border = value;
			draw();
		}
		
		/**
		 * Контейнер, который резинится. 
		 * 
		 */		
		public function get resizableContainer():DisplayObject
		{
			return _resizableContainer;
		}

		public function set resizableContainer(value:DisplayObject):void
		{
			_resizableContainer = value;
		}

	}
}
