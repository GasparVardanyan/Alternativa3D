package entity {
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.GeoSphere;
	import alternativaphysics.collision.dispatch.A3DGhostObject;
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DCapsuleShape;
	import alternativaphysics.collision.shapes.A3DConvexHullShape;
	import alternativaphysics.collision.shapes.A3DSphereShape;
	import alternativaphysics.dynamics.A3DRigidBody;
	import alternativaphysics.dynamics.character.A3DKinematicCharacterController;
	import flash.geom.Vector3D;
	import flash.events.KeyboardEvent;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	import utility.GameController;

	/**
	 * ...
	 * @author redefy
	 */
	public class Hero extends Entity {
		private var _mesh:Mesh;
		private var rigidBody:Mesh;
		private var character:A3DKinematicCharacterController;
		private var keyRight : Boolean = false;
		private var keyLeft : Boolean = false;
		private var keyForward : Boolean = false;
		private var keyReverse : Boolean = false;
		private var keyUp : Boolean = false;
		private var walkDirection : Vector3D = new Vector3D();
		private var walkSpeed : Number = 0.03;
		private var chRotation : Number = 0;

		public function Hero() {
			super();
			
			name = "hero";
			
			createMesh();
			createRigidBody();
			GV.stage.addEventListener(KeyboardEvent.KEY_DOWN, keyDownHandler);
			GV.stage.addEventListener(KeyboardEvent.KEY_UP, keyUpHandler);
		}
		
		public function get mesh():Mesh {
			return _mesh;
		}
		
		private function createMesh():void {
			_mesh = new GeoSphere(50, 12);
			//_mesh.setMaterialToAllSurfaces(new FillMaterial(0xFF00FF,1));
			addChild(_mesh);
		}
		
		private function createRigidBody():void {
			GV.parserA3D.parse(new GFX.CharacterShape());
			var convex:Mesh = GV.parserA3D.objects[0] as Mesh;
			var shape:A3DConvexHullShape = new A3DConvexHullShape(convex.geometry);
	
			var ghost:A3DGhostObject = new A3DGhostObject(shape, _mesh);
			character = new A3DKinematicCharacterController(ghost, shape, 0.1);
			character.gravity = 20;
			character.jumpSpeed = 5;
			character.warp(GV.currentScene.startPoint);

			GV.camera.rotationX = GV.currentScene.startRotation.x;
			GV.camera.rotationY = GV.currentScene.startRotation.y;
			GV.camera.rotationZ = GV.currentScene.startRotation.z;
			GV.physicsWorld.addCharacter(character);
		}
		
		private function keyDownHandler(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case Keyboard.W:
					keyForward = true;
					keyReverse = false;
					break;
				case Keyboard.S:
					keyReverse = true;
					keyForward = false;
					break;
				case Keyboard.A:
					keyLeft = true;
					keyRight = false;
					break;
				case Keyboard.D:
					keyRight = true;
					keyLeft = false;
					break;
				case Keyboard.SPACE:
					keyUp = true;
					break;
			}
			
			/**if (event.keyCode == Keyboard.W) {
				keyForward = true;
				keyReverse = false;
			}
			if (event.keyCode == Keyboard.S) {
				keyReverse = true;
				keyForward = false;
			}
			if (event.keyCode == Keyboard.A) {
				keyLeft = true;
				keyRight = false;
			}
			if (event.keyCode == Keyboard.D) {
				keyRight = true;
				keyLeft = false;
			}
			if (event.keyCode == Keyboard.SPACE) {
				keyUp = true;
			}*/
		}

		private function keyUpHandler(event : KeyboardEvent) : void {
			switch(event.keyCode) {
				case Keyboard.W:
					keyForward = false;
					walkDirection.scaleBy(0);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = false;
					break;
				case Keyboard.S:
					keyReverse = false;
					walkDirection.scaleBy(0);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = false;
					break;
				case Keyboard.A:
					keyLeft = false;
					GV.gameController.keyDown = false;
					break;
				case Keyboard.D:
					keyRight = false;
					GV.gameController.keyDown = false;
					break;
				case Keyboard.SPACE:
					keyUp = false;
					break;
			}
		}
		
		override public function update():void {
			//trace(character.ghostObject.position);
			if (character) {
				walkDirection = new Vector3D();
				character.setWalkDirection(walkDirection);
				if (keyLeft && character.onGround()) {
					var ss:Vector3D = character.ghostObject.right;
					ss.negate();
					walkDirection = ss;
					walkDirection.scaleBy(walkSpeed);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = true;
				}
				if (keyRight && character.onGround()) {
					walkDirection = character.ghostObject.right;
					walkDirection.scaleBy(walkSpeed);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = true;
				}
				character.ghostObject.rotation = new Vector3D(0, 0, GV.camera.rotationZ/Math.PI * 180);
				if (keyForward) {
					walkDirection = character.ghostObject.front;
					walkDirection.scaleBy(walkSpeed);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = true;
				}
				if (keyReverse) {
					walkDirection = character.ghostObject.front;
					walkDirection.scaleBy(-walkSpeed);
					character.setWalkDirection(walkDirection);
					GV.gameController.keyDown = true;
				}
				if (keyUp && character.onGround()) {
					character.jump();
				}
			}
		}
	}
}