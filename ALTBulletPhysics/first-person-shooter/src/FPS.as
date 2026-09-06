package {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	import alternativaphysics.debug.A3DDebugDraw;
	
	import entity.Crosshair;
	import entity.Entity;
	import entity.Flash;
	import entity.Hand;
	import entity.Hero;
	import entity.Level1;
	import entity.Level1;
	import entity.Level2;
	import utility.FPSCamera;
	import utility.GameController;
	import utility.UI;
	
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.external.ExternalInterface;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import flash.utils.Timer;
	import flash.ui.Mouse;
	
	import Alternativa3DUtilities;

	/**
	 * ...
	 * @author redefy
	 */
	[SWF(width="1280",height="960",frameRate="60")]
	public class FPS extends Sprite {
		private var hero:Hero;
		private var timer:Timer = new Timer(10);
		private var txt:TextField = new TextField();
		
		public function FPS():void {
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			addChild(txt);
			
			stage.displayState = StageDisplayState.FULL_SCREEN;
			//stage.mouseLock = true;
			
			Mouse.hide();
			GV.stage = stage;
			Alternativa3DUtilities.settingsStage();
			Alternativa3DUtilities.createCamera({nearClipping:1,
												 farClipping:10000,
												 x:0,
												 y: 0,
												 z: 0,
												 rotationX: -120 * Math.PI/180,
												 rotationZ: 0.122173,
												 viewWidth:stage.stageWidth, 
												 viewHeight:stage.stageHeight,
												 backgroundColor:0x1b1b1b,
												 backgroundAlpha:1.0,
												 diagram:true,
												 diagramHorizontalMargin:15,
												 diagramVerticalMargin:15,
												 antiAlias:8,
												 shape:true
												});
			GV.camera.view.hideLogo();
			Alternativa3DUtilities.createSkybox();
			Alternativa3DUtilities.createLight();
			Alternativa3DUtilities.createController(GV.camera, 100);
			Alternativa3DUtilities.createParsers(true, true, false);
			GV.fpscamera = new FPSCamera();
			GV.gameController = new GameController()
			GV.ui = new UI();
			GV.stage.addChild(GV.ui);
			
			settingsPhysics();
			
			GV.stage3D = stage.stage3Ds[0];
			GV.stage3D.addEventListener(Event.CONTEXT3D_CREATE, onContextCreate)
			GV.stage.addEventListener(Event.RESIZE, onResize)
			onResize();
			GV.stage3D.requestContext3D();
		}
		
		private function settingsPhysics():void {
			GV.physicsWorld = A3DDynamicsWorld.getInstance();
			GV.physicsWorld.initWithDbvtBroadphase();
		}
		
		private function createScene():void {
			GV.currentScene = new Level2();
			GV.container.addChild(GV.currentScene);
			
			hero = new Hero();
			GV.container.addChild(hero);
			
			GV.hand = new Hand();
			GV.container.addChild(GV.hand);
			GV.flash = new Flash();
			//GV.s = new Crosshair();
			
			for each (var resource:Resource in GV.container.getResources(true)){
				resource.upload(GV.stage3D.context3D);
			}
		}
		
		
		private function onContextCreate(e:Event):void {
			createScene();	
			GV.gameController.addListeners();
			stage.addEventListener(Event.ENTER_FRAME, update);
			GV.debugDraw = new A3DDebugDraw(GV.stage3D, GV.container,GV.physicsWorld); //инициализируем debug отрисовку тел
		    GV.debugDraw.debugMode |= A3DDebugDraw.DBG_DrawTransform;
			//GV.debugDraw.debugDrawWorld();
			
			//stage.addEventListener(MouseEvent.MOUSE_MOVE, moveHandler);
		}
		
		private function moveHandler(e:MouseEvent):void {
			//GV.fpscamera.update(e.movementX, e.movementY);
		}
		
		private function onResize(e:Event=null):void {
			GV.camera.view.width = stage.stageWidth;
			GV.camera.view.height = stage.stageHeight;
			GV.ui.update();
			
			GV.shapeDiagram.x = GV.stage.stageWidth - 105;
			GV.shapeDiagram.y = 5; 
		}

		private function update(e : Event) : void {
			//txt.text = ExternalInterface.call("checkX") + "\n" + ExternalInterface.call("checkY") + "\n" + GV.camera.x;  
			//trace(GV.camera.x, GV.camera.y, GV.camera.z);
		//	trace(GV.camera.rotationX, GV.camera.rotationY, GV.camera.rotationZ);
			
			GV.skybox.x = GV.camera.x = hero.mesh.x;
			GV.skybox.y = GV.camera.y = hero.mesh.y;
			GV.skybox.z = GV.camera.z = hero.mesh.z+50;
			
			for each (var obj:Entity in GV.entitys) {
				obj.update();
			}
			
			GV.timeStep = 1/ (getTimer() - GV.preTimer); //расчитываем время шага
			GV.physicsWorld.step(GV.timeStep, 1); //обновляем мир
			
			//GV.controller.update();
			GV.fpscamera.update();
			GV.gameController.update();
			GV.camera.render(GV.stage3D);
			
			GV.preTimer = getTimer();
		}
	}
}