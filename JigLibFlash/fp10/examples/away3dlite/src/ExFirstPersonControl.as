package
{
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;
	import away3dlite.ui.Keyboard3D;
	
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Vector3D;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#666666", frameRate="30", width="800", height="600")]
	/**
	 * Example : First Person Control
	 * 
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExFirstPersonControl extends PhysicsTemplate
	{
		private var _cameraRigidBody:RigidBody;

		private var _isDrag:Boolean;
		private var _startDragPoint:Point;

		override protected function build():void
		{
			//system
			title += " | Keyboard Control | Use Arrow Key to move, C to fly | ";

			camera.y = -1000;
			camera.lookAt(new Vector3D);

			//event
			new Keyboard3D(stage);

			//decor
			for (var i:int = 0; i < 16; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(1000 * Math.random() - 1000 * Math.random(), -50, 1000 * Math.random() - 1000 * Math.random()));
			}

			//camera instance
			_cameraRigidBody = physics.createCube(new WireframeMaterial, 50, 50, 50);
			Away3DLiteMesh(_cameraRigidBody.skin).mesh.visible = false;
			_cameraRigidBody.moveTo(new Vector3D(0, -50, 0));
			_cameraRigidBody.mass = 3;

			stage.addEventListener(MouseEvent.MOUSE_DOWN, onMouse);
			stage.addEventListener(MouseEvent.MOUSE_UP, onMouse);
		}

		private function onMouse(event:MouseEvent):void
		{
			switch (event.type)
			{
				case MouseEvent.MOUSE_DOWN:
					_isDrag = true;
					_startDragPoint = new Point(view.mouseX, view.mouseY);
					break;
				case MouseEvent.MOUSE_UP:
					_isDrag = false;
					break;
			}
		}

		override protected function onPreRender():void
		{
			// current state
			var _p:Vector3D = Keyboard3D.position.clone();
			
			// look
			if (_isDrag)
			{
				var _currentPoint:Point = new Point(view.mouseX, view.mouseY);
				_startDragPoint = _currentPoint.subtract(_startDragPoint);
				
				_cameraRigidBody.rotationY += _startDragPoint.x / 20;
				_cameraRigidBody.rotationX -= _startDragPoint.y / 20;
				
				_startDragPoint = _currentPoint.clone();
			}
			
			// force
			if (_p.length > 0)
			{
				var _force:Vector3D = _p.clone();
				_force.scaleBy(20);
				
				_cameraRigidBody.addBodyForce(_force, _p);
			}

			// run
			physics.step();
			
			// move camera
			camera.transform.matrix3D = _cameraRigidBody.getTransform().clone();
		}
	}
}