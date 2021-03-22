package a3d_helper.examples
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Resource;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Capsule;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionComposite;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import alternativa.utils.templates.TextInfo;
	import a3d_helper.physics.Collision;
	import a3d_helper.physics.Effects;
	import a3d_helper.physics.Physics3D;
	import a3d_helper.templates.SceneTemplate;
	import flash.events.KeyboardEvent;
	import flash.ui.Keyboard;
	
	public class BlastEffectExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -300, 75);
			cameraController.lookAtXYZ(0, 0, 0);
			cameraController.speed = 50;
			cameraController.unbindKey(Keyboard.UP);
			cameraController.unbindKey(Keyboard.DOWN);
			cameraController.unbindKey(Keyboard.LEFT);
			cameraController.unbindKey(Keyboard.RIGHT);
			cameraController.enable();
			
			ambientLight.intensity = 0.2;
			omniLight.x = 0;
			omniLight.y = 200;
			omniLight.z = 1000;
			omniLight.intensity = 0.8;
			rootContainer.addChild(ambientLight);
			rootContainer.addChild(omniLight);
			
			var walls:Physics3D = new Physics3D();
			
			var transform:Matrix4 = new Matrix4();
			transform.setPositionXYZ(0, 0, -375);
			addWall();
			transform.setPositionXYZ(0, 0, 375);
			addWall();
			transform.setPositionXYZ(0, -375, 0);
			transform.setRotationMatrix(Math.PI / 2, 0, 0);
			addWall();
			transform.setPositionXYZ(0, 375, 0);
			addWall();
			transform.setPositionXYZ(-375, 0, 0);
			transform.setRotationMatrix(0, Math.PI / 2, 0);
			addWall();
			transform.setPositionXYZ(375, 0, 0);
			addWall();
			transform = new Matrix4();
			
			function addWall():void
			{
				walls.addPrimitive(
					new PhysicsPrimitive(Collision.Rect(750, 750, CollisionType.STATIC), 1, PhysicsMaterial.defaultMaterial)
					, transform
					, MeshUtils.createRectangle(750, 750, new VertexLightMaterial(0x777777))
				);
			}
			
			walls.body.movable = false;
			addPhysics3D(walls);
			
			var filter:GravityFilter = new GravityFilter();
			var filterMaterial:VertexLightMaterial = new VertexLightMaterial(0xffffff);
			for each (var r:Resource in filterMaterial.getResources())
				r.upload(stage3d.context3D);
			var primitives:Vector.<Physics3D> = new Vector.<Physics3D>();
			for (var b:int = -90; b <= 90; b += 15)
			{
				for (var a:int = -90; a <= 90; a += 15)
				{
					var primitive:Physics3D = new Physics3D();
					var tmp0:int = fRandomFT(0, 5);
					var tmp1:int = fRandomFT(0, 2);
					var tmp2:int = fRandomFT(4, 6);
					var tmp3:int = fRandomFT(2, 3);
					var tmp4:int = fRandomFT(4, 8);
					var tmp5:int = fRandomFT(4, 6);
					var tmp6:int = fRandomFT(4, 6);
					var tmp7:int = fRandomFT(0, 1);
					var tmp8:int = -1;
					
					var com3d:Object3D = new Object3D();
					var com:PhysicsPrimitive;
					
					if (tmp0 == 0)
						primitive.addPrimitive(
							new PhysicsPrimitive(Collision.Box(tmp2, tmp5, tmp6, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createBox(new Vector3(tmp2, tmp5, tmp6), new VertexLightMaterial(0xffffff * Math.random()))
						);
					if (tmp0 == 1)
						primitive.addPrimitive(
							new PhysicsPrimitive(Collision.Cylinder(tmp3, tmp4, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createCylinder(tmp3, tmp4, new VertexLightMaterial(0xffffff * Math.random()))
						);
					if (tmp0 == 2)
						primitive.addPrimitive(
							new PhysicsPrimitive(Collision.Cone(tmp1, tmp2, tmp4, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createConicFrustum(tmp1, tmp2, tmp4, new VertexLightMaterial(0xffffff * Math.random()))
						);
					if (tmp0 == 3)
						primitive.addPrimitive(
							new PhysicsPrimitive(Collision.Ball(tmp3, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createSphere(tmp3, new VertexLightMaterial(0xffffff * Math.random()), fRandomFT(3, 4))
						);
					if (tmp0 == 4)
					{
						primitive.addPrimitive(
							new PhysicsPrimitive(Collision.CapsularComposite(tmp3, tmp4, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createMesh3dFromGeometryMesh(MeshUtils.createGeometryMeshFromMesh3d(new Capsule(tmp3, tmp4, 16, 12, false)), new VertexLightMaterial(0xffffff * Math.random()))
						);
					}
					if (tmp0 == 5)
					{
						com3d = new Object3D();
						com = new PhysicsPrimitive(Collision.Composite(new <CollisionPrimitive>[
							Collision.Ball(2, CollisionType.DYNAMIC),
							Collision.Cylinder(.5, 12, CollisionType.DYNAMIC),
							Collision.Cylinder(.5, 9, CollisionType.DYNAMIC),
							Collision.Box(4, 4, 4, CollisionType.DYNAMIC),
							Collision.Box(4, 4, 4, CollisionType.DYNAMIC),
							Collision.Cone(.5, 5, 2, CollisionType.DYNAMIC),
							Collision.Cone(.5, 5, 2, CollisionType.DYNAMIC)
						], CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial);
						
						com3d.addChild(MeshUtils.createSphere(2, new VertexLightMaterial(0xffffff * Math.random()), fRandomFT(3, 4)));
						com3d.addChild(MeshUtils.createCylinder(.5, 12, new VertexLightMaterial(0xffffff * Math.random())));
						com3d.addChild(MeshUtils.createCylinder(.5, 9, new VertexLightMaterial(0xffffff * Math.random())));
						com3d.addChild(MeshUtils.createBox(new Vector3(4, 4, 4), new VertexLightMaterial(0xffffff * Math.random())));
						com3d.addChild(MeshUtils.createBox(new Vector3(4, 4, 4), new VertexLightMaterial(0xffffff * Math.random())));
						com3d.addChild(MeshUtils.createConicFrustum(.5, 5, 2, new VertexLightMaterial(0xffffff * Math.random())));
						com3d.addChild(MeshUtils.createConicFrustum(.5, 5, 2, new VertexLightMaterial(0xffffff * Math.random())));
						
						TRANSFORM();
						TRANSFORM();
						if (tmp7) transform.setRotationMatrix(Math.PI / 2, 0, 0);
						else transform.setRotationMatrix(0, Math.PI / 2, 0);
						TRANSFORM();
						transform.setPositionXYZ(0, 0, 6);
						TRANSFORM();
						transform.setPositionXYZ(0, 0, -6);
						TRANSFORM();
						if (tmp7)
						{
							transform.setRotationMatrix(Math.PI / 2, 0, 0);
							transform.setPositionXYZ(0, 4.5+2, 0);
						} else {
							transform.setRotationMatrix(0, Math.PI / 2, Math.PI);
							transform.setPositionXYZ(4.5+2, 0, 0);
						}
						TRANSFORM();
						if (tmp7)
						{
							transform.setRotationMatrix(Math.PI / 2, 0, Math.PI);
							transform.setPositionXYZ(0, -4.5-2, 0);
						} else {
							transform.setRotationMatrix(0, Math.PI / 2, 0);
							transform.setPositionXYZ(-4.5-2, 0, 0);
						}
						TRANSFORM();
						
						primitive.addPrimitive(
							com
							, null
							, com3d
						);
					}
					
					function TRANSFORM():void
					{
						CollisionComposite(com.getCollisionPrimitive()).primitives[++tmp8].localTransform = transform.clone();
						transform = new Matrix4();
					}
					
					primitive.body.setPositionXYZ(a, b, 0);
					primitive.body.useGravity = false;
					if (Math.abs(a) == Math.abs(b) || a == 0 || b == 0)
					{
						if (primitive.graphics.getChildAt(0) is Mesh) Mesh(primitive.graphics.getChildAt(0)).setMaterialToAllSurfaces(filterMaterial);
						else for (var i:int = 0; i < primitive.graphics.getChildAt(0).numChildren; i++)
							Mesh(primitive.graphics.getChildAt(0).getChildAt(i)).setMaterialToAllSurfaces(filterMaterial);
						filter.bodies.push(primitive.body);
					}
					addPhysics3D(primitive);
					primitives.push(primitive);
				}
			}
			
			var textInfo:TextInfo = new TextInfo();
			textInfo.write("Press SPACE for run the effect.");
			textInfo.write("Press ENTER for change the effect mode.");
			addChild(textInfo);
			
			var k:int = 2500;
			stage.addEventListener(KeyboardEvent.KEY_DOWN, function(e:KeyboardEvent):void
			{
				if (e.keyCode == Keyboard.SPACE) Effects.Blast(physicsScene.bodies, Vector3.ZERO, k, null, filter);
				if (e.keyCode == Keyboard.ENTER) k *= (k > 0 ? -2 : -.5);
			});
			
			function fRandomFT(a:int, b:int):int
			{
				return (a + Math.floor((Math.random() * (b - a + 1))));
			}
		}
	}
}

import alternativa.physicsengine.physics.types.Body;
import a3d_helper.physics.IBodyFilter;

class GravityFilter implements IBodyFilter
{
	public var bodies:Vector.<Body> = new Vector.<Body>();
	
	function GravityFilter() {}
	
	public function acceptBody(body:Body):Boolean
	{
		var b:Boolean = true;
		for (var i:int = 0; i < bodies.length; i++)
			if (bodies[i] == body) b = false;
		return b;
	}
}
