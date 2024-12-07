package alternativa.proplib {
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.utils.ByteArray;
	
	/**
	 * 
	 */
	public class PropLibValidator {
		
		public var errors:Array;

		private var dirListing:Object;
		private var libXml:XML;
		
		public function PropLibValidator() {
		}
		
		public function validate(libraryFile:File):void {
			errors = [];
			dirListing = {};
			var listing:Array = libraryFile.parent.getDirectoryListing();
			for each (var f:File in listing) {
				if (f.isDirectory) continue;
				var path:String = f.nativePath;
				var fileName:String = path.substring(path.lastIndexOf(File.separator) + 1);
				var lowerCaseName:String = fileName.toLowerCase();
				if (lowerCaseName != fileName)
					logError("File on disk \"" + fileName + "\" has not lowercase name");
				dirListing[lowerCaseName] = path;
			}
			var fileStream:FileStream = new FileStream();
			fileStream.open(libraryFile, FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			fileStream.readBytes(bytes);
			libXml = XML(bytes.toString());
			fileStream.close();
			validateFiles();
		}
		
		private function validateFiles():void {
			for each (var group:XML in libXml.elements("prop-group")) {
				var groupName:String = group.@name;
				for each (var prop:XML in group.elements("prop")) {
					var propName:String = prop.@name;
					var propKey:String = groupName + "/" + propName; 
					if (prop.mesh.length() > 0)
						validatePropMesh(prop.mesh[0], propKey);
					else
						validatePropSprite(prop.sprite[0], propKey);
				}
			}
		}
		
		private function validatePropMesh(meshXml:XML, propKey:String):void {
			var fileName:String = meshXml.@file;
			var lowerCaseName:String = fileName.toLowerCase();
			if (lowerCaseName != fileName)
				logXmlNameCaseError(propKey, fileName);
			checkFileExistence(propKey, lowerCaseName);
			var textures:XMLList = meshXml.texture;
			if (textures.length() > 0)
				for each (var texture:XML in textures) {
					var diffuseMapName:String = texture.attribute("diffuse-map");
					if (diffuseMapName.toLowerCase() != diffuseMapName)
						logXmlTextureNameCaseError(propKey, diffuseMapName);
				}
			check3DS(lowerCaseName, propKey);
		}
		
		private function check3DS(lowerCaseName:String, propKey:String):void {
			var path:String = dirListing[lowerCaseName];
			if (path == null) return;
			var stream:FileStream = new FileStream();
			stream.open(new File(path), FileMode.READ);
			var bytes:ByteArray = new ByteArray();
			stream.readBytes(bytes);
			var parser:Parser3DS = new Parser3DS();
			stream.close();
			parser.parse(bytes);
			var mesh:Mesh = Mesh(parser.objects[0]);
			trace(propKey, mesh.name);
			var material:TextureMaterial = mesh.faceList.material as TextureMaterial;
			if (material == null) {
				errors.push(propKey + ": No texture materials found");
			} else {
				var textureName:String = material.diffuseMapURL.toLowerCase();
				if (dirListing[textureName] == null)
					errors.push(propKey + ": Texture file from 3DS with name \"" + textureName + "\" not found");
			}
		}

		private function validatePropSprite(spriteXml:XML, propKey:String):void {
			var fileName:String = spriteXml.@file;
			var lowerCaseName:String = fileName.toLowerCase();
			if (lowerCaseName != fileName)
				logXmlNameCaseError(propKey, fileName);
			checkFileExistence(propKey, lowerCaseName);
		}
		
		private function checkFileExistence(propKey:String, lowerCaseName:String):void {
			if (dirListing[lowerCaseName] == null)
				errors.push(propKey + ": File \"" + lowerCaseName + "\" not found");
		}
		
		private function logError(message:String):void {
			errors.push(message);
		}
		
		private function logXmlTextureNameCaseError(propKey:String, name:String):void {
			errors.push(propKey + ": Texture file name \"" + name + "\" is not in lowercase");
		}

		private function logXmlNameCaseError(propKey:String, name:String):void {
			errors.push(propKey + ": File name \"" + name + "\" is not in lowercase");
		}
	}
}