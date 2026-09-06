package alternativa.demo.factory {

	import alternativa.engine3d.controllers.WalkController;
	import alternativa.types.Point3D;

	import flash.display.DisplayObject;

	/**
	 * Camera controller for the demo.
	 */
	public class FactoryCameraController extends WalkController {

		// Minimum camera's X coordinate
		public var minCameraCoordsX:Number;
		// Maximum camera's X coordinate
		public var maxCameraCoordsX:Number;
		// Minimum camera's Y coordinate
		public var minCameraCoordsY:Number;
		// Maximum camera's Y coordinate
		public var maxCameraCoordsY:Number;
		// Minimum camera's rotation angle around X axis 
		public var minCameraRotationX:Number;
		// Maximum camera's rotation angle around X axis 
		public var maxCameraRotationX:Number;

		/**
		 * Creates a new instance of controller.
		 */
		public function FactoryCameraController(eventSourceObject:DisplayObject) {
			super(eventSourceObject);
		}

		/**
		 * The method overloaded to apply rotation limits.
		 */
		override protected function rotateObject(frameTime:Number):void {
			super.rotateObject(frameTime);
			_object.rotationX = (_object.rotationX < minCameraRotationX) ? minCameraRotationX : (_object.rotationX > maxCameraRotationX) ? maxCameraRotationX : _object.rotationX;
		}

		/**
		 * The method overloaded to apply movement limits.
		 */
		override protected function applyDisplacement(frameTime:Number, displacement:Point3D):void {
			super.applyDisplacement(frameTime, displacement);
			// Applying limits along X axis
			_coords.x = (_coords.x < minCameraCoordsX) ? minCameraCoordsX : ((_coords.x > maxCameraCoordsX) ? maxCameraCoordsX : _coords.x);
			// Applying limits along Y axis
			_coords.y = (_coords.y < minCameraCoordsY) ? minCameraCoordsY : ((_coords.y > maxCameraCoordsY) ? maxCameraCoordsY : _coords.y);
			// Updating object's coordinates
			setObjectCoords();
		}

	}
}
