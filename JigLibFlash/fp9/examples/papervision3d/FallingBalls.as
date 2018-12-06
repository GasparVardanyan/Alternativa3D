package {
	import jiglib.geometry.JSphere;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.papervision3d.Papervision3DPhysics;
	import jiglib.plugin.papervision3d.Pv3dMesh;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Sphere;
	import org.papervision3d.view.BasicView;
	
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;	

	/**
	 * @author bartekd
	 */
	[SWF(width='900', height='700', backgroundColor='#404040', frameRate='50')]
	public class FallingBalls extends BasicView {

		private var physics:Papervision3DPhysics;

		public function FallingBalls() {
			stage.quality = StageQuality.LOW;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.showDefaultContextMenu = false;
			stage.stageFocusRect = false;

			super(800, 600, true, false, CameraType.TARGET);
			
			physics = new Papervision3DPhysics(scene, 10);
			
			for (var i:int = 0; i < 10; i++) {
//				var sphere:RigidBody = physics.createSphere(new WireframeMaterial(0xffffff), 30, 6, 6);
//				sphere.x = 100 - Math.random() * 200;
//				sphere.y = 700 + Math.random() * 3000;
//				sphere.z = 200 - Math.random() * 100;
				// sphere.rotationX, Y & Z coming soon!
//				sphere.material.restitution = 2; 
				
				// This is how to access the engine specific mesh/do3d
//				physics.getMesh(sphere).material = new WireframeMaterial(0xffffff);

				var ml:MaterialsList = new MaterialsList();
				ml.addMaterial(new WireframeMaterial(0xffffff), "all");
				
				var cube:RigidBody = physics.createCube(ml, 60, 60, 60);
				cube.x = 100 - Math.random() * 200;
				cube.y = 700 + Math.random() * 3000;
				cube.z = 200 - Math.random() * 100;
				cube.rotationY = Math.PI / 4;
				cube.rotationZ = Math.PI / 4;
				cube.material.restitution = 2; 
				physics.getMesh(cube).material = new WireframeMaterial(0xffffff);
			}
			
			// Here's how to create a sphere without the shortcut method:
			var manualSphere:Sphere = new Sphere(new WireframeMaterial(0xff0000), 30, 6, 6);
			scene.addChild(manualSphere);
			var jmanualSphere:RigidBody = new JSphere(new Pv3dMesh(manualSphere), 30);
			jmanualSphere.y = 700 + Math.random() * 3000;
			physics.addBody(jmanualSphere);
			// = more code, but this is necessary for custom objects (ex. Collada)
			
			var mb:MaterialsList = new MaterialsList();
			var w:WireframeMaterial = new WireframeMaterial(0x009900);
			mb.addMaterial(w, "all");
			
			var north:RigidBody = physics.createCube(mb, 1800, 50, 1800);
			north.z = 850;
			north.y = 700;
			north.movable = false;
			
			var south:RigidBody = physics.createCube(mb, 1800, 50, 1800);
			south.z = -850;
			south.y = 700;
			south.movable = false;
			
			var west:RigidBody = physics.createCube(mb, 50, 1800, 1800);
			west.x = -850;
			west.y = 700;
			west.movable = false;
			
			var east:RigidBody = physics.createCube(mb, 50, 1800, 1800);
			east.x = 850;
			east.y = 700;
			east.movable = false;

			physics.createGround(new WireframeMaterial(), 1800, -200);

			startRendering();
		}
		
		protected override function onRenderTick(event:Event = null):void {
			physics.step();
			super.onRenderTick(event);
		}
	}
}