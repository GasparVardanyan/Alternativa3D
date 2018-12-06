package 
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jiglib.cof.JConfig;
	import jiglib.math.JNumber3D;
	import jiglib.physics.RigidBody;
	import jiglib.physics.constraint.JConstraintPoint;
	import jiglib.plugin.papervision3d.Papervision3DPhysics;
	import jiglib.plugin.papervision3d.constraint.MouseConstraint;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	/**
	 * Constraints
	 * @author Reynaldo a.k.a. reyco1
	 * 
	 */
	[SWF(width="900", height="700", backgroundColor="#000000", frameRate="60")]
	public class Constraints extends BasicView
	{
		
		private var physics:Papervision3DPhysics;
		private var vplObjects:ViewportLayer;
		private var sceneLight:PointLight3D;
		private var mouseConstraint:MouseConstraint;
		
		public function Constraints()
		{
			super(stage.stageWidth, stage.stageHeight, true, true, CameraType.TARGET);
			
			JConfig.numContactIterations = 12;
			physics = new Papervision3DPhysics(scene, 8);
						
			setupVPLayer();
			setupLighting();
			createFloor();
			setCamera();
			createSpheres();		
			startRendering();
		}
		
		private function setupVPLayer():void
		{
			vplObjects = new ViewportLayer(viewport, null);
			vplObjects.layerIndex = 2;
			vplObjects.sortMode = ViewportLayerSortMode.Z_SORT;
			viewport.containerSprite.addLayer(vplObjects);
		}
		
		private function setupLighting():void
		{
			sceneLight = new PointLight3D(true, true); 
			sceneLight.x = -100;
			sceneLight.y = 400;
			sceneLight.z = -300;
		}
		
		private function createFloor():void
		{
			physics.createGround(new WireframeMaterial(0xFFFFFF, 0), 1800, 0);
			
			var floor:Plane = new Plane(new WireframeMaterial(0xFFFFFF), 10000, 10000, 10000*0.001, 10000*0.001);
            floor.rotationX = 90;
            floor.y = -200
            scene.addChild(floor);
		}
		
		private function setCamera():void
		{
			camera.y = 500
			camera.focus = 100;
			camera.zoom = 5;
		}
		
		private function createSpheres():void
		{
			var sphere:RigidBody;
			var prevSphere:RigidBody;
			
			for(var a:Number = 0; a<5; a++){
				var flatShadedMaterial:FlatShadeMaterial = new FlatShadeMaterial(sceneLight, 0xFF0000 * Math.random());
				flatShadedMaterial.interactive = true;
			 
				sphere = physics.createSphere(flatShadedMaterial, 100);
				vplObjects.addDisplayObject3D(physics.getMesh(sphere));
				physics.getMesh(sphere).addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				sphere.mass = 5;
				sphere.maxLinVelocities = 200;
				sphere.currentState.position = (a == 0) ? new JNumber3D(-500, 200, 0) : JNumber3D.add(prevSphere.currentState.position, new JNumber3D(200, 0, 0));
				
				if(a != 0){
					var pos1:JNumber3D = JNumber3D.multiply(JNumber3D.UP, -prevSphere.boundingSphere);
					var pos2:JNumber3D = JNumber3D.multiply(JNumber3D.UP, sphere.boundingSphere);
					var constraint:JConstraintPoint = new JConstraintPoint(prevSphere, pos1, sphere, pos2, 0, 0.1);
				}
				prevSphere = sphere;
			}
		}
		
		private function handleMousePress(event:InteractiveScene3DEvent):void
		{
			mouseConstraint = new MouseConstraint(event.displayObject3D, new Number3D(0, 0, 1), camera, viewport);
			stage.addEventListener(MouseEvent.MOUSE_UP, removeMouseConstraint);
		}
		
		private function removeMouseConstraint(e:MouseEvent):void
		{
			stage.removeEventListener(MouseEvent.MOUSE_UP, removeMouseConstraint);
			mouseConstraint.destroy();
			mouseConstraint = null;
		}
		
		override protected function onRenderTick(event:Event = null):void
		{
			physics.step();
			renderer.renderScene(scene, camera, viewport);
		}
	}
}
