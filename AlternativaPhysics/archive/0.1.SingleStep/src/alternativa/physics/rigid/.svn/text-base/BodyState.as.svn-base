package alternativa.physics.rigid {
	import alternativa.physics.types.Quaternion;
	import alternativa.physics.types.Vector3;
	
	/**
	 * Класс описывает состояние твёрдого тела.
	 */
	public class BodyState {
		/**
		 * Положение тела.
		 */		
		public var pos:Vector3 = new Vector3();
		/**
		 * Ориентация тела.
		 */		
		public var orientation:Quaternion = new Quaternion();
		/**
		 * Скорость тела.
		 */		
		public var velocity:Vector3 = new Vector3();
		/**
		 * Угловая скорость тела.
		 */		
		public var rotation:Vector3 = new Vector3();
		
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