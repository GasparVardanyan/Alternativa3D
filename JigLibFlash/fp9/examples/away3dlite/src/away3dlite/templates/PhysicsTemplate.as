package away3dlite.templates
{
	import away3dlite.arcane;
	import away3dlite.core.render.*;
	import away3dlite.materials.ColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.primitives.Cube6;
	
	use namespace arcane;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLitePhysics;
	import away3dlite.core.clip.RectangleClipping;
	
	/**
	 * Physics Template
	 * 
 	 * @see http://away3d.googlecode.com/svn/branches/JigLibLite/src
 	 * @see http://away3d.googlecode.com/svn/trunk/fp10/Examples/JigLibLite
 	 * 
	 * @author katopz
	 */
	public class PhysicsTemplate extends Template
	{
		protected var physics:Away3DLitePhysics;
		protected var ground:RigidBody;
		
		/** @private */
		arcane override function init():void
		{
			super.init();
			
			view.renderer = renderer;
			view.clipping = clipping;
			
			build();
		}
		
		/**
		 * The renderer object used in the template.
		 */
		public var renderer:BasicRenderer = new BasicRenderer();
		
		/**
		 * The clipping object used in the template.
		 */
		public var clipping:RectangleClipping = new RectangleClipping();
		
		protected override function onInit():void
		{
			title += " | JigLibLite Physics";
			
			physics = new Away3DLitePhysics(scene, 10);
			ground = physics.createGround(new WireframeMaterial(), 1000, 0);
			ground.movable = false;
			ground.friction = 0.2;
			ground.restitution = 0.8;
		}

		override public function set debug(val:Boolean):void
		{
			super.debug = val;
			
			// debug cube, to be remove
			var length:int = 250;
			var oCube:Cube6 = new Cube6(new ColorMaterial(0xFFFFFF), 10, 10, 10);
			scene.addChild(oCube);

			var xCube:Cube6 = new Cube6(new ColorMaterial(0xFF0000), 10, 10, 10);
			xCube.x = length;
			scene.addChild(xCube);

			var yCube:Cube6 = new Cube6(new ColorMaterial(0x00FF00), 10, 10, 10);
			yCube.y = length;
			scene.addChild(yCube);

			var zCube:Cube6 = new Cube6(new ColorMaterial(0x0000FF), 10, 10, 10);
			zCube.z = length;
			scene.addChild(zCube);
			
			//
			
			var _xCube:Cube6 = new Cube6(new ColorMaterial(0x660000), 10, 10, 10);
			_xCube.x = -length;
			scene.addChild(_xCube);

			var _yCube:Cube6 = new Cube6(new ColorMaterial(0x006600), 10, 10, 10);
			_yCube.y = -length;
			scene.addChild(_yCube);

			var _zCube:Cube6 = new Cube6(new ColorMaterial(0x000066), 10, 10, 10);
			_zCube.z = -length;
			scene.addChild(_zCube);
		}
		
		protected function build():void
		{
			// override me
		}
	}
}