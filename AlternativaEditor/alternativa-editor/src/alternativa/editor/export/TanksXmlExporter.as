package alternativa.editor.export {
	import __AS3__.vec.Vector;
	
	import alternativa.editor.prop.Bonus;
	import alternativa.editor.prop.Flag;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Spawn;
	import alternativa.editor.prop.Tile;
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	
	import flash.filesystem.FileStream;
	
	use namespace alternativa3d;

	/**
	 * Экспортёр, сохраняющий уровень в формате XML, который используется для представления танкового уровня на сервере.
	 */
	public class TanksXmlExporter extends FileExporter {
		
		private var collPrimCache:CollisionPrimitivesCache;
		
		/**
		 * 
		 */
		public function TanksXmlExporter(root:Object3D) {
			super(root);
			collPrimCache = new CollisionPrimitivesCache();
		}

		/**
		 * 
		 * @param tile
		 * @return 
		 */
		private function getTileXml(tile:Tile):XML {
//			trace("export ", tile.free);
			var xml:XML =
				<prop library-name={tile.library} group-name={tile.group} name={tile.name} mirror={tile.isMirror} free={tile.free}>
					<rotation>
						<z>{tile.rotationZ}</z>
					</rotation>
					<position>
						<x>{tile.x}</x>
						<y>{tile.y}</y>
						<z>{tile.z}</z>
					</position>
					<texture-name>{tile.textureName}</texture-name>
				</prop>;
			return xml;
		}

		/**
		 * 
		 * @param stream
		 */
		override public function exportToFileStream(stream:FileStream):void {
			var xml:XML =
				<map version="1.0">
					<static-geometry>
					</static-geometry>
					<collision-geometry>
					</collision-geometry>
					<spawn-points>
					</spawn-points>
					<bonus-regions>
					</bonus-regions>
				</map>;
			
			var staticGeometry:XML = xml.child("static-geometry")[0]; 
			var collisionGeometry:XML = xml.child("collision-geometry")[0];
			var bonusRegions:XML = xml.child("bonus-regions")[0];
			var spawnPoints:XML = xml.child("spawn-points")[0];
			for (var child:* in root.children) {
				var prop:Prop = child as Prop;
				if (prop) {
					switch (prop.type) {
						case Prop.BONUS:
							bonusRegions.appendChild(getBonusXml(prop as Bonus));
							break;
						case Prop.SPAWN:
							spawnPoints.appendChild(getSpawnXml(prop as Spawn));	
							break;
						case Prop.FLAG:
							addCtfFlag(xml, prop as Flag);
							break;
						case Prop.TILE:
							var tile:Tile = prop as Tile;
							staticGeometry.appendChild(getTileXml(tile));
							createTileCollisionXml(tile, collisionGeometry);
							break;
					}
				}
			}
			
			stream.writeUTFBytes(xml.toXMLString());
		}
		
		/**
		 * 
		 * @param mapXml
		 */
		private function addCtfFlag(mapXml:XML, flag:Flag):void {
			var flags:XMLList = mapXml.elements("ctf-flags");
			var flagsElement:XML;
			if (flags.length() == 0) {
				flagsElement = <ctf-flags></ctf-flags>;
				mapXml.appendChild(flagsElement);
			} else {
				flagsElement = flags[0];
			}
			var flagElement:XML;
			switch (flag.name) {
				case "red_flag":
					flagElement =
						<flag-red>
							<x>{flag.x}</x>
							<y>{flag.y}</y>
							<z>{flag.z}</z>
						</flag-red>;
					break;
				case "blue_flag":
					flagElement =
						<flag-blue>
							<x>{flag.x}</x>
							<y>{flag.y}</y>
							<z>{flag.z}</z>
						</flag-blue>;
					break;
			}
			flagsElement.appendChild(flagElement);
		}
		
		/**
		 * 
		 * @param tile
		 * @return 
		 */
		private function createTileCollisionXml(tile:Tile, parentElement:XML):void {
			// Пробуем достать примитивы из кэша, если не удаётся, создаём набор для пропа и добавляем его в кэш
			var primitives:Vector.<CollisionPrimitive> = collPrimCache.getPrimitives(tile.library, tile.group, tile.name);
			if (primitives == null) {
				primitives = createPropCollisionPrimitives(tile);
				collPrimCache.addPrimitives(tile.library, tile.group, tile.name, primitives);
			}
			// Записываем XML представления примитивов
			for each (var p:CollisionPrimitive in primitives) parentElement.appendChild(p.getXml(tile._transformation));
		}
		
		/**
		 * Создаёт набор физической геометрии для пропа.
		 * @param tile
		 */
		private function createPropCollisionPrimitives(tile:Tile):Vector.<CollisionPrimitive> {
			var primitives:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
			for (var key:* in tile.collisionGeometry) {
				var mesh:Mesh = key;
				var meshName:String = mesh.name.toLowerCase();
				if (meshName.indexOf("plane") == 0) primitives.push(new CollisionPlane(mesh));
				else if (meshName.indexOf("box") == 0) primitives.push(new CollisionBox(mesh));
			}
			return primitives;
		}
		
		/**
		 * 
		 * @param spawn
		 * @return 
		 */
		private function getSpawnXml(spawn:Spawn):XML {
			var xml:XML = 
				<spawn-point type={spawn.name} free={spawn.free}>
					<position>
						<x>{spawn.x}</x>							
						<y>{spawn.y}</y>							
						<z>{spawn.z}</z>							
					</position>		
					<rotation>
						<z>{spawn.rotationZ}</z>					
					</rotation>					
				</spawn-point>	
			return xml;
		}
		
		/**
		 * 
		 * @param prop
		 * @return 
		 */
		private function getBonusXml(prop:Bonus):XML {
			
			var xml:XML = 
			<bonus-region name={prop.name} free={prop.free}>
				<position>
					<x>{prop.x}</x>							
					<y>{prop.y}</y>							
					<z>{prop.z}</z>							
				</position>		
				<rotation>
					<z>{prop.rotationZ}</z>					
				</rotation>	
				<min>
					<x>{prop.x + prop.distancesX.x}</x>
					<y>{prop.y + prop.distancesY.x}</y>
					<z>{prop.z + prop.distancesZ.x}</z>
				</min>
				<max>
					<x>{prop.x + prop.distancesX.y}</x>
					<y>{prop.y + prop.distancesY.y}</y>
					<z>{prop.z + prop.distancesZ.y}</z>
				</max>
			</bonus-region>;
			
			
			for (var type:* in prop.types) {
				xml.appendChild(<bonus-type>{type}</bonus-type>);
			}
			
			return xml;
		}
		
	}
}