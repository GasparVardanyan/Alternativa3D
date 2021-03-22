package a3d_helper.examples
{
	import alternativa.engine3d.core.events.MouseEvent3D;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.primitives.Box;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import a3d_helper.physics.Collision;
	import a3d_helper.physics.Effects;
	import a3d_helper.physics.Physics3D;
	import a3d_helper.templates.SceneTemplate;
	import flash.geom.Vector3D;
	import flash.ui.Keyboard;
	
	public class StressExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -20, 10);
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
			
			var transform:Matrix4 = new Matrix4();
			var walls:Physics3D = new Physics3D();
			var w:Number = 20, h:Number = 40;
			
			addWall();
			h /= 2;
			transform.setRotationMatrix(90*Math.PI/180, 0, 0);
			transform.setPositionXYZ(0, h, h/2);
			addWall();
			transform.setPositionXYZ(0, -h, h/2);
			addWall();
			h *= 2;
			transform.setRotationMatrix(0, 90*Math.PI/180, 0);
			transform.setPositionXYZ(w/2, 0, h/4);
			addWall();
			transform.setPositionXYZ(-w/2, 0, h/4);
			addWall();
			
			function addWall():void
			{
				walls.addPrimitive(
					new PhysicsPrimitive(Collision.Rect(w, h, CollisionType.STATIC), 1, PhysicsMaterial.defaultMaterial)
					, transform
					, MeshUtils.createRectangle(w, h, new VertexLightMaterial(0x777777))
				);
			}
			
			walls.body.movable = false;
			addPhysics3D(walls);
			
			var boxes:Vector.<Physics3D> = new Vector.<Physics3D>();
			for (var x:Number = -6.25; x < 6.25; x += 1.25)
			{
				for (var y:Number = -.75; y <= .75; y += 1.25)
				{
					for (var z:Number = .5; z <= 9.5; z++)
					{
						var box:Physics3D = new Physics3D();
						box.addPrimitive(
							new PhysicsPrimitive(Collision.Box(1, 1, 1, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
							, null
							, MeshUtils.createBox(new Vector3(1, 1, 1), new VertexLightMaterial(0xffffff*Math.random()))
						);
						box.body.setPositionXYZ(x+.625, y+.625, z);
						addPhysics3D(box);
						box.graphics.addEventListener(MouseEvent3D.CLICK, bullet);
						boxes.push(box);
					}
				}
			}
		}
		
		public function bullet(e:MouseEvent3D):void
		{
			var pos:Vector3 = new Vector3(camera.x, camera.y, camera.z);
			var mpos:Vector3 = new Vector3().copyFromVector3D(e.target.localToGlobal(new Vector3D(e.localX, e.localY, e.localZ)));
			
			var ball:Physics3D = new Physics3D();
			ball.addPrimitive(
				new PhysicsPrimitive(Collision.Ball(.2, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
				, null
				, MeshUtils.createSphere(.2, new VertexLightMaterial(0xffffff*Math.random()))
			);
			ball.body.setPosition(pos);
			ball.body.useGravity = false;
			ball.body.addEventListener(ContactEvent.OnContact, function(e:ContactEvent):void
			{
				e.target.useGravity = true;
			});
			Effects.TransformTo(ball.body, mpos, 750);
			addPhysics3D(ball);
		}
	}
}
