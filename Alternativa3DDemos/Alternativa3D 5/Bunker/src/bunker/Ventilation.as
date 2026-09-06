package bunker {

	import alternativa.engine3d.core.Face;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	
	import flash.display.BlendMode;
	import flash.geom.Point;

	/**
	 * Grid of the ventilators.
	 */
	public class Ventilation extends TextureLoader {

		[Embed(source="ventilationlow.jpg")] private static const Bmp:Class;
		private static const texture:Texture = new Texture(new Bmp().bitmapData);

		public var material:TextureMaterial = new TextureMaterial(texture, 1, false, true, BlendMode.NORMAL, -1, 0xFFFFFF);
		
		private var normals:Array;
		private var offsets:Array;
		private var centerPoints:Array;
		private var fanRadius2:Number;

		public function Ventilation() {
			super("Ventilation");

			bindings = [new TextureMaterialBinding([material], "ventilation.jpg", "ventilationalpha.gif")];
			loadingMessage = "Loading ventilation texture";

			coords = new Point3D(6.017908068568778e-13, 2322.834716796875, -629.9212646484375);

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

			createFace(["8", "9", "10", "11"], "0");
			setUVsToFace(new Point(0.49900170450910625, 0.501001579179785), new Point(0.49899822473526, 0.9990017414093018), new Point(0.0009982585906982422, 0.9989981651306152), "0");
			createFace(["3", "1", "0", "2"], "2");
			setUVsToFace(new Point(0.5009998506457531, 0.0010000000474974513), new Point(0.9990000128746033, 0.0010000000474974513), new Point(0.9990000128746033, 0.49900001287460327), "2");
			createFace(["6", "7", "4", "5"], "6");
			setUVsToFace(new Point(0.0009990896796807647, 0.0010008811950683594), new Point(0.49899911880493164, 0.0009990036487579346), new Point(0.4990005419761064, 0.49899896979486336), "6");

			createSurface(["0", "2", "6"], "Ventilation");
			setMaterialToSurface(material, "Ventilation");
			
			calculatePlanes();
		}
		
		/**
		 * The method calculates force intensity of fans' air currents which act on a body. The air current's zone of a fan is supposed to be a
		 * cylinder of given length. The intensity magnitude equals 1 close to a fan and linearly decreases along the cylinder's axis so that at the
		 * farhtest end of the cylinder the force intensity is zero.
		 * @param objectCoords coordinates of an object
		 * @param windZoneLength the length of cylindrical zone of the air current
		 * @param force the force intencity is stored here
		 */
		public function getWindForce(objectCoords:Point3D, windZoneLength:Number, force:Point3D):void {
			var normal:Point3D; 
			force.reset();
			for (var i:int = 0; i < 3; i++) {
				normal = normals[i];
				var objectOffset:Number = Point3D.dot(objectCoords, normal) - offsets[i];
				if (objectOffset > 0 && objectOffset < windZoneLength) {
					var centerPoint:Point3D = centerPoints[i];
					var px:Number = objectCoords.x - normal.x * objectOffset - centerPoint.x;
					var py:Number = objectCoords.y - normal.y * objectOffset - centerPoint.y;
					var pz:Number = objectCoords.z - normal.z * objectOffset - centerPoint.z;
					if (px*px + py*py + pz*pz < fanRadius2 + 0.01) {
						var strength:Number = 1 - objectOffset / windZoneLength;
						force.x += normal.x * strength;
						force.y += normal.y * strength;
						force.z += normal.z * strength;
					}
				}
			}
		}
		
		/**
		 * The method calculates normals of the fans' grid.
		 */
		private function calculatePlanes():void {
			var normal:Point3D;
			normals = new Array();
			offsets = new Array();
			centerPoints = new Array();
			var p:Point3D;
			
			for each (var face:Face in faces) {
				// Normal and offset of the fan's plane
				normal = face.normal;
				normals.push(normal);
				p = face.vertices[0].coords;
				p.add(coords);
				offsets.push(Point3D.dot(p, normal));
				// Center of the fan
				p = new Point3D();
				for each (var v:Vertex in face.vertices) {
					p.add(v.coords);
				}
				p.multiply(0.25);
				p.add(coords);
				centerPoints.push(p);
				// Square radius of fans
				if (isNaN(fanRadius2)) {
					p = p.clone();
					p.subtract(coords);
					p.subtract(v.coords);
					fanRadius2 = p.length / Math.sqrt(2);
					fanRadius2 *= fanRadius2;
				}
			}
		}
	}
}