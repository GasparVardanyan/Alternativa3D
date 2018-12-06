package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Trident;

	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLitePhysics;

	use namespace arcane;

	/**
	 * Physics Template
	 *
	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Away3DLite/src
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class PhysicsTemplate extends BasicTemplate
	{
		protected var physics:Away3DLitePhysics;
		protected var ground:RigidBody;

		private var _trident:Trident;

		protected override function onInit():void
		{
			title += " | JigLib Physics";

			physics = new Away3DLitePhysics(scene, 10);

			ground = physics.createGround(new WireframeMaterial(), 1000, 0);
			ground.movable = false;
			ground.friction = 0.2;
			ground.restitution = 0.8;

			build();
		}

		protected function build():void
		{
			// override me
		}

		override public function set debug(value:Boolean):void
		{
			super.debug = value;

			if (value)
			{
				scene.addChild(_trident = new Trident(250));
			}
			else
			{
				scene.removeChild(_trident);
				_trident = null;
			}
		}
	}
}