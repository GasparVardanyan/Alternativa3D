package
{
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import jiglib.physics.RigidBody;
	import jiglib.plugin.papervision3d.Papervision3DPhysics;
	import jiglib.plugin.papervision3d.constraint.MouseConstraint;
	
	import org.papervision3d.cameras.CameraType;
	import org.papervision3d.core.math.Number3D;
	import org.papervision3d.events.InteractiveScene3DEvent;
	import org.papervision3d.lights.PointLight3D;
	import org.papervision3d.materials.WireframeMaterial;
	import org.papervision3d.materials.shadematerials.FlatShadeMaterial;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.view.BasicView;
	import org.papervision3d.view.layer.ViewportLayer;
	import org.papervision3d.view.layer.util.ViewportLayerSortMode;
	
	/**
	 * Dragging objects in 3D using MouseConstrait 
	 * @author Reynaldo a.k.a. reyco1
	 * 
	 */	
	[SWF(width="900", height="700", backgroundColor="#000000", frameRate="60")]
	public class MouseConstraintTest extends BasicView
	{
		private var physics:Papervision3DPhysics;		
		private var sceneLight:PointLight3D;
		private var mouseConstraint:MouseConstraint;
		private var vplObjects:ViewportLayer;
		
		public function MouseConstraintTest()
		{
			
			super(stage.stageWidth, stage.stageHeight, true, true, CameraType.TARGET);
			
			physics = new Papervision3DPhysics(scene, 8);
						
			setupVPLayer();
			setupLighting();
			createFloor();
			setCamera();
			createBoxes();		
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
			sceneLight.x = 0;
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
		
		private function createBoxes():void
		{
			var randomBox:RigidBody;
			var material:MaterialsList = new MaterialsList();
			var flatShadedMaterial:FlatShadeMaterial = new FlatShadeMaterial(sceneLight, 0x77ee77);
			flatShadedMaterial.interactive = true;
			material.addMaterial(flatShadedMaterial, "all");
			
			for(var a:Number = 0; a<10; a++)
			{
				randomBox = physics.createCube(material, 100, 100, 100);
				randomBox.y = a * 100 + 75;
				randomBox.x = ((a * 150) + 150) - 750;
				randomBox.mass = 2;
				physics.getMesh(randomBox).addEventListener(InteractiveScene3DEvent.OBJECT_PRESS, handleMousePress);
				vplObjects.addDisplayObject3D(physics.getMesh(randomBox));	
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