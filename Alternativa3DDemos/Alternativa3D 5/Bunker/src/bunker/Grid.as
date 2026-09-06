package bunker {

	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;

	/**
	 * Grid on the bunker's room floor.
	 */
	public class Grid extends TextureLoader {

		[Embed(source="gridlow.jpg")] private static const Bmp:Class;
		private static const texture:Texture = new Texture(new Bmp().bitmapData);

		public var material:TextureMaterial = new TextureMaterial(texture, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);

		public function Grid() {
			super("Grid");
			
			bindings = [new TextureMaterialBinding([material], "grid.jpg", "gridalpha.gif")];
			loadingMessage = "Loading grid texture";

			mobility = 2;

			createVertex(39.37008612055797, 314.9606394042494, 0.0000152587890625, "0");
			createVertex(39.37008612055797, 0.000030517578125, 0.00006866455078125, "1");
			createVertex(-39.37008721928578, 0.000030517578125, 0.00006866455078125, "2");
			createVertex(-39.37008721928578, 314.9606394042494, 0.0000152587890625, "3");
			createVertex(-39.370071960496716, -157.48033959965687, 0.0001068115234375, "4");
			createVertex(39.37007086176891, -157.48033959965687, 0.0001068115234375, "5");
			createVertex(39.37008612055797, -944.88198144536, 0.00022125244140625, "6");
			createVertex(39.37008612055797, -629.921288085985, 0.00017547607421875, "7");
			createVertex(-39.37008721928578, -629.921288085985, 0.00017547607421875, "8");
			createVertex(39.37007086176891, -472.4409108887194, 0.000152587890625, "9");
			createVertex(-39.37008721928578, -944.88198144536, 0.00022125244140625, "10");
			createVertex(-39.370071960496716, -472.4409108887194, 0.000152587890625, "11");

			createFace(["7", "8", "10", "6"], "0");
			setUVsToFace(new Point(0.2524999976158142, 0.9950000047683716), new Point(0.004999999888241291, 0.9950000047683716), new Point(0.004999999888241291, 0.004999999888241291), "0");
			createFace(["4", "11", "9", "5"], "1");
			setUVsToFace(new Point(0.26226165890693665, 0.9949997067451477), new Point(0.26226165890693665, 0.004999999888241291), new Point(0.5097615718841553, 0.004999999888241291), "1");
			createFace(["0", "3", "2", "1"], "6");
			setUVsToFace(new Point(0.5202288627624512, 0.004999999888241291), new Point(0.7677289247512817, 0.004999999888241291), new Point(0.7677289247512817, 0.9949998259544373), "6");

			createSurface(["0", "6", "1"], "Grid");
			setMaterialToSurface(material, "Grid");
		}
	}
}