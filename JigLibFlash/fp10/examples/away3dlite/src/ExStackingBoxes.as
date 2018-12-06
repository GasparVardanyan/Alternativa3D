package
{
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;

	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Vector3D;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;

	import jiglib.cof.JConfig;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;

	[SWF(backgroundColor="#DDDDDD", frameRate="30", width="800", height="600")]
	/**
	 * Example : Stack Boxes
	 *
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExStackingBoxes extends PhysicsTemplate
	{
		private var _boxes:Vector.<RigidBody>;
		private var _BOX_SIZE:int = 50;

		private var _SIZE_X:int = 3;
		private var _SIZE_Y:int = 4;
		private var _SIZE_Z:int = 3;

		private var logTextField:TextField;

		protected override function build():void
		{
			title += " | Stack Boxes | Click to reset |";

			init3D();

			JConfig.doShockStep = true;

			camera.x = 1000;
			camera.y = -1000 * Math.SQRT2 * .5;
			camera.lookAt(new Vector3D);

			addChild(logTextField = new TextField());
			logTextField.autoSize = TextFieldAutoSize.LEFT;
			logTextField.y = 100;
		}

		private function init3D():void
		{
			// layer
			var layer:Sprite = new Sprite();
			view.addChild(layer);

			// boxes
			_boxes = new Vector.<RigidBody>();

			for (var k:int = 0; k < _SIZE_Y; k++)
			{
				for (var j:int = 0; j < _SIZE_Z; j++)
				{
					for (var i:int = 0; i < _SIZE_X; i++)
					{
						var box:RigidBody = physics.createCube(new WireframeMaterial(int(0xFF0000 * (k + 1) / (_SIZE_Y + 1) + 0x00FF * (i + 1) / (_SIZE_X + 1) + 0x0000FF * (j + 1) / (_SIZE_Z + 1))), _BOX_SIZE, _BOX_SIZE, _BOX_SIZE);
						Away3DLiteMesh(box.skin).mesh.layer = layer;
						_boxes.push(box);
					}
				}
			}

			reset();

			// event
			stage.addEventListener(MouseEvent.CLICK, onClick);
		}

		private function onClick(event:MouseEvent):void
		{
			reset();
		}

		private function reset():void
		{
			for (var k:int = 0; k < _SIZE_Y; k++)
			{
				for (var j:int = 0; j < _SIZE_Z; j++)
				{
					for (var i:int = 0; i < _SIZE_X; i++)
					{
						var box:RigidBody = _boxes[(_SIZE_X * _SIZE_Z) * k + j * _SIZE_X + i];
						box.rotationX = box.rotationY = box.rotationZ = 0;
						box.moveTo(new Vector3D(i * _BOX_SIZE * 2 - _SIZE_X * _BOX_SIZE * .5, -(k + 1) * _BOX_SIZE - _BOX_SIZE, j * _BOX_SIZE * 2 - _SIZE_Z * _BOX_SIZE * .5));
						box.setActive();
					}
				}
			}
		}

		override protected function onPreRender():void
		{
			physics.engine.integrate(0.12);
		}
	}
}