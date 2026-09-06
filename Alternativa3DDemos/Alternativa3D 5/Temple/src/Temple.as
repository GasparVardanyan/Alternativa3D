package {
	
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.utils.FPS;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import temple.Columns;
	import temple.Environment;
	import temple.Ground;
	import temple.Limits;
	import temple.SoundManager;
	import temple.Stairs;
	import temple.Stones;
	import temple.TextInfo;
	import temple.Wrecks;
	
	/**
	 * The main application class.
	 */
	public class Temple extends Sprite {
		// Logo image
		[Embed(source="temple/logo.png")] private static const bmpLogo:Class;
		private static const logoBmp:BitmapData = new bmpLogo().bitmapData;
		
		// 3D-scene
		private var scene:Scene3D;
		// The view
		private var view:View;
		// The camera
		private var camera:Camera3D;
		// The camera controller
		private var controller:WalkController;

		// Objects of the scene
		private var environment:Environment = new Environment();
		private var limits:Limits = new Limits();
		private var stones:Stones = new Stones();
		private var columns:Columns = new Columns();
		private var stairs:Stairs = new Stairs();
		private var ground:Ground = new Ground();
		private var wrecks:Wrecks = new Wrecks();
		// Sound manager
		private var soundManager:SoundManager = new SoundManager();
		// High quality rendering delay for static camera, in milliseconds
		private var qualitySwitchTime:uint = 500;
		// The identifier of the quality switch timer
		private var qualityTimerId:int = -1;
		// Wire drawing flag
		private var drawWire:Boolean = false;
		// Number of steps for window size
		private var maxViewSize:uint = 10;
		// Current window size
		private var viewSize:uint = maxViewSize;
		
		// Resources loading sequence
		private var loadingSequence:Array = [stairs, columns, stones, ground, wrecks, environment, soundManager];
		private var loadingCounter:int = -1;
		private var loadingInfo:TextField;

		private var prevOnGround:Boolean;
		
		/**
		 * Applications' constructor.
		 */
		public function Temple() {
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

			onResize(null);
		}
		
		/**
		 * Scene initialization.
		 */
		private function initScene():void {
			scene = new Scene3D();
			scene.root = new Object3D("root");
			
			environment.rotationZ = -0.34;
			environment.mobility = 0;
			scene.root.addChild(environment);
			
			limits.mobility = 5;
			scene.root.addChild(limits);
			ground.mobility = 2;
			scene.root.addChild(ground);
			stairs.mobility = 3;
			scene.root.addChild(stairs);
			columns.mobility = 4;
			scene.root.addChild(columns);
			stones.mobility = 4;
			scene.root.addChild(stones);
			wrecks.mobility = 4;
			scene.root.addChild(wrecks);
			
			camera = new Camera3D("camera");
			camera.rotationX = -1.5;
			camera.rotationZ = 2.1;
			scene.root.addChild(camera);

			view = new View(camera);
			addChild(view);
			FPS.init(this);
			
			controller = new WalkController(stage);

			controller.setDefaultBindings();
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_RIGHT);
			
			controller.object = camera;
			controller.checkCollisions = true;
			controller.speed = 80;
			controller.jumpSpeed = 160;
			controller.gravity = 500;
			controller.objectZPosition = 0.95;
			controller.maxGroundAngle = MathUtils.toRadian(45);
			controller.speedMultiplier = 2.5;
			controller.onStartMoving = setLowQuality;
			controller.onStopMoving = startHighQualityTimer;
			controller.coords = new Point3D(150, 60, 25);
			// Collision detection settings
			controller.collider.offsetThreshold = 0.0001;
			controller.collider.radiusX = 25;
			controller.collider.radiusY = 25;
			controller.collider.radiusZ = 35;

			scene.calculate();
		}
		
		/**
		 * Interface initialization.
		 */
		private function initUI():void {
			// Adding logo to the screen
			var logo:Bitmap = new Bitmap(logoBmp);
			logo.x = 3; 
			logo.y = 3; 
			addChild(logo);
			
			// Text field with controls description
			var info:TextInfo = new TextInfo();
			info.x = 3;
			info.y = 46;
			info.write("Drag — look");
			info.write("WSAD or arrows — move");
			info.write("Shift — run");
			info.write("Space — jump");
			info.write("Wheel or [ ] — change FOV");
			info.write("+/- — change screen size");
			info.write("T — show triangulation");
			addChild(info);
			
			// Status string 
			loadingInfo = new TextField();
			loadingInfo.x = 3;
			loadingInfo.text = " ";
			loadingInfo.autoSize = TextFieldAutoSize.LEFT;
			loadingInfo.selectable = false;
			loadingInfo.setTextFormat(new TextFormat("Tahoma", 10, 0xFF0000));
			loadingInfo.defaultTextFormat = new TextFormat("Tahoma", 10, 0xFF0000); 
			addChild(loadingInfo);
		}
		
		/**
		 * The main cycle method.
		 */
		private function onEnterFrame(e:Event):void {
			// Moving camera 
			controller.processInput();
			// Setting steps sound
			if (!controller.onGround || (controller.currentSpeed == 0 && prevOnGround)) {
				// When in the air or standing still
				soundManager.stopSteps();
			} else {
				// The sound is selected according to the surface under feet
				soundManager.playSteps((controller.groundMesh == ground) ? (controller.accelerated ? SoundManager.GRASS_RUN : SoundManager.GRASS_WALK) : (controller.accelerated ? SoundManager.STONE_RUN : SoundManager.STONE_WALK));
			}
			prevOnGround = controller.onGround;
			scene.calculate();
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
			environment.leftMaterial.precision = 20;
			environment.rightMaterial.precision = 20;
			environment.frontMaterial.precision = 20;
			environment.backMaterial.precision = 20;
			environment.topMaterial.precision = 20;
			stones.material.precision = 20;
			columns.material.precision = 20;
			stairs.material.precision = 20;
			ground.material.precision = 20;
			wrecks.material.precision = 20;
		}
		
		/**
		 * The method starts the timer for the setHighQiality method
		 */
		private function startHighQualityTimer():void {
			qualityTimerId = setTimeout(setHighQuality, qualitySwitchTime);
		}
		
		/**
		 * The method sets high quality of scene rendering.
		 */
		private function setHighQuality():void {
			qualityTimerId = -1;
			stage.quality = StageQuality.HIGH;
			TextureMaterial(environment.getSurfaceById("left").material).precision = 1;
			TextureMaterial(environment.getSurfaceById("right").material).precision = 1;
			TextureMaterial(environment.getSurfaceById("front").material).precision = 1;
			TextureMaterial(environment.getSurfaceById("back").material).precision = 1;
			TextureMaterial(environment.getSurfaceById("top").material).precision = 1;
			stones.material.precision = 1;
			columns.material.precision = 1;
			stairs.material.precision = 1;
			ground.material.precision = 1;
			wrecks.material.precision = 1;
		}
		
		/**
		 * The method toggles drawing of wire for polygons.
		 */
		private function toggleWire():void {
			drawWire = !drawWire;
			var thickness:int = drawWire ? 0 : -1;
			environment.leftMaterial.wireThickness = thickness; 
			environment.rightMaterial.wireThickness = thickness;
			environment.frontMaterial.wireThickness = thickness;
			environment.backMaterial.wireThickness = thickness;
			environment.topMaterial.wireThickness = thickness;
			stones.material.wireThickness = thickness;
			columns.material.wireThickness = thickness;
			stairs.material.wireThickness = thickness;
			ground.material.wireThickness = thickness;
			wrecks.material.wireThickness = thickness;
		}
		
		/**
		 * The method changes FOV when mouse wheel is being used.
		 */
		private function onMouseWheel(e:MouseEvent):void {
			addFOV(-e.delta / 20);
		}
		
		/**
		 * The method changes FOV.
		 */
		private function addFOV(value:Number):void {
			var fov:Number = camera.fov + value;
			camera.fov = (fov < MathUtils.DEG30) ? MathUtils.DEG30 : ((fov > MathUtils.toRadian(170)) ? MathUtils.toRadian(170) : fov);
		}
		
		/**
		 * Processing pressed keys.
		 */
		private function onKeyDown(e:KeyboardEvent):void {
			switch (e.keyCode) {
				// Toggling wire
				case KeyboardUtils.T:
					toggleWire();
					break;
				// Increasing view size
				case KeyboardUtils.EQUAL:
				case KeyboardUtils.NUMPAD_ADD:
					if (viewSize < maxViewSize) {
						viewSize++;
						onResize(null);
					}
					break;
				// Decreasing view size
				case KeyboardUtils.MINUS:
				case KeyboardUtils.NUMPAD_SUBTRACT:
					if (viewSize > 1) {
						viewSize--;
						onResize(null);
					}
					break;
				// Increasing FOV
				case KeyboardUtils.LEFTBRACKET:
					addFOV(3 / 20);
					break;
				// Decreasing FOV
				case KeyboardUtils.RIGHTBRACKET:
					addFOV(- 3 / 20);
					break;
			}
		}

		/**
		 * Setting size and location of interface objects on Flash player's window resizing.
		 */
		private function onResize(e:Event):void {
			var width:Number = stage.stageWidth * viewSize / maxViewSize; 
			var height:Number = stage.stageHeight * viewSize / maxViewSize; 

			view.x = (stage.stageWidth - width) >> 1;
			view.y = (stage.stageHeight - height) >> 1;
			view.width = width;
			view.height = height;
			
			loadingInfo.y = stage.stageHeight - loadingInfo.height - 1;
		}

		/**
		 * The method loads next resource.
		 */
		private function loadNextResource():void {
			loadingInfo.text = "";
			loadingCounter++;
			if (loadingCounter < loadingSequence.length) {
				loadingInfo.text = loadingSequence[loadingCounter].load(loadNextResource);
			}
		}
	}
}