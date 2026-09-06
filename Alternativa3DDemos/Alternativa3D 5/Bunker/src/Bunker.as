package {
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.utils.FPS;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	
	import bunker.BunkerCameraController;
	import bunker.BunkerMesh;
	import bunker.BunkerWindows;
	import bunker.Core;
	import bunker.Energy;
	import bunker.Entrance;
	import bunker.EntranceWindows;
	import bunker.Grid;
	import bunker.MoveSound;
	import bunker.Passage;
	import bunker.Reactor;
	import bunker.ReactorLight;
	import bunker.Screen;
	import bunker.ScreenLight;
	import bunker.Slope;
	import bunker.Sound3D;
	import bunker.Splits;
	import bunker.TextInfo;
	import bunker.Ventilation;
	import bunker.Ventilators;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
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
	import flash.utils.getTimer;
	import flash.utils.setTimeout;
	
	/**
	 * The main application class.
	 */
	public class Bunker extends Sprite {
		// Logo image
		[Embed(source="bunker/logo.png")] private static const bmpLogo:Class;
		private static const logoBmp:BitmapData = new bmpLogo().bitmapData;
		
		// Walk mode icon
		[Embed(source="bunker/walk.png")] private static const bmpWalk:Class;
		private static const walkBmp:BitmapData = new bmpWalk().bitmapData;
		
		// Fly mode icon
		[Embed(source="bunker/fly.png")] private static const bmpFly:Class;
		private static const flyBmp:BitmapData = new bmpFly().bitmapData;
		
		// Constants for bunker sectors
		private static const SECTOR_NONE:int = 0;
		private static const SECTOR_ENTRANCE:int = 1;
		private static const SECTOR_BUNKER:int = 2;
		private static const SECTOR_REACTOR:int = 3;

		// Current sector
		private var currentSector:int = SECTOR_NONE;
		// Object with zero mobility containing auxiliary planes, which separate bunker's parts for BSP-tree optimization
		private var splits:Splits = new Splits();
		
		// Bunker's parts
		private var entrance:Entrance = new Entrance();
		private var entranceWindows:EntranceWindows = new EntranceWindows();
		private var screen:Screen = new Screen();
		private var screenLight:ScreenLight = new ScreenLight();
		private var passage:Passage = new Passage();
		private var bunkerMesh:BunkerMesh = new BunkerMesh();
		private var bunkerWindows:BunkerWindows = new BunkerWindows();
		private var grid:Grid = new Grid();
		private var slope:Slope = new Slope();
		private var core:Core = new Core();
		private var reactor:Reactor = new Reactor();
		private var reactorLight:ReactorLight = new ReactorLight();
		private var ventilation:Ventilation = new Ventilation();
		private var ventilators:Ventilators = new Ventilators();
		private var energy:Energy = new Energy();
		
		// Sets contain objects which form each sector of the bunker
		private	var entranceObjects:Set = Set.createFromArray([entrance, entranceWindows, screen, screenLight, passage]);
		private	var bunkerObjects:Set = Set.createFromArray([bunkerMesh, bunkerWindows, grid, passage, slope]);
		private	var reactorObjects:Set = Set.createFromArray([core, reactor, ventilation, ventilators, reactorLight, energy, slope]);
		// Map associates sectors with sets of objects
		private	var sectorObjects:Map = new Map();

		// Sounds
		private var moveSound:MoveSound = new MoveSound();
		private var entranceAmbient:Sound3D = new Sound3D(new Point3D(362, -1945, 0), 370, 690, 50, "entrance.mp3", "Loading entrance ambient",3);
		private var bunkerAmbient:Sound3D = new Sound3D(new Point3D(0, -315, 0), 770, 1270, 50, "bunker.mp3", "Loading bunker ambient", 3);
		private var reactorAmbient:Sound3D = new Sound3D(new Point3D(0, 2323, -250), 607, 1615, 50, "reactor.mp3", "Loading reactor ambient", 1);
		private var ventilatorSound1:Sound3D = new Sound3D(new Point3D(472, 2322, -470), 150, 650, 10, "ventilator.mp3", "Loading ventilator sound", 3);
		private var ventilatorSound2:Sound3D = new Sound3D(new Point3D(-472, 2322, -470), 150, 650, 10, "ventilator.mp3", "Loading ventilator sound", 3);
		private var ventilatorSound3:Sound3D = new Sound3D(new Point3D(0, 2795, -470), 150, 650, 10, "ventilator.mp3", "Loading ventilator sound", 3);
		
		// 3D-scene
		private var scene:Scene3D;
		// Root object
		private var sceneRoot:Object3D;
		// View
		private var view:View;
		// Camera
		private var camera:Camera3D;
		
		// Camera controller
		private var controller:BunkerCameraController;
		private var controllerCoords:Point3D = new Point3D();
		
		// High quality rendering delay for static camera, in milliseconds
		private var qualitySwitchTime:uint = 500;
		// The identifier of the quality switch timer
		private var qualityTimerId:int = -1;
		
		// Wire drawing flag
		private var drawWire:Boolean = false;
		// Fly mode flag
		private var flyMode:Boolean = false;
		// Icon, which shows current move mode
		private var moveModeIcon:Bitmap;

		// Starting coordinates in each sector
		private var entranceCoords:Point3D = new Point3D(362, -2120, 30);
		private var bunkerCoords:Point3D = new Point3D(73, -776, 31);
		private var reactorCoords:Point3D = new Point3D(-4, 1934, -600);
		
		// Ventilators' wind force
		private var windForce:Point3D = new Point3D();

		// Number of steps for window size
		private var maxViewSize:uint = 10;
		// Current window size
		private var viewSize:uint = maxViewSize;

		// Resources loading sequence
		private var loadingSequence:Array = [moveSound, entrance, passage, entranceAmbient, bunkerMesh, grid, bunkerAmbient, slope, reactor, ventilation, reactorAmbient, ventilatorSound1, ventilatorSound2, ventilatorSound3];
		private var loadingCounter:int = -1;
		private var loadingInfo:TextField;
		
		// Time of the last frame, which is used for calculation of the time that passed between frames
		private var lastFrameTime:uint;
		private var prevOnGround:Boolean;
		
		/**
		 * Application's constructor.
		 */
		public function Bunker() {
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.frameRate = 100;
			
			sectorObjects.add(SECTOR_NONE, new Set());
			sectorObjects.add(SECTOR_ENTRANCE, entranceObjects);
			sectorObjects.add(SECTOR_BUNKER, bunkerObjects);
			sectorObjects.add(SECTOR_REACTOR, reactorObjects);
			
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
			scene.root = sceneRoot = new Object3D("root");
			sceneRoot.addChild(splits);
			// Setting starting sector
			controllerCoords.copy(entranceCoords);
			changeSector(SECTOR_ENTRANCE);
			
			camera = new Camera3D("camera");
			camera.rotationX = -MathUtils.DEG90;
			sceneRoot.addChild(camera);

			view = new View(camera);
			addChild(view);
			FPS.init(this);
			
			controller = new BunkerCameraController(stage);
			controller.object = camera;
			
			controller.setDefaultBindings();
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_RIGHT);
			
			controller.onStartMoving = setLowQuality;
			controller.onStopMoving = startHighQualityTimer;
			controller.speed = 150;
			controller.speedThreshold = 1;
			controller.jumpSpeed = 300;
			controller.maxGroundAngle = MathUtils.toRadian(50);
			controller.gravity = 1000;
			controller.objectZPosition = 0.95;
			controller.coords = controllerCoords;
			controller.checkCollisions = true;
			
			// Collision detection settings
			controller.collider.offsetThreshold = 0.0001;
			controller.collider.radiusX = 14;
			controller.collider.radiusY = 14;
			controller.collider.radiusZ = 35;
			// Part of the bunker mesh (under the grid) which is ignored in collision detection procedure
			var ignoreSet:Set = new Set(true);
			ignoreSet.add(bunkerMesh.getSurfaceById("Bunker1"));
			controller.collider.collisionSet = ignoreSet;
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
			
			// Addig move mode icon
			moveModeIcon = new Bitmap(flyMode ? flyBmp : walkBmp);
			moveModeIcon.alpha = 0.4;
			moveModeIcon.blendMode = BlendMode.ADD;
			addChild(moveModeIcon);
			
			// Text field with controls description
			var info:TextInfo = new TextInfo();
			info.x = 3;
			info.y = 46;
			info.write("Drag — look");
			info.write("WSAD or arrows — move");
			info.write("Space — jump");
			info.write("F — on/off fly mode");
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
		 * The method loads next resource.
		 */
		private function loadNextResource():void {
			loadingInfo.text = "";
			loadingCounter++;
			if (loadingCounter < loadingSequence.length) {
				loadingInfo.text = loadingSequence[loadingCounter].load(loadNextResource);
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
			var precision:Number = 20;
			stage.quality = StageQuality.LOW;
			entrance.material.precision = precision;
			screen.material.precision = precision;
			passage.material.precision = precision;
			bunkerMesh.material1.precision = precision;
			bunkerMesh.material2.precision = precision;
			grid.material.precision = precision;
			slope.material.precision = precision;
			reactor.bottomMaterial1.precision = precision;
			reactor.bottomMaterial2.precision = precision;
			reactor.topMaterial1.precision = precision;
			reactor.topMaterial2.precision = precision;
			ventilation.material.precision = precision;
			energy.material.precision = precision;
			ventilators.material.precision = precision;
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
			qualityTimerId = -1;
			stage.quality = StageQuality.HIGH;
			entrance.material.precision = 1;
			screen.material.precision = 5;
			passage.material.precision = 1;
			bunkerMesh.material1.precision = 1;
			bunkerMesh.material2.precision = 1;
			grid.material.precision = 1;
			slope.material.precision = 1;
			reactor.bottomMaterial1.precision = 1;
			reactor.bottomMaterial2.precision = 1;
			reactor.topMaterial1.precision = 1;
			reactor.topMaterial2.precision = 1;
			ventilation.material.precision = 1;
			energy.material.precision = 15;
			ventilators.material.precision = 15;
		}
		
		/**
		 * The method changes current sector.
		 */
		private function changeSector(value:uint):void {
			if (value == currentSector) {
				return;
			}
			
			var currentObjects:Set = sectorObjects[currentSector];
			var targetObjects:Set = sectorObjects[value];
			
			// Deleting all objects that don't belong to the destination sector
			removeObjects(Set.difference(currentObjects, targetObjects));
			// Adding necessary objects to the scene
			addObjects(Set.difference(targetObjects, currentObjects));
			
			currentSector = value;

			if (currentSector == SECTOR_ENTRANCE) {
				screen.startAnimation();
			} else {
				screen.stopAnimation();
			}

			scene.calculate();
		}
		
		/**
		 * The method adds the objects from the set to scene.
		 */
		private function addObjects(objects:Set):void {
			for (var o:* in objects) {
				sceneRoot.addChild(o);
			}
		}
		
		/**
		 * The method deletes listed in the set objects from the scene.
		 */
		private function removeObjects(objects:Set):void {
			for (var o:* in objects) {
				sceneRoot.removeChild(o);
			}
		}
		
		/**
		 * The method checks current location and switches sectors if necessary.
		 */
		private function checkPlace():void {
			if (camera.y > -1582.677 && camera.y < -1062.992) {
				// The camera is in the corridor between entrance and bunker room
				if (currentSector == SECTOR_ENTRANCE && camera.x < 117.645) {
					changeSector(SECTOR_BUNKER);
				} else if (currentSector == SECTOR_BUNKER && camera.x > 246.789) {
					changeSector(SECTOR_ENTRANCE);
				}
			} else {
				// The camera is in the passage to the reactor
				if (camera.y > 629.921 && camera.y < 1574.803) {
					var z:Number = -0.5333999377700073 * camera.y + 335.9998222000208;
					if (currentSector == SECTOR_BUNKER && camera.z <= z + 2) {
						changeSector(SECTOR_REACTOR);
					} else if (currentSector == SECTOR_REACTOR && camera.z > z+10) {
							changeSector(SECTOR_BUNKER);
					} 
				}
			}
		}
		
		/**
		 * The main cycle method.
		 */
		private function onEnterFrame(e:Event):void {
			// Calculating time between frames
			var time:uint = getTimer();
			var frameTime:Number = (time - lastFrameTime) / 1000;
			if (frameTime > 0.1) {
				frameTime = 0.1;
			}
			lastFrameTime = time;
			
			// Calculating fans' influence
			if (currentSector == SECTOR_REACTOR) {
				ventilation.getWindForce(controllerCoords, 400, windForce);
				windForce.multiply(4000);
				controller.additionalAcceleration.copy(windForce);
			}
			
			// Moving camera 
			controller.processInput();
			controller.readCoords(controllerCoords);

			// Setting sound properties
			// The right ear's normal is used to calculate sound panning
			var normal:Point3D = new Point3D(Math.cos(camera.rotationZ), Math.sin(camera.rotationZ), 0);
			var cameraCoords:Point3D = camera.coords;
			entranceAmbient.checkVolume(cameraCoords, normal);
			bunkerAmbient.checkVolume(cameraCoords, normal);
			reactorAmbient.checkVolume(cameraCoords, normal);
			ventilatorSound1.checkVolume(cameraCoords, normal);
			ventilatorSound2.checkVolume(cameraCoords, normal);
			ventilatorSound3.checkVolume(cameraCoords, normal);
			screen.checkVolume(cameraCoords, normal);

			// Energy and fans animation
			if (currentSector == SECTOR_REACTOR) {
				ventilators.rotate(frameTime * 3);
				energy.redraw();
			}
			// Rotation of the lightning plane to the camera
			var isMoving:Boolean = controller.currentSpeed > 0;
			if (currentSector == SECTOR_REACTOR && isMoving) {
				energy.rotationZ = -Math.atan2(energy.x - camera.x, energy.y - camera.y);
			}
			
			if (flyMode) {
				// In the fly mode the sound of jet pack is turned on
				moveSound.setMode(MoveSound.FLY, 2 + 2 * controller.currentSpeed / controller.speed);
			} else {
				// In the walk mode sound of steps is turned on while moving
				if (controller.onGround && (isMoving || !prevOnGround)) {
					if (!prevOnGround) {
						moveSound.playSingleStepSample();
					} else if (isMoving) {
						moveSound.setMode(controller.accelerated ? MoveSound.RUN : MoveSound.WALK);
					}
				} else {
					moveSound.setMode(MoveSound.NONE);
				}
			}
			prevOnGround = controller.onGround;
			
			checkPlace();
			scene.calculate();
		}

		/**
		 * The method toggles drawing of wire for polygons.
		 */
		private function toggleWire():void {
			drawWire = !drawWire;
			var thickness:int = drawWire ? 0 : -1;
			entrance.material.wireThickness = thickness;
			screen.material.wireThickness = thickness;
			passage.material.wireThickness = thickness;
			bunkerMesh.material1.wireThickness = thickness;
			bunkerMesh.material2.wireThickness = thickness;
			grid.material.wireThickness = thickness;
			slope.material.wireThickness = thickness;
			reactor.bottomMaterial1.wireThickness = thickness;
			reactor.bottomMaterial2.wireThickness = thickness;
			reactor.topMaterial1.wireThickness = thickness;
			reactor.topMaterial2.wireThickness = thickness;
			ventilation.material.wireThickness = thickness;
			ventilators.material.wireThickness = thickness;
			energy.material.wireThickness = thickness;
		}
		
		/**
		 * The method changes FOV when mouse wheel is being used.
		 */
		private function onMouseWheel(e:MouseEvent):void {
			addFOV(e.delta / 20);
		}
		
		/**
		 * The method changes FOV.
		 */
		private function addFOV(value:Number):void {
			var fov:Number = camera.fov - value;
			camera.fov = (fov < MathUtils.DEG30) ? MathUtils.DEG30 : ((fov > MathUtils.toRadian(170)) ? MathUtils.toRadian(170) : fov);
		}

		/**
		 * The methods toggles move modes.
		 */
		private function toggleFlyMode():void {
			flyMode = !flyMode;
			controller.flyMode = flyMode;
			moveModeIcon.bitmapData = flyMode ? flyBmp : walkBmp;
		}
		
		/**
		 * Processing pressed keys.
		 */
		private function onKeyDown(e:KeyboardEvent):void {
			var key:*;
			switch (e.keyCode) {
				// Toggling move mode
				case KeyboardUtils.F:
					toggleFlyMode();
					break;
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
					addFOV(-3/20);
					break;
				// Decreasing FOV
				case KeyboardUtils.RIGHTBRACKET:
					addFOV(3/20);
					break;
				// Teleport to the entrance room
				case KeyboardUtils.NUMBER_1:
					controller.coords = entranceCoords;
					changeSector(SECTOR_ENTRANCE);
					break;
				// Teleport to the bunker room
				case KeyboardUtils.NUMBER_2:
					controller.coords = bunkerCoords;
					changeSector(SECTOR_BUNKER);
					break;
				// Teleport to the ractor room
				case KeyboardUtils.NUMBER_3:
					controller.coords = reactorCoords;
					changeSector(SECTOR_REACTOR);
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
			moveModeIcon.x = stage.stageWidth - moveModeIcon.width - 5;
			moveModeIcon.y = stage.stageHeight - moveModeIcon.height - 5;
		}
	}
}
