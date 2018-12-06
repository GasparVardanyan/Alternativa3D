package
{
	import flash.ui.Keyboard;
	import flash.events.Event;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;

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
	public class Constraints extends BasicView
	{
		private var mylight:PointLight3D;
		private var mouse3D:Mouse3D;
		private var shadeMateria:FlatShadeMaterial;
		private var vplObjects:ViewportLayer;
		
		private var ground:RigidBody;
		private var chainBody1:Vector.<RigidBody>;
		private var chain1:Vector.<JConstraintPoint>;
		
		private var onDraging:Boolean = false;
		
		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var startMousePos:Vector3D;
		private var planeToDragOn:Plane3D;
		
		private var physics:Papervision3DPhysics;
		 
		public function Constraints()
		{
			super(800, 600, true, true, CameraType.TARGET);
			
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
			
			initObject();
		}

		private function initObject():void
		{
			physics = new Papervision3DPhysics(scene, 8);
			
			shadeMateria = new FlatShadeMaterial(mylight, 0x77ee77);
			var materiaList :MaterialsList = new MaterialsList();
			materiaList.addMaterial(shadeMateria, "all");
			
			ground = physics.createCube(materiaList, 500, 500, 10);
			ground.y = -50;
			ground.movable = false;
			viewport.getChildLayer(physics.getMesh(ground)).layerIndex = 1;
			 
			vplObjects = new ViewportLayer(viewport,null);
			vplObjects.layerIndex = 2;
			vplObjects.sortMode = ViewportLayerSortMode.Z_SORT;
			viewport.containerSprite.addLayer(vplObjects);
			
			shadeMateria = new FlatShadeMaterial(mylight, 0xeeee00);
			shadeMateria.interactive = true;
			 
			chain1 = new Vector.<JConstraintPoint>();
			chainBody1 = new Vector.<RigidBody>();
			for (var i:int = 0; i < 12; i++)
			{
				chainBody1[i] = physics.createSphere(shadeMateria, 15,6,3);
				chainBody1[i].maxLinVelocities = 200;
				chainBody1[i].maxRotVelocities = 10;
				physics.getMesh(chainBody1[i]).addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				chainBody1[i].moveTo(new Vector3D( 0, 100 + (20 * i + 20), 0));
				vplObjects.addDisplayObject3D(physics.getMesh(chainBody1[i]));
			}
			 
			var pos1:Vector3D;
			var pos2:Vector3D;
			for (i = 1; i < chainBody1.length; i++ ){
				pos1 = JNumber3D.getScaleVector(Vector3D.Y_AXIS, chainBody1[i - 1].boundingSphere);
				pos2 = JNumber3D.getScaleVector(Vector3D.Y_AXIS, -chainBody1[i].boundingSphere);
				chain1[i - 1] = new JConstraintPoint(chainBody1[i - 1], pos1, chainBody1[i], pos2, 1, 0.01);
			}
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
				dragConstraint.disableConstraint();
				currDragBody.setActive();
			}
		}
		
		private function resetBody():void
		{
			if (chainBody1[0].currentState.position.y < -1000)
			{
				for (var i:String in chainBody1)
				{
					chainBody1[i].moveTo(new Vector3D( 0, 800 + (20 * int(i) + 20), 0));
				}
			}
		}
		
		protected override function onRenderTick(event:Event = null):void {
			
			//physics.step();//dynamic timeStep
			physics.engine.integrate(0.2);//static timeStep
			resetBody();
			super.onRenderTick(event);
		}
	}
}