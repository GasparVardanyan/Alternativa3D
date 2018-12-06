package
{
	import away3dlite.materials.BitmapFileMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;
	
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	
	import jiglib.math.JNumber3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#666666",frameRate="30",quality="MEDIUM",width="800",height="600")]
	/**
	 * Example : Gravity
	 *
	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp9/src
	 *
	 * @author katopz
	 */
	public class ExGravity extends PhysicsTemplate
	{
		private var cubes:Vector.<RigidBody>;

		override protected function build():void
		{
			title += " | Gravity : Click to reset | ";

			// move camera to top view
			camera.y = -1000;

			// random decor
			cubes = new Vector.<RigidBody>(20, true);
			for (var i:int = 0; i < 20; i++)
			{
				var cube:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				cube.material.restitution = .1;
				cubes[i] = cube;
			}
			
			physics.createSphere(new BitmapFileMaterial("assets/earth.jpg"), 50).moveTo(new JNumber3D(0, 50, 0));
			
			//reset
			reset();
			stage.addEventListener(MouseEvent.CLICK, reset);
		}

		private function reset(e:* = null):void
		{
			for each (var cube:RigidBody in cubes)
			{
				cube.x = Math.random() * 500 - Math.random() * 500;
				cube.y = 500 + Math.random() * 1000;
				cube.z = Math.random() * 500 - Math.random() * 500;
				cube.rotationX = 360 * Math.random();
				cube.rotationY = 360 * Math.random();
				cube.rotationZ = 360 * Math.random();
				cube.setActive();
			}
		}

		override protected function onPreRender():void
		{
			//run
			physics.step();

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position, new Vector3D(0, -1, 0));
		}
	}
}