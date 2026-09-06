package bunker {
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.types.Point3D;
	
	import flash.display.DisplayObject;

	/**
	 * Camera controller for the demo.
	 */
	public class BunkerCameraController extends WalkController {
		
		/**
		 * Additional external acceleration vector. 
		 */
		public var additionalAcceleration:Point3D = new Point3D();
		
		/**
		 * 
		 */
		public function BunkerCameraController(eventSourceObject:DisplayObject) {
			super(eventSourceObject);
		}
		
		/**
		 * Method is overloaded to apply external acceleration.
		 */
		override protected function applyDisplacement(frameTime:Number, displacement:Point3D):void {
			if (additionalAcceleration.x != 0 || additionalAcceleration.y != 0 || additionalAcceleration.z != 0) {
				var k:Number = 0.5 * frameTime * frameTime;
				displacement.x += k * additionalAcceleration.x;
				displacement.y += k * additionalAcceleration.y;
				displacement.z += k * additionalAcceleration.z;
			}
			super.applyDisplacement(frameTime, displacement);
		}
	}
}