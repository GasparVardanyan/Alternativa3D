package entity {
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserMaterial;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.Surface;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	import alternativa.engine3d.resources.Geometry;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import flash.display.BitmapData;
	
	import alternativaphysics.collision.shapes.A3DBvhTriangleMeshShape;
	import alternativaphysics.collision.shapes.A3DConeShape;
	import alternativaphysics.dynamics.A3DRigidBody;
	
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author redefy
	 */
	public class Level1 extends Entity {
		private var childMesh:Mesh;
		private var rigidBody:A3DRigidBody;

		public function Level1(){
			super();
			name = "level1";
			createMesh();
		}


		private function createMesh():void {
			GV.parserA3D.parse(new GFX.Scene());

			var parser:Parser3DS = new Parser3DS(); 
			parser.parse(new GFX.Model());
			
			var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
			for each (var obj:Object3D in parser.objects){
				childMesh = obj as Mesh;
				
				/*if (childMesh.name == "DrawCall_0015" || childMesh.name == "DrawCall_0005" || 
					childMesh.name == "DrawCall_0014" || childMesh.name == "DrawCall_0012" || 
					childMesh.name == "DrawCall_0010" || childMesh.name == "DrawCall_0011" || 
					childMesh.name == "DrawCall_0013" || childMesh.name == "DrawCall_0043" || 
					childMesh.name == "DrawCall_0006" || childMesh.name == "DrawCall_0007" || 
					childMesh.name == "DrawCall_0008" || childMesh.name == "DrawCall_0041" ||
					childMesh.name == "DrawCall_0009" || childMesh.name == "DrawCall_0007" ||
					childMesh.name == "DrawCall_0041" || childMesh.name == "DrawCall_0060" ||
					childMesh.name == "DrawCall_0062" || childMesh.name == "DrawCall_0061" ||
					childMesh.name == "DrawCall_0073" || childMesh.name == "DrawCall_0076" ||
					childMesh.name == "DrawCall_0100" || childMesh.name == "DrawCall_0101"){*/
					createRigidBody(childMesh);
				/*} else {
					childMesh.x = 0;
					childMesh.y = 0;
					childMesh.z = 0;
				}*/
				
				for (var i:int = 0; i < childMesh.numSurfaces; i++) {
				var surface:Surface = childMesh.getSurface(i);
				var material:ParserMaterial = surface.material as ParserMaterial;
				if (material != null){
					var diffuse:ExternalTextureResource = material.textures["diffuse"];
					if (diffuse != null){

						//var endStr:String = diffuse.url.substr(0, diffuse.url.indexOf(".")) + ".jpg"; // ???????
						//diffuse.url = "level1/" + diffuse.url;

						textures.push(diffuse);
						surface.material = new VertexLightTextureMaterial(diffuse);
					}
				}
				}
				addChild(childMesh);
			}

			var texturesLoader:TexturesLoader = new TexturesLoader(GV.stage3D.context3D);
			texturesLoader.loadResources(textures);
			
			/*var parser:Parser3DS = new Parser3DS(); 
			parser.parse(new GFX.Model());
			for each (var obj:Object3D in parser.objects){
				childMesh = obj as Mesh;
				var bit:BitmapData = new BitmapData(128, 128, true, 0xFF546213);
				var f:BitmapTextureResource = new BitmapTextureResource(bit);
				childMesh.setMaterialToAllSurfaces(new VertexLightTextureMaterial(f));
				addChild(childMesh);
				createRigidBody(childMesh);
			}*/
		}

		private function createRigidBody(mesh:Mesh):void {
			var shape:A3DCollisionShape;
			switch (mesh.name){
				case "DrawCall_0043":

					var conteiner:Object3D = new Object3D();
					addChild(conteiner);
					mesh.y = 0;
					mesh.z = 0;
					conteiner.addChild(mesh);

					shape = new A3DConeShape(200, 1500);
					rigidBody = new A3DRigidBody(shape, conteiner, 0);

					rigidBody.rotation = new Vector3D(-90, -1, 0);
					rigidBody.position = new Vector3D(200, 1100, -800);
					break;

				default:
					shape = new A3DBvhTriangleMeshShape(mesh.geometry);
					rigidBody = new A3DRigidBody(shape, mesh, 0);
					rigidBody.rotation = new Vector3D(-90, 0, 0);
			}

			GV.physicsWorld.addRigidBody(rigidBody);
		}
	}
}