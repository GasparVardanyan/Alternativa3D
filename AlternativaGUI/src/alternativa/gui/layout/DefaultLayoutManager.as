package alternativa.gui.layout {
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.lod.simple.ISimpleLODobject;
	
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.events.Event;
	
	/**
	 * Кастомный LayoutManager.
	 * <p>При удалении/добавлении объекта на сцену, смотрим тип объекта:</p>
	 * <listing>
	 * <ul>ISimpleLODobject - передаем его в LODManager.</ul>
	 * <ul>IStageSizeListener - добавляем его в массив stageSizeObjects.</ul>
	 * </listing>
	 * <p>Объекты, имплиментирующие IStageSizeListener, получают размеры сцены.</p>
	 * <p>Данный класс является примитивным, все объекты с интерфейсом IStageSizeListener получают размеры stage.</p>
	 * 
	 * @see LayoutManager
	 * 
	*/
	
	public class DefaultLayoutManager implements ILayoutManager {
		
		/**
		 * Вектор объектов, которые были добавлены на сцену на предыдущем кадре. 
		 */		
		protected var addedToStageLastFrame:Vector.<DisplayObject>;
		
		/**
		 * Ширина сцены. 
		 */		
		protected var width:int = 0;
		
		/**
		 * Высота сцены. 
		 */		
		protected var height:int = 0;
		
		/**
		 * Массив объектов с интерфейсом IStageSizeListener.
		 */		
		protected var stageSizeObjects:Array;
		
		public function DefaultLayoutManager():void {
			
		}
		
		/**
		 * Инициализация DefaultLayoutManager.
		 * 
		 */		
		public function init():void {
			addedToStageLastFrame = new Vector.<DisplayObject>();
			stageSizeObjects = new Array();
			
			LODmanager.init(new DefaultLODManager());
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function onResize(w:int, h:int):void	{
			width = w;
			height = h;
			resize();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function addedToStage(object:Object):void {
			var index:int;
			if (object is ISimpleLODobject) {
				LODmanager.add(object as ISimpleLODobject);
			}
			if (object is IStageSizeListener) {
				addedToStageLastFrame.push(object as DisplayObject)
				
				index = stageSizeObjects.indexOf(object);
				if (index == -1) stageSizeObjects.push(object);
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function removedFromStage(object:Object):void {
			if (object is IStageSizeListener) {
				stageSizeObjects.splice(stageSizeObjects.indexOf(object), 1);
			}
				
			if (object is ISimpleLODobject) {
				LODmanager.remove(object as ISimpleLODobject);
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function update():void {
			if (addedToStageLastFrame.length > 0) {
				resize();
				addedToStageLastFrame.length = 0;
			}
		}
		
		/**
		 * Изменение размеров. Вызывается из LayoutManager при вызове Event.RESIZE. 
		 * 
		 */		
		public function resize(e:Event = null):void {
			// SIMPLE LOD OBJECTS MANAGER
			LODmanager.resize(width, height);

			if (stageSizeObjects!=null && stageSizeObjects.length>0) {
				for (var i:int = 0; i < stageSizeObjects.length; i++) {
					if (stageSizeObjects[i] is GUIobject) {
						(stageSizeObjects[i] as GUIobject).resize(width, height);
					} else {
						(stageSizeObjects[i] as DisplayObject).width = width;
						(stageSizeObjects[i] as DisplayObject).height = height;
					}
				}
			}
//			trace("DefaultLayoutManager resize");
		}
	}
}