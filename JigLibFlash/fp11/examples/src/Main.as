package {
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;

	/**
	 * @author Ringo
	 */
	[SWF(width="800", height="600", frameRate="60")]

	public class Main extends Sprite
	{
		public function Main()
		{
			this.addEventListener(Event.ENTER_FRAME, tempLoop);
		}

		// Make sure the stage is ready
		private function tempLoop(event : Event) : void
		{
			if ( stage.stageWidth > 0 && stage.stageHeight > 0 ) {
				this.removeEventListener(Event.ENTER_FRAME, tempLoop);
				init();
			}
		}

		private function init() : void
		{
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.quality = StageQuality.HIGH;
			stage.frameRate = 60;

			// Demos, uncomment one
			
//			var away3DCarDrive : Away3DCarDrive = new Away3DCarDrive();
//			this.addChild(away3DCarDrive);
			
//			var away3DGridSystem:Away3DGridSystem = new Away3DGridSystem();
//			this.addChild(away3DGridSystem);

//			var away3DStackingTest:Away3DStackingTest = new Away3DStackingTest();
//			this.addChild(away3DStackingTest);
			
//			var away3DTerrainTest:Away3DTerrainTest = new Away3DTerrainTest();
//			this.addChild(away3DTerrainTest);

			var away3DTriangleMesh:Away3DTriangleMesh = new Away3DTriangleMesh();
			this.addChild(away3DTriangleMesh);

//			var collisionEventTest:CollisionEventTest = new CollisionEventTest();
//			this.addChild(collisionEventTest);
		}
	}
}