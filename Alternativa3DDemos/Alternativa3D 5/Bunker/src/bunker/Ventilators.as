package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * Ventilators in the reactor room.
	 */
	public class Ventilators extends Mesh {

		[Embed(source="ventilator.jpg")] private static const Bmp:Class;
		private static const ventilatorBitmapData:BitmapData = new Bmp().bitmapData;
		
		private static const texture:Texture = new Texture(new BitmapData(276, 276, false, 0xFF0000));

		private var angle:Number = 0;
		
		public var material:TextureMaterial = new TextureMaterial(texture, 1, false, false, BlendMode.NORMAL, -1, 0xFFFFFF);
		/**
		 * Angular speed of fans' revolution (radians per second)
		 */
		public var rotationSpeed:Number = 1;
		
		/**
		 * 
		 */
		public function Ventilators() {
			super("Ventilators");

			coords = new Point3D(6.017908068568778e-13, 2322.834716796875, -629.9212646484375);

			createVertex(548.6146850585932, -78.740234375, 194.70086669921875, "v0");
			createVertex(548.6146850585932, 78.739990234375, 194.70083618164063, "v1");
			createVertex(437.2592773437494, 78.739990234375, 83.34539794921875, "v2");
			createVertex(437.2593078613275, -78.740234375, 83.34539794921875, "v3");
			createVertex(-437.2592468261725, 78.740234375, 83.34539794921875, "v4");
			createVertex(-548.6146240234381, 78.740234375, 194.70086669921875, "v5");
			createVertex(-548.6146240234381, -78.739990234375, 194.70086669921875, "v6");
			createVertex(-437.2591552734381, -78.739990234375, 83.34539794921875, "v7");
			createVertex(78.74028778076112, 437.25927734375, 83.34539794921875, "v8");
			createVertex(78.740257263183, 548.614501953125, 194.70086669921875, "v9");
			createVertex(-78.73999786377013, 548.614501953125, 194.70086669921875, "v10");
			createVertex(-78.73993682861388, 437.259033203125, 83.34539794921875, "v11");

			createFace(["v9", "v10", "v11", "v8"], "v0");
			setUVsToFace(new Point(0, 0.9999998211860657), new Point(1.937866613843653e-7, 0), new Point(1, 3.875733227687306e-7), "v0");
			createFace(["v6", "v7", "v4", "v5"], "v1");
			setUVsToFace(new Point(0, -4.463188929548778e-8), new Point(1, 1.9378668980607472e-7), new Point(1, 1), "v1");
			createFace(["v3", "v0", "v1", "v2"], "v6");
			setUVsToFace(new Point(0.9999999833754984, 0.9999995158196897), new Point(0, 0.9999992251396179), new Point(2.9067999207654793e-7, 0), "v6");

			createSurface(["v0", "v6", "v1"], "Ventilators");
			setMaterialToSurface(material, "Ventilators");
			
			createVertex(529.1339111328119, 78.739990234375, 214.181640625, "0");
			createVertex(529.1339111328119, -78.740234375, 214.18167114257813, "1");
			createVertex(417.77847290039, 78.739990234375, 102.826171875, "2");
			createVertex(417.7785034179681, -78.740234375, 102.826171875, "3");
			createVertex(-417.7784423828131, 78.740234375, 102.826171875, "4");
			createVertex(-529.1338500976568, 78.740234375, 214.18167114257813, "5");
			createVertex(-529.1338500976568, -78.739990234375, 214.181640625, "6");
			createVertex(-417.77835083007875, -78.739990234375, 102.826171875, "7");
			createVertex(78.74028778076112, 417.7783203125, 102.826171875, "8");
			createVertex(78.740257263183, 529.1337890625, 214.18167114257813, "9");
			createVertex(-78.73999786377013, 529.1337890625, 214.181640625, "10");
			createVertex(-78.73993682861388, 417.7783203125, 102.826171875, "11");
			createVertex(548.6210937499994, -78.740234375, 194.6944580078125, "12");
			createVertex(548.6210937499994, 78.739990234375, 194.69442749023438, "13");
			createVertex(437.2656860351556, 78.739990234375, 83.3389892578125, "14");
			createVertex(437.2656860351556, -78.740234375, 83.3389892578125, "15");
			createVertex(-437.2656250000006, 78.740234375, 83.3389892578125, "16");
			createVertex(-548.6210327148443, 78.740234375, 194.6944580078125, "17");
			createVertex(-548.6210327148443, -78.739990234375, 194.6944580078125, "18");
			createVertex(-437.2655639648444, -78.739990234375, 83.3389892578125, "19");
			createVertex(78.74028778076112, 437.265625, 83.3389892578125, "20");
			createVertex(78.740257263183, 548.620849609375, 194.6944580078125, "21");
			createVertex(-78.73999786377013, 548.620849609375, 194.6944580078125, "22");
			createVertex(-78.73993682861388, 437.265380859375, 83.3389892578125, "23");

			createFace(["17", "5", "6", "18"], "0");
			createFace(["20", "8", "9", "21"], "1");
			createFace(["19", "7", "4", "16"], "2");
			createFace(["4", "5", "17", "16"], "24");
			createFace(["8", "20", "23", "11"], "4");
			createFace(["0", "2", "14", "13"], "5");
			createFace(["12", "1", "0", "13"], "6");
			createFace(["21", "9", "10", "22"], "7");
			createFace(["3", "1", "12", "15"], "8");
			createFace(["6", "7", "19", "18"], "9");
			createFace(["11", "23", "22", "10"], "10");
			createFace(["14", "2", "3", "15"], "11");

			createSurface(["2", "5", "11", "10", "9", "7", "1", "0", "6", "4", "24", "8"], "BlackBox");
			setMaterialToSurface(new FillMaterial(0x0), "BlackBox");
		}
		
		/**
		 * Rotation of the texture with fan image.
		 * 
		 * @param time time in seconds
		 */
		public function rotate(time:Number):void {
			angle += rotationSpeed * time;
			var matrix:Matrix = new Matrix(1, 0, 0, 1, -138, -138);
			matrix.rotate(angle);
			matrix.translate(138, 138);
			texture.bitmapData.draw(ventilatorBitmapData, matrix);
		}
	}
}