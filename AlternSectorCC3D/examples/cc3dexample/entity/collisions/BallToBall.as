package cc3dexample.entity.collisions 
{
	import alternsector.physics.adaptors.alternativa3d.ccd.CC3DPair;
	import flash.geom.Vector3D;
	/**
	 * Example: 
	 * Supports moving ellipsoid to ellipsoid collision detection and resolution.
	 * @author Glenn Ko
	 */
	public class BallToBall extends CC3DPair
	{
		
		public function BallToBall() 
		{
			
		}
		
		private var ellipsoid_radius:Vector3D = new Vector3D();
		private var ray_travel:Vector3D = new Vector3D();
		private var ray_origin:Vector3D = new Vector3D();
	//	/*
		override public function willCollide(dt:Number):Boolean {
			
			// This is a C1 ray hit test against....
			ray_origin.x = c1.object.x - c2.object.x;
			ray_origin.y = c1.object.y - c2.object.y;
			ray_origin.z = c1.object.z - c2.object.z;
			
			// ...inflated ellipsoid (sum of radii)
			ellipsoid_radius.x = c1.collider.radiusX + c2.collider.radiusX;
			ellipsoid_radius.y = c1.collider.radiusY + c2.collider.radiusY;
			ellipsoid_radius.z = c1.collider.radiusZ + c2.collider.radiusZ;
			
			// ...based on relative velocities of c1/c2.
			ray_travel.x = c1.vx - c2.vx;
			ray_travel.y = c1.vy - c2.vy;
			ray_travel.z = c1.vz - c2.vz;
		
			// Find "d" in normalized unit time. 
			// Quadratic formula (to consider: simplified to 1 solution: b^2-ac. instead)
			var a:Number = ((ray_travel.x*ray_travel.x)/(ellipsoid_radius.x*ellipsoid_radius.x))
					+ ((ray_travel.y*ray_travel.y)/(ellipsoid_radius.y*ellipsoid_radius.y))
					+ ((ray_travel.z*ray_travel.z)/(ellipsoid_radius.z*ellipsoid_radius.z));
				var b:Number = ((2*ray_origin.x*ray_travel.x)/(ellipsoid_radius.x*ellipsoid_radius.x))
						+ ((2*ray_origin.y*ray_travel.y)/(ellipsoid_radius.y*ellipsoid_radius.y))
						+ ((2*ray_origin.z*ray_travel.z)/(ellipsoid_radius.z*ellipsoid_radius.z));
				var c:Number = ((ray_origin.x*ray_origin.x)/(ellipsoid_radius.x*ellipsoid_radius.x))
						+ ((ray_origin.y*ray_origin.y)/(ellipsoid_radius.y*ellipsoid_radius.y))
						+ ((ray_origin.z*ray_origin.z)/(ellipsoid_radius.z*ellipsoid_radius.z))
						- 1;

				var d:Number = b*b-4*a*c;
				if ( d < 0 ) {  // no real roots
					return false;
				}
				
				d = Math.sqrt(d);
				
				const multiplier:Number = 1/(2*a);
				var hit:Number = (-b + d)*multiplier;
				var hitsecond:Number = (-b - d)*multiplier;
				d = hit < hitsecond ? hit : hitsecond;  // 2 solutions, bah...
				if (d < 0) {
					return false;
				}
				
				t = d * dt; 
				
				return t <= dt;   // collision happened within timeframe
		}
		//*/
		
		/**
		 * * Original implementations: http://wonderfl.net/c/8RNL 
		  * generalrelativity's Elastic Collision
		 */
		
		/*
		override public function willCollide(dt:Number):Boolean {
			const EPSILON:Number = 1e-4;
			//points from 1 -> 2
			var dx:Vector3D = new Vector3D(c2.object.x - c1.object.x, c2.object.y - c1.object.y, c2.object.z - c1.object.z);// .minus( p1.x );
			
			//if the circle's are already overlapped, return true (this brings the sim to a halt)
		
			var sumRadiiX:Number = c1.collider.radiusX + c2.collider.radiusX;

			c = (dx.x*dx.x + dx.y*dx.y + dx.z*dx.z) - sumRadiiX*sumRadiiX;
			if( c < 0 )
			{
				t = EPSILON;
				return true;
			}
			
			//relative velocity
			var dv:Vector3D = new Vector3D(c2.vx - c1.vx, c2.vy - c1.vy, c2.vz - c1.vz) ;// p2.v.minus( p1.v );
			
			var a:Number = dv.dotProduct( dv );
			if( a < EPSILON ) return false; //not moving enough toward each other to warrant a response
			
			var b:Number = dv.dotProduct( dx );
			if( b >= 0 ) return false; //moving apart
			
			var d:Number = b * b - a * c;
			if( d < 0 ) return false; //no intersection
			
			t = ( -b - Math.sqrt( d ) ) / a;
			
			//circle's collide if the time of collision is within the current time-step
			return t <= dt;
		}	
	*/
		
		override public function resolve():void {
			// halt total
			//c1.vx = 0; c1.vy = 0; c1.vz = 0
			//c2.vx = 0; c2.vy = 0; c2.vz = 0;
			//return;
			 
			var cn:Vector3D = c1.collisionNormal;
			cn.x = c2.object.x - c1.object.x;
			cn.y = c2.object.y - c1.object.y;
			cn.z = c2.object.z - c1.object.z;
			cn.normalize();
			//p2.x.minus( p1.x );

			//relative velocity
			var dv:Vector3D = new Vector3D(c2.vx - c1.vx, c2.vy - c1.vy, c2.vz - c1.vz); //  p2.v.minus( p1.v );
			
			const p2Mass:Number = 1;
			const p1Mass:Number = 1;
			//const mass:Number = 1;
			
			//perfectly elastic impulse
			dv.x *= -2; dv.y *= -2; dv.z *= -2;
			var cn2:Vector3D = cn.clone();
			cn2.scaleBy( 1 / p1Mass + 1 / p2Mass );
		
			var impulse:Number = cn.dotProduct( dv  ) / cn.dotProduct( cn2);
			var multiplier:Number = -impulse / p1Mass;
			c1.vx += cn.x * multiplier;
			c1.vy += cn.y  * multiplier;
			c1.vz += cn.z * multiplier;
			multiplier = impulse / p2Mass;
			c2.vx += cn.x * multiplier;
			c2.vy += cn.y  * multiplier;
			c2.vz += cn.z * multiplier;
			
		}
		
	}

}