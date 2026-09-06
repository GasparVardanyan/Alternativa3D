package {

	/**
	 * ...
	 * @author redefy
	 */
	public class GFX {
		//[Embed("resources/models/scene.A3D",mimeType="application/octet-stream")] static public const Scene:Class;
		[Embed("resources/models/hand.A3D", mimeType = "application/octet-stream")] static public const Hand:Class;
		[Embed("resources/models/level2.3ds", mimeType = "application/octet-stream")] static public const Level2:Class;
		[Embed("resources/models/characterShape.A3D", mimeType = "application/octet-stream")] static public const CharacterShape:Class;
		
		[Embed (source = "resources/textures/skybox/RD4_D.jpg")] static public const SkyD:Class;
		[Embed (source = "resources/textures/skybox/RD4_B.jpg")] static public const SkyB:Class;
		[Embed (source = "resources/textures/skybox/RD4_F.jpg")] static public const SkyF:Class;
		[Embed (source = "resources/textures/skybox/RD4_L.jpg")] static public const SkyL:Class;
		[Embed (source = "resources/textures/skybox/RD4_R.jpg")] static public const SkyR:Class;
		[Embed (source = "resources/textures/skybox/RD4_U.jpg")] static public const SkyU:Class;
		
	
		[Embed (source = "resources/sprites/UI.png")] static public const UI:Class;
		[Embed (source = "resources/sprites/hud.jpg")] static public const HUD:Class;
		[Embed (source = "resources/sprites/radar.png")] static public const RADAR:Class;
		[Embed (source = "resources/sprites/flash.png")] static public const FLASH:Class;
		[Embed (source = "resources/sprites/crosshair.png")] static public const CROSSHAIR:Class;
		
		[Embed (source = "resources/menu/menu.jpg")] static public const MenuBackground:Class;
		[Embed (source = "resources/menu/NewGame.swf")] static public const MenuNewGame:Class;
		[Embed (source = "resources/menu/Settings.swf")] static public const MenuSettings:Class;
		[Embed (source = "resources/menu/About.swf")] static public const MenuAbout:Class;
		[Embed (source = "resources/menu/Level1.swf")] static public const MenuLevel1:Class;
		[Embed (source = "resources/menu/Level2.swf")] static public const MenuLevel2:Class;
		[Embed (source = "resources/menu/Back.swf")] static public const MenuBack:Class;
		[Embed (source = "resources/menu/Label.png")] static public const MenuLabel:Class;
		
		[Embed(source = "resources/fonts/LOUDNOISEBLACKSKEW.ttf", embedAsCFF="false", fontFamily = "ui")] public static const FONT_UI:Class;
	}
}