package
{
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.ui.Keyboard3D;

	import flash.geom.Vector3D;

	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;
	import away3dlite.templates.PhysicsTemplate;

	[SWF(backgroundColor="#666666", frameRate="30", width="800", height="600")]
	/**
	 * Example : Keyboard Control
	 *
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExKeyboardControl extends PhysicsTemplate
	{
		private var ball:RigidBody;

		override protected function build():void
		{
			//system
			title += " | Keyboard Control | Use Arrow Key to move, C to fly | ";

			camera.y = -1000;

			//event
			new Keyboard3D(stage);

			//decor
			for (var i:int = 0; i < 16; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(0, -500 - (100 * i + 100), 0));
			}

			for (i = 0; i < 4; i++)
			{
				var sphere:RigidBody;
				if (i == 2)
				{
					//controllable
					ball = sphere = physics.createSphere(new ColorMaterial(0xFF0000), 25);
				}
				else
				{
					sphere = physics.createSphere(new WireframeMaterial(), 25);
				}

				sphere.mass = 3;
				sphere.moveTo(new Vector3D(-100, -500 - (100 * i + 100), -100));
			}
		}

		override protected function onPreRender():void
		{
			//move
			var position:Vector3D = Keyboard3D.position.clone();
			position.scaleBy(20);

			//fly by hold "c" 
			position.y *= ball.mass*1.5;

			ball.addWorldForce(position, ball.currentState.position);

			//run
			physics.step();

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position);
		}
	}
}