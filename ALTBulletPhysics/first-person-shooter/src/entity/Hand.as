package entity {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import entity.Entity;
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author redefy
	 */
	public class Hand extends Entity {
		private var childMesh:Mesh;
		private var offsetsHandAxes:Vector3D = new Vector3D(3, 1, 0);
		private var offsetsHandRotation:Vector3D = new Vector3D(90 * Math.PI /180, 0, 0);
		
		public function Hand():void {
			super();
			name = "hand";
			createMesh();
		}

		private function createMesh():void {
			GV.parserA3D.parse(new GFX.Hand());
			
			var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
			for each (var obj:Object3D in GV.parserA3D.objects){
				childMesh = obj as Mesh;
				var surface:Surface = childMesh.getSurface(0);
				var material:ParserMaterial = surface.material as ParserMaterial;
				if (material != null){
					var diffuse:ExternalTextureResource = material.textures["diffuse"];
					if (diffuse != null){

						var newTextureUrl:String = diffuse.url.substr(0, diffuse.url.indexOf(".")) + ".jpg"; //хуй его знает почему так
						diffuse.url = "../src/resources/textures/level/" + newTextureUrl;

						textures.push(diffuse);
						surface.material = new VertexLightTextureMaterial(diffuse);
					}
				}
				addChild(childMesh);
			}

			var texturesLoader:TexturesLoader = new TexturesLoader(GV.stage3D.context3D);
			texturesLoader.loadResources(textures);
		}

		override public function update():void {
			super.update();
			x = GV.camera.x - offsetsHandAxes.x;
			y = GV.camera.y - offsetsHandAxes.y;
			z = GV.camera.z - offsetsHandAxes.z;
			
			rotationX = GV.camera.rotationX + offsetsHandRotation.x;
			rotationY = GV.camera.rotationY + offsetsHandRotation.y;
			rotationZ = GV.camera.rotationZ + offsetsHandRotation.z;
		}
	}
}