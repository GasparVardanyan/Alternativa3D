package alternativa.editor.importLevel {
	
	import alternativa.editor.LibraryManager;
	import alternativa.editor.prop.Bonus;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Tile;
	import alternativa.editor.prop.TileSprite3D;
	import alternativa.editor.scene.MainScene;
	import alternativa.types.Point3D;
	
	import flash.filesystem.FileStream;
	
	import mx.controls.Alert;

	public class TanksXmlImporter extends FileImporter {
		
		public function TanksXmlImporter(scene:MainScene, libraryManager:LibraryManager) {
			
			super(scene, libraryManager);
		}
		
		override public function importFromFileStream(stream:FileStream):void {
			
			var xml:XML = new XML(stream.readUTFBytes(stream.bytesAvailable));
			stream.close();
			try {
				var staticGeometry:XML = xml.child("static-geometry")[0];
				var bonusRegions:XML = xml.child("bonus-regions")[0];
				var spawnPoints:XML = xml.child("spawn-points")[0];
				
				if (staticGeometry) {
					loadTiles(staticGeometry);
				}
				if (bonusRegions) {
					loadBonuses(bonusRegions);
				}
				if (spawnPoints) {
					loadSpawns(spawnPoints);
				}
				
				var flagList:XMLList = xml.child("ctf-flags");
				if (flagList.length() > 0) loadFlags(flagList[0]);
				
			} catch (err:Error) {
				Alert.show(err.message);
			}
			endLoadLevel();
			
			
		}
		
		/**
		 * 
		 * @param flags
		 */
		private function loadFlags(flags:XML):void {
			addFlag(flags.child("flag-red")[0], "red_flag");
			addFlag(flags.child("flag-blue")[0], "blue_flag");
		}
		
		/**
		 * 
		 * @param flagXml
		 * @param flagPropName
		 */
		private function addFlag(flagXml:XML, flagPropName:String):void {
			libname = "FunctionalFlags" + flagPropName;
			var prop:Prop = libraryManager.nameProp[libname];
			if (prop != null) {
				// Добавляем проп на сцену
				prop = scene.addProp(prop, new Point3D(Number(flagXml.x),Number(flagXml.y), Number(flagXml.z)), 0, true, false);
				libname = "";
				scene.calculate();
			}
		}
		
		/**
		 * 
		 * @param staticGeometry
		 */
		private function loadTiles(staticGeometry:XML):void {
			var tiles:XMLList = staticGeometry.child("prop");
			for (var i:int = 0; i < tiles.length(); i++) {
				var propXML:XML = tiles[i];
				libname = propXML.attribute("library-name").toString() + propXML.attribute("group-name").toString() + propXML.attribute("name").toString();
				var prop:Prop = libraryManager.nameProp[libname];
				if (prop) {
					var position:XML = propXML.child("position")[0];
					var rotation:XML = propXML.child("rotation")[0];
					// Добавляем проп на сцену
					prop = scene.addProp(prop, new Point3D(Number(position.child("x")[0]),Number(position.child("y")[0]), Number(position.child("z")[0])), Number(rotation.child("z")[0]), true, false);
					var free:Boolean = propXML.attribute("free").toString() == "true";
//					trace("import free", free);
					if (!(free && prop is TileSprite3D)) {
						// Заполняем карту
						scene.occupyMap.occupy(prop);
					}
					
					var textureName:String = propXML.child("texture-name")[0];
//					var isMirror:Boolean = fileStream.readBoolean();
					var tile:Tile = prop as Tile;
					if (tile) {
						try {
							if (textureName != "") {
								tile.textureName = textureName;
							}
						} catch (err:Error) {
							Alert.show("Tile " + tile.name + ": texture " + textureName + " is not found");
						}
						
//						if (isMirror) {
//						tile.mirrorTexture();
//						}
					}
					libname = "";
					scene.calculate();
//					} else {
//						Alert.show("Library '"+ lib + "' is used by the level. Load?", "", Alert.YES|Alert.NO, this, libAlertListener);
//						return;
//					}
//					}
					
					
				}
			}
		}
		
		private function loadBonuses(bonusRegions:XML):void {
			var bonuses:XMLList = bonusRegions.child("bonus-region");
			for (var i:int = 0; i < bonuses.length(); i++) {
				var bonusXML:XML = bonuses[i];
				libname = "FunctionalBonus Regions" + bonusXML.attribute("name").toString();
				var prop:Prop = libraryManager.nameProp[libname];
				if (prop) {
					var position:XML = bonusXML.child("position")[0];
					var rotation:XML = bonusXML.child("rotation")[0];
					// Добавляем проп на сцену
					prop = scene.addProp(prop, new Point3D(Number(position.child("x")[0]),Number(position.child("y")[0]), Number(position.child("z")[0])), Number(rotation.child("z")[0]), true, false);
					var free:Boolean = bonusXML.attribute("free");
					if (!free) {
						// Заполняем карту
						scene.occupyMap.occupy(prop);
					}
					var bonusType:XMLList = bonusXML.child("bonus-type");
					
					(prop as Bonus).types.clear();
					for (var j:int = 0; j < bonusType.length(); j++) {
//						trace("j", bonusType[j].toString());
						(prop as Bonus).types.add(bonusType[j].toString());
					}
					libname = "";
					scene.calculate();
				}
			}
		}

		private function loadSpawns(spawnPoints:XML):void {
			var spawns:XMLList = spawnPoints.child("spawn-point");
			for (var i:int = 0; i < spawns.length(); i++) {
				var spawnXML:XML = spawns[i];
				libname = "FunctionalSpawn Points" + spawnXML.attribute("type").toString();
				var prop:Prop = libraryManager.nameProp[libname];
				if (prop) {
					var position:XML = spawnXML.child("position")[0];
					var rotation:XML = spawnXML.child("rotation")[0];
					// Добавляем проп на сцену
					prop = scene.addProp(prop, new Point3D(Number(position.child("x")[0]),Number(position.child("y")[0]), Number(position.child("z")[0])), Number(rotation.child("z")[0]), true, false);
					var free:Boolean = spawnXML.attribute("free");;
					if (!free) {
						// Заполняем карту
						scene.occupyMap.occupy(prop);
					}
					
					libname = "";
					scene.calculate();
				}
			}
		}
		
		
		
		
	}
}
