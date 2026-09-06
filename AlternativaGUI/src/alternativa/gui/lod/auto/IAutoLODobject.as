package alternativa.gui.lod.auto {
	import __AS3__.vec.Vector; 
	
	/**
	 * Интерфейс лодируемого объекта, выбирающего лод в зависимости от заданных ему размеров.
	 * 
	 */	
	public interface IAutoLODobject {
		
		/**
		 * Границы диапазонов уровней детализации по вертикали.
		 */
		function get LODlimitsV():Vector.<int>;
		function set LODlimitsV(value:Vector.<int>):void;
		
		/**
		 * Двухмерный массив границ диапазонов уровней детализации по горизонтали.
		 * <p>Индекс массива соответствует индексу детализации по вертикали.</p>
		 */		
		function get LODlimitsH():Vector.<Vector.<int>>;
		function set LODlimitsH(value:Vector.<Vector.<int>>):void;
		
		/**
		 * Индекс уровня детализации по горизонтали.
		 * <p>Увеличение индекса - уменьшение детализации.</p>
		 */		
		function get LODindexH():int;
		function set LODindexH(index:int):void;
		
		/**
		 * Индекс уровня детализации по вертикали.
		 * <p>Увеличение индекса - уменьшение детализации.</p>
		 */
		function get LODindexV():int;
		function set LODindexV(index:int):void;
		
	}
}