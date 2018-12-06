package
{
	import away3dlite.containers.Lines;
	import away3dlite.core.base.Line3D;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.LineMaterial;
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
	 * Example : Mouse Control
	 *
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExMouseControl extends PhysicsTemplate
	{
		private var _boxBodies:Array;

		private var _isDrag:Boolean = false;

		private var _currDragBody:RigidBody;
		private var _dragConstraint:JConstraintWorldPoint;
		private var _planeToDragOn:Vector3D;

		private var _startMousePos:Vector3D;

		private var lines:Lines;
		private var dragLineMaterial:LineMaterial = new LineMaterial(0xFF00FF);
		private var rayLineMaterial:LineMaterial = new LineMaterial(0x00FFFF);

		override protected function build():void
		{
			title += " | Mouse Control | Use mouse to drag red ball | ";

			camera.x = 0;
			camera.y = -1000;
			camera.z = -1000;

			init3D();
		}

		private function init3D():void
		{
			// Layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);

			var color:uint;
			for (var i:int = 0; i < 3; i++)
			{
				color = (i == 0) ? 0xff8888 : 0xeeee00;

				var ball:RigidBody;
				if (i == 2)
				{
					ball = physics.createSphere(new ColorMaterial(0xFF0000), 25);

					// draggable
					_currDragBody = ball;
					Away3DLiteMesh(ball.skin).mesh.layer = layer;
				}
				else
				{
					ball = physics.createSphere(new WireframeMaterial(), 25);
				}
				ball.mass = 5;
				ball.moveTo(new Vector3D(-100, -500 - (100 * i + 100), -100));
			}

			_boxBodies = [];
			for (i = 0; i < 10; i++)
			{
				_boxBodies[i] = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				_boxBodies[i].moveTo(new Vector3D(500 * Math.random() - 500 * Math.random(), -500 - 500 * Math.random(), 500 * Math.random() - 500 * Math.random()));
			}

			layer.addEventListener(MouseEvent.MOUSE_DOWN, handleMousePress);
		}

		private function handleMousePress(event:MouseEvent):void
		{
			_isDrag = true;

			_startMousePos = _currDragBody.getTransform().position;

			_planeToDragOn = JMath3D.fromNormalAndPoint(Vector3D.Y_AXIS, new Vector3D(0, 0, -_startMousePos.z));
			var bodyPoint:Vector3D = _startMousePos.subtract(_currDragBody.currentState.position);

			_dragConstraint = new JConstraintWorldPoint(_currDragBody, bodyPoint, _startMousePos);

			physics.engine.addConstraint(_dragConstraint);

			stage.addEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			stage.addEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);

			if (lines)
				lines.destroy();

			lines = new Lines();
			scene.addChild(lines);

			lines.addLine(new Line3D(_startMousePos, _startMousePos, dragLineMaterial));
			lines.addLine(new Line3D(camera.position, _startMousePos, rayLineMaterial));
		}

		private function handleMouseMove(event:MouseEvent):void
		{
			if (_isDrag)
			{
				var _ray:Vector3D = camera.lens.unProject(view.mouseX, view.mouseY, camera.screenMatrix3D.position.z);
				_ray = camera.transform.matrix3D.transformVector(_ray);
				_dragConstraint.worldPosition = JMath3D.getIntersectionLine(_planeToDragOn, camera.position, _ray);

				lines.children[0].endPosition = _dragConstraint.worldPosition;
				lines.children[1].endPosition = _ray;
			}
		}

		private function handleMouseRelease(event:MouseEvent):void
		{
			if (_isDrag)
			{
				_isDrag = false;
				physics.engine.removeConstraint(_dragConstraint);
				_currDragBody.setActive();
			}

			stage.removeEventListener(MouseEvent.MOUSE_MOVE, handleMouseMove);
			stage.removeEventListener(MouseEvent.MOUSE_UP, handleMouseRelease);
		}

		override protected function onPreRender():void
		{
			//run
			physics.step();

			//system
			camera.lookAt(new Vector3D(0, 0, 0));
		}
	}
}