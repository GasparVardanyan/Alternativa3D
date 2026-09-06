package alternativaphysics.data {

	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DCollisionFlags {

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_STATIC_OBJECT : int = 1;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_KINEMATIC_OBJECT : int = 2;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_NO_CONTACT_RESPONSE : int = 4;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_CUSTOM_MATERIAL_CALLBACK : int = 8;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_CHARACTER_OBJECT : int = 16;

		/** 
		* 
		* @public (constant) 
		*/
		public static const CF_DISABLE_VISUALIZE_OBJECT : int = 32;
	}
}