package alternativa.physics.constraints {
	
	import alternativa.physics.PhysicsScene;
	import alternativa.physics.altphysics;
	
	use namespace altphysics;
	
	/**
	 * 
	 */
	public class Constraint {
		
		altphysics var satisfied:Boolean;
		altphysics var world:PhysicsScene;
		
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