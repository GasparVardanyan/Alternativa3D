package jiglib.plugin.away3dlite
{
	import away3dlite.containers.Scene3D;
	import away3dlite.core.base.Mesh;
	import away3dlite.materials.Material;
	import away3dlite.primitives.Cube6;
	import away3dlite.primitives.Plane;
	import away3dlite.primitives.Sphere;
	
	import flash.geom.Vector3D;
	
	import jiglib.geometry.JBox;
	import jiglib.geometry.JPlane;
	import jiglib.geometry.JSphere;
	import jiglib.geometry.JTerrain;
	import jiglib.math.JNumber3D;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.AbstractPhysics;

	public class Away3DLitePhysics extends AbstractPhysics
	{
		private var _scene:Scene3D;

		public function Away3DLitePhysics(scene:Scene3D, speed:Number = 1)
		{
			super(speed);

			_scene = scene;

			engine.setGravity(JNumber3D.getScaleVector(Vector3D.Y_AXIS, 10));
		}

		public function getMesh(body:RigidBody):Mesh
		{
			return body.skin ? Away3DLiteMesh(body.skin).mesh as Mesh : null;
		}

		public function createSphere(material:Material, radius:Number = 100, segmentsW:int = 8, segmentsH:int = 6):RigidBody
		{
			var sphere:Sphere = new Sphere(material, radius, segmentsW, segmentsH);
			_scene.addChild(sphere);

			var jsphere:JSphere = new JSphere(new Away3DLiteMesh(sphere), radius);
			addBody(jsphere);
			return jsphere;
		}

		public function createCube(material:Material, width:Number = 100, depth:Number = 100, height:Number = 100):RigidBody
		{
			var cube:Cube6 = new Cube6(material, width, height, depth);
			_scene.addChild(cube);

			var jbox:JBox = new JBox(new Away3DLiteMesh(cube), width, depth, height);
			addBody(jbox);
			return jbox;
		}

		public function createGround(material:Material, size:Number, level:Number):RigidBody
		{
			var ground:Plane = new Plane(material, size, size, 1, 1);
			_scene.addChild(ground);

			var jGround:JPlane = new JPlane(new Away3DLiteMesh(ground), new Vector3D(0, -1, 0));
			jGround.y = level;
			addBody(jGround);

			jGround.moveTo(new Vector3D);

			return jGround;
		}

		public function createTerrain(heightMapData:HeightMapData, material:Material, width:Number = 100, depth:Number = 100, segmentsW:int = 10, segmentsH:int = 10):JTerrain
		{
			var terrainMap:Away3DLiteTerrain = new Away3DLiteTerrain(heightMapData, material, width, depth, segmentsW, segmentsH);
			_scene.addChild(terrainMap);

			var jTerrain:JTerrain = new JTerrain(terrainMap, false);
			addBody(jTerrain);
			
			return jTerrain;
		}
	}
}