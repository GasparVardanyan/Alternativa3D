package alternativa.gui.lod.simple {
	import __AS3__.vec.Vector;
	
	/**
	 * Интерфейс элемента с несколькими визуальными состояниями.
	 * Индекс состояния задается только снаружи.
	 */	
	public interface ISimpleLODobject {
		
		/**
		 * Индекс уровня детализации. Также от индекса зависят и размеры элемента.
		 * Т.е. ширина или высота элемента (или и то, и другое) будут меняться дискретно в зависимости от индекса.
		 */		
		function get LODindex():int;
		function set LODindex(index:int):void;
		
		/**
		 * Приоритет получения нового индекса при его изменении.
		 */		
		function get LODpriority():LODlistenerPriority;
		function set LODpriority(value:LODlistenerPriority):void;
		
	}
}