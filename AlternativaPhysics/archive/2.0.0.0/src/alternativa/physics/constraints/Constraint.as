package alternativa.physics.constraints {
	
	import alternativa.physics.PhysicsScene;
	
	/**
	 * 
	 */
	public class Constraint {
		
		public var satisfied:Boolean;
		public var world:PhysicsScene;
		
		/**
		 * 
		 */
		public function Constraint() {
		}
		
		/**
		 * @param dt
		 */
		public function preProcess(dt:Number):void {
		}

		/**
		 * @param dt
		 */
		public function apply(dt:Number):void {
		}

	}
}