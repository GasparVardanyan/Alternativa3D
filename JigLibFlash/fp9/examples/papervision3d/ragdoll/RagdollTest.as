package
{
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;

	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.cof.JConfig;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.papervision3d.*;

	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.events.*;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	import org.papervision3d.view.stats.StatsView;

	
	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="60")]
	public class RagdollTest extends BasicView
	{
		private var mylight:PointLight3D;
		private var mouse3D:Mouse3D;
		private var shadeMateria:FlatShadeMaterial;
		private var vplObjects:ViewportLayer;
		
		private var ground:RigidBody;
		private var ballBody:RigidBody;
		private var ragdoll:Array
		
		private var onDraging:Boolean = false;
		
		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var startMousePos:JNumber3D;
		private var planeToDragOn:Plane3D;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
		
		private var physics:Papervision3DPhysics;
		 
		public function RagdollTest()
		{
			super(800, 600, true, true, CameraType.TARGET);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			Mouse3D.enabled = true;
			mouse3D = viewport.interactiveSceneManager.mouse3D;
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			mylight = new PointLight3D(true, true);
			mylight.y = 300;
			mylight.z = -400;
			
			camera.y = mylight.y;
			camera.z = mylight.z;
			 
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
			 
			startRendering();
			
			initObjects();
		}

		private function initObjects():void
		{
			JConfig.deactivationTime = 0.5;
			JConfig.velThreshold = 0.6;
			JConfig.posThreshold = 0.2;
			JConfig.orientThreshold = 0.4;
			JConfig.numCollisionIterations = 2;
			JConfig.numContactIterations = 4;
			
			physics = new Papervision3DPhysics(scene, 8);
			
			shadeMateria = new FlatShadeMaterial(mylight, 0x77ee77);
			var materiaList :MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria, "all");
			
			ground = physics.createCube(materiaList, 500, 500, 10);
			ground.movable = false;
			ground.restitution = 0.8;
			viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 1;
			
			 
			vplObjects = new ViewportLayer(viewport,null);
			vplObjects.layerIndex = 2;
			vplObjects.sortMode = ViewportLayerSortMode.Z_SORT;
			viewport.containerSprite.addLayer(vplObjects);
			
			shadeMateria = new FlatShadeMaterial(mylight, 0xff8888);
			shadeMateria.interactive = true;
			ballBody = physics.createSphere(shadeMateria, 22);
			ballBody.mass = 10;
			ballBody.moveTo(new JNumber3D( -100, 30, -100));
			vplObjects.addDisplayObject3D(physics.getMesh(ballBody));
			 
			
			ragdoll = new Array();
			var ragdollSkins:Array;
			shadeMateria = new FlatShadeMaterial(mylight, 0xeeee00);
			shadeMateria.interactive = true;
			for (var i:int = 0; i < 1; i++ ) {
				ragdollSkins = createRagdollSkin();
				ragdoll[i] = new Ragdoll(new Pv3dMesh(ragdollSkins[Ragdoll.HEAD]), new Pv3dMesh(ragdollSkins[Ragdoll.TORSO]),
				                         new Pv3dMesh(ragdollSkins[Ragdoll.UPPER_ARM_LEFT]), new Pv3dMesh(ragdollSkins[Ragdoll.UPPER_ARM_RIGHT]),
										 new Pv3dMesh(ragdollSkins[Ragdoll.LOWER_ARM_LEFT]), new Pv3dMesh(ragdollSkins[Ragdoll.LOWER_ARM_RIGHT]),
										 new Pv3dMesh(ragdollSkins[Ragdoll.UPPER_LEG_LEFT]), new Pv3dMesh(ragdollSkins[Ragdoll.UPPER_LEG_RIGHT]),
										 new Pv3dMesh(ragdollSkins[Ragdoll.LOWER_LEG_LEFT]), new Pv3dMesh(ragdollSkins[Ragdoll.LOWER_LEG_RIGHT]));
										 
				ragdoll[i].moveTo(new JNumber3D(0, 200 * i + 200, 0));
			}
		}
		 
		private function createRagdollSkin():Array {
			var skins:Array = new Array();
			
			skins[Ragdoll.HEAD] = new Sphere(shadeMateria, 12);
			skins[Ragdoll.TORSO] = new Cylinder(shadeMateria, 16, 40);
			skins[Ragdoll.UPPER_ARM_LEFT] = new Cylinder(shadeMateria, 6, 20);
			skins[Ragdoll.UPPER_ARM_RIGHT] = new Cylinder(shadeMateria, 6, 20);
			skins[Ragdoll.LOWER_ARM_LEFT] = new Cylinder(shadeMateria, 5, 25);
			skins[Ragdoll.LOWER_ARM_RIGHT] = new Cylinder(shadeMateria, 5, 25);
			skins[Ragdoll.UPPER_LEG_LEFT] = new Cylinder(shadeMateria, 8, 30);
			skins[Ragdoll.UPPER_LEG_RIGHT] = new Cylinder(shadeMateria, 8, 30);
			skins[Ragdoll.LOWER_LEG_LEFT] = new Cylinder(shadeMateria, 7, 30);
			skins[Ragdoll.LOWER_LEG_RIGHT] = new Cylinder(shadeMateria, 7, 30);
			
			for (var i:String in skins) {
				skins[i].addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				vplObjects.addDisplayObject3D(skins[i]);
				scene.addChild(skins[i]);
			}
			
			return skins;
		}
		 
		private function findSkinBody(skin:DisplayObject3D):int
		{
			for (var i:String in PhysicsSystem.getInstance().bodys)
			{
				if (skin == PhysicsSystem.getInstance().bodys[i].skin.mesh)
				{
					return int(i);
				}
			}
			return -1;
		}
		
		private function handleMousePress(event:InteractiveScene3DEvent):void
		{
			onDraging = true;
			startMousePos = new JNumber3D(mouse3D.x, mouse3D.y, mouse3D.z);
			currDragBody = PhysicsSystem.getInstance().bodys[findSkinBody(event.displayObject3D)];
			planeToDragOn = new Plane3D(new Number3D(0, 0, -1), new Number3D(0, 0, -startMousePos.z));
			
			var bodyPoint:JNumber3D = JNumber3D.sub(startMousePos, currDragBody.currentState.position);
			dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, startMousePos);
		}
		
		private function handleMouseMove(event:MouseEvent):void
		{
			if (onDraging)
			{
				var ray:Number3D = camera.unproject(viewport.containerSprite.mouseX, viewport.containerSprite.mouseY);
				ray = Number3D.add(ray, new Number3D(camera.x, camera.y, camera.z));
				
				var cameraVertex3D:Vertex3D = new Vertex3D(camera.x, camera.y, camera.z);
				var rayVertex3D:Vertex3D = new Vertex3D(ray.x, ray.y, ray.z);
				var intersectPoint:Vertex3D = planeToDragOn.getIntersectionLine(cameraVertex3D, rayVertex3D);
				
				dragConstraint.worldPosition = new JNumber3D(intersectPoint.x, intersectPoint.y, intersectPoint.z);
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				dragConstraint.disableConstraint();
				currDragBody.setActive();
			}
		}
		
		private function resetRagdoll():void {
			for (var i:String in ragdoll)
			{
				if (ragdoll[i].limbs[Ragdoll.TORSO].currentState.position.y < -600)
				{
					ragdoll[i].moveTo(new JNumber3D(0, 600 + (200 * int(i) + 200), 0));
				}
			}
			
			if (ballBody.currentState.position.y < -500)
			{
				ballBody.moveTo(new JNumber3D(0, 800, 0));
			}
		}
		
		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = true;
					keyReverse = false;
					break;

				case Keyboard.DOWN:
					keyReverse = true;
					keyForward = false;
					break;

				case Keyboard.LEFT:
					keyLeft = true;
					keyRight = false;
					break;

				case Keyboard.RIGHT:
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.SPACE:
					keyUp = true;
					break;
			}
		}
		
		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch(event.keyCode)
			{
				case Keyboard.UP:
					keyForward = false;
					break;

				case Keyboard.DOWN:
					keyReverse = false;
					break;

				case Keyboard.LEFT:
					keyLeft = false;
					break;

				case Keyboard.RIGHT:
					keyRight = false;
					break;
				case Keyboard.SPACE:
					keyUp=false;
			}
		}

		protected override function onRenderTick(event:Event = null):void {
			
			if(keyLeft)
			{
				ballBody.addWorldForce(new JNumber3D(-100,0,0),ballBody.currentState.position);
			}
			if(keyRight)
			{
				ballBody.addWorldForce(new JNumber3D(100,0,0),ballBody.currentState.position);
			}
			if(keyForward)
			{
				ballBody.addWorldForce(new JNumber3D(0,0,100),ballBody.currentState.position);
			}
			if(keyReverse)
			{
				ballBody.addWorldForce(new JNumber3D(0,0,-100),ballBody.currentState.position);
			}
			if(keyUp)
			{
				ballBody.addWorldForce(new JNumber3D(0, 100, 0), ballBody.currentState.position);
			}
			resetRagdoll();
			//physics.step();//dynamic timeStep
			physics.engine.integrate(0.2);//static timeStep
			super.onRenderTick(event);
		}
	}
}