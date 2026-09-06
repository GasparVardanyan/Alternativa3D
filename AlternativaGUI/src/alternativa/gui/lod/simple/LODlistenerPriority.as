package alternativa.gui.lod.simple {
	
	/**
	 * Список приоритетов для лодирования объектов. 
	 * Чем меньше приоритет, тем раньше передается LODIndex объекту ISimpleLODobject.
	 */	
	public class LODlistenerPriority {
		
		/** 
		 * Порядок выполнения: 0. 
		 */		
		public static const SIMPLE_OBJECT:LODlistenerPriority = new LODlistenerPriority(0);		
		
		/** 
		 * Порядок выполнения: 1. 
		 */
		public static const CONTROL:LODlistenerPriority = new LODlistenerPriority(1);		
		
		/** 
		 * Порядок выполнения: 2. 
		 */
		public static const COMPOSITE_CONTROL:LODlistenerPriority = new LODlistenerPriority(2);	
			
		/** 
		 * Порядок выполнения: 3. 
		 */
		public static const CONTAINER:LODlistenerPriority = new LODlistenerPriority(3);		
		
		/** 
		 * Порядок выполнения: 4. 
		 */
		public static const COMPOSITE_CONTAINER:LODlistenerPriority = new LODlistenerPriority(4);		
		
		/** 
		 * Порядок выполнения: 5. 
		 */
		public static const PANEL:LODlistenerPriority = new LODlistenerPriority(5);		
		
		public var value:int;
		
		public function LODlistenerPriority(value:int) {
			this.value = value;
		}
		
		/**
		 * Возвращает строковое представление значения LODlistenerPriority. 
		 * 
		 */		
		public function toString():String {
			var s:String;
			switch (value) {
				case 0:
					s = "SIMPLE_OBJECT";
					break;
				case 1:
					s = "CONTROL";
					break;
				case 2:
					s = "COMPOSITE_CONTROL";
					break;
				case 3:
					s = "CONTAINER";
					break;
				case 4:
					s = "COMPOSITE_CONTAINER";
					break;
				case 5:
					s = "PANEL";
					break;
			}			
			return s;
		}
		
	}
}