package {
	import alternativa.engine3d.core.Light3D;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.physics3dintegration.PhysicsSprite;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.events.PhysicsEvent;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;

	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;

	[SWF (backgroundColor="0xAAAAAA", width="1024", height="768", frameRate="60")]
	public class BallDemo extends PhysicsSprite {
        // EN: Flags of pressing the buttons
		// RU: Флаги нажатия клавиш.
		private var left:Boolean, right:Boolean, up:Boolean,  down:Boolean;
        // EN: Controlled ball
		// RU: Шар, которым мы управляем.
		private var ball:SimBall;
        // EN: Flag that we move
		// RU: Флаг, который мы несем.
		private var flag:SimFlag = null;

        // EN: temporary variables
		// RU: временные  переменые
		private var dir:Vector3 = new Vector3();
		private var t:Vector3 = new Vector3();

		public function BallDemo() {
			super();
		}

		override protected function setScene():void {
			addChild(camera.diagram);
			/**
             * EN: Add the light
			 * RU: Добавление света
			 */
			var light:Light3D = new OmniLight(0xAAAAAA, 1, 10000);
			light.x = 100;
			light.y = 100;
			light.z = 1000;
			light.intensity = 1;
			addObject3D(light);
			light = new AmbientLight(0xAAAAAA);
			light.intensity = 0.3;
			addObject3D(light);

			flag = null;
			left = right = up = down = false;
            // EN: Add a plane
			// RU: Добавляем плоскость.
			addSimObject(new SimPlane(10, 10));

            // EN: Specify the ball transformation and add the ball.
			// RU: Задаем трансформацию шара и добавляем шар.
			var transform:Matrix4 = new Matrix4();
			transform.setPositionXYZ(0, 0, 0.8);
			addSimObject(ball = new SimBall(0.8, transform));

            // EN: Add flags
			// RU: Добавляем флаги.
			transform = new Matrix4();
			transform.setMatrix(4, 4, 0, 0, 0, Math.PI*(1 + 1/6));
			addSimObject(new SimFlag(transform, 0xFB0AFF, takeFlag));
			transform = new Matrix4();
			transform.setMatrix(-4, -4, 0, 0, 0, -Math.PI/6);
			addSimObject(new SimFlag(transform, 0xFF00, takeFlag));

			// EN: Add places for the flags.
			// RU: Добавляем места под флаги.
			transform = new Matrix4();
			transform.setPositionXYZ(-4, 4, 0);
			addSimObject(new SimTargetTrigger(transform, placeFlag));
			transform.setPositionXYZ(4, -4, 0);
			addSimObject(new SimTargetTrigger(transform, placeFlag));

			// EN: Disable moving of the camera.
			// RU: Отключаем передвижение камеры.
			cameraController.disable();
            // EN: Set the camera position.
			// RU: Устанавливаем камере позицию.
			cameraController.setObjectPosXYZ(0, -10, 5);
            // EN: Set the direction of view.
			// RU: Устанавливаем направление взляда.
			cameraController.lookAtXYZ(0, 0, 0);
            // EN: Add the handlers of keyboard events.
			// RU: Добавляем обработчики события клавиатуры.
			stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
            // EN: Add the handler for the OnBeforeUpdate (before the simulation step) event.
			// RU: Добавление обработчика события до шага симуляции.
			physicsScene.addEventListener(PhysicsEvent.OnBeforeUpdate, moveBall);
		}

        // EN: onKeyDown handler.
		// RU: Обработчик на нажатие клавиши.
		private function onKeyDown(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
				case Keyboard.A:
					left = true;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					right = true;
					break;
				case Keyboard.UP:
				case Keyboard.W:
					up = true;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					down = true;
					break;
			}
		}

        // EN: onKeyUp handler.
		// RU: Обработчик на отжатие клавиши.
		private function onKeyUp(event:KeyboardEvent):void {
			switch (event.keyCode) {
				case Keyboard.LEFT:
				case Keyboard.A:
					left = false;
					break;
				case Keyboard.RIGHT:
				case Keyboard.D:
					right = false;
					break;
				case Keyboard.UP:
				case Keyboard.W:
					up = false;
					break;
				case Keyboard.DOWN:
				case Keyboard.S:
					down = false;
					break;
			}
		}

        // EN: Moving of the ball.
		// RU: Передвижение мяча.
		private function moveBall(event:PhysicsEvent):void {
            // EN: Calculates the moving direction vector on pressed buttons.
			// RU: Вычисляется вектор направления движения по нажатым клавишам.
			dir.reset();
			if (left) {
				dir.x--;
			}
			if (right) {
				dir.x++;
			}
			if (up) {
				dir.y++;
			}
			if (down) {
				dir.y--;
			}
			if (dir.length() > 0.5) {
                // EN: The ball rotates only in the direction of motion.
				// RU: Не даем шару вращаться не в направлении движения.
				var rotation:Vector3 = ball.body.state.rotation;
				dir.normalize();
				t.cross2(dir, rotation);
				var dot:Number = t.z;
				if (dot < 0) {
					dot = 0;
				}
				t.cross2(Vector3.Z_AXIS, dir);
				rotation.copy(t).scale(dot);

				dir.scale(20);
                // EN: Add the force to ball for the next simulation step.
				// RU: Добавляем силу мячу на следущий шаг симуляции.
				ball.body.addForce(dir);
			} else {
                // EN: Stop the ball.
				// RU: Тормозим, не давая шару вращаться.
				ball.body.state.rotation.reset();
			}
		}

        // EN: Handler of taking the flag.
		// RU: Обработчик взятия флага.
		private function takeFlag(event:ContactEvent):void {
            // EN: If you get the first flag and try to get the second flag, then the first flag is goes back.
			// RU: Если флаг был взят, то взятый флаг ставится на место.
			if (flag != null) {
				flag.visible = true;
			}
            // EN: Get information about taken flag from the user data.
			// RU: Берем информацию о взятом флаге из пользовательских данных.
			flag = (event.userData as SimFlag);
            // EN: Set color of taken flag to ball
			// RU: Устанавливаем шару, цвет флага.
			ball.setColor(context, flag.flagColor);
            // EN: Flag is disappeared.
			// RU: Флаг исчезает.
			flag.visible = false;
		}

		private function placeFlag(event:ContactEvent):void {
            // EN: If flag is not get, then nothing else to do
			// RU: Если флаг не взят, то ничего делать не надо.
			if (flag == null) {
				return;
			}
            // EN: Get the flag place from the user data.
			// RU: Берем место под флага из пользовательских данных.
			var target:SimTargetTrigger = event.userData as SimTargetTrigger;
            // EN: Set the color of the ball to the place
			// RU: Окрашиваем место в цвет флага.
			target.setColor(context, flag.flagColor);
            // EN: Set the ball color.
			// RU: Устанавливаем цвет шара.
			ball.setColor(context, 0xFFFF40);
            // EN: Now the ball does not move the flag.
			// RU: Шар флаг больше не несет.
			flag = null;
		}
	}
}
