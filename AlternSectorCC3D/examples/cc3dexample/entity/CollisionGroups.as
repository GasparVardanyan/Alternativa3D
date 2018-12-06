package cc3dexample.entity 
{
	import alternsector.physics.adaptors.alternativa3d.ccd.CollisionTable;
	import cc3dexample.entity.collisions.*;

	import cc3dexample.entity.collisions.BallToBall;
	/**
	 * Example collision groups setup for specific applications.
	 * @author Glenn Ko
	 */
	public class CollisionGroups
	{
		//eg. buffer in 16 BallToWorld collision pairs
		public const BALL:int = CollisionTable._instance.getNewCollisionGroupId(BallToWorld, 16);
		
		// (Not yet available)
		//public const PLAYER:int = CollisionTable._instance.getNewCollisionGroupId(PlayerToWorld);
		//public const PROJECTILES:int = CollisionTable._instance.getNewCollisionGroupId(ProjectileToWorld);
		
		public function CollisionGroups() {
			
			// Setup table and filtering
			var table:CollisionTable = CollisionTable._instance;
		
			 // eg. buffer in 8 BallToBall collision pairs
			table.registerCollisionPair(BALL, BALL, BallToBall);
			table.getPool(BALL, BALL).allocate(8); 
			
			// (Not yet available)
			//table.registerCollisionPair(PLAYER, BALL, PlayerToBall);
			//table.registerCollisionPair(PLAYER, PROJECTILES, PlayerToProjectile);
			//table.setFilterMask(PROJECTILES,  PLAYER);
			
			// Finalize table
			table.finalize();
		}
	}

}