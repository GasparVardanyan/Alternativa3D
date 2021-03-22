package a3d_helper.examples
{
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.primitives.Box;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import a3d_helper.physics.Collision;
	import a3d_helper.physics.Physics3D;
	import a3d_helper.templates.SceneTemplate;
	import flash.ui.Keyboard;
	
	public class RestitutionExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -40, 20);
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
			
			var plane:Physics3D = new Physics3D();
			plane.addPrimitive(
				new PhysicsPrimitive(Collision.Rect(60, 10, CollisionType.STATIC), 1, new PhysicsMaterial(1))
				, null
				, MeshUtils.createRectangle(60, 10, new VertexLightMaterial(0x777777))
			);
			plane.body.movable = false;
			addPhysics3D(plane);
			
			var balls:Vector.<Physics3D> = new Vector.<Physics3D>();
			
			var r:int = 0;
			for (var x:int = -25; x <= 25; x += 5)
			{
				var ball:Physics3D = new Physics3D();
				ball.addPrimitive(
					new PhysicsPrimitive(Collision.Ball(2, CollisionType.DYNAMIC), 1, new PhysicsMaterial((r++)/10))
					, null
					, MeshUtils.createSphere(2, new VertexLightMaterial(0x77AA77))
				);
				ball.body.setPositionXYZ(x, 0, 1);
				ball.body.setVelocityXYZ(0, 0, 15);
				addPhysics3D(ball);
				balls.push(ball);
			}
		}
	}
}
