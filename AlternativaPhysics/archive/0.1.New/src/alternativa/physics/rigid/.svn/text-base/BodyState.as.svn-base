package alternativa.physics.rigid {
	import alternativa.types.Point3D;
	import alternativa.types.Quaternion;
	
	/**
	 * Класс описывает состояние твёрдого тела.
	 */
	public class BodyState {
		/**
		 * Положение тела.
		 */		
		public var pos:Point3D = new Point3D();
		/**
		 * Ориентация тела.
		 */		
		public var orientation:Quaternion = new Quaternion();
		/**
		 * Скорость тела.
		 */		
		public var velocity:Point3D = new Point3D();
		/**
		 * Угловая скорость тела.
		 */		
		public var rotation:Point3D = new Point3D();
		
		/**
		 * Копирует значение указанного объекта.
		 * 
		 * @param state
		 */
		public function copy(state:BodyState):void {
			pos.copy(state.pos);
			orientation.copy(state.orientation);
			velocity.copy(state.velocity);
			rotation.copy(state.rotation);
		}
		
	}
}