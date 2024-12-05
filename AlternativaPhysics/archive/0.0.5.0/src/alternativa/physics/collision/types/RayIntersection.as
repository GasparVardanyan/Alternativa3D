package alternativa.physics.collision.types {
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.types.Vector3;
	
	/**
	 * Структура описывает точку пересечения луча с физической геометрией.
	 */
	public class RayIntersection {
		// Физический примитив, с которым пересекается луч
		public var primitive:CollisionPrimitive;
		// Положенеи точки пересечения
		public var pos:Vector3 = new Vector3();
		// Нормаль поверхности физического примитива в точке пересечения
		public var normal:Vector3 = new Vector3();
		// Время пересечения (|pos - ray.origin|/|ray.dir|)
		public var t:Number = 0;
		
		public function copy(source:RayIntersection):void {
			primitive = source.primitive;
			pos.vCopy(source.pos);
			normal.vCopy(source.normal);
			t = source.t;
		}
	}
}