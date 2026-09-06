package alternativa.gui.container.linear {
	import alternativa.gui.lod.simple.ISimpleLODobject;
	import alternativa.gui.lod.simple.LODlistenerPriority;
	
	/**
	 * 
	 * Лодируемый горизонтальный контейнер.
	 * 
	 */	
	public class LODHBox extends HBox implements ISimpleLODobject {
		
		/**
		 * Индекс лода. 
		 */		
		protected var index:int;
		
		/**
		 * Приоритет лода. 
		 */		
		protected var priority:LODlistenerPriority;
		
		/**
		 * Зазоры между элементами. 
		 */		
		protected var _spaces:Array;
		
		/**
		 * 
		 * @param spaces Массив зазоров между элементами.
		 * 
		 */			
		public function LODHBox(spaces:Array) {
			super(space);
			
			priority = LODlistenerPriority.SIMPLE_OBJECT;
			
			_spaces = spaces;
		}
		
		/**
		 * Зазоры между элементами. 
		 * 
		 */		
		public function get spaces():Array {
			return _spaces;
		}
		public function set spaces(value:Array):void {
			_spaces = value;
			_space = _spaces[index]; 
			draw();
		}
		
		//----- ISimpleLODobject
		/**
		 * @inheritDoc 
		 * 
		 */				
		public function get LODindex():int {
			return index;
		}
		public function set LODindex(value:int):void {
			index = value;
			_space = _spaces[index]; 
			draw();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function get LODpriority():LODlistenerPriority {
			return priority;
		}
		public function set LODpriority(value:LODlistenerPriority):void {
			priority = value;
		}
		
	}
}