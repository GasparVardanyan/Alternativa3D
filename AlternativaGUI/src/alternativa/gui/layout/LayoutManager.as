package alternativa.gui.layout {
	import alternativa.gui.primitives.Logo;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.text.TextField;

	/**
	 * Базовый класс LayoutManager.
	 * <p>Менеджер отвечает за позиционирование и изменение размеров контейнеров.</p> 
	 * <p>Массив слоев (guiLayers) содержит рабочие слои и отслеживает добавление/удаление объектов в этих слоях.</p>
	 * <p>Минимальный размер сцены определяется свойствами: minStageWidth, minStageHeight.</p>
	 * 
	 * 
	 * @see DefaultLayoutManager
	 * @see LODManager
	 * @see RedrawManager
	 */	
	public class LayoutManager extends EventDispatcher {
		
		/**
		 * Минимальная ширина сцены. 
		 */		
		public static var minStageWidth:int = 640;
		
		/**
		 * Минимальная высота сцены. 
		 */		
		public static var minStageHeight:int = 480;
		
		/**
		 * Ссылка на stage. 
		 */		
		public static var stage:Stage;
		
		/**
		 * Массив слоев. 
		 */		
		public static var guiLayers:Array;
		
		/**
		 * Кастомный LayoutManager.
		 */		
		public static var manager:ILayoutManager;
		
		/**
		 * Менеджер отвечающий за отрисовку визуальных объектов.
		 */		
		public static var redrawManager:RedrawManager;
		
		protected static var width:int;
		protected static var height:int
		
		protected static var _enabled:Boolean = true;
		
		/**
		 * Инициализация LayoutManager.
		 * @param _stage Ссылка на stage.
		 * @param _guiLayers Массив слоев.
		 * @param _layoutManager Кастомный LayoutManager. Если в качестве параметра null, то создается DefaultLayoutManager.
		 * 
		 */		
		public static function init(_stage:Stage, _guiLayers:Array, _layoutManager:ILayoutManager = null):void {
			if (manager == null) {
				stage = _stage;
				guiLayers = _guiLayers;
				
				if (_layoutManager!=null) {
					manager = _layoutManager;
				} else {
					manager = new DefaultLayoutManager();
				}
				manager.init();
				
				
				stage.addEventListener(Event.RESIZE, resizeHandler);
				stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				// следим за добавлением и удалением объектов в данных слоях
				for (var i:int = 0; i < _guiLayers.length; i++) {
					var layer:EventDispatcher = _guiLayers[i] as EventDispatcher;
					layer.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler, true);
					layer.addEventListener(Event.REMOVED_FROM_STAGE, removedFromStageHandler, true);
				}
				var logo:Logo;
				
				for (i = 0; i < _stage.numChildren; i++) {
					if (_stage.getChildAt(i) is Logo) {
						logo = _stage.getChildAt(i) as Logo;
						break;
					}
				}
				if (logo != null) {
					_stage.addChild(logo);
				}
				
				redrawManager = new RedrawManager();
				
				resizeHandler();
			}
		}
		
		/**
		 * Добавили объект на сцену.
		 * 
		 */		
		private static function addedToStageHandler(e:Event):void {
			manager.addedToStage(e.target as DisplayObject);
			redrawManager.addedToStage(e.target as DisplayObject);
		}
		
		/**
		 * Удалили объект со сцены.
		 * 
		 */		
		private static function removedFromStageHandler(e:Event):void {
			manager.removedFromStage(e.target as DisplayObject);
			redrawManager.removedFromStage(e.target as DisplayObject);
		}
		
		protected static function onEnterFrame(e:Event):void {
			manager.update();
			redrawManager.update();
		}
		
		//----- RESIZE
		/**
		 * Произошло изменение размеров stage.
		 * 
		 */		
		public static function resizeHandler(e:Event = null):void {
			var newWidth:int = Math.max(minStageWidth, stage.stageWidth);
			var newHeight:int = Math.max(minStageHeight, stage.stageHeight);
			width = newWidth;
			height = newHeight;
				
			manager.onResize(width, height);
			redrawManager.drawObjects();
		}
		
		/**
		 * Включение/отключение LayoutManager. 
		 * <p>Включает/отключает изменение размеров контейнеров при изменении размеров сцены и при добавлении объекта на сцену.</p> 
		 */
		public static function get enabled():Boolean {
			return _enabled;
		}
		public static function set enabled(value:Boolean):void {
			if (value != _enabled) {
				if (_enabled) {
					stage.removeEventListener(Event.RESIZE, resizeHandler);
					stage.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				} else {
					stage.addEventListener(Event.RESIZE, resizeHandler);
					stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
				}
				_enabled = value;
			}
		}

	}
}