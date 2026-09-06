package {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.resources.TextureResource;
	
	import alternativaphysics.debug.A3DDebugDraw;
	import alternativaphysics.dynamics.A3DDynamicsWorld;
	
	import entity.Crosshair;
	import entity.Entity;
	import entity.Flash;
	import entity.Hand;
	import entity.Level;
	import utility.FPSCamera;
	import utility.GameController;
	import utility.UI;
	
	import flash.display.Stage;
	import flash.display.Shape;
	import flash.display.Stage3D;

	/**
	 * ...
	 * @author redefy
	 */
	public class GV {
		/* переменнные для Alternativa3D */
		public static var stage3D:Stage3D;	
		public static var container:Object3D = new Object3D();
		public static var camera:Camera3D;
		public static var parser3DS:Parser3DS;
		public static var parserA3D:ParserA3D;
		public static var parserCollada:ParserCollada;
		public static var controller:SimpleObjectController;
		public static var skybox:SkyBox;
		public static var shapeDiagram:Shape;
		
		
		/* переменные шутера */
		public static var stage:Stage;	
		public static var fpscamera:FPSCamera;
		public static var hand:Hand;
		public static var gameController:GameController;
		public static var currentScene:Level;
		public static var ui:UI;
		public static var flash:Flash;
		public static var entitys:Array = [];
		
		
		/* переменные Bullet */
		public static var physicsWorld : A3DDynamicsWorld; 
		public static var preTimer:Number = 0; 
		public static var timeStep : Number = 0; 
		public static var debugDraw:A3DDebugDraw; 
		
		
		/* Временные переменные */
		public static var model:Object3D;
		public static var texture:TextureResource;
		public static var textureLoader:TexturesLoader;
		public static var material:Material;
		public static var lightAmbient:AmbientLight;
		public static var lightDirectional:DirectionalLight;
		public static var s:Crosshair;
	}
}