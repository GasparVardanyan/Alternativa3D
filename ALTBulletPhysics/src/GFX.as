package {

	/**
	 * ...
	 * @author redefy
	 */
	public class GFX {
	[Embed(source = 'assets/wp9.jpg')] public static const Brick:Class;
	[Embed(source = 'assets/concrete1.jpg')] public static const Floor:Class;
	[Embed(source = 'assets/wp9_bump.jpg')] public static const BrickFront:Class;
	[Embed(source = 'assets/electro14.jpg')] public static const Bullet:Class;
	[Embed(source = 'assets/gt8_bump.jpg')] public static const Box:Class;
	[Embed(source = 'assets/Heightmap.jpg')] public static const Heightmap:Class;
	[Embed(source = 'assets/terrain_tex.jpg')] public static const Heightmap2:Class;

	[Embed(source = 'assets/skybox/d10_B.png')] public static const TextureSkyB:Class;
	[Embed(source = 'assets/skybox/d10_D.png')] public static const TextureSkyD:Class;
	[Embed(source = 'assets/skybox/d10_F.png')] public static const TextureSkyF:Class;
	[Embed(source = 'assets/skybox/d10_L.png')] public static const TextureSkyL:Class;
	[Embed(source = 'assets/skybox/d10_R.png')] public static const TextureSkyR:Class;
	[Embed(source = 'assets/skybox/d10_U.png')] public static const TextureSkyU:Class;
	
	[Embed("assets/primitivies/Cylinder.A3D", mimeType = "application/octet-stream")] static public const Cylinder:Class;
	[Embed("assets/primitivies/Cone.A3D", mimeType = "application/octet-stream")] static public const Cone:Class;
	[Embed("assets/primitivies/Capsule.A3D",mimeType="application/octet-stream")] static public const Capsule:Class;
	[Embed("assets/primitivies/Convex.A3D",mimeType="application/octet-stream")] static public const Convex:Class;
	}

}