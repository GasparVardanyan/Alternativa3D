package utility{
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	/**
	 * ...
	 * @author redefy
	 */
	public class FPSCamera {
		private var centerMouseX:Number;
		private var centerMouseY:Number;
		private var stageWidth:Number;
		private var stageHeight:Number;
		private var nullPositionCamera:Vector3D = new Vector3D();
		private var nullRotationCamera:Vector3D = new Vector3D();
		private var offsetCameraCenter:Point = new Point();
		private var offsetCameraFrame:Point = new Point();
		
		private var speedFactor:Point = new Point(0.002, 0.002);
		private var speedCamera:Number = 0.4;
		private var hTriggers:Number = 10;
		private var hTriggersSpeed:Number = 0.25;
		private var hOffset:Number = 1.05;
		private var vCameraConstraints:Point = new Point( -1.10, -2.36);
		
		public function FPSCamera():void {
			initMainParametrs();
		}
		
		private function initMainParametrs():void {
			stageWidth = GV.stage.stageWidth;
			stageHeight = GV.stage.stageHeight;
			centerMouseX = stageWidth >> 1;
			centerMouseY = stageHeight >> 1;
			nullPositionCamera = new Vector3D(GV.camera.x, GV.camera.y, GV.camera.z);
			nullRotationCamera = new Vector3D(GV.camera.rotationX, GV.camera.rotationY, GV.camera.rotationZ);
		}
		
		public function update(/*xx:Number, yy:Number*/):void {
			//trace(xx, yy);
			/*if (xx < 0) {
				GV.camera.rotationZ -= xx / 200;
			} else {
				GV.camera.rotationZ -= xx / 200;
			}
			
			if (yy < 0) {
				GV.camera.rotationX -= yy / 200;
			} else {
				GV.camera.rotationX -= yy / 200;
			}*/
			
			var direct:int = 0;
			offsetCameraCenter.x = centerMouseX - GV.stage.mouseX;
			offsetCameraCenter.y = centerMouseY - GV.stage.mouseY;
			
			if (Math.abs(offsetCameraCenter.x) > 0) {
				direct = FPSCamera.sign(offsetCameraCenter.x);
				if (Math.abs(offsetCameraCenter.x) > centerMouseX-hTriggers) {
					offsetCameraFrame.x = GV.camera.rotationZ + hTriggersSpeed * direct;
					nullRotationCamera.z = GV.camera.rotationZ - hOffset *direct;
				} else {
					offsetCameraFrame.x = nullRotationCamera.z + offsetCameraCenter.x * speedFactor.x;
				}
			}
		
			if (Math.abs(offsetCameraCenter.y) > 0) {
				direct = FPSCamera.sign(offsetCameraCenter.y);
				if (Math.abs(offsetCameraCenter.y) > centerMouseX-hTriggers) {
					offsetCameraFrame.y = GV.camera.rotationX + hTriggersSpeed * direct;
					nullRotationCamera.x = GV.camera.rotationX - hOffset *direct;
				} else {
					if(GV.camera.rotationX < vCameraConstraints.x || GV.camera.rotationX > vCameraConstraints.y) {
						offsetCameraFrame.y = nullRotationCamera.x + offsetCameraCenter.y * speedFactor.y;
					}
				}
			}
			
			TweenNano.to(GV.camera, speedCamera, {rotationX:offsetCameraFrame.y, rotationZ:offsetCameraFrame.x } );
		}
		
		public static function sign(value:Number):int {
			return value < 0 ? -1 : (value > 0 ? 1 : 0);
		}
	}
}