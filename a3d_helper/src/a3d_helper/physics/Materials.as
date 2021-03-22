package a3d_helper.physics
{
	import alternativa.physicsengine.physics.materials.PhysicsMaterial;
	
	public class Materials
	{
		public static var Default:PhysicsMaterial = PhysicsMaterial.defaultMaterial;
		public static var StoneRough:PhysicsMaterial = new PhysicsMaterial(.05, .95);
		public static var StoneSmooth:PhysicsMaterial = new PhysicsMaterial(.05, .5);
		public static var Entity:PhysicsMaterial = new PhysicsMaterial(.5, .9);
	}
}
