package a3d_helper.examples
{
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.physics3dintegration.VertexLightMaterial;
	import alternativa.physics3dintegration.utils.MeshUtils;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import a3d_helper.physics.Collision;
	import a3d_helper.physics.Physics3D;
	import a3d_helper.templates.SceneTemplate;
	import a3d_helper.utils.Utils;
	import flash.display.BitmapData;
	import flash.ui.Keyboard;
	
	public class ContactExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -20, 7.5);
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
				new PhysicsPrimitive(Collision.Rect(10, 10, CollisionType.STATIC), 1, PhysicsMaterial.defaultMaterial)
				, null
				, MeshUtils.createRectangle(10, 10, new VertexLightMaterial(0x777777))
			);
			plane.body.setPositionXYZ(0, 0, -1.5);
			plane.body.movable = false;
			addPhysics3D(plane);
			
			var plane1:Physics3D = new Physics3D();
			plane1.addPrimitive(
				new PhysicsPrimitive(Collision.Rect(10, 10, CollisionType.STATIC), 1, PhysicsMaterial.defaultMaterial)
				, null
				, MeshUtils.createRectangle(10, 10, new VertexLightMaterial(0x777777))
			);
			plane1.body.setPositionXYZ(0, 0, 1.5);
			plane1.body.movable = false;
			addPhysics3D(plane1);
			plane1.name = "PlaneTrigger";
			
			var box:Physics3D = new Physics3D();
			box.addPrimitive(
				new PhysicsPrimitive(Collision.Box(2, 2, 2, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
				, null
				, MeshUtils.createBox(new Vector3(2, 2, 2), new VertexLightMaterial(0x77AA77))
			);
			box.body.setPositionXYZ(-3, 0, 5);
			box.body.setVelocityXYZ(0, 0, 10);
			addPhysics3D(box);
			
			var box1:Physics3D = new Physics3D();
			box1.addPrimitive(
				new PhysicsPrimitive(Collision.Box(2, 2, 2, CollisionType.DYNAMIC), 1, PhysicsMaterial.defaultMaterial)
				, null
				, MeshUtils.createBox(new Vector3(2, 2, 2), new VertexLightMaterial(0x77AA77))
			);
			box1.body.setPositionXYZ(3, 0, 5);
			box1.body.setVelocityXYZ(0, 0, 20);
			addPhysics3D(box1);
			
			box.body.addEventListener(ContactEvent.OnContact, function(e:ContactEvent):void
			{
				var contactedObject:Physics3D = Utils.getPhysics3D(Utils.getContactedBody(e));
				if (contactedObject)
				{
					var res:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xffffff * Math.random()))
					res.upload(stage3d.context3D);
					Mesh(contactedObject.graphics.getChildAt(0)).setMaterialToAllSurfaces(new VertexLightTextureMaterial(res));
				}
			});
			
			box1.body.addEventListener(ContactEvent.OnContact, function(e:ContactEvent):void
			{
				var contactedObject:Physics3D = Utils.getPhysics3D(Utils.getContactedBody(e));
				if (contactedObject)
				{
					if (contactedObject.name == "PlaneTrigger") e.cancel = true;
					else {
						var res:BitmapTextureResource = new BitmapTextureResource(new BitmapData(1, 1, false, 0xffffff * Math.random()))
						res.upload(stage3d.context3D);
						Mesh(contactedObject.graphics.getChildAt(0)).setMaterialToAllSurfaces(new VertexLightTextureMaterial(res));
					}
				}
			});
		}
	}
}
