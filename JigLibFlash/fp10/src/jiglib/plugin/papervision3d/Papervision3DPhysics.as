package jiglib.plugin.papervision3d {
	import flash.display.BitmapData;
	
	import jiglib.geometry.JBox;
	import jiglib.geometry.JPlane;
	import jiglib.geometry.JSphere;
	import jiglib.geometry.JTerrain;
	import jiglib.math.JMatrix3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.AbstractPhysics;
	import jiglib.plugin.papervision3d.pv3dTerrain;
	
	import org.papervision3d.core.proto.DisplayObjectContainer3D;
	import org.papervision3d.core.proto.MaterialObject3D;
	import org.papervision3d.materials.utils.MaterialsList;
	import org.papervision3d.objects.DisplayObject3D;
	import org.papervision3d.objects.primitives.Cube;
	import org.papervision3d.objects.primitives.Plane;
	import org.papervision3d.objects.primitives.Sphere;		

	public class Papervision3DPhysics extends AbstractPhysics {

		private var scene:DisplayObjectContainer3D;

		public function Papervision3DPhysics(scene:DisplayObjectContainer3D, speed:Number = 1) {
			super(speed);
			this.scene = scene;
		}
		
		public function getMesh(body:RigidBody):DisplayObject3D {
			if(body.skin!=null){
				return Pv3dMesh(body.skin).mesh;
			}else {
				return null;
			}
		}

		public function createSphere(material:MaterialObject3D, radius:Number=100, segmentsW:int=8, segmentsH:int = 6):RigidBody {
			var sphere:Sphere = new Sphere(material, radius, segmentsW, segmentsH);
			scene.addChild(sphere);
			var jsphere:JSphere = new JSphere(new Pv3dMesh(sphere), radius);
			addBody(jsphere);
			return jsphere;
		}
		
		public function createCube(materials:MaterialsList, width:Number=500, depth:Number=500, height:Number=500, segmentsS:int=1, segmentsT:int=1, segmentsH:int=1, insideFaces:int=0, excludeFaces:int=0):RigidBody {
			var cube:Cube = new Cube(materials, width, depth, height, segmentsS, segmentsT, segmentsH, insideFaces, excludeFaces);
			scene.addChild(cube);
			var jbox:JBox = new JBox(new Pv3dMesh(cube), width, depth, height);
			addBody(jbox);
			return jbox;
		}
		
		public function createGround(material:MaterialObject3D, size:Number, level:Number):RigidBody {
			var ground:Plane = new Plane(material, size, size);
			scene.addChild(ground);
			
			var jGround:JPlane = new JPlane(new Pv3dMesh(ground));
			jGround.setOrientation(JMatrix3D.getRotationMatrixAxis(90));
			jGround.y = level;
			addBody(jGround);
			return jGround;
		}
		
		public function createTerrain(terrainHeightMap:BitmapData, material:MaterialObject3D = null, width:Number = 100, depth:Number = 100, maxHeight:Number = 0, segmentsW:int = 1, segmentsH:int = 1):JTerrain {
			var terrainMap:pv3dTerrain = new pv3dTerrain(terrainHeightMap, material, width, depth, maxHeight, segmentsW, segmentsH);
			scene.addChild(terrainMap);
			
			var terrain:JTerrain = new JTerrain(terrainMap);
			addBody(terrain);
			
			return terrain;
		}
	}
}
