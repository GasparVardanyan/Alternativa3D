package bunker {

	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.MovieClip;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.media.SoundTransform;

	/**
	 * The screen at the entrance room.
	 */
	public class Screen extends Mesh {

		[Embed(source="screen.swf")] private static const screenAnimation:Class;	
		private static const animation:MovieClip = new screenAnimation();

		private static const screen:Texture = new Texture(new BitmapData(256, 256, false, 0x440000));
		
		private var soundTansform:SoundTransform = new SoundTransform();
		private var soundCoords:Point3D = new Point3D(362, -2007, 0);

		public var material:TextureMaterial = new TextureMaterial(screen, 1, false, false, BlendMode.NORMAL, -1, 0xFFFFFF);

		public function Screen() {
			super("Screen");
			
			mobility = 2;

			coords = new Point3D(362.20477294921875, -1921.260009765625, 78.74015808105469);

			createVertex(64.90576171875, -149.6063232421875, -51.18110656738281, "0");
			createVertex(88.78988647460938, -108.3538818359375, -51.18110656738281, "1");
			createVertex(23.909713745117188, 3.9371337890625, -51.18110656738281, "2");
			createVertex(-64.90582275390625, -149.6063232421875, -51.18110656738281, "3");
			createVertex(-88.78994750976563, -108.3538818359375, -51.18110656738281, "4");
			createVertex(-23.909774780273438, 3.9371337890625, -51.18110656738281, "5");

			createFace(["1", "2", "5", "4", "3", "0"], "2");
			setUVsToFace(new Point(1 - 0.009999999776482582, 0.36833637952804565), new Point(1 - 0.36805060505867004, 0.9880308508872986), new Point(1 - 0.6319494157642815, 0.9880311936093502), "2");

			createSurface(["2"], "Screen");
			setMaterialToSurface(material, "Screen");
			
			animation.stop();
		}
		
		public function startAnimation():void {
			animation.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		public function stopAnimation():void {
			animation.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			screen.bitmapData.draw(animation);
		}
		
		public function checkVolume(coords:Point3D, normal:Point3D):void {
			Sound3D.getSoundProperties(coords, soundCoords, normal, 125, 250, 10, soundTansform);
			animation.soundTransform = soundTansform;
		}
		
	}
}