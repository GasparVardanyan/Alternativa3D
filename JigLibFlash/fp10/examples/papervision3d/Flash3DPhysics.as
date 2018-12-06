package
{
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.cof.JConfig;
	import jiglib.geometry.*;
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.papervision3d.*;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.geom.renderables.Vertex3D;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.core.math.Plane3D;
	import org.papervision3d.core.utils.Mouse3D;
	import org.papervision3d.events.*;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.shadematerials.*;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.*;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	import org.papervision3d.view.stats.StatsView;

	
	[SWF(width="800", height="600", backgroundColor="#ffffff", frameRate="60")]
	public class Flash3DPhysics extends BasicView
	{
		private var mylight:PointLight3D;
		private var mouse3D:Mouse3D;
		private var shadeMateria:FlatShadeMaterial;
		
		private var ground:RigidBody;
		private var ballBody:Vector.<RigidBody>;
		private var boxBody:Vector.<RigidBody>;
		private var capsuleBody:Vector.<RigidBody>;
		
		private var onDraging:Boolean = false;
		
		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var startMousePos:Vector3D;
		private var planeToDragOn:Plane3D;
		
		private var keyRight   :Boolean = false;
		private var keyLeft    :Boolean = false;
		private var keyForward :Boolean = false;
		private var keyReverse :Boolean = false;
		private var keyUp:Boolean = false;
		
		private var physics:Papervision3DPhysics;
		 
		public function Flash3DPhysics()
		{
			super(800, 600, true, true, CameraType.TARGET);
			
			stage.addEventListener( KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener( KeyboardEvent.KEY_UP, keyUpHandler);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			
			init3D();
		}

		private function init3D():void
		{
			JConfig.numContactIterations = 12;
			physics = new Papervision3DPhysics(scene, 8);
			
			Mouse3D.enabled = true;
			mouse3D = viewport.interactiveSceneManager.mouse3D;
			viewport.containerSprite.sortMode = ViewportLayerSortMode.INDEX_SORT;
			
			mylight = new PointLight3D(true, true);
			mylight.y = 300;
			mylight.z = -400;
			 
			shadeMateria = new FlatShadeMaterial(mylight, 0x77ee77);
			var materiaList :MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria, "all");
			
			ground = physics.createCube(materiaList, 500, 500, 10);
			ground.movable = false;
			//ground.friction = 0.9;
			ground.restitution = 0.8;
			viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 1;

			var vplObjects:ViewportLayer = new ViewportLayer(viewport,null);
			vplObjects.layerIndex = 2;
			vplObjects.sortMode = ViewportLayerSortMode.Z_SORT;
			viewport.containerSprite.addLayer(vplObjects);
			
			ballBody = new Vector.<RigidBody>();
			var color:uint;
			for (var i:int = 0; i < 6; i++)
			{
				color = (i == 0)?0xff8888:0xeeee00;
				shadeMateria = new FlatShadeMaterial(mylight, color);
				shadeMateria.interactive = true;
				ballBody[i] = physics.createSphere(shadeMateria, 22);
				physics.getMesh(ballBody[i]).addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				ballBody[i].mass = 3;
				ballBody[i].moveTo(new Vector3D( -100, 30 + (50 * i + 50), -100));
				vplObjects.addDisplayObject3D(physics.getMesh(ballBody[i]));
			}
			 
			shadeMateria = new FlatShadeMaterial(mylight,0xeeee00);
			shadeMateria.interactive = true;
			materiaList = new MaterialsList();
			materiaList.addMaterial(shadeMateria,"all");
			boxBody=new Vector.<RigidBody>();
			for (i = 0; i < 6; i++)
			{
				boxBody[i] = physics.createCube(materiaList, 50, 50, 30);
				physics.getMesh(boxBody[i]).addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				boxBody[i].moveTo(new Vector3D(0, 10 + (40 * i + 40), 0));
				vplObjects.addDisplayObject3D(physics.getMesh(boxBody[i]));
			}
			var capsuleSkin:Cylinder;
			capsuleBody = new Vector.<RigidBody>();
			for (i = 0; i < 6; i++)
			{
				capsuleSkin = new Cylinder(shadeMateria, 20, 50);
				capsuleSkin.addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				scene.addChild(capsuleSkin);
				vplObjects.addDisplayObject3D(capsuleSkin);
				
				capsuleBody[i] = new JCapsule(new Pv3dMesh(capsuleSkin), 20, 50);
				capsuleBody[i].moveTo(new Vector3D(100, 10 + (80 * i + 80), -100));
				PhysicsSystem.getInstance().addBody(capsuleBody[i]);
			}
			
			camera.y = mylight.y;
			camera.z = mylight.z;
						 
			var stats:StatsView = new StatsView(renderer);
			addChild(stats);
			 
			startRendering();
		}
		
		private function findSkinBody(skin:DisplayObject3D):int
		{
			for (var i:String in PhysicsSystem.getInstance().bodies)
			{
				if (skin == physics.getMesh(PhysicsSystem.getInstance().bodies[i]))
				{
					return int(i);
				}
			}
			return -1;
		}
		
		private function handleMousePress(event:InteractiveScene3DEvent):void
		{
			onDraging = true;
			startMousePos = new Vector3D(mouse3D.x, mouse3D.y, mouse3D.z);
			currDragBody = PhysicsSystem.getInstance().bodies[findSkinBody(event.displayObject3D)];
			planeToDragOn = new Plane3D(new Number3D(0, 0, -1), new Number3D(0, 0, -startMousePos.z));
			
			var bodyPoint:Vector3D = startMousePos.subtract(currDragBody.currentState.position);
			dragConstraint = new JConstraintWorldPoint(currDragBody, bodyPoint, startMousePos);
			PhysicsSystem.getInstance().addConstraint(dragConstraint);
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
				
				dragConstraint.worldPosition = new Vector3D(intersectPoint.x, intersectPoint.y, intersectPoint.z);
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				PhysicsSystem.getInstance().removeConstraint(dragConstraint);
				currDragBody.setActive();
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
		
		private function resetBox():void
		{
			for (var i:int = 0; i < ballBody.length;i++ )
			{
				if (ballBody[i].currentState.position.y < -200)
				{
					ballBody[i].moveTo(new Vector3D( 0, 1000 + (60 * i + 60), 0));
				}
			}
			
			for (i = 0; i < boxBody.length;i++ )
			{
				if (boxBody[i].currentState.position.y < -200)
				{
					boxBody[i].moveTo(new Vector3D(0, 1000 + (60 * i + 60), 0));
				}
			}
			
			for (i = 0; i < capsuleBody.length;i++ )
			{
				if (capsuleBody[i].currentState.position.y < -200)
				{
					capsuleBody[i].moveTo(new Vector3D(0, 1000 + (60 * i + 60), 0));
				}
			}
		}
		
		private function testFreezeObject():void {
			var _body:RigidBody;
			for (var i:int = 0; i < ballBody.length; i++ )
			{
				_body = ballBody[i];
				if (_body.isActive)
				{
					shadeMateria = (i == 0)? new FlatShadeMaterial(mylight, 0xff8888):new FlatShadeMaterial(mylight, 0xeeee00);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
				else
				{
					shadeMateria = new FlatShadeMaterial(mylight, 0xff7777);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
			}
			
			for each (_body in boxBody)
			{
				if (_body.isActive)
				{
					shadeMateria = new FlatShadeMaterial(mylight, 0xeeee00);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
				else
				{
					shadeMateria = new FlatShadeMaterial(mylight, 0xff7777);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
			}
			for each (_body in capsuleBody)
			{
				if (_body.isActive)
				{
					shadeMateria = new FlatShadeMaterial(mylight, 0xeeee00);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
				else
				{
					shadeMateria = new FlatShadeMaterial(mylight, 0xff7777);
					shadeMateria.interactive = true;
					physics.getMesh(_body).material = shadeMateria;
				}
			}
		}


		protected override function onRenderTick(event:Event = null):void {
			
			if(keyLeft)
			{
				ballBody[0].addWorldForce(new Vector3D(-60,0,0),ballBody[0].currentState.position);
			}
			if(keyRight)
			{
				ballBody[0].addWorldForce(new Vector3D(60,0,0),ballBody[0].currentState.position);
			}
			if(keyForward)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,60),ballBody[0].currentState.position);
			}
			if(keyReverse)
			{
				ballBody[0].addWorldForce(new Vector3D(0,0,-60),ballBody[0].currentState.position);
			}
			if(keyUp)
			{
				ballBody[0].addWorldForce(new Vector3D(0, 60, 0), ballBody[0].currentState.position);
			}
			
			//physics.step();//dynamic timeStep
			physics.engine.integrate(0.1);//static timeStep
			resetBox();
			//testFreezeObject();
			super.onRenderTick(event);
		}
	}
}