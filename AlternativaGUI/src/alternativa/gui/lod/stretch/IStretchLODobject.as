package alternativa.gui.lod.stretch {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.lod.simple.ISimpleLODobject;
	
	/**
	 * Интерфейс элемента с несколькими визуальными состояниями.
	 * Дискретно меняется вид элемента и его размер по лодируемой стороне.
	 * Индекс состояния задается только снаружи.
	 * Если лодируется высота, нужно задать набор фиксированных высот для LOD-ов.
	 * Если набора замеров для стороны нет - размер по этой стороне меняется плавно.
	 * Индекс лодирования не может быть больше длины набора размеров.
	 * Т.е. из LODwidth.length и LODheight.length берется максимальный.
	 * А если в наборе не хватает значения для текущего индекса, то берется крайнее значение набора.
	 */	
	public interface IStretchLODobject extends ISimpleLODobject {
		
		/**
		 * Ширина LOD-ов. Если не задано, ширина меняется плавно. 
		 */		
		function get LODwidth():Vector.<int>;
		function set LODwidth(value:Vector.<int>):void;
		
		/**
		 * Высота LOD-ов. Если не задано, высота меняется плавно. 
		 */
		function get LODheight():Vector.<int>;
		function set LODheight(value:Vector.<int>):void;
		
	}
}