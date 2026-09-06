package alternativa.gui.event {
	
	/**
	 * Класс DataChangeType определяет константы для события DataChangeEvent.changeType. 
	 * Эти константы используются классом DataChangeEvent для определения типа изменений.  
	 * 
	 */	
	public class DataChangeType {

		/**
		 * Изменены данные компонента. Это значение не влияет на данные компонента, которые оно описывает.  
		 */		
		public static const CHANGE:String = "change";
		
		/**
		 * Изменены данные, содержащиеся в элементе.  
		 */		
		public static const INVALIDATE:String = "invalidate";
		
		/**
		 * Набор данных недопустим.  
		 */		
		public static const INVALIDATE_ALL:String = "invalidateAll";
		
		/**
		 * В набор данных, предоставляемых поставщиком данных, были добавлены элементы.  
		 */		
		public static const ADD:String = "add";
		
		/**
		 * Из набора данных, предоставляемых поставщиком данных, были удалены элементы.  
		 */		
		public static const REMOVE:String = "remove";
		
		/**
		 * Из набора данных, предоставляемых поставщиком данных, были удалены все элементы.  
		 */		
		public static const REMOVE_ALL:String = "removeAll";
		
		/**
		 * Элементы, предоставляемые поставщиком данных, были заменены новыми элементами.  
		 */		
		public static const REPLACE:String = "replace";
		
		/**
		 * Данные, предоставляемые поставщиком данных, были отсортированы. Эта константа используется, чтобы обозначить изменение порядка данных, а не самих данных.  
		 */		
		public static const SORT:String = "sort";
	}
}