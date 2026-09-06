package alternativa.init {
	import alternativa.gui.enum.Align;
	import alternativa.gui.keyboard.KeyboardManager;
	import alternativa.gui.layout.DefaultLayoutManager;
	import alternativa.gui.layout.ILayoutManager;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.layout.RedrawManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.primitives.Logo;
	import alternativa.gui.utils.MouseUtils;

	import flash.display.DisplayObjectContainer;
	import flash.display.Stage;
	import flash.events.Event;
	
	
	public class GUI {
		
		public static var stage:Stage;
		
		public static var mouseManager:MouseManager;
		public static var keyboardManager:KeyboardManager;
		//public static var focusManager:FocusManager;
		
		/**
		 * @private
		 */
		private static var logo:Logo;
		/**
		 * @private
		 */
		private static var _logoAlign:Align;
		/**
		 * @private
		 */
		private static var _logoHorizontalMargin:Number = 7;
		/**
		 * @private
		 */
		private static var _logoVerticalMargin:Number = 7;
		
		/**
		 * Иницализация GUI. 
		 * 
		 * @param stage Сцена. 
		 * @param showLogo Флаг отображения логотипа.
		 * 
		 */		
		//public static function init(stage:Stage, hintContainer:DisplayObjectContainer, showLogo:Boolean = true):void {
		public static function init(stage:Stage, showLogo:Boolean = true):void {
			_logoAlign = Align.BOTTOM_RIGHT;
			
			GUI.stage = stage;
			
			// инициализация мыши
			//MouseManager.init(hintContainer);
			MouseManager.init(stage);
			
			// инициализация клавиатуры
			KeyboardManager.init(stage);
			
			MouseUtils.init(stage);
			
			if (showLogo) {
				GUI.showLogo();
			}
			
			// инициализация фокуса
//			focusManager = new FocusManager();
//			focusManager.init(stage);
		}
		
		/**
		 * @private
		 */
		private static function resizeLogo(e:Event = null):void {
			if (logo != null) {
				if (_logoAlign == Align.TOP_LEFT || _logoAlign == Align.LEFT || _logoAlign == Align.BOTTOM_LEFT) {
					logo.x = Math.round(_logoHorizontalMargin);
				}
				if (_logoAlign == Align.TOP || _logoAlign == Align.BOTTOM) {
					logo.x = Math.round((GUI.stage.stageWidth - logo.width)/2);
				}
				if (_logoAlign == Align.TOP_RIGHT || _logoAlign == Align.RIGHT || _logoAlign == Align.BOTTOM_RIGHT) {
					logo.x = Math.round(GUI.stage.stageWidth - _logoHorizontalMargin - logo.width);
				}
				if (_logoAlign == Align.TOP_LEFT || _logoAlign == Align.TOP || _logoAlign == Align.TOP_RIGHT) {
					logo.y = Math.round(_logoVerticalMargin);
				}
				if (_logoAlign == Align.LEFT || _logoAlign == Align.RIGHT) {
					logo.y = Math.round((GUI.stage.stageHeight - logo.height)/2);
				}
				if (_logoAlign == Align.BOTTOM_LEFT || _logoAlign == Align.BOTTOM || _logoAlign == Align.BOTTOM_RIGHT) {
					logo.y = Math.round(GUI.stage.stageHeight - _logoVerticalMargin - logo.height);
				}
			}
		}
		
		/**
		 * Показывает логотип.
		 */
		public static function showLogo():void {
			if (logo == null) {
				logo = new Logo();
				GUI.stage.addChild(logo);
				GUI.stage.addEventListener(Event.RESIZE, resizeLogo);
				resizeLogo();
			}
		}
		
		/**
		 * Убирает логотип.
		 */
		public static function hideLogo():void {
			if (logo != null) {
				GUI.stage.removeEventListener(Event.RESIZE, resizeLogo);
				if (GUI.stage.contains(logo)) {
					GUI.stage.removeChild(logo);
				}
				logo = null;
			}
		}
		
		/**
		 * Выравнивание логотипа относительно сцены.
		 * Можно использовать константы класса <code>Align</code>.
		 */
		public static function get logoAlign():Align {
			return _logoAlign;
		}
		
		/**
		 * @private
		 */
		public static function set logoAlign(value:Align):void {
			_logoAlign = value;
			resizeLogo();
		}
		
		/**
		 * Отступ логотипа от края сцены по горизонтали.
		 */
		public static function get logoHorizontalMargin():Number {
			return _logoHorizontalMargin;
		}
		
		/**
		 * @private
		 */
		public static function set logoHorizontalMargin(value:Number):void {
			_logoHorizontalMargin = value;
			resizeLogo();
		}
		
		/**
		 * Отступ логотипа от края сцены по вертикали.
		 */
		public static function get logoVerticalMargin():Number {
			return _logoVerticalMargin;
		}
		
		/**
		 * @private
		 */
		public static function set logoVerticalMargin(value:Number):void {
			_logoVerticalMargin = value;
			resizeLogo();
		}

	}
}