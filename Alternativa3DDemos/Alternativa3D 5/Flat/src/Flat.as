package {
	import alternativa.engine3d.*;
	import alternativa.engine3d.controllers.ObjectController;
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Face;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.materials.SurfaceMaterial;
	import alternativa.types.Point3D;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.clearTimeout;
	import flash.utils.setTimeout;
	
	import flat.CustomTextureMaterial;
	import flat.gui.button.ModeViewButton;
	import flat.gui.progress.ProgressWindow;
	import flat.listbox.BathTextureListBox;
	import flat.listbox.CeilTextureListBox;
	import flat.listbox.FloorTextureListBox;
	import flat.listbox.TextureListBox;
	import flat.listbox.WallsTextureListBox;
	import flat.model.FlatModel;
	import flat.model.Skybox;
	import flat.model.Windows;
	
	[SWF(backgroundColor="#000000", frameRate="100")]
	public class Flat extends Sprite {
		// 3D-scene
		private var scene:Scene3D;
		// Camera output area
		private var view:View;
		// Camera
		private var camera:Camera3D;
		// Camera container
		private var container:Object3D;
		// Container controller inside view
		private var controller:WalkController;
		// Container controller for outside view
		private var controllerOut:WalkController;
		// Current controller
		private var currentController:WalkController;
		// Listbox with wall textures
		private	var wallsListBox:WallsTextureListBox = new WallsTextureListBox();
		// Listbox with floor textures
		private	var floorListBox:FloorTextureListBox = new FloorTextureListBox();
		// Listbox with ceiling textures
		private	var ceilListBox:CeilTextureListBox = new CeilTextureListBox();
		// Listbox with bathroom wall textures
		private var bathListBox:BathTextureListBox = new BathTextureListBox();
		// Flag to differ click from drag
		private var flgClick:Boolean; 
		// Time from camera stop to high quality switch, in milliseconds
		private var qualitySwitchTime:uint = 500;
		// Quality switch timer identifier
		private var qualityTimerId:int = -1;
		// Skybox
		private var skybox:Skybox;
		// Appartament model
		private var flatModel:FlatModel;
		// Resources loading sequence
		private var loadingSequence:Array;
		private var loadingCounter:int = -1;
		private var progressWindow:ProgressWindow;
		// View mode switch key
		private var modeViewButton:ModeViewButton = new ModeViewButton();
		
		// UI elements
		[Embed(source="alternativa.png")] private static var logoClass:Class;
		private static const logo:Bitmap = new logoClass();

		[Embed(source="helppanel.png")] private static var helpPanelClass:Class;
		private static const helpPanel:Bitmap = new helpPanelClass();
		
		/**
		 * Application constructor.
		 */
		public function Flat() { 
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);

			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT; 
			
			// Flat
			flatModel = new FlatModel(ceilListBox, wallsListBox, floorListBox, bathListBox);
			
			initScene();
			
			scene.root.addChild(flatModel);

			// Listboxes for wall, floor and ceiling
			view.addChild(wallsListBox);
			view.addChild(floorListBox);
			view.addChild(ceilListBox);
			view.addChild(bathListBox);

			
			// Windows
			var windows:Windows = new Windows();
			scene.root.addChild(windows);
			// Skybox
			skybox = new Skybox();
			scene.root.addChild(skybox);

			// Setting nececcary handlers
			initListeners();
		
			// Interface elements
			stage.addChild(logo);
			logo.x = 3;
			logo.y = 3;
			stage.addChild(helpPanel);
			progressWindow = new ProgressWindow("Загрузка текстур", 200);
			progressWindow.y = 10;
			stage.addChild(progressWindow);
			
			// Switch view mode button
			addChild(modeViewButton);
			modeViewButton.addEventListener(MouseEvent.CLICK, onModeViewButtonClick);			

			// Sequence of the objects, for which textures are loading
			loadingSequence = [flatModel, skybox];
			// Start textures loading
			loadNextResource();
			
			onResize(null);
		}
		
		private function initScene():void {
			// Scene creation
			scene = new Scene3D();
			scene.root = new Object3D();
			
			// Adding camera and viewport
			camera = new Camera3D();
			camera.rotationX = - MathUtils.DEG90;
			camera.fov = MathUtils.toRadian(110);

			view = new View();
			addChild(view);
			view.camera = camera;
			
			// Camera container
			container = new Object3D();
			container.addChild(camera); 
			scene.root.addChild(container);
			
			// Adding inside view controller
			controller = new WalkController(stage);
			controller.object = container;
			controller.lookAt(flatModel.coords);
			controller.speed = 25;
			controller.maxGroundAngle = MathUtils.DEG45;
			controller.speedThreshold = 1;
			controller.gravity = 10;
			controller.checkCollisions = true;
			controller.collider.radiusX = 5;
			controller.collider.radiusY = 5;
			controller.collider.radiusZ = 17;
			controller.collider.offsetThreshold = 0.0001;
			controller.coords = new Point3D(-25, 61, 17);
			controller.onStartMoving = setLowQuality;
			controller.onStopMoving = startHighQualityTimer;
			controller.setDefaultBindings();
			controller.bindKey(KeyboardUtils.UP, ObjectController.ACTION_FORWARD);
			controller.bindKey(KeyboardUtils.DOWN, ObjectController.ACTION_BACK);
			controller.bindKey(KeyboardUtils.LEFT, ObjectController.ACTION_LEFT);
			controller.bindKey(KeyboardUtils.RIGHT, ObjectController.ACTION_RIGHT);
			controller.objectZPosition = 0.95;
		
			currentController = controller;
		
			// Adding outside view controller
			controllerOut = new WalkController(stage);
			controllerOut.object = container;
			controllerOut.lookAt(flatModel.coords);
			controllerOut.speed = 25;
			controllerOut.coords = new Point3D(-25, 61, 17);
			controllerOut.onStartMoving = setLowQuality;
			controllerOut.onStopMoving = startHighQualityTimer;
			controllerOut.objectZPosition = 0.5;
			controllerOut.setDefaultBindings();
			controllerOut.bindKey(KeyboardUtils.W, ObjectController.ACTION_PITCH_UP);
			controllerOut.bindKey(KeyboardUtils.S, ObjectController.ACTION_PITCH_DOWN);
			controllerOut.bindKey(KeyboardUtils.A, ObjectController.ACTION_YAW_LEFT);
			controllerOut.bindKey(KeyboardUtils.D, ObjectController.ACTION_YAW_RIGHT);	
		}
		/**
		 * Setting necessary handlers.
		 */ 
		private function initListeners():void {
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			stage.addEventListener(MouseEvent.MOUSE_WHEEL, onMouseWheel);
			stage.addEventListener(Event.RESIZE, onResize);
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			
		}
		
		/**
		 * Reading keypresses.
		 */
		private function onKeyDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case KeyboardUtils.EQUAL:
				case KeyboardUtils.NUMPAD_ADD:
					zoom(-3);
					break;
				case KeyboardUtils.MINUS:
				case KeyboardUtils.NUMPAD_SUBTRACT:
					zoom(3);
					break;	
			}
		}
		
		/**
		 * Objects' sizes and positions correction, depending on a window size.
		 */
		private function onResize(e:Event):void {
			view.width = stage.stageWidth;
			view.height = stage.stageHeight;
			
			modeViewButton.x = stage.stageWidth - 40;
			modeViewButton.y = stage.stageHeight - 40;
			
			helpPanel.y = stage.stageHeight - helpPanel.height;
			progressWindow.x = (stage.stageWidth - progressWindow.width) >> 1;
			
		}
	
		/**
		 * Hiding texture listboxes.  
		 */ 
		private function hideBoxes():void {
			floorListBox.hide();
			ceilListBox.hide();
			wallsListBox.hide();
			bathListBox.hide();
		}
		
		/**
		 * Click handler.
		 */ 
		private function onMouseUp(event:MouseEvent):void {
			
			if (flgClick) {
				
				if ((floorListBox.visible) || (ceilListBox.visible) || (wallsListBox.visible) || bathListBox.visible){
					// If one texture box visible, hide			
					hideBoxes();
					currentController.enabled = true;
				} else {
					// Else showing needed texture box
					var face:Face = view.getObjectUnderPoint(new Point(event.stageX, event.stageY)) as Face;
					if (face != null) {
						
						var surfaceMaterial:SurfaceMaterial = face.surface.material;
						if (surfaceMaterial is CustomTextureMaterial) {
							
							var material:CustomTextureMaterial = surfaceMaterial as CustomTextureMaterial;
							var textureListBox:TextureListBox = material.textureListBox;
														
							// Calculating texture box coords. Checking for stage border
							if (event.stageX + textureListBox.width > stage.stageWidth) {
								textureListBox.x = stage.stageWidth - textureListBox.width;
							} else {
								textureListBox.x = event.stageX;
							}
								
							if (event.stageY + textureListBox.height > stage.stageHeight) {	
								textureListBox.y = stage.stageHeight - textureListBox.height;
							} else {
								textureListBox.y = event.stageY;
							}
							//
							textureListBox.show(material);
							currentController.enabled = false;
							
						}
					} 
				}
			}
	 
		}
		
		/**
		 * 
		 */		
		private function onMouseMove(event:MouseEvent):void {
			
			flgClick = false;
		}
		
		/**
		 * 
		 */
		private function onMouseDown(event:MouseEvent):void {
			
			flgClick = true;
		}
		
		/**
		 * Change zoom with mousewheel.
		 */
		private function onMouseWheel(e:MouseEvent):void {
		
			zoom(-e.delta);
		}

		/**
		 * Change view zoom.
		 */
		private function zoom(delta:Number):void {
			if (modeViewButton.out) {
				
				camera.y = camera.y*( 1 + delta/20);
				if (camera.y < -450) {
					camera.y = -450;
				} else if (camera.y > -250) {
					camera.y = -250;
				}	
			}		
			
		}
		
		/**
		 * Change view mode. Controller setup.
		 */
		private function onModeViewButtonClick(event:MouseEvent):void {
	
			flgClick = false;
			hideBoxes();

			if (modeViewButton.out) {
								
				// Switch controller to outside view
				currentController = controllerOut;
				controllerOut.enabled = true;
				camera.y = -350;
				scene.root.removeChild(skybox);
												
			} else {
				
				// Switch controller to inside view
				currentController = controller;
				controller.enabled = true;
				camera.y = 0;
				scene.root.addChild(skybox);
			
			}
			
		}
		
		/**
		 * Set scene render quality to low.
		 */
		private function setLowQuality():void {
		
			if (qualityTimerId > -1) {
				clearTimeout(qualityTimerId);
				qualityTimerId = -1;
			}
			stage.quality = StageQuality.LOW;
			flatModel.setLowPrecision();
		}
	
		/**
		 * Turn on timer to switch to high quality scene rendering.
		 */
		private function startHighQualityTimer():void {
			qualityTimerId = setTimeout(setHighQiality, qualitySwitchTime);
		}
		
		/**
		 * Set scene render quality to high.
		 */
		private function setHighQiality():void {
			
			qualityTimerId = -1;
			stage.quality = StageQuality.HIGH;
			flatModel.setBestPrecision();
			
		}
		
		/**
		 * Load next resource.
		 */
		private function loadNextResource():void {

			loadingCounter++;
			if (loadingCounter < loadingSequence.length) {
				progressWindow.progress = (loadingCounter + 1)/loadingSequence.length; 
				loadingSequence[loadingCounter].load(loadNextResource);
				
			} else {
				progressWindow.hide();
			}
		}
	
		/**
		 * Every frame handling.
		 */ 
		private function onEnterFrame(event:Event):void {
			
			currentController.processInput();
			scene.calculate();
		}
		
		
	}
}
