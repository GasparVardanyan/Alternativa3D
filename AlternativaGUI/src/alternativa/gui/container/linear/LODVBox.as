package alternativa.gui.container.linear {
	import alternativa.gui.lod.simple.ISimpleLODobject;
	import alternativa.gui.lod.simple.LODlistenerPriority;
	
	/**
	 * Лодируемый вертикальный контейнер
	 * 
	 */	
	public class LODVBox extends VBox implements ISimpleLODobject {
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
		 * @param spaces Массив зазоров между объектами
		 * 
		 */		
		public function LODVBox(spaces:Array) {
			super(space);
			
			priority = LODlistenerPriority.SIMPLE_OBJECT;
			
			_spaces = spaces;
		}
		
		/**
		 * 
		 * Зазоры между объектами 
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
		 * Индекс уровня детализации. Также от индекса зависят и размеры элемента.
		 * Т.е. ширина или высота элемента (или и то, и другое) будут меняться дискретно в зависимости от индекса.
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
		 * Приоритет получения нового индекса при его изменении 
		 */		
		public function get LODpriority():LODlistenerPriority {
			return priority;
		}
		public function set LODpriority(value:LODlistenerPriority):void {
			priority = value;
		}
		
	}
}