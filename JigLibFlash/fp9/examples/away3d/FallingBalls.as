package {
	import away3d.containers.View3D;
	import away3d.materials.WireframeMaterial;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.away3d.Away3DPhysics;
	import jiglib.plugin.away3d.Away3dMesh;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;		

	/**
	 * @author bartekd
	 */
	public class FallingBalls extends Sprite {
		
		private var view:View3D;
		private var physics:Away3DPhysics;

		public function FallingBalls() {
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;
			addEventListener(Event.ADDED_TO_STAGE, init);
		}

		public function init(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			view = new View3D();
			view.x = stage.stageWidth / 2;
			view.y = stage.stageHeight / 2;
			addChild(view);
			
			physics = new Away3DPhysics(view, 1);

			for (var i:int = 0; i < 40; i++) {
				var sphere:RigidBody = physics.createSphere({radius:30, segmentsW:6, segmentsH:6});
				sphere.x = 100 - Math.random() * 200;
				sphere.y = 700 + Math.random() * 3000;
				sphere.z = 200 - Math.random() * 100;
				// sphere.rotationX, Y & Z coming soon!
				sphere.material.restitution = 2; 
				
				// This is how to access the engine specific mesh/do3d
				physics.getMesh(sphere).material = new WireframeMaterial(0xffffff);
			}
			
			var north:RigidBody = physics.createCube({width:1800, height:1800, depth:500});
			north.z = 850;
			north.y = 700;
			north.movable = false;
			Away3dMesh(north.skin).mesh.material = new WireframeMaterial(); 
			
			var south:RigidBody = physics.createCube({width:1800, height:1800, depth:500});
			south.z = -850;
			south.y = 700;
			south.movable = false;
			
			var west:RigidBody = physics.createCube({width:500, height:1800, depth:1800});
			west.x = -850;
			west.y = 700;
			west.movable = false;
			
			var east:RigidBody = physics.createCube({width:500, height:1800, depth:1800});
			east.x = 850;
			east.y = 700;
			east.movable = false;

			var ground:RigidBody = physics.createGround({width:1800, height:1800}, -200);
			Away3dMesh(ground.skin).mesh.material = new WireframeMaterial();
			
			view.camera.z = 3000;

			addEventListener(Event.ENTER_FRAME, render);
		}

		private function render(event:Event):void {
			physics.step();
			view.render();
		}
	}
}
