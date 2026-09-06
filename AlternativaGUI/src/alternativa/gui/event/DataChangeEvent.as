package alternativa.gui.event {

	import __AS3__.vec.Vector;
	
	import alternativa.gui.container.list.ListItemContainer;
	import alternativa.gui.controls.tree.TreeItemContainer;
	import alternativa.gui.data.DataProvider;
	
	import flash.events.Event;
	
	/**
	 * Класс DataChangeEvent определяет событие, которое отправляется при изменении данных, связанных с компонентом. 
	 * Это событие используется компонентами ListItemContainer, TreeItemContainer и DataProvider.  
	 * 
	 */	
	public class DataChangeEvent extends Event {
		
		/**
		 * Задает значение свойства type для объекта события dataChange. 
		 */		
		public static const DATA_CHANGE:String = "dataChange";
		
		/**
		 * Задает значение свойства type для объекта события preDataChange. 
		 */		
		public static const PRE_DATA_CHANGE:String = "preDataChange";
		
		protected var _startIndex:uint;
		protected var _endIndex:uint;
		protected var _changeType:String;
		protected var _items:Vector.<Object>;
		
		/**
		 * Создает новый объект DataChangeEvent с заданными параметрами.  
		 * @param eventType Тип события изменения. 
		 * @param changeType Тип внесенного изменения. Класс DataChangeType определяет возможные значения этого параметра. 
		 * @param items Список измененных элементов. 
		 * @param startIndex Индекс первого измененного элемента. 
		 * @param endIndex Индекс последнего измененного элемента. 
		 * 
		 */		
		public function DataChangeEvent(eventType:String, changeType:String, items:Vector.<Object>, startIndex:int=-1, endIndex:int=-1):void {
			super(eventType);
			_changeType = changeType;
			_startIndex = startIndex;
			_items = items;
			_endIndex = (endIndex == -1) ? _startIndex : endIndex;
		}
		
		/**
		 * Определяет тип изменения, повлекшего событие. Класс DataChangeType определяет возможные значения этого свойства.  
		 * 
		 */		
		public function get changeType():String {
			return _changeType;
		}
		
		/**
		 * Определяет вектор, содержащий измененные элементы.   
		 * 
		 */		
		public function get items():Vector.<Object> {
			return _items;
		}
		
		/**
		 * Определяет индекс первого измененного элемента в массиве измененных элементов.   
		 * 
		 */		
		public function get startIndex():uint {
			return _startIndex;
		}
		
		/**
		 * Определяет индекс последнего измененного элемента в массиве измененных элементов.  
		 * 
		 */		
		public function get endIndex():uint {
			return _endIndex;
		}
		
		/**
		 * Возвращает строку, содержащую все свойства объекта DataChangeEvent. 
		 * <p>Строка имеет следующий формат:</p>
		 * <p>[DataChangeEvent type=<i>value</i> changeType=<i>value</i> startIndex=<i>value</i> endIndex=<i>value</i> bubbles=<i>value</i> cancelable=<i>value</i>]</p>  
		 * 
		 * 
		 */		
		override public function toString():String {
			return formatToString("DataChangeEvent", "type", "changeType", "startIndex", "endIndex", "bubbles", "cancelable");
		}

		/**
		 * Создает копию объекта DataEvent и задает значение каждого параметра, совпадающее с оригиналом.  
		 * @return Новый объект DataChangeEvent, значения свойств которого соответствуют значениям оригинала.  
		 * 
		 */		
		override public function clone():Event {
			return new DataChangeEvent(type, _changeType, _items, _startIndex, _endIndex);
		}
	}
}