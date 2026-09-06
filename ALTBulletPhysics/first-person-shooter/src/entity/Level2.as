package entity {
	import alternativa.engine3d.core.events.Event3D;
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
	
	import alternativaphysics.collision.shapes.A3DBoxShape;
	import alternativaphysics.collision.shapes.A3DCollisionShape;
	import alternativaphysics.collision.shapes.A3DBvhTriangleMeshShape;
	import alternativaphysics.collision.shapes.A3DConeShape;
	import alternativaphysics.dynamics.A3DRigidBody;
	
	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	/**
	 * ...
	 * @author redefy
	 */
	public class Level2 extends Level {
		
		public function Level2(){
			super();
			startHeroPoint = new Vector3D(906, -338, 84);
			startHeroRotation = new Vector3D( -1, 0, 1.45);
			name = "level2";
			createMesh();
		}

		private function createMesh():void {
			GV.parser3DS.parse(new GFX.Level2());

			var textures:Vector.<ExternalTextureResource> = new Vector.<ExternalTextureResource>();
			for each (var obj:Object3D in GV.parser3DS.objects){
				childMesh = obj as Mesh;
		
				for (var i:int = 0; i < childMesh.numSurfaces; i++){
					var surface:Surface = childMesh.getSurface(i);
					var material:ParserMaterial = surface.material as ParserMaterial;
					if (material != null) {
						var diffuse:ExternalTextureResource = material.textures["diffuse"];
						if (diffuse != null) {
							var baseURL:String = diffuse.url;
							
							if (baseURL.length < 10)
								diffuse.url = "../src/resources/textures/level/" + baseURL;
							
							textures.push(diffuse);
							surface.material = new VertexLightTextureMaterial(diffuse);
						}
					}
				}
				addChild(childMesh);
				createRigidBody(childMesh);
			}

			var texturesLoader:TexturesLoader = new TexturesLoader(GV.stage3D.context3D);
			texturesLoader.loadResources(textures);
		}

		private function createRigidBody(mesh:Mesh):void {
			var shape:A3DCollisionShape;
		
			switch (mesh.name) {
				
				default:
					shape = new A3DBvhTriangleMeshShape(mesh.geometry);
					rigidBody = new A3DRigidBody(shape, mesh, 0);
				break;
			}
			
			GV.physicsWorld.addRigidBody(rigidBody);
		}
	}
}