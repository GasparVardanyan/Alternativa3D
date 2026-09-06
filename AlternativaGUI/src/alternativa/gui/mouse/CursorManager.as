package alternativa.gui.mouse {
    
    import flash.ui.Mouse;
    import flash.ui.MouseCursor;
		
	
	/**
	 * Менеджер для работы с курсорами.
	 * <p>Регистрирует курсоры и управляет отображением.</p>
	 * <p>Если заданный курсор не найден среди зарегистрированных, то показывается курсор по умолчанию: MouseCursor.AUTO.</p>
	 * 
	 * <p>Чтобы заменить имеющиеся курсоры, достаточно их назвать так же.</p>
	 * 
	 * @see CursorData
	 * @see flash.ui.MouseCursor 
	 * 
	 */	
    public class CursorManager {
		
		/**
		 * Экземпляр CursorManager.  
		 */		
        protected static var instance:CursorManager;
		
		/**
		 * Флаг принудительного отображения заданного курсора.
		 */		
        protected var _showCursor:Boolean = false;
		
		/**
		 * Текущий тип курсора. 
		 */		
        protected var _cursorType:String;
		
		/**
		 * Задает отображение указателя мыши в виде стрелки. 
		 */		
		public static const ARROW:String = "arrow";
		
		/**
		 * Задает отображение указателя мыши в виде руки, нажимающей кнопку. 
		 */		
		public static const BUTTON:String = "button";
		
		/**
		 * Задает отображение указателя мыши в виде руки, перетаскивающей предмет. 
		 */		
		public static const HAND:String = "hand";
		
		/**
		 * Задает использование I-образного курсора.
		 */		
		public static const IBEAM:String = "ibeam";
		
		/**
		 * Задает отображение указателя мыши изменения размеров по вертикали.
		 */		
		public static const SIZE_NS:String = "sizens";
		
		/**
		 * Задает отображение указателя мыши изменения размеров по горизонтали.
		 */		
		public static const SIZE_WE:String = "sizewe";
		
		/**
		 * Задает отображение указателя мыши изменения размеров по диагонали 1.
		 */		
		public static const SIZE_NWSE:String = "sizenwse";
		
		/**
		 * Задает отображение указателя мыши изменения размеров по диагонали 2.
		 */		
		public static const SIZE_NESW:String = "sizenesw";
		
		/**
		 * Задает отображение указателя мыши занятости.
		 */		
		public static const WAIT_CURSOR:String = "waitcursor";
		
		/**
		 * Задает отображение указателя мыши в виде креста.
		 */		
		public static const CROSS:String = "cross";
		
        public function CursorManager():void {
        }
		
		/**
		 * Инициализация CursorManager и регистрация курсоров.
		 * @param cursors Вектор с данными курсоров.
		 * 
		 */		
        public static function init(cursors:Vector.<CursorData> = null):void {
            if (instance == null && Mouse.supportsNativeCursor) {
                instance = new CursorManager();
                if (cursors != null) {
                    for (var i:int = 0; i < cursors.length; i++) {
                        Mouse.registerCursor(cursors[i].cursorName, cursors[i].cursorData);
                    }
                }
				Mouse.cursor = ARROW;
            }
        }
		
		/**
		 * Тип курсора.
		 * <p>Если такой тип курсора не зарегистрирован, показываем по умолчанию AUTO.</p> 
		 * 
		 */		
        public static function get cursorType():String {
            if (instance != null) {
                return instance._cursorType;
            } else {
                return null;
            }
        }
        public static function set cursorType(value:String):void {
//			COMPILER::DEBUG {
//				var clientLog:IClientLog = OSGi.getInstance().getService(IClientLog) as IClientLog;
//				clientLog.log("CURSOR", "cursorType: %1", value);
//			}
            if (instance != null && !instance._showCursor) {
                try {
                    instance._cursorType = value;
                    Mouse.cursor = value;
                }
                catch (e:Error) {
                    Mouse.cursor = MouseCursor.AUTO;
                    instance._cursorType = MouseCursor.AUTO;
                    //throw new Error("нет такого курсора");
                }
            }
        }

		/**
		 * Сброс курсора. 
		 * 
		 */        
        public static function reset():void {
//			COMPILER::DEBUG {
//				var clientLog:IClientLog = OSGi.getInstance().getService(IClientLog) as IClientLog;
//				clientLog.log("CURSOR", "reset");
//			}
            if (instance != null && !instance._showCursor) {
                Mouse.cursor = ARROW;
            }
        }

		/**
		 * Включает указанный курсор, который нельзя выключить с помощью метода reset(). Сброс курсора - hideCursor().   
		 * @param value Имя зарегистрированного курсора. Если курсор с таким именем не найден, показывается курсор по умолчанию(MouseCursor.AUTO).
		 * 
		 * @see #hideCursor
		 */        
        public static function showCursor(value:String):void {
//			COMPILER::DEBUG {
//				var clientLog:IClientLog = OSGi.getInstance().getService(IClientLog) as IClientLog;
//				clientLog.log("CURSOR", "showCursor: %1", value);
//			}
            if (instance != null) {
                instance._showCursor = true;
                try {
                    Mouse.cursor = value;
                }
                catch (e:Error) {
                    Mouse.cursor = MouseCursor.AUTO;
                }
            }
        }

		/**
		 * Сброс курсора, после показа с помощью метода showCursor().
		 * 
		 * @see #showCursor
		 */		
        public static function hideCursor():void {
//			COMPILER::DEBUG {
//				var clientLog:IClientLog = OSGi.getInstance().getService(IClientLog) as IClientLog;
//				clientLog.log("CURSOR", "hideCursor");
//			}
            if (instance != null) {
                instance._showCursor = false;
                Mouse.cursor = ARROW;
            }
        }
    }
}
