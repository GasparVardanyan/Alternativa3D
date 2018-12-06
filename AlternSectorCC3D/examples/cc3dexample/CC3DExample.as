package cc3dexample {
	import alternativa.engine3d.containers.ConflictContainer;
	import alternativa.engine3d.containers.DistanceSortContainer;
	import alternativa.engine3d.containers.KDContainer;
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Object3DContainer;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternsector.physics.adaptors.alternativa3d.ccd.SectorWorld;
	import cc3dexample.entity.TestBall;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.utils.getTimer;
	import portal.Sector;
	import cc3dexample.entity._GROUPS;
	import cc3dexample.entity._WORLD;
	import cc3dexample.entity.CollisionGroups;
	import alternativa.engine3d.alternativa3d;
	use namespace alternativa3d;
	

	/**
	 * CC3D example demo.
	 */
	public class CC3DExample extends Sprite {
		
		private var rootContainer:Object3DContainer = new DistanceSortContainer();
		
		private var camera:Camera3D;
		private var controller:SimpleObjectController;
		private var _debugField:TextField;
		private var errors:String = "";
		
		public function CC3DExample() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			
			// Camera and view
			// Создание камеры и вьюпорта
			camera = new Camera3D();
			camera.view = new View(stage.stageWidth, stage.stageHeight);

			addChild(camera.view);
			addChild(camera.diagram);
			
			// Initial position
			// Установка начального положения камеры
			camera.rotationX = -130*Math.PI/180;
			camera.rotationZ = -30*Math.PI/180;
			camera.x = -800;
			camera.y = -1600;
			camera.z = 1000;
			controller = new SimpleObjectController(stage, camera, 200);
			rootContainer.addChild(camera);
			rootContainer.name = "Root container!";
			

			// Listeners
			// Подписка на события
			stage.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.addEventListener(Event.RESIZE, onResize);
			
			setupDebugField();
			setupWorld();
			
			_currTime = getTimer();
		}
		
		private function setupWorld():void 
		{
			// World and collision groups
			_WORLD = new SectorWorld();
			_GROUPS = new CollisionGroups();
			
			var ball:TestBall;
			var testSector:Sector;
			
			var container:Object3DContainer = new DistanceSortContainer();
			container.name = "CONTAINER_1";
			container.x = 0;
			container.y = 0;
			container.z = 0;
			var polyhedron:Mesh;
			
			polyhedron = new Box(712, 512, 400, 1, 1, 1, true);
			polyhedron.sorting = 0;
			// jitter vertex hack required because EllipsoidCollider has bug that returns zero-length collision
			// normal for axis-aligned surfaces
			for (var v:Vertex = polyhedron.vertexList; v != null; v = v.next) {
				v.x += Math.random() * 1e-8;
				v.y += Math.random() * 1e-8;
				v.z += Math.random() * 1e-8;
			}
			polyhedron.calculateNormals();
			polyhedron.calculateBounds();
			polyhedron.setMaterialToAllFaces(new FillMaterial(0, 0.2, 1, 0));
			FaceMacros.makeDoubleSided(polyhedron);
			

			testSector = new Sector();
			testSector.container = container;
			testSector.collisionTarget = polyhedron;
			
			container.addChild(polyhedron);
			rootContainer.addChild(container);
		

			ball = getRandomBall(testSector, 50, 0, 0, 1000);
			ball.object.x += 120;
			ball = getRandomBall(testSector, 50, 0, 0, 1000);
			ball.object.x -= 120;
			getRandomBall(testSector, 51, 50, 0, 1000);
			
		
	//	/*
			polyhedron = new GeoSphere(512, 1, true);
			polyhedron.setMaterialToAllFaces(new FillMaterial(0, .1, 1));
			
			
			container = new DistanceSortContainer();
			container.name = "CONTAINER 2";
			container.x = 1600;
			container.y = 0;
			container.z = 0;
			testSector = new Sector();
			
			testSector.collisionTarget = polyhedron;
			
			
			testSector.container = container;
			container.addChild(polyhedron);
			rootContainer.addChild(container);
			
		
		
			polyhedron.calculateNormals();
			polyhedron.calculateBounds();
			polyhedron.sorting = 0;
			FaceMacros.makeDoubleSided(polyhedron);
		
			ball = getRandomBall(testSector, 20);
			ball.object.x += 220;
			
			ball = getRandomBall(testSector, 50, 50, 20);
			ball.object.y += 220;
			ball = getRandomBall(testSector, 20);
			ball.object.y -= 220;
			ball = getRandomBall(testSector, 20);
			ball.object.z -= 220;
			ball = getRandomBall(testSector, 60);
			ball.object.z += 220;
		//	*/
			
			
		}
		
		private function getRandomBall(sector:Sector, radius:Number=20, radiusY:Number=0, radiusZ:Number=0, baseSpeed:Number=1500):TestBall {
			var ball:TestBall = new TestBall(sector, radius, radiusY, radiusZ);
			var cloneSector:Object3D = sector.collisionTarget;
			ball.object.x = cloneSector.x + ( cloneSector.boundMinX + (cloneSector.boundMaxX-cloneSector.boundMinX)*.5);
			ball.object.y = cloneSector.y + ( cloneSector.boundMinY + (cloneSector.boundMaxY-cloneSector.boundMinY)*.5);
			ball.object.z = cloneSector.z + ( cloneSector.boundMinZ + (cloneSector.boundMaxZ - cloneSector.boundMinZ) * .5);
			var dir:Vector3D =new Vector3D(Math.random() * 100, Math.random() * 100, Math.random() * 100);
			dir.normalize();
			dir.scaleBy(baseSpeed);
			ball.cc3D.vx =  dir.x;
			ball.cc3D.vy =   dir.y;
			ball.cc3D.vz =  dir.z;
			sector.container.addChild(ball.object);
			return ball;
		}
		
		private function setupDebugField():void 
		{
			_debugField  = new TextField();
			_debugField.autoSize = "left";
			addChild(_debugField);
		}
		
		private var _currTime:int;
		private function onEnterFrame(e:Event):void {
			var newTime:int = getTimer()
			var timeElapsed:int = newTime - _currTime;
			_currTime = newTime;
			
			_WORLD.update(timeElapsed);
			
			var errorShow:Error;
			if ( (errorShow= _WORLD.getTraceError()) ) {
				errors +=  "\n" + errorShow.message;
			}
			_debugField.text = "Updating...::" + errors;
				
			controller.update();
			camera.render();
		}
		
		private function onResize(e:Event = null):void {
			// Width and height of view
			// Установка ширины и высоты вьюпорта
			camera.view.width = stage.stageWidth;
			camera.view.height = stage.stageHeight;
		}
		
	
		
	}
}




