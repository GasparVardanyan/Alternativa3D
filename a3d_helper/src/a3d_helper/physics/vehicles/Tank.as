package a3d_helper.physics.vehicles
{
	import alternativa.physicsengine.geometry.collision.CollisionPrimitive;
	import alternativa.physicsengine.geometry.collision.types.BoundBox;
	import alternativa.physicsengine.math.Matrix3;
	import alternativa.physicsengine.math.Vector3;
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	import alternativa.physicsengine.physics.types.Body;
	import alternativa.physicsengine.physics.types.PhysicsPrimitive;
	
	public class Tank
	{
		public var body:Body;
		public var hull:PhysicsPrimitive;
		public var hullSize:Vector3;
		
		public var leftTrack:Track;
		public var rightTrack:Track;
		
		public function Tank(invMass:Number = 0, invInertia:Matrix3 = null)
		{
			body = new Body(invMass, invInertia);
		}
		
		public function initHull(hull:PhysicsPrimitive, hullSize:Vector3, numRaysInTrack:uint = 5):void
		{
			for (var i:uint = 0; i < body.primitives.length; i++)
				if (PhysicsPrimitive(body.primitives[i]) == this.hull)
					body.removePhysicsPrimitive(body.primitives[i] as PhysicsPrimitive);
			this.hull = hull;
			body.addPhysicsPrimitive(hull);
			hull.getCollisionPrimitive().calculateAABB();
			//hullSize = new Vector3(hull.getCollisionPrimitive().aabb.getSizeX(), hull.getCollisionPrimitive().aabb.getSizeY(), hull.getCollisionPrimitive().aabb.getSizeZ());
			this.hullSize = hullSize;
			
			leftTrack = new Track(this, -1, numRaysInTrack);
			rightTrack = new Track(this, 1, numRaysInTrack);
		}
		
		public function moveWithKeyboard(kUp:Boolean, kDown:Boolean, kRight:Boolean, kLeft:Boolean, rayForce:Number):void
		{
			//var moveDir:int = (int(kUp)^int(kDown)?(kUp?1:-1):0);
			//var turnDir:int = (int(kRight)^int(kLeft)?(kRight?1:-1):0);
			
			var fRs:int, fLs:int;
			var m:Number = .3;
			if (int(kUp) ^ int(kDown))
			{
				if (kUp)
				{
					fLs = fRs = 1;
					if (int(kLeft) ^ int(kRight))
					{
						if (kLeft) fLs = m;
						else fRs = m;
					}
				} else {
					fLs = fRs = -1;
					if (int(kLeft) ^ int(kRight))
					{
						if (kLeft) fLs = -m;
						else fRs = -m;
					}
				}
			}
			else if (int(kRight) ^ int(kLeft))
			{
				if (kLeft) fLs = -1, fRs = 1;
				else fLs = 1, fRs = -1;
			}
			
			leftTrack.addForce(rayForce * fLs);
			rightTrack.addForce(rayForce * fRs);
		}
	}
}



import a3d_helper.physics.vehicles.Tank;

class Track
{
	public var tank:Tank;
	public var rays:Vector.<SuspensionRay> = new Vector.<SuspensionRay>();
	public var sideDirection:int;
	
	public function Track(tank:Tank, sideDirection:int, numRays:uint)
	{
		this.tank = tank;
		this.sideDirection = sideDirection;
		
		for (var i:uint = 0; i < numRays; i++)
			rays.push(new SuspensionRay(this));
	}
	
	public function addForce(force:Number):void
	{
		for each (var ray:SuspensionRay in rays)
			ray.addForce(force);
	}
}



import alternativa.physics3dintegration.utils.MeshUtils;
import alternativa.physicsengine.geometry.collision.CollisionType;
import alternativa.physicsengine.geometry.collision.types.BoundBox;
import alternativa.physicsengine.geometry.collision.types.RayHit;
import alternativa.physicsengine.math.Vector3;

class SuspensionRay
{
	public var track:Track;
	public var relPos:Vector3;
	public var relDir:Vector3;
	public var worldPos:Vector3 = new Vector3();
	public var worldDir:Vector3 = new Vector3();
	public var forceRelPos:Vector3;
	public var forceWorldPos:Vector3 = new Vector3();
	public var zPadding:Number;
	public var xPaddingScale:Number;
	public var lastCollided:Boolean;
	public var collisionMask:int = CollisionType.DYNAMIC.mask;
	public var maxTime:Number = .1;
	public var filter:RayPredicate;
	public var result:RayHit = new RayHit();
	
	public function SuspensionRay(track:Track)
	{
		this.track = track;
		filter = new RayPredicate(track.tank.body);
		zPadding = track.tank.hullSize.z / 10;
		xPaddingScale = .25;
		relPos = new Vector3(track.sideDirection * track.tank.hullSize.x * (1-xPaddingScale)/2, (track.tank.hullSize.y / (track.rays.length + 1)) * (track.rays.length + 1) - track.tank.hullSize.y / 2, -track.tank.hullSize.z / 2 + zPadding);
		forceRelPos = new Vector3(track.sideDirection * track.tank.hullSize.x * (1-xPaddingScale)/2, (track.tank.hullSize.y / (track.rays.length + 1)) * (track.rays.length + 1) - track.tank.hullSize.y / 2, -track.tank.hullSize.z / 2);
		relDir = Vector3.DOWN.clone();
	}
	
	public function calculateIntersection():Boolean
	{
		var worldPos:Vector3 = new Vector3();
		var worldDir:Vector3 = new Vector3();
		track.tank.body.transform.transformPoint(relPos, worldPos);
		track.tank.body.transform.transformVector(relDir, worldDir);
		return (lastCollided = track.tank.body.scene.raycast(worldPos, worldDir, collisionMask, maxTime+zPadding, filter, result));
	}
	
	public function addForce(force:Number):void
	{
		if (calculateIntersection())
		{
			track.tank.body.transform.transformPoint(forceRelPos, forceWorldPos);
			var forceRelDir:Vector3 = (force >= 0 ? Vector3.FORWARD.clone() : Vector3.BACK.clone());
			var forceVector:Vector3 = new Vector3();
			track.tank.body.transform.transformVector(forceRelDir, forceVector);
			forceVector.scale(Math.abs(force));
			track.tank.body.addWorldForceXYZ(
				forceWorldPos.x, forceWorldPos.y, forceWorldPos.z
				, forceVector.x, forceVector.y, forceVector.z
			);
		}
	}
}



import alternativa.physicsengine.geometry.collision.IRaycastFilter;
import alternativa.physicsengine.geometry.collision.types.RaycastData;
import alternativa.physicsengine.physics.types.Body;

class RayPredicate implements IRaycastFilter
{
	public var body:Body;
	
	public function RayPredicate(body:Body)
	{
		this.body = body;
	}
	
	public function acceptRayHit(data:RaycastData):Boolean
	{
		return (data.physicsPrimitive.body != body);
	}
}
