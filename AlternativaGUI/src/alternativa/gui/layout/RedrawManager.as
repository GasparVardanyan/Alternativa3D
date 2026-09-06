package alternativa.gui.layout {
	import alternativa.gui.base.GUIobject;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	/**
	 *  Менеджер отвечающий за отрисовку визуальных объектов.
	 * 
	 */	
	public class RedrawManager extends EventDispatcher {
		
		/**
		 * @private
		 * Вектор объектов, которые были добавлены на сцену на предыдущем кадре. 
		 */		
		private var addedToStageLastFrame:Vector.<DisplayObject>;
		
		/**
		 * @private
		 * Вектор объектов, которые находятся на сцене.
		 */		
		private var objectsOnStage:Vector.<DisplayObject>; 
		
		/**
		 * Создание экземпляра класса. Происходит при инициализации LayoutManager.
		 * 
		 */		
		public function RedrawManager() {
			addedToStageLastFrame = new Vector.<DisplayObject>();
			objectsOnStage = new Vector.<DisplayObject>();
		}
		
		/**
		 * @private
		 * 
		 * Добавление объекта на сцену.
		 * @param object Объект, который добавили на stage.
		 */	
		public function addedToStage(object:Object):void {
			if (object is DisplayObject) {
				var index:int = objectsOnStage.indexOf(object);
				if (index == -1) objectsOnStage[objectsOnStage.length] = object as DisplayObject;
				
				var index2:int = addedToStageLastFrame.indexOf(object);
				if (index2 == -1) addedToStageLastFrame[addedToStageLastFrame.length] = object as DisplayObject;
				
				if (object is GUIobject) {
					(object as GUIobject).drawGraphics();
				}
			}
		}
		
		/**
		 * @private
		 * 
		 * Удаление объекта со сцены.
		 * @param object Объект, который удалили со stage.
		 */	
		public function removedFromStage(object:Object):void {
			if (object is DisplayObject) {
				objectsOnStage.splice(objectsOnStage.indexOf(object), 1);
			}
		}
		
		/**
		 * Обновление. Вызывается из LayoutManager при вызове Event.ENTER_FRAME. 
		 * 
		 */	
		public function update(e:Event = null):void {
			var length:int = addedToStageLastFrame.length;
			if (length > 0) {
				var object:DisplayObject;
				for (var i:int = 0; i < length; i++) {
					object = addedToStageLastFrame[i]; 
					if (object != null && object is GUIobject) {
						(object as GUIobject).drawGraphics();
					}
				} 
				addedToStageLastFrame.length = 0;
			}
		}
		
		/**
		 * Отрисовка объектов находящихся на сцене. Вызывается после ресайза из LayoutManager.
		 * 
		 * 
		 */		
		public function drawObjects(e:Event = null):void {
			var length:int = objectsOnStage.length;
			var object:DisplayObject;
			for (var i:int = 0; i < length; i++) {
				object = objectsOnStage[i]; 
				if (object != null && object is GUIobject) {
					(object as GUIobject).drawGraphics();
				}
			} 
		}
		
	}
}
