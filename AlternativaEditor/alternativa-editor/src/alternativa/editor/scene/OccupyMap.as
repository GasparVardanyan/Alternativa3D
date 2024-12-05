package alternativa.editor.scene {
	
	import alternativa.editor.prop.Prop;
	import alternativa.types.Map;
	import alternativa.types.Set;
	
	public class OccupyMap {	
		private var map:Map;
		
		public function OccupyMap() {

			map = new Map();
		}
		
		public function occupy(prop:Prop):void {
			if (prop.free) {
				var z1:Number = prop.distancesZ.x + prop.z;
				var z2:Number = prop.distancesZ.y + prop.z;
				
				var mapZ:Map = new Map();
				for (var i:Number = z1; i < z2; i += EditorScene.vBase) {
					mapZ.add(i, [prop]);
				}
	
				var y1:Number = prop.distancesY.x + prop.y;
				var y2:Number = prop.distancesY.y + prop.y;
				
				var setY:Set = new Set();
				for (i = y1; i < y2; i += EditorScene.hBase) {
					setY.add(i);
				}
	
				var x1:Number = prop.distancesX.x + prop.x;
				var x2:Number = prop.distancesX.y + prop.x;
				
				for (var x:Number = x1; x < x2; x += EditorScene.hBase) {
					for (var y:Number = y1; y < y2; y += EditorScene.hBase) {
						for (var z:Number = z1; z < z2; z += EditorScene.vBase) {
							addElement(x, y, z, prop);
						}
					}
					
				}
				prop.free = false;
			}
			
		}
		
		public function addElement(x:Number, y:Number, z:Number, prop:Prop):void {
			
			var mapY:Map = map[x];
			if (!mapY) {
				mapY = new Map();
				map[x] = mapY;
			}
			var mapZ:Map = mapY[y]; 
			if (!mapZ) {
				mapZ = new Map();
				mapY[y] = mapZ;
			}
			var props:Array = mapZ[z]; 
			if (!props) {
				mapZ.add(z, [prop]);
			} else {
				props.push(prop);
			}
			
			
		}
		
		public function free(prop:Prop):void {
			if (!prop.free) {
				var z1:Number = prop.distancesZ.x + prop.z;
				var z2:Number = prop.distancesZ.y + prop.z;
				
				var setZ:Set = new Set();
				for (var i:Number = z1; i < z2; i += EditorScene.vBase) {
					setZ.add(i);
				}
	
				var y1:Number = prop.distancesY.x + prop.y;
				var y2:Number = prop.distancesY.y + prop.y;
				
				var setY:Set = new Set();
				for (i = y1; i < y2; i += EditorScene.hBase) {
					setY.add(i);
				}
	
				var x1:Number = prop.distancesX.x + prop.x;
				var x2:Number = prop.distancesX.y + prop.x;
				
				for (i = x1; i < x2; i += EditorScene.hBase) {
					var mapY:Map = map[i]; 
					if (mapY) {
						for (var cy:* in setY) {
							var y:Number = cy;
							var mapZ:Map = mapY[y]; 
							if (mapZ) {
								for (var cz:* in setZ) {
									var z:Number = cz;
									var arr:Array = mapZ[z];
									if (arr) {
										var index:int = arr.indexOf(prop);  
										if (index > -1) {
											arr.splice(index, 1);
											if (arr.length == 0) {
												mapZ.remove(z);
											}	
										}
									}
								}
								if (mapZ.length == 0) {
									mapY.remove(y);	
								}
							} 
							
						}	
						
						if (mapY.length == 0) {
							map.remove(i);
						}
					} 	
				}
				prop.free = true;
			}
			
		}
		
		public function isOccupy(x:Number, y:Number, z:Number):Array {
			
			var mapY:Map = map[x]; 
			if (mapY) {
				var mapZ:Map = mapY[y];
				if (mapZ) {
					if (mapZ.hasKey(z)) {
						return mapZ[z];
					}
				}
			}
			
			return null;
		}
		
		
		public function clear():void {
			map.clear();
		}
		
		public function isConflict(prop:Prop):Boolean {
			var x1:Number = prop.distancesX.x + prop.x;
			var x2:Number = prop.distancesX.y + prop.x;
			for (var i:Number = x1; i < x2; i += EditorScene.hBase) {
				var y1:Number = prop.distancesY.x + prop.y;
				var y2:Number = prop.distancesY.y + prop.y;
				for (var j:Number = y1; j < y2; j += EditorScene.hBase) {
					var z1:Number = prop.distancesZ.x + prop.z;
					var z2:Number = prop.distancesZ.y + prop.z;
					for (var k:Number = z1; k < z2; k += EditorScene.vBase) {
						var props:Array = isOccupy(i, j, k);
						 
						if (props && (props.indexOf(prop) == -1 || props.length > 1)) {
							return true;
						}
					}
				}
			}
			
			return false;
		}
		
		public function isConflictGroup(prop:Prop):Boolean {
			
			var x1:Number = prop.distancesX.x + prop.x;
			var x2:Number = prop.distancesX.y + prop.x;
			for (var i:Number = x1; i < x2; i += EditorScene.hBase) {
				var y1:Number = prop.distancesY.x + prop.y;
				var y2:Number = prop.distancesY.y + prop.y;
				for (var j:Number = y1; j < y2; j += EditorScene.hBase) {
					var z1:Number = prop.distancesZ.x + prop.z;
					var z2:Number = prop.distancesZ.y + prop.z;
					for (var k:Number = z1; k < z2; k += EditorScene.vBase) {
						var props:Array = isOccupy(i, j, k);
						if (props) {
							var len:int = props.length; 
							for (var p:int = 0; p < len; p++) {
								var conflictProp:Prop = props[p];
								if (conflictProp != prop && conflictProp.group == prop.group) {
//									trace('name', conflictProp.name, i, j, k);
									return true;
								}
							}
						}
					}
				}
			}
			
			return false;
		}
			
		public function getConflictProps():Set {
			
			var conflictProps:Set = new Set();
			for (var x:* in map) {
				var mapY:Map = map[x];
				for (var y:* in mapY) {
					var mapZ:Map = mapY[y];
					for (var z:* in mapZ) {
						var props:Array = mapZ[z];
						if (props && props.length > 1) {
							for (var i:int = 0; i < props.length; i++) {
								conflictProps.add(props[i]);
							}
						}
					}
				} 
			}
			return conflictProps;
		}
		

	}
}