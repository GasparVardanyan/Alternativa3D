package alternativa.physics.rigid.constraints {
	
	import alternativa.physics.altphysics;
	import alternativa.physics.rigid.RigidWorld;
	
	use namespace altphysics;
	
	/**
	 * 
	 */
	public class Constraint {
		
		altphysics var satisfied:Boolean;
		altphysics var world:RigidWorld;
		
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