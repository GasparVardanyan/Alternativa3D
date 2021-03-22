package a3d_helper.examples
{
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.OmniLight;
	import alternativa.utils.templates.TextInfo;
	import a3d_helper.loaders.MapLoader;
	import a3d_helper.templates.SceneTemplate;
	import flash.ui.Keyboard;
	
	public class MapLoaderExample extends SceneTemplate
	{
		public var ambientLight:AmbientLight = new AmbientLight(0xFFFFFF);
		public var omniLight:OmniLight = new OmniLight(0xFFFFFF, 1, 7000);
		
		override protected function init():void
		{
			cameraController.setObjectPosXYZ(0, -10, 5);
			cameraController.lookAtXYZ(0, 0, 0);
			cameraController.speed = 15;
			cameraController.unbindKey(Keyboard.UP);
			cameraController.unbindKey(Keyboard.DOWN);
			cameraController.unbindKey(Keyboard.LEFT);
			cameraController.unbindKey(Keyboard.RIGHT);
			cameraController.enable();
			
			ambientLight.intensity = 0.2;
			omniLight.x = 0;
			omniLight.y = 200;
			omniLight.z = 1000;
			omniLight.intensity = 0.8;
			rootContainer.addChild(ambientLight);
			rootContainer.addChild(omniLight);
			
			var textInfo:TextInfo = new TextInfo();
			
			try {
				var mapLoader:MapLoader = new MapLoader("res/propslibs/", "res/map.xml", .005);
				mapLoader.loadAndParseMap(rootContainer, stage3d.context3D);
			} catch (error:Error)
				{
					if (error.errorID == 2148)
					{
						textInfo.write("SecurityError: Error #2148: SWF file cannot access local resources.\nOnly local-with-filesystem and trusted local SWF files may access local resources.");
						addChild(textInfo);
					}
					else throw error;
				}
		}
	}
}
