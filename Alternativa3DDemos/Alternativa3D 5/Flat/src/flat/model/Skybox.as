package flat.model {

	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;
	
	import flat.LoaderMesh;
	import flat.LoaderTextureMaterial;

	public class Skybox extends LoaderMesh {

		[Embed(source="skybox/skybox_s.jpg")] private static const bmpSkybox_s:Class;
		private static const skybox_s:Texture = new Texture(new bmpSkybox_s().bitmapData, "skybox_s.jpg");
		[Embed(source="skybox/skybox_w.jpg")] private static const bmpSkybox_w:Class;
		private static const skybox_w:Texture = new Texture(new bmpSkybox_w().bitmapData, "skybox_w.jpg");
		[Embed(source="skybox/skybox_e.jpg")] private static const bmpSkybox_e:Class;
		private static const skybox_e:Texture = new Texture(new bmpSkybox_e().bitmapData, "skybox_e.jpg");
		[Embed(source="skybox/skybox_n.jpg")] private static const bmpSkybox_n:Class;
		private static const skybox_n:Texture = new Texture(new bmpSkybox_n().bitmapData, "skybox_n.jpg");

		public function Skybox() {
			super("Skybox");

			coords = new Point3D(1823.1383319371519, 392.1760624116148, -8984.29812927834);

			createVertex(41825.431561203455, -41821.24421989059, -31825.42488596753, 1);
			createVertex(-41825.431561203455, 41821.24732047653, -31825.42488596753, 2);
			createVertex(41825.431561203455, -41821.24421989059, 51825.438236439375, 11);
			createVertex(-41825.431561203455, -41821.24421989059, -31825.42488596753, 13);
			createVertex(41825.431561203455, 41821.24732047653, -31825.42488596753, 15);
			createVertex(41825.431561203455, 41821.24732047653, 51825.438236439375, 17);
			createVertex(-41825.431561203455, 41821.24732047653, 51825.438236439375, 18);
			createVertex(-41825.431561203455, -41821.24421989059, 51825.438236439375, 24);

			createFace([11, 17, 15, 1], 12);
			setUVsToFace(new Point(0, 1), new Point(1, 1), new Point(1, 0), 12);
			createFace([2, 15, 17, 18], 13);
			setUVsToFace(new Point(1, 0), new Point(0, 0), new Point(0, 1), 13);
			createFace([1, 13, 24, 11], 14);
			setUVsToFace(new Point(1, 0), new Point(0, 0), new Point(0, 1), 14);
			createFace([11, 24, 18, 17], 15);
			setUVsToFace(new Point(1, 0), new Point(0, 0), new Point(0, 1), 15);
			createFace([13, 2, 18, 24], 16);
			setUVsToFace(new Point(1, 0), new Point(0, 0), new Point(0, 1), 16);
			createFace([1, 15, 2, 13], 17);
			setUVsToFace(new Point(0, 0), new Point(0, 1), new Point(1, 1), 17);

			
			
			createSurface([14], "skybox_n");
			var materialN:LoaderTextureMaterial = new LoaderTextureMaterial(skybox_n, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 3);
			materialN.url = "skybox/high/skybox_n.jpg";
			setMaterialToSurface(materialN, "skybox_n");
			
			createSurface([12], "skybox_e");
			var materialE:LoaderTextureMaterial = new LoaderTextureMaterial(skybox_e, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 3);
			materialE.url = "skybox/high/skybox_e.jpg";
			setMaterialToSurface(materialE, "skybox_e");
			
			createSurface([16], "skybox_w");
			var materialW:LoaderTextureMaterial = new LoaderTextureMaterial(skybox_w, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 3);
			materialW.url = "skybox/high/skybox_w.jpg"; 
			setMaterialToSurface(materialW, "skybox_w");
			
			createSurface([13], "skybox_s");
			var materialS:LoaderTextureMaterial = new LoaderTextureMaterial(skybox_s, 1, true, true, BlendMode.NORMAL, -1, 0x000000, 3);
			materialS.url = "skybox/high/skybox_s.jpg"; 
			setMaterialToSurface(materialS, "skybox_s");
			
			materials = new Array();
			materials[0] = materialN;
			materials[1] = materialE;
			materials[2] = materialW;
			materials[3] = materialS;
			
			scaleX = 0.7;
			scaleY = 0.7;
			scaleZ = 0.7;
		}
	}
}