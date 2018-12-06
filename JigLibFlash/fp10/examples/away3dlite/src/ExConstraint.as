package
{
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import jiglib.math.*;
	import jiglib.physics.*;
	import jiglib.physics.constraint.*;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#666666", frameRate="30", width="800", height="600")]
	/**
	 * Example : Physics Constraint
	 *
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExConstraint extends PhysicsTemplate
	{
		private var boxBody:Array;

		private var onDraging:Boolean = false;

		private var currDragBody:RigidBody;
		private var dragConstraint:JConstraintWorldPoint;
		private var planeToDragOn:Vector3D;

		private var startMousePos:Vector3D;

		override protected function build():void
		{
			title += " | Constraint : Use mouse to drag red ball | ";

			camera.y = -1000;

			init3D();

			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
		}

		private function init3D():void
		{
			// TODO: use object hit instead of layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);

			var sphere:RigidBody;
			var prevSphere:RigidBody;

			for (var i:int = 0; i < 4; i++)
			{
				if (i == 0)
				{
					sphere = physics.createSphere(new ColorMaterial(0xFF0000), 25, 6, 6);

					// draggable
					currDragBody = sphere;
					Away3DLiteMesh(sphere.skin).mesh.layer = layer;
				}
				else
				{
					sphere = physics.createSphere(new WireframeMaterial(), 25);
				}

				sphere.mass = 10;
				sphere.moveTo(new Vector3D(-i * 50, -100, 0));

				if (i != 0)
				{
					var pos1:Vector3D = JNumber3D.getScaleVector(Vector3D.X_AXIS, -prevSphere.boundingSphere);
					var pos2:Vector3D = JNumber3D.getScaleVector(Vector3D.X_AXIS, sphere.boundingSphere);
					var constraint:JConstraintPoint = new JConstraintPoint(prevSphere, pos1, sphere, pos2, 1, 1);
				}

				prevSphere = sphere;
			}

			boxBody = [];
			for (i = 0; i < 10; i++)
			{
				boxBody[i] = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				boxBody[i].moveTo(new Vector3D(500 * Math.random() - 500 * Math.random(), -500 - 500 * Math.random(), 500 * Math.random() - 500 * Math.random()));
			}

			layer.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
		}

		private function handleMousePress(event:MouseEvent):void
		{
			onDraging = true;

			startMousePos = new Vector3D(currDragBody.x, currDragBody.y, currDragBody.z);

			planeToDragOn = JMath3D.fromNormalAndPoint(new Vector3D(0, 1, 0), new Vector3D(0, 0, -startMousePos.z));

			var p:Vector3D = currDragBody.currentState.position;
			var bodyPoint:Vector3D = startMousePos.subtract(new Vector3D(p.x, p.y, p.z));

			var a:Vector3D = new Vector3D(bodyPoint.x, bodyPoint.y, bodyPoint.z);
			var b:Vector3D = new Vector3D(startMousePos.x, startMousePos.y, startMousePos.z);

			dragConstraint = new JConstraintWorldPoint(currDragBody, a, b);
			physics.engine.addConstraint(dragConstraint);
		}

		// TODO:clean up/by pass
		private function handleMouseMove(event:MouseEvent):void
		{
			if (onDraging)
			{
				var _ray:Vector3D = camera.lens.unProject(view.mouseX, view.mouseY, camera.screenMatrix3D.position.z);
				_ray = camera.transform.matrix3D.transformVector(_ray);

				var cameraVector3D:Vector3D = new Vector3D(view.camera.x, view.camera.y, view.camera.z);
				var rayVector3D:Vector3D = new Vector3D(_ray.x, _ray.y, _ray.z);
				var intersectPoint:Vector3D = JMath3D.getIntersectionLine(planeToDragOn, cameraVector3D, rayVector3D);

				dragConstraint.worldPosition = new Vector3D(intersectPoint.x, intersectPoint.y, intersectPoint.z);
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (onDraging)
			{
				onDraging = false;
				physics.engine.removeConstraint(dragConstraint);
				currDragBody.setActive();
			}
		}

		override protected function onPreRender():void
		{
			//run
			physics.step();

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position);
		}
	}
}