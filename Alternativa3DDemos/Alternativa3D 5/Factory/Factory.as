package {

	import alternativa.demo.DemoInfo;
	import alternativa.demo.factory.*;
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.core.*;
	import alternativa.engine3d.display.View;
	import alternativa.types.Point3D;
	import alternativa.utils.*;

	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	import flash.utils.*;

	// Setting background color and Flash player window size.
	[SWF(backgroundColor="0x0", width="800", height="600")]
	/**
	 * The main application class.
	 */
	public class Factory extends Sprite {

		// Factory AS-class generated model
		private var factory:FactoryMesh = new FactoryMesh();

		// 3D scene
		private var scene:Scene3D;
		// Root object
		private var sceneRoot:Object3D;
		// The camera
		private var camera:Camera3D;
		// The view
		private var view:View;

		// Camera controller
		private var controller:FactoryCameraController;

		// High quality rendering delay for static camera, in milliseconds
		private var qualitySwitchTime:uint = 100;
		// The identifier of the quality switch timer
		private var qualityTimerId:int = -1;

		// Wire drawing flag
		private var drawWire:Boolean = false;

		// Resources loading sequence
		private var loadingSequence:Array = [factory];
		private var loadingCounter:int = -1;
		private var loadingInfo:TextField;

		/**
		 * Application's constructor.
		 */
		public function Factory() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 100;

			// Scene initialization
			initScene();

			// Interface initialization
			initUI();

			// Start resources loading
			loadNextResource();

			// Setting events handlers
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.RESIZE, onResize);

			onResize();
		}

		/**
		 * Scene initialization.
		 */
		private function initScene():void {
			scene = new Scene3D();
 			scene.root = sceneRoot = new Object3D("root");

			sceneRoot.addChild(factory);

			camera = new Camera3D("camera");
			camera.orthographic = true;
			camera.zoom = 0.6;
			camera.rotationX = -1.93;
			camera.rotationZ = 2.15;
			sceneRoot.addChild(camera);

			controller = new FactoryCameraController(stage);
			controller.object = camera;
			controller.speed = 2500;
			// Initial camera position
			controller.coords = new Point3D(0, 0, 250);
			// Camera's motion limits
			controller.minCameraCoordsX = -1685;
			controller.maxCameraCoordsX = 1688;
			controller.minCameraCoordsY = -1031;
			controller.maxCameraCoordsY = 1216;
			// Camera's angle limits
			controller.minCameraRotationX = -2.8;
			controller.maxCameraRotationX = -1.7;
			// Quality switch handlers
			controller.onStartMoving = setLowQuality;
			controller.onStopMoving = startHighQualityTimer;
			// Setting control keys
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.W, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.S, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.A, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_RIGHT);
			controller.bindKey(KeyboardUtils.D, ObjectController.ACTION_RIGHT);

			view = new View(camera)
			addChild(view);
		}

		/**
		 * Interface initialization.
		 */
		private function initUI():void {
			FPS.init(this);

			// Adding logo and text info to the screen
			var info:DemoInfo = new DemoInfo("Alternativa3D 5\nDemo \"Factory\"\n");
			info.x = 3;
			info.y = 3;
			info.write("Drag — rotate camera");
			info.write("WSAD or arrows — move camera");
			info.write("Wheel or +/- — change zoom");
			info.write("T — show polygons");
			addChild(info);

			// Status string 
			loadingInfo = new TextField();
			loadingInfo.x = 3;
			loadingInfo.autoSize = TextFieldAutoSize.LEFT;
			loadingInfo.selectable = false;
			loadingInfo.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF0000); 
			addChild(loadingInfo);
		}

		/**
		 * The method loads next resource.
		 */
		public function loadNextResource():void {
			loadingCounter++;
			if (loadingCounter < loadingSequence.length) {
				loadingInfo.text = loadingSequence[loadingCounter].load(loadNextResource);
			} else {
				// Hiding status line
				loadingInfo.parent.removeChild(loadingInfo);
			}
		}

		/**
		 * The method sets low quality of scene rendering.
		 */
		private function setLowQuality():void {
			if (qualityTimerId > -1) {
				clearTimeout(qualityTimerId);
				qualityTimerId = -1;
			}
			stage.quality = StageQuality.LOW;
		}

		/**
		 * The method starts the timer for the setHighQiality method
		 */
		private function startHighQualityTimer():void {
			qualityTimerId = setTimeout(setHighQiality, qualitySwitchTime);
		}

		/**
		 * The method sets high quality of scene rendering.
		 */
		private function setHighQiality():void {
			stage.quality = StageQuality.HIGH;
		}

		/**
		 * The method toggles drawing of wire for polygons.
		 */
		private function toggleWire():void {
			drawWire = !drawWire;
			factory.material.wireThickness = drawWire ? 0 : -1;
		}

		/**
		 * The method changes zoom when mouse wheel is being used.
		 */
		private function onMouseWheel(e:MouseEvent):void {
			multiplyZoom(e.delta/20);
		}

		/**
		 * The method changes zoom.
		 */
		private function multiplyZoom(value:Number):void {
			var zoom:Number = camera.zoom*(1 + value);
			camera.zoom = (zoom < 0.1) ? 0.1 : (zoom > 20 ? 20 : zoom);
		}

		/**
		 * Processing pressed keys.
		 */
		private function onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				case KeyboardUtils.EQUAL:
				case KeyboardUtils.NUMPAD_ADD:
					multiplyZoom(3/20);
					break;
				case KeyboardUtils.MINUS:
				case KeyboardUtils.NUMPAD_SUBTRACT:
					multiplyZoom(-3/20);
					break;
				case KeyboardUtils.T:
					toggleWire();
					break;
			}
		}

		/**
		 * The main cycle method.
		 */
		private function onEnterFrame(e:Event = null):void {
			// Processing user input 
			controller.processInput();
			// Scene calculation
			scene.calculate();
		}

		/**
		 * Setting size and location of interface objects on Flash player's window resizing.
		 */
		private function onResize(e:Event = null):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;

			loadingInfo.y = stage.stageHeight - loadingInfo.height - 1;

			// Redrawing the view
			onEnterFrame();
		}

	}
}
