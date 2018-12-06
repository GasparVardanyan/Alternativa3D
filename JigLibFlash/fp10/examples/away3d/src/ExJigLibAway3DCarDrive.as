package
{
	import away3d.containers.ObjectContainer3D;
	import away3d.core.base.Mesh;
	import away3d.core.utils.Debug;
	import away3d.events.Loader3DEvent;
	import away3d.loaders.Collada;
	import away3d.loaders.Loader3D;
	import away3d.materials.WireColorMaterial;
	import away3d.materials.WireframeMaterial;
	import away3d.test.SimpleView;

	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	import jiglib.cof.JConfig;
	import jiglib.math.JNumber3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3d.Away3DPhysics;
	import jiglib.plugin.away3d.Away3dMesh;
	import jiglib.vehicles.JCar;

	[SWF(backgroundColor="0xFFFFFF", frameRate="30", width="800", height="600")]
	/**
	 *
	 * JigLibFlash for Away3D
	 *
	 * @source http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 * @author katopz@sleepydesign.com
	 *
	 */
	public class ExJigLibAway3DCarDrive extends SimpleView
	{
		private var physics:Away3DPhysics;

		private var carBody:JCar;

		private var steerFR:ObjectContainer3D;
		private var steerFL:ObjectContainer3D;

		private var wheelFR:Mesh;
		private var wheelFL:Mesh;
		private var wheelBR:Mesh;
		private var wheelBL:Mesh;

		private var boxBody:Array = [];

		public function ExJigLibAway3DCarDrive()
		{
			super("JigLibFlash", "JigLibFlash via Away3D, CarDrive by katopz");
			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		override protected function create():void
		{
			// Physics System
			physics = new Away3DPhysics(view, 10);

			// Ground
			var ground:RigidBody = physics.createGround({width: 1000, height: 1000, material: new WireframeMaterial(), pushback: true}, 0);

			// Decor
			var box:RigidBody;
			var boxSize:Number = 100;
			for (var i:uint = 0; i < 4; i++)
			{
				box = physics.createCube({width: boxSize, height: boxSize, depth: boxSize})
				box.moveTo(new Vector3D(200, 240 + (boxSize * i + 60), -100));
			}

			Debug.active = true;

			// Car
			var loader:Loader3D = Collada.load("assets/car.dae", {scaling: 1});
			loader.addOnSuccess(onLoaderSuccess);
			view.scene.addChild(loader);
		}

		private function onLoaderSuccess(event:Loader3DEvent):void
		{
			var carSkin:ObjectContainer3D = event.loader.handle as ObjectContainer3D;

			// wheel
			carSkin.materialLibrary.getMaterial("ColorMaterial_06860600").material = new WireColorMaterial();
			// body
			carSkin.materialLibrary.getMaterial("ColorMaterial_E3989800").material = new WireColorMaterial();

			carBody = new JCar(new Away3dMesh(carSkin));
			carBody.setCar(45, 4, 500);
			carBody.chassis.moveTo(new Vector3D(0, 100, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(40, 20, 90);
			physics.addBody(carBody.chassis);

			carBody.setupWheel("WheelFL", new Vector3D(-20, -10, 25), 1.2, 1.2, 3, 10, 0.4, 0.6, 2);
			carBody.setupWheel("WheelFR", new Vector3D(20, -10, 25), 1.2, 1.2, 3, 10, 0.4, 0.6, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-20, -10, -25), 1.2, 1.2, 3, 10, 0.4, 0.6, 2);
			carBody.setupWheel("WheelBR", new Vector3D(20, -10, -25), 1.2, 1.2, 3, 10, 0.4, 0.6, 2);

			steerFL = carSkin.getChildByName("WheelFL-node") as ObjectContainer3D;
			steerFR = carSkin.getChildByName("WheelFR-node") as ObjectContainer3D;

			wheelFL = carSkin.getChildByName("WheelFL-node") as Mesh;
			wheelFL.material = new WireframeMaterial();

			wheelFR = carSkin.getChildByName("WheelFR-node") as Mesh;
			wheelFR.material = new WireframeMaterial();

			wheelBL = carSkin.getChildByName("WheelBL-node") as Mesh;
			wheelBL.material = new WireframeMaterial();
			wheelBR = carSkin.getChildByName("WheelBR-node") as Mesh;
			wheelBR.material = new WireframeMaterial();

			// Look at me please
			target = carSkin;

			// Fun!
			start();
		}

		private function keyDownHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
					carBody.setAccelerate(-1);
					break;
				case Keyboard.DOWN:
					carBody.setAccelerate(1);
					break;
				case Keyboard.LEFT:
					carBody.setSteer(["WheelFL", "WheelFR"], 1);
					break;
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], -1);
					break;
				case Keyboard.SPACE:
					carBody.setHBrake(1);
					break;
			}
		}

		private function keyUpHandler(event:KeyboardEvent):void
		{
			switch (event.keyCode)
			{
				case Keyboard.UP:
					carBody.setAccelerate(0);
					break;
				case Keyboard.DOWN:
					carBody.setAccelerate(0);
					break;
				case Keyboard.LEFT:
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], 0);
					break;
				case Keyboard.SPACE:
					carBody.setHBrake(0);
					break;
			}
		}

		private function updateWheelSkin():void
		{
			if (!carBody)
				return;

			steerFL.rotationY = -carBody.wheels["WheelFL"].getSteerAngle();
			steerFR.rotationY = -carBody.wheels["WheelFR"].getSteerAngle();

			wheelFL.rotationX -= carBody.wheels["WheelFL"].getRollAngle();
			wheelFR.rotationX -= carBody.wheels["WheelFR"].getRollAngle();

			wheelBL.rotationX -= carBody.wheels["WheelBL"].getRollAngle();
			wheelBR.rotationX -= carBody.wheels["WheelBR"].getRollAngle();

			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
		}

		override protected function draw():void
		{
			physics.engine.integrate(0.125);
			updateWheelSkin();
		}
	}
}