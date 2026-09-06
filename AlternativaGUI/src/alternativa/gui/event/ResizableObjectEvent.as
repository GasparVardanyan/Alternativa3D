package alternativa.gui.event {

	import flash.events.Event;
	import flash.geom.Rectangle;

	/**
	 * События у ResizableObject.
	 * 
	 */	
	public class ResizableObjectEvent extends Event {
		
		/**
		 * Начало перетаскивания. 
		 */		
		public static const START:String = "START_ResizableObjectEvent";
		
		/**
		 * Завершение перетаскивания. 
		 */		
		public static const STOP:String = "STOP_ResizableObjectEvent";
		
		/**
		 * Изменение данных в процессе перетаскивания. 
		 */		
		public static const CHANGE:String = "CHANGE_ResizableObjectEvent";
		
		/**
		 * x координата.
		 */		
		public var x:Number;
		
		/**
		 * y координата. 
		 */
		public var y:Number;
		
		/**
		 * Ширина. 
		 */
		public var width:Number;
		
		/**
		 * Высота. 
		 */
		public var height:Number;
		
		/**
		 * 
		 * @param type Тип события.
		 * @param pointsRect Новые размеры и координаты объекта. Передаются ввиде Rectangle.
		 * @param bubbles Определяет, является ли событие событием восходящей цепочки.
		 * @param cancelable Указывает, можно ли предотвратить поведение, связанное с событием.
		 * 
		 */		
		public function ResizableObjectEvent(type:String, pointsRect:Rectangle = null, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
			if (pointsRect != null) {
				this.x = pointsRect.x;
				this.y = pointsRect.y;
				this.width = pointsRect.width;
				this.height = pointsRect.height;
			}
		}

	}
}
