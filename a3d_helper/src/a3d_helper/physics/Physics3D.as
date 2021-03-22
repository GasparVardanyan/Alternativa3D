package a3d_helper.physics
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionComposite;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionTriangleMesh;
	import alternativa.physicsengine.math.Matrix3;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.PhysicsScene;
	import alternativa.physicsengine.physics.types.Body;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	import a3d_helper.utils.Utils;
	
	public dynamic class Physics3D
	{
		public var body:Body;
		public var graphics:Object3D = new Object3D();
		
		public function Physics3D(invMass:Number = 0, invInertia:Matrix3 = null)
		{
			body = new Body(invMass, invInertia);
			body.data = {physics3d: this};
		}
		
		public function addPrimitive(physicsPrimitive:PhysicsPrimitive = null, localTransform:Matrix4 = null, object3d:Object3D = null):void
		{
			if (physicsPrimitive)
			{
				body.addPhysicsPrimitive(physicsPrimitive, localTransform);
				if ((physicsPrimitive.getCollisionPrimitive() is CollisionComposite) && localTransform)
					setCompositeLocalTransform(physicsPrimitive.getCollisionPrimitive() as CollisionComposite, localTransform);
			}
			if (object3d) graphics.addChild(object3d);
		}
		
		public function removePrimitiveAt(index:int):void
		{
			if (body.primitives.length > index)
				body.removePhysicsPrimitive(body.primitives[index] as PhysicsPrimitive);
			if (graphics.numChildren > index)
				graphics.removeChildAt(index);
		}
		
		public function setBody(_body:Body, saveData:int = 0):void
		{
			var data:Object = {};
			if (saveData == 1) data = body.data;
			if (saveData == 2) data = _body.data;
			_body.data = data;
			Utils.setPhysics3D(_body, this);
		}
		
		public function upload(physicsScene:PhysicsScene = null, scene3d:Object3D = null):void
		{
			if (physicsScene && body.scene != physicsScene) physicsScene.add(body);
			if (scene3d && !scene3d.contains(graphics)) scene3d.addChild(graphics);
		}
		
		public function remove():void
		{
			if (body.scene) body.scene.remove(body);
			if (graphics.parent) graphics.parent.removeChild(graphics);
		}
		
		public function update():void
		{
			for (var i:int = 0; i < graphics.numChildren; i++)
				if (body.primitives.length > i && body.primitives[i].getCollisionPrimitive().transform)
				{
					var primTransform:Matrix4 = body.primitives[i].getCollisionPrimitive().transform.clone();
					if (body.primitives[i].getCollisionPrimitive() is CollisionComposite)
					{
						for each (var clt:Object in compositeLocalTransforms)
							if (CollisionComposite(body.primitives[i].getCollisionPrimitive()) == clt.composite && clt.localTransform != null)
							{
								var primTransformPos:Vector3 = new Vector3();
								var primTransformAng:Vector3 = new Vector3();
								primTransform.getPosition(primTransformPos);
								primTransform.getEulerAngles(primTransformAng);
								var cltTransformPos:Vector3 = new Vector3();
								var cltTransformAng:Vector3 = new Vector3();
								clt.localTransform.getPosition(cltTransformPos);
								clt.localTransform.getEulerAngles(cltTransformAng);
								primTransformPos.add(cltTransformPos);
								primTransformAng.add(cltTransformAng);
								primTransform.setPosition(primTransformPos);
								primTransform.setRotationMatrix(primTransformAng.x, primTransformAng.y, primTransformAng.z);
								break;
							}
						if (!(body.primitives[i].getCollisionPrimitive() is CollisionTriangleMesh))
						{
							for (var j:int = 0; j < graphics.getChildAt(i).numChildren; j++)
								if (CollisionComposite(body.primitives[i].getCollisionPrimitive()).primitives.length > j && CollisionComposite(body.primitives[i].getCollisionPrimitive()).primitives[j].localTransform)
									Utils.setTransformToObject3D(graphics.getChildAt(i).getChildAt(j), CollisionComposite(body.primitives[i].getCollisionPrimitive()).primitives[j].localTransform);
						}
					}
					Utils.setTransformToObject3D(graphics.getChildAt(i), primTransform);
				}
				else Utils.setTransformToObject3D(graphics.getChildAt(i), body.transform);
		}
		
		
		
		private static var compositeLocalTransforms:Vector.<Object> = new Vector.<Object>();
		
		public static function setCompositeLocalTransform(composite:CollisionComposite, localTransform:Matrix4):void
		{
			var haveItsComposite:Boolean;
			for (var i:int = 0; i < compositeLocalTransforms.length; i++)
			{
				if (composite == compositeLocalTransforms[i].composite)
				{
					haveItsComposite = true;
					if (localTransform == null) compositeLocalTransforms.splice(i, 1);
					else compositeLocalTransforms[i].localTransform = localTransform;
					break;
				}
			}
			if (!haveItsComposite)
			{
				compositeLocalTransforms.push({"composite":composite, "localTransform":localTransform});
			}
		}
	}
}
