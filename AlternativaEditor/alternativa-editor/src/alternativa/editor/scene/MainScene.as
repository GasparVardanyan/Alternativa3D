package alternativa.editor.scene {
	import alternativa.editor.eventjournal.EventJournal;
	import alternativa.editor.eventjournal.EventJournalItem;
	import alternativa.editor.export.BinaryExporter;
	import alternativa.editor.export.FileExporter;
	import alternativa.editor.export.TanksXmlExporter;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.Tile;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.materials.WireMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	
	import flash.filesystem.FileStream;
	
	/**
	 * Главная сцена. 
	 * @author danilova
	 */	
	public class MainScene extends PropsScene {
		
		public static const EXPORT_BINARY:int = 1;
		public static const EXPORT_XML:int = 2;
		
		// Сетка
		private var grid:Plane;
		
		private var exporters:Object = {};
				
		/**
		 * 
		 */
		public function MainScene() {
			super();
			
			// Сетка
			var count:int = 15;
			var width:Number = count*hBase2;
			grid = new Plane(width, width, count, count);
			grid.cloneMaterialToAllSurfaces(new WireMaterial());
			root.addChild(grid);
			grid.x = hBase;
			grid.y = hBase;
			grid.mouseEnabled = false;
			
			exporters[EXPORT_BINARY] = new BinaryExporter(root);
			exporters[EXPORT_XML] = new TanksXmlExporter(root);
		}
		
		/**
		 * 
		 * @param value
		 */
		override public function set root(value:Object3D):void {
			super.root = value;
			for each (var exp:FileExporter in exporters) exp.root = value;
		}
		
		/**
		 * 
		 * @param type
		 * @param stream
		 */
		public function export(type:int, stream:FileStream):void {
			(exporters[type] as FileExporter).exportToFileStream(stream);
			_changed = false;
		}
		
		/**
		 * Перемещение пропов. 
		 * @param props перемещаемые пропы 
		 * @param delta смещение
		 */			
		public function moveProps(props:Set, delta:Point3D):void {
			
			for (var p:* in props) {
				var prop:Prop = p; 
				occupyMap.free(prop);
				prop.x -= delta.x;
				prop.y -= delta.y;
				prop.z -= delta.z;
				if (snapMode) {
					prop.snapCoords();
					occupyMap.occupy(prop);
				}
			}
		}
		
		/**
		 * Отмена действия.
		 * @param e отменяемое событие
		 */		
		public function undo(e:EventJournalItem):void {
			var props:Set = e.props;
			var p:*;

			switch (e.operation) {
				case EventJournal.ADD:
					deleteProps(props);
					break;
				case EventJournal.COPY:
					deleteProps(props);
					break;
				case EventJournal.DELETE:
					for (p in props) {
						var prop:Prop = p;
						prop.deselect();
						addProp(prop, prop.coords, prop.rotationZ, false);
					}
					break;
				case EventJournal.MOVE:
					moveProps(props, e.oldState);
					(e.oldState as Point3D).multiply(-1); 
					break;
				case EventJournal.ROTATE:
					rotateProps(e.oldState, props);
					e.oldState = !e.oldState;
					break;			
				case EventJournal.CHANGE_TEXTURE:
					break; 		
			}		
		}
		
		/**
		 * Возврат действия. 
		 * @param e 
		 */		
		public function redo(e:EventJournalItem):void {
			var props:Set = e.props;
			var prop:Prop;
			var p:*;
			switch (e.operation) {
				case EventJournal.ADD:
					prop = props.peek();
					addProp(prop, prop.coords, prop.rotationZ, false);
					break;
				case EventJournal.COPY:
					for (p in props) {
						prop = p;
						addProp(prop, prop.coords, prop.rotationZ, false);
					}
					break;
				case EventJournal.DELETE:
					deleteProps(props);
					break;
				case EventJournal.MOVE:
					moveProps(props, e.oldState);
					(e.oldState as Point3D).multiply(-1);
					break;
				case EventJournal.ROTATE:
					rotateProps(e.oldState, props);
					e.oldState = !e.oldState;
					break;
				case EventJournal.CHANGE_TEXTURE:
					break;				
			}		
		}
		
		
		/**
		 * Синхронизация с камерой главной сцены
		 * @param cameraCoords
		 * @param rotationX
		 * @param rotationY
		 * @param rotationZ
		 * 
		 */		
		public function synchronize(cameraCoords:Point3D, rotationX:Number, rotationY:Number, rotationZ:Number):void {
			
			camera.coords = cameraCoords;
			camera.rotationX = rotationX;
			camera.rotationY = rotationY;
			camera.rotationZ = rotationZ;
		}
		
		/**
		 * 
		 */		
		public function showCollisionBoxes():void {
			
			for (var child:* in root.children) {
				var tile:Tile = child as Tile;
				if (tile) {
					tile.showCollisionBoxes();
				}
			}
		}
		
		/**
		 * 
		 */		
		public function hideCollisionBoxes():void {
			
			for (var child:* in root.children) {
				var tile:Tile = child as Tile;
				if (tile) {
					tile.hideCollisionBoxes();
				}
			}
		}
		
		/**
		 * 
		 */		
		public function showGrid():void {
			root.addChild(grid);
		}
		
		/**
		 * 
		 */		
		public function hideGrid():void {
			root.removeChild(grid);
		}
		
		
	}
}