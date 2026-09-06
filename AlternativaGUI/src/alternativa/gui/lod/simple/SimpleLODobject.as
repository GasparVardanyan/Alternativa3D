package alternativa.gui.lod.simple {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	use namespace alternativagui;
	
	/**
	 * Интерфейс элемента с несколькими визуальными состояниями. Индекс состояния задается только снаружи.
	 * 
	 */	
	public class SimpleLODobject extends GUIobject implements ISimpleLODobject {
		
		/**
		 * Индекс лода. 
		 */		
		protected var index:int;
		
		/**
		 * Приоритет. 
		 */		
		protected var priority:LODlistenerPriority;
		
		
		public function SimpleLODobject() {
			super();
			
			priority = LODlistenerPriority.SIMPLE_OBJECT;
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