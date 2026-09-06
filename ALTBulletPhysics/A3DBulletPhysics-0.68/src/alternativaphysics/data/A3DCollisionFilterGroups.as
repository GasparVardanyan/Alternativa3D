package alternativaphysics.data {

	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DCollisionFilterGroups {

		/** 
		* 
		* @public (constant) 
		*/
		public static const DefaultFilter : int = 1;

		/** 
		* 
		* @public (constant) 
		*/
		public static const StaticFilter : int = 2;

		/** 
		* 
		* @public (constant) 
		*/
		public static const KinematicFilter : int = 4;

		/** 
		* 
		* @public (constant) 
		*/
		public static const DebrisFilter : int = 8;

		/** 
		* 
		* @public (constant) 
		*/
		public static const SensorTrigger : int = 16;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CharacterFilter : int = 32;

		/** 
		* 
		* @public (constant) 
		*/
		public static const AllFilter : int = -1;
		// all bits sets: DefaultFilter | StaticFilter | KinematicFilter | DebrisFilter | SensorTrigger
	}
}