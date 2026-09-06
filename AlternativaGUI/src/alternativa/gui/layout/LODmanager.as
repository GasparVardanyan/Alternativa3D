package alternativa.gui.layout {
	import alternativa.gui.lod.simple.ISimpleLODobject;

	
	/**
	 * Базовый класс LODmanager.
	 * <p>Менеджер отвечает за детализацию объектов(лоды) на сцене.
	 * Менеджер рассылает индекс лода всем объектам с интерфейсом ISimpleLODobject.</p>
	 * <p>Номер лода(LODIndex) зависит от высоты и ширины stage, которая передается в LODmanager из LayoutManager. 
	 * В зависимости от номера лода, объект может изменять скины, данные, убирать/показывать разные панели и т.д.
	 * После изменения номера лода, надо делать перерисовку(вызов draw).</p>
	 * <p>Для изменения границ переключения индекса можно воспользоваться сеттерами на limitsH и limitsV, которым передается массив с границами.</p>
	 * <p>Также есть список LODlistenerPriority, который имеет набор приоритетов, 
	 * т.е. вначале рассылается номер лода объектам имеющим низкий приоритет (SIMPLE_OBJECT), и далее уже тем, кто выше, заканчивая PANEL.</p>
	 * 
	 * @see DefaultLODManager
	 * @see ILODManager
	 * @see alternativa.gui.lod.simple.LODlistenerPriority
	 * @see alternativa.gui.lod.simple.ISimpleLODobject
	 * @see alternativa.gui.lod.simple.SimpleLODobject
	 * @see alternativa.gui.lod.simple.SimpleLODbitmap
	 * @see LayoutManager
	 * 
	 * 
	 */	
	public class LODmanager {
		
		/**
		 * Кастомный менеджер LODmanager. 
		 */		
		public static var manager:ILODManager;

		protected var instance:ILODManager; 
		
		/**
		 * Инициализация LODmanager.
		 * @param _manager Кастомный менеджер.
		 * 
		 */		
		public static function init(_manager:ILODManager):void {
//	    	trace("LODmanager init");
//	    	if (instance == null) {
//            	instance = new LODmanager();
//        	}
			if (manager == null) {
				manager = _manager;
				manager.init();
			}
		}
		
		/**
		 * Добавление объекта. 
		 * 
		 */		
		public static function add(object:ISimpleLODobject):void {
//	    	trace("LODmanager add");
			manager.add(object);
		}

		/**
		 * Удаление объекта.
		 * 
		 */		
		public static function remove(object:ISimpleLODobject):void {
//	    	trace("LODmanager remove");
			manager.remove(object);
		}
		
		/**
		 * Изменение размеров.
		 * @param width Ширина.
		 * @param height Высота.
		 * 
		 */		
		public static function resize(width:int, height:int):void {
			manager.resize(width, height);
		}
		
		/**
		 * Принудительное переключение LODindex.
		 * <p>Отладочная возможность.</p>
		 */
		public static function get LODIndex():int {
			return manager.LODIndex;
		}
		public static function set LODIndex(value:int):void {
			manager.LODIndex = value;
		}
		
		/**
		 * Границы переключения лодов по горизонтали. 
		 * 
		 */	
		public static function get limitsH():Array {
			return manager.limitsH;
		}
		public static function set limitsH(value:Array):void {
			manager.limitsH = value;
		}
		
		/**
		 * Границы переключения лодов по вертикали. 
		 * 
		 */	
		public static function get limitsV():Array {
			return manager.limitsV;
		}
		public static function set limitsV(value:Array):void {
			manager.limitsV = value;
		}
	}
}
