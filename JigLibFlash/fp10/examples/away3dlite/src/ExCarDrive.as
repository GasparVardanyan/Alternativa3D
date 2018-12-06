package
{
	import away3dlite.containers.ObjectContainer3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.events.Loader3DEvent;
	import away3dlite.loaders.Collada;
	import away3dlite.loaders.Loader3D;
	import away3dlite.materials.WireColorMaterial;
	import away3dlite.materials.WireframeMaterial;
	import away3dlite.templates.PhysicsTemplate;

	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;

	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3dlite.Away3DLiteMesh;
	import jiglib.vehicles.JCar;

	[SWF(backgroundColor="#666666", frameRate="30", width="800", height="600")]
	/**
	 * Example : Car Drive
	 *
	 * @see http://away3d.googlecode.com/svn/branches/lite/libs
	 * @see http://jiglibflash.googlecode.com/svn/trunk/fp10/src
	 *
	 * @author katopz
	 */
	public class ExCarDrive extends PhysicsTemplate
	{
		private var carBody:JCar;

		private var steerFR:ObjectContainer3D;
		private var steerFL:ObjectContainer3D;

		private var wheelFR:Mesh;
		private var wheelFL:Mesh;
		private var wheelBR:Mesh;
		private var wheelBL:Mesh;

		override protected function build():void
		{
			//system
			title += " | Car Drive | Use Key Up, Down, Left, Right | ";

			camera.y = -1000;

			//decor
			for (var i:int = 0; i < 20; i++)
			{
				var box:RigidBody = physics.createCube(new WireframeMaterial(0xFFFFFF * Math.random()), 25, 25, 25);
				box.moveTo(new Vector3D(500 * Math.random() - 500 * Math.random(), -500 - (100 * i + 100), 500 * Math.random() - 500 * Math.random()));
			}

			//player
			initCar();

			stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}

		private function initCar():void
		{
			var collada:Collada = new Collada();
			collada.scaling = 0.5;
			collada.bothsides = false;

			var loader:Loader3D = new Loader3D();
			loader.addEventListener(Loader3DEvent.LOAD_SUCCESS, onSuccess);
			loader.loadGeometry("assets/car.dae", collada);
			scene.addChild(loader);
		}

		private function onSuccess(event:Loader3DEvent):void
		{
			var carSkin:ObjectContainer3D = event.loader.handle as ObjectContainer3D;

			// wheel
			carSkin.materialLibrary.getMaterial("ColorMaterial_06860600").material = new WireColorMaterial();
			// body
			carSkin.materialLibrary.getMaterial("ColorMaterial_E3989800").material = new WireColorMaterial();

			carBody = new JCar(new Away3DLiteMesh(carSkin));
			carBody.setCar(40, 1, 400);
			carBody.chassis.moveTo(new Vector3D(0, -100, 0));
			carBody.chassis.rotationY = 90;
			carBody.chassis.mass = 9;
			carBody.chassis.sideLengths = new Vector3D(40, 20, 90);
			physics.addBody(carBody.chassis);

			carBody.setupWheel("WheelFL", new Vector3D(-20, 10, 25), 1.2, 1.2, 3, 10, 0.5, 0.6, 2);
			carBody.setupWheel("WheelFR", new Vector3D(20, 10, 25), 1.2, 1.2, 3, 10, 0.5, 0.6, 2);
			carBody.setupWheel("WheelBL", new Vector3D(-20, 10, -25), 1.2, 1.2, 3, 10, 0.5, 0.6, 2);
			carBody.setupWheel("WheelBR", new Vector3D(20, 10, -25), 1.2, 1.2, 3, 10, 0.5, 0.6, 2);

			steerFL = carSkin.getChildByName("WheelFL") as ObjectContainer3D;
			steerFR = carSkin.getChildByName("WheelFR") as ObjectContainer3D;

			wheelFL = carSkin.getChildByName("WheelFL_PIVOT") as Mesh;
			wheelFL.material = new WireframeMaterial();

			wheelFR = carSkin.getChildByName("WheelFR_PIVOT") as Mesh;
			wheelFR.material = new WireframeMaterial();

			wheelBL = carSkin.getChildByName("WheelBL") as Mesh;
			wheelBL.material = new WireframeMaterial();
			wheelBR = carSkin.getChildByName("WheelBR") as Mesh;
			wheelBR.material = new WireframeMaterial();
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
					carBody.setSteer(["WheelFL", "WheelFR"], -1);
					break;
				case Keyboard.RIGHT:
					carBody.setSteer(["WheelFL", "WheelFR"], 1);
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
			}
		}

		private function updateWheelSkin():void
		{
			if (!carBody)
				return;

			steerFL.rotationY = carBody.wheels["WheelFL"].getSteerAngle();
			steerFR.rotationY = carBody.wheels["WheelFR"].getSteerAngle();

			wheelFL.rotationX -= carBody.wheels["WheelFL"].getRollAngle();
			wheelFR.rotationX -= carBody.wheels["WheelFR"].getRollAngle();

			wheelBL.rotationX -= carBody.wheels["WheelBL"].getRollAngle();
			wheelBR.rotationX -= carBody.wheels["WheelBR"].getRollAngle();

			steerFL.y = carBody.wheels["WheelFL"].getActualPos().y;
			steerFR.y = carBody.wheels["WheelFR"].getActualPos().y;
			wheelBL.y = carBody.wheels["WheelBL"].getActualPos().y;
			wheelBR.y = carBody.wheels["WheelBR"].getActualPos().y;
		}

		override protected function onPreRender():void
		{
			//update
			updateWheelSkin();

			//run
			physics.engine.integrate(0.1);

			//system
			camera.lookAt(Away3DLiteMesh(ground.skin).mesh.position);
		}
	}
}