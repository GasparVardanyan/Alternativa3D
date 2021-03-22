package a3d_helper.templates
{
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.core.events.Event3D;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.theme.defaulttheme.init.DefaultTheme;
	import alternativa.gui.theme.defaulttheme.primitives.base.Hint;
	import alternativa.gui.theme.defaulttheme.skin.Cursors;
	import alternativa.init.GUI;
	import alternativa.physics3dintegration.Appearance;
	import alternativa.physics3dintegration.AppearanceComponent;
	import alternativa.physics3dintegration.SimulationObject;
	import alternativa.physicsengine.configurations.PhysicsConfiguration;
	import alternativa.physicsengine.physics.PhysicsScene;
	import alternativa.physicsengine.physics.types.BodyListItem;
	import a3d_helper.physics.Physics3D;
	
	import flash.display.Sprite;
	import flash.display.Stage3D;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DRenderMode;
	import flash.events.Event;
	import flash.utils.getTimer;
	
	/**
	 * alternativa.physics3dintegration.PhysicsSprite - Modified.
	 * 
	 * Changes.
	 * - Comments deleted.
	 * - onContext3dCreate, addedObject3d - Including hierarchy resources for uploading.
	 * - updatePhysics3D - created and called after physics scene update, for the Crystal3D physics 3d integration.
	 * - initA3D - the camera logo was hidden.
	 * - AlternativaGUI and DefaultTheme integration.
	 * - init - created and called in the onContext3dCreate.
	 * - addPhysics3D - created to add the Physics3D object.
	 */
	
	public class SceneTemplate extends Sprite
	{
		public var physicsStep:int = 33;
		
		public var rootContainer:Object3D;
		public var view:View;
		public var camera:Camera3D;
		public var cameraController:SimpleObjectController;
		public var physicsScene:PhysicsScene;
		public var objects:Vector.<Appearance>;
		
		public var guiContainer:Sprite = new Sprite();
		public var hintContainer:Sprite = new Sprite();
		
		public function set stageScaleMode(value:String):void
		{
			stage.scaleMode = value;
		}
		
		public function set stageAlign(value:String):void
		{
			stage.align = value;
		}
		
		public var stage3d:Stage3D;
		public var context:Context3D;
		
		protected var _pause:Boolean = false;
		
		public function SceneTemplate()
		{
			mouseEnabled = false;
			tabEnabled = false;
			guiContainer.mouseEnabled = false;
			guiContainer.tabEnabled = false;
			hintContainer.mouseEnabled = false;
			hintContainer.tabEnabled = false;
			addChild(guiContainer);
			addChild(hintContainer);
			
			DefaultTheme.init();
			GUI.init(stage/*, false*/);
			LayoutManager.init(stage, [guiContainer, hintContainer]);
			MouseManager.setHintImaging(hintContainer, new Hint());
			CursorManager.init(Cursors.createCursors());
			
			stage3d = stage.stage3Ds[0];
			stage3d.addEventListener(Event.CONTEXT3D_CREATE, onContext3dCreate);
			stage3d.requestContext3D(Context3DRenderMode.AUTO);
			stageScaleMode = StageScaleMode.NO_SCALE;
			stageAlign = StageAlign.TOP_LEFT;
			initEnvironment();
			load();
		}
		
		protected function load():void
		{
			onLoadComplete();
		}
		
		protected function onLoadComplete():void
		{
			createScene();
			setScene();
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		protected function initCamera():void
		{
			cameraController = new SimpleObjectController(stage, camera = new Camera3D(1, 10000), 10);
			cameraController.setObjectPosXYZ(-10, 5, 10);
			cameraController.lookAtXYZ(0, 0, 0);
		}
		
		protected function initEnvironment():void
		{
			objects = new Vector.<Appearance>();
			initA3D();
		}
		
		protected function createScene():void
		{
			physicsScene = PhysicsConfiguration.DEFAULT.getPhysicsScene();
		}
		
		protected function setScene():void
		{
			addChild(camera.diagram);
		}
		
		protected function onContext3dCreate(e:Event):void
		{
			context = stage3d.context3D;
			context.enableErrorChecking = true;
			
			init();
			
			var r:Resource;
			for (var i:int = rootContainer.numChildren - 1; i >= 0; --i)
			{
				for each (r in rootContainer.getChildAt(i).getResources(true))
				{
					r.upload(context);
				}
			}
		}
		
		protected function init():void {}
		
		protected function addedObject3d(e:Event):void
		{
			if (context != null)
			{
				var obj:Object3D = e.target as Object3D;
				for each (var r:Resource in obj.getResources(true))
				{
					r.upload(context);
				}
			}
		}
		
		protected function removedObject3d(e:Event):void
		{
			var obj:Object3D = e.target as Object3D;
			for each (var r:Resource in obj.getResources())
			{
				r.dispose();
			}
		}
		
		protected function initA3D():void
		{
			rootContainer = new Object3D();
			rootContainer.addEventListener(Event3D.ADDED, addedObject3d);
			rootContainer.addEventListener(Event3D.REMOVED, removedObject3d);
			
			//View
			view = new View(stage.stageWidth, stage.stageHeight);
			view.antiAlias = 4;
			view.backgroundColor = 0x224466;
			
			initCamera();
			camera.view = view;
			camera.view.logoHorizontalMargin = 20;
			camera.view.logoVerticalMargin = 10;
			
			camera.view.hideLogo();
			
			addChild(view);
			rootContainer.addChild(camera);
			stage.addEventListener(Event.RESIZE, onResize);
		}
		
		protected function onResize(event:Event):void
		{
			view.height = stage.stageHeight;
			view.width = stage.stageWidth;
		}
		
		protected function onEnterFrame(event:Event):void
		{
			var t:Number;
			if (!_pause)
			{
				var now:int = getTimer();
				while (physicsScene.time < now)
				{
					physicsScene.update(physicsStep);
					updatePhysics3D();
				}
				t = 1 + (now - physicsScene.time) / physicsStep;
			}
			else
			{
				t = 1;
			}
			update3D(t);
			cameraController.update();
			camera.startTimer();
			camera.render(stage3d);
			camera.stopTimer();
		}
		
		protected function update3D(t:Number):void
		{
			for each (var simObject:Appearance in objects)
			{
				simObject.interpolate(t);
			}
		}
		
		protected function updatePhysics3D():void
		{
			for (var bodyLI:BodyListItem = physicsScene.bodies.head; bodyLI != null; bodyLI = bodyLI.next)
				if (bodyLI.body.data && bodyLI.body.data.physics3d is Physics3D)
					bodyLI.body.data.physics3d.update();
		}
		
		public function addSimObject(object:SimulationObject):void
		{
			physicsScene.add(object.sceneObject);
			addAppearance(object);
		}
		
		public function removeSimObject(object:SimulationObject):void
		{
			physicsScene.remove(object.sceneObject);
			removeAppearance(object);
		}
		
		public function addObject3D(object:Object3D):void
		{
			rootContainer.addChild(object);
		}
		
		public function addAppearance(appearance:Appearance):void
		{
			objects.push(appearance);
			for each (var component:AppearanceComponent in appearance.appearanceComponents)
			{
				rootContainer.addChild(component.appearanceObject);
			}
		}
		
		public function removeAppearance(appearance:Appearance):void
		{
			var index:int = objects.indexOf(appearance);
			if (index == -1) return;
			objects.splice(index, 1);
			for each (var component:AppearanceComponent in appearance.appearanceComponents)
			{
				rootContainer.removeChild(component.appearanceObject);
			}
		}
		
		public function addPhysics3D(physics3d:Physics3D):void
		{
			physics3d.upload(physicsScene, rootContainer);
		}
		
		public function removeObject3D(object:Object3D):void
		{
			rootContainer.removeChild(object);
		}
		
		public function nextPhysicsStep():void
		{
			physicsScene.time = getTimer() - physicsStep;
			physicsScene.update(physicsStep);
		}
		
		public function set pause(value:Boolean):void
		{
			if (value)
			{
				_pause = true;
			}
			else
			{
				physicsScene.time = getTimer();
				_pause = false;
			}
		}
		
		public function get pause():Boolean
		{
			return _pause;
		}
	}
}
