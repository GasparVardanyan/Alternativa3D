package alternativa.gui.layout {
	import alternativa.gui.lod.simple.ISimpleLODobject;
	
	
	/**
	 * Интерфейс ILODManager предоставляет методы менеджера лодирования.
	 * 
	 */	
	public interface ILODManager {
		
		/**
		 * Инициализация. 
		 * 
		 */		
		function init():void;
		
		/**
		 * Добавление объекта в массив.
		 * @param object Лодируемый объект.
		 * 
		 */		
		function add(object:ISimpleLODobject):void;
		
		/**
		 * Удаление объекта из массива. 
		 * @param object Лодируемый объект.
		 * 
		 */		
		function remove(object:ISimpleLODobject):void;
		
		/**
		 * Изменение индекса лода.
		 * @param value Индекс лода.
		 * @return Текущий индекс лода.
		 * 
		 */
		function get LODIndex():int;
		function set LODIndex(value:int):void;
		
		/**
		 * Границы переключения лодов по горизонтали. 
		 * 
		 */		
		function get limitsH():Array;
		function set limitsH(value:Array):void;
		
		/**
		 * Границы переключения лодов по вертикали. 
		 * 
		 */		
		function get limitsV():Array;
		function set limitsV(value:Array):void;
		
		/**
		 * Изменение размеров.
		 * @param width Ширина.
		 * @param height Высота.
		 * 
		 */		
		function resize(width:int, height:int):void;
		
	}
}