package cc3dexample.entity.collisions
{
	import alternativa.engine3d.core.EllipsoidCollider;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.RayIntersectionData;
	import alternativa.engine3d.materials.FillMaterial;
	import alternsector.physics.adaptors.alternativa3d.ccd.CC3DPair;
	import alternsector.physics.adaptors.utils.Vector3DUtils;
	import flash.geom.Vector3D;
	
	/**
	 * Example:
	 * Original implementation: http://wonderfl.net/c/8RNL 
	 * generalrelativity's Elastic Collision
	 * 
	 * @author Glenn Ko
	 */
	public class BallToWorld extends CC3DPair
	{
		
		public function BallToWorld() 
		{
		
		}

		
		override public function resolve():void 
		{
			 var cn:Vector3D = c1.collisionNormal.clone();        
            
			//relative velocity
			var dv:Vector3D = new Vector3D(c1.vx, c1.vy, c1.vz);
			
			//perfectly elastic
			const mass:Number = 1;

			var impulse:Number = cn.dotProduct( Vector3DUtils.getNewScaledVector(dv,  -2 ) ) / ( 1 / mass );
			var scalar:Number =  impulse / mass;
			cn.scaleBy( scalar);
			dv.incrementBy( cn );
			c1.vx = dv.x;
			c1.vy = dv.y;
			c1.vz = dv.z;
		}
		
	}

}
