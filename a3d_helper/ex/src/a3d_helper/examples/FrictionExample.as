package a3d_helper.examples
{
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.primitives.Box;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import a3d_helper.physics.Collision;
	import a3d_helper.physics.Physics3D;
	import a3d_helper.templates.SceneTemplate;
	import a3d_helper.utils.Utils;
	import flash.ui.Keyboard;
	
	public class FrictionExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -80, 40);
			cameraController.lookAtXYZ(0, 0, 0);
			cameraController.speed = 15;
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
			
			var rotY:int = 45;
			
			var transform:Matrix4 = new Matrix4();
			transform.setRotationMatrix(0, rotY*Math.PI/180, 0);
			
			var plane:Physics3D = new Physics3D();
			plane.addPrimitive(
				new PhysicsPrimitive(Collision.Rect(50, 110, CollisionType.STATIC), 1, new PhysicsMaterial(.5, 0))
				, transform
				, MeshUtils.createRectangle(50, 110, new VertexLightMaterial(0x777777))
			);
			plane.body.movable = false;
			addPhysics3D(plane);
			
			var boxes:Vector.<Physics3D> = new Vector.<Physics3D>();
			
			var f:int = 0;
			for (var y:int = -50; y <= 50; y += 10)
			{
				var relPos:Vector3 = new Vector3(-25+1, y, 1);
				var worldPos:Vector3 = new Vector3();
				transform.transformPoint(relPos, worldPos);
				
				var box:Physics3D = new Physics3D();
				box.addPrimitive(
					new PhysicsPrimitive(Collision.Box(2, 2, 2, CollisionType.DYNAMIC), 1, new PhysicsMaterial(0, (f++)/10))
					, transform
					, MeshUtils.createBox(new Vector3(2, 2, 2), new VertexLightMaterial(0x77AA77))
				);
				box.body.setPosition(worldPos);
				addPhysics3D(box);
				boxes.push(box);
			}
		}
	}
}
