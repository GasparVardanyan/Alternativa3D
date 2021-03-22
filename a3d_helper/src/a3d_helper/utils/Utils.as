package a3d_helper.utils
{
	import alternativa.engine3d.core.Object3D;
	import alternativa.physicsengine.events.ContactEvent;
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionComposite;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.types.Body;
	import a3d_helper.physics.Physics3D;
	
	public class Utils
	{
		public static function setTransformToObject3D(object:Object3D, transform:Matrix4):void
		{
			object.matrix = transform.createMatrix3D();
		}
		
		public static function getContactedBody(e:ContactEvent):Body
		{
			if (e.contact.body1 == e.target)
				return e.contact.body2;
			return e.contact.body1;
		}
		
		public static function getPhysics3D(_body:Body):Physics3D
		{
			if (_body.data) return _body.data.physics3d;
			return null;
		}
		
		public static function setPhysics3D(_body:Body, _physics3d:Physics3D):void
		{
			_physics3d.body = _body;
			if (_body.data) _body.data.physics3d = _physics3d;
			else _body.data = {physics3d: _physics3d};
		}
		
		public static function getTransformForce(from:Vector3, to:Vector3, k:Number):Vector3
		{
			return to.clone().subtract(from).normalize().scale(k);
		}
		
		public static function getBlastForce(blastPos:Vector3, bodyPos:Vector3, k:Number):Vector3
		{
			return bodyPos.clone().subtract(blastPos).scale(k/bodyPos.clone().subtract(blastPos).lengthSqr());
		}
	}
}
