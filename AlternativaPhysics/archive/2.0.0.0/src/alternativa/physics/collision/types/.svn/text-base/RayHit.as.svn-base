package alternativa.physics.collision.types {
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.math.Vector3;
	
	/**
	 * Структура описывает точку пересечения луча с физической геометрией.
	 */
	public class RayHit {
		// Физический примитив, с которым пересекается луч
		public var primitive:CollisionPrimitive;
		// Глобальные координаты точки пересечения
		public var pos:Vector3 = new Vector3();
		// Глобальная нормаль поверхности физического примитива в точке пересечения
		public var normal:Vector3 = new Vector3();
		// Время пересечения (|pos - ray.origin|/|ray.dir|)
		public var t:Number = 0;
		
		/**
		 * Копирует данные объекта-источника.
		 * 
		 * @param source источник данных
		 */
		public function copy(source:RayHit):void {
			primitive = source.primitive;
			pos.copy(source.pos);
			normal.copy(source.normal);
			t = source.t;
		}
	}
}