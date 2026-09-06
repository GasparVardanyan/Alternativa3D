package alternativa.gui.layout {
	import __AS3__.vec.Vector;
	
	import alternativa.gui.lod.simple.ISimpleLODobject;
	import alternativa.gui.lod.simple.LODlistenerPriority;

	
	/**
	 * Кастомный LODManager. 
	 * <p>В классе DefaultLODManager реализована примитивная логика лодирования.</p>
	 * <p>Данный LODManager имеет 3 индекса лода.</p>
	 * <p>Границы переключения: 
	 * <listing>
	 * <ul>_limitsH = [1000, 800];</ul>  
	 * <ul>_limitsV = [800, 600]; </ul>
	 * </listing></p>
	 * 
	 * 
	 * @see LODmanager
	 * @see ILODManager
	 * @see alternativa.gui.lod.simple.LODlistenerPriority
	 * @see LayoutManager
	 * 
	 */	
	public class DefaultLODManager implements ILODManager {

		protected var objects:Vector.<Vector.<ISimpleLODobject>>;

		/**
		 * Текущий индекс лода. 
		 */		
		public var _LODIndex:int = -1;
		
		/**
		 * Приоритет лодирования. 
		 */		
		protected var maxPriorityIndex:int;

		/**
		 * Границы переключения лодов по горизонтали. 
		 * 
		 */	
		protected var _limitsH:Array;
		
		/**
		 * Границы переключения лодов по вертикали. 
		 * 
		 */	
		protected var _limitsV:Array;

		public function DefaultLODManager():void {

		}
		
		/**
		 * Инициализация DefaultLODManager.
		 * 
		 */		
		public function init():void {
			objects = new Vector.<Vector.<ISimpleLODobject>>();

			maxPriorityIndex = LODlistenerPriority.PANEL.value;
			
			var objectsCount:int = 0;
			
			for (var i:int = 0; i <= maxPriorityIndex; i++) {
				//objects.push(new Vector.<ISimpleLODobject>());
				objects[objectsCount] = new Vector.<ISimpleLODobject>();
				objectsCount++;
			}

			_limitsH = [1000, 800];
			_limitsV = [800, 600];
		}
		
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function add(object:ISimpleLODobject):void {
			var index:int = objects[object.LODpriority.value].indexOf(object);
			if (index == -1) {
				objects[object.LODpriority.value].push(object);
			}
			object.LODindex = _LODIndex;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function remove(object:ISimpleLODobject):void {
//			trace("DefaultLODManager remove");
			var index:int = objects[object.LODpriority.value].indexOf(object);
			if (index != -1) {
				objects[object.LODpriority.value].splice(index, 1);
			}
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		public function resize(width:int, height:int):void {
			var newIndex:int;
			var i:int;
			
//			trace("LOD Manager resize");
//			trace("     _limitsH: " + _limitsH);
//			trace("     _limitsV: " + _limitsV);
//			trace("     width: " + width);
//			trace("     height: " + height);

			newIndex = 0;
			for (i = 0; i < _limitsH.length; i++) {
				if (width <= _limitsH[i] && height <= _limitsV[i]) {
					newIndex = i+1;
				}
			}
						
//			trace("     _LODIndex: " + _LODIndex);
//    		trace("     newIndex: " + newIndex);
			// Сохранение индекса
			if (_LODIndex != newIndex) {
				_LODIndex = newIndex;
				
				for (var l:int = 0; l <= maxPriorityIndex; l++) {
					var level:Vector.<ISimpleLODobject> = objects[l];
//					trace("level["+l+"].length: " + level.length);
					if (level.length > 0) {
						// Установка index для всех SimpleLODobject одного уровню приоритета
						for (i = level.length - 1; i >= 0; i--) {
							var object:ISimpleLODobject = level[i];
//							trace("object.LODindex: " + object.LODindex);
//							trace("_LODIndex: " + _LODIndex);
							if (object.LODindex != _LODIndex) {
								object.LODindex = _LODIndex;
							}
						}
					}
				}
			}
		}
		
		
		/**
		 * @inheritDoc
		 * 
		 */	
		public function get limitsH():Array {
			return _limitsH;
		}
		
		public function set limitsH(value:Array):void {
			_limitsH = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */
		public function get limitsV():Array {
			return _limitsV;
		}
		
		public function set limitsV(value:Array):void {
			_limitsV = value;
		}
		
		/**
		 * @inheritDoc
		 * 
		 */
		public function get LODIndex():int {
			return _LODIndex;
		}
		public function set LODIndex(value:int):void {
			if (_LODIndex != value) {
				_LODIndex = value;

				for (var l:int = 0; l <= maxPriorityIndex; l++) {
					var level:Vector.<ISimpleLODobject> = objects[l];

					if (level.length > 0) {
						// Установка index для всех SimpleLODobject
						for (var i:int = level.length - 1; i >= 0; i--) {
							var object:ISimpleLODobject = level[i];
							object.LODindex = _LODIndex;
						}
					}
				}
			}
		}

		
	}
}
