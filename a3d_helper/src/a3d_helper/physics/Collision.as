package a3d_helper.physics
{
	import alternativa.physicsengine.geometry.GeometryFace;
	import alternativa.physicsengine.geometry.GeometryMesh;
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.geometry.collision.CollisionType;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionBall;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionBox;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionComposite;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionCone;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionCylinder;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionPolyhedron;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionRect;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionTriangle;
	import alternativa.physicsengine.geometry.collision.primitives.CollisionTriangleMesh;
	import alternativa.physicsengine.math.Matrix4;
	import alternativa.physicsengine.math.Vector3;
	
	public class Collision
	{
		public static function Ball(radius:Number, collisionType:CollisionType):CollisionBall
		{ return new CollisionBall(radius, collisionType); }
		public static function Box(width:Number, length:Number, height:Number, collisionType:CollisionType):CollisionBox
		{ return new CollisionBox(new Vector3(width / 2, length / 2, height / 2), collisionType); }
		public static function CapsularComposite(radius:Number, height:Number, collisionType:CollisionType):CollisionComposite
		{
			var com:CollisionComposite = Composite(new <CollisionPrimitive>[
				Ball(radius, CollisionType.DYNAMIC),
				Cylinder(radius, height, CollisionType.DYNAMIC),
				Ball(radius, CollisionType.DYNAMIC)
			], collisionType);
			com.primitives[0].localTransform = new Matrix4();
			com.primitives[0].localTransform.setPositionXYZ(0, 0, height/2);
			com.primitives[2].localTransform = new Matrix4();
			com.primitives[2].localTransform.setPositionXYZ(0, 0, height/-2);
			return com;
		}
		public static function Composite(primitives:Vector.<CollisionPrimitive>, collisionType:CollisionType):CollisionComposite
		{ return new CollisionComposite(primitives, collisionType); }
		public static function Cone(smallRadius:Number, bigRadius:Number, height:Number, collisionType:CollisionType):CollisionCone
		{ return new CollisionCone(smallRadius, bigRadius, height, collisionType); }
		public static function Cylinder(radius:Number, height:Number, collisionType:CollisionType):CollisionCylinder
		{ return new CollisionCylinder(radius, height, collisionType); }
		public static function Polyhedron(mesh:GeometryMesh, collisionType:CollisionType):CollisionPolyhedron
		{ return new CollisionPolyhedron(mesh, collisionType); }
		public static function Rect(width:Number, height:Number, collisionType:CollisionType):CollisionRect
		{ return new CollisionRect(width, height, collisionType); }
		public static function Triangle(v1:Vector3, v2:Vector3, v3:Vector3, collisionType:CollisionType, face:GeometryFace=null):CollisionTriangle
		{ return new CollisionTriangle(v1, v2, v3, collisionType, face); }
		public static function TriangleMesh(_mesh:GeometryMesh, collisionType:CollisionType):CollisionTriangleMesh
		{ return new CollisionTriangleMesh(_mesh, collisionType); }
	}
}
