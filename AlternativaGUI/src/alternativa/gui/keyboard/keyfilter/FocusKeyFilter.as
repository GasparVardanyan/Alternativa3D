package alternativa.gui.keyboard.keyfilter {
	import alternativa.gui.keyboard.IKeyFilter;
	import alternativa.init.GUI;
	
	import flash.display.InteractiveObject;
	import flash.events.KeyboardEvent;
	import flash.utils.getQualifiedClassName;
	
	/**
	 * Фильтр событий клавиатуры, проверяющий кроме фильтруемых клавиш в фокусе ли нужный объект.
	 */
	public class FocusKeyFilter implements IKeyFilter {
		
		/**
		 * Объект, который должен быть в фокусе. 
		 */		
		private var focusObject:InteractiveObject;
		
		/**
		 * Фильтр событий клавиатуры.
		 */
		private var keyFilter:IKeyFilter;
		
		
		/**
		 * @param focusObject Объект, который должен быть в фокусе.
		 * @param keyFilter Фильтр событий клавиатуры.
		 */		
		public function FocusKeyFilter(focusObject:InteractiveObject, keyFilter:IKeyFilter) {
			this.focusObject = focusObject;
			this.keyFilter = keyFilter;
		}
		
		/**
		 * Профильтровать событие клавиатуры.
		 * @param e Событие.
		 * @return Результат фильтрования.
		 */	
		public function filter(e:KeyboardEvent):Boolean {
			return ((focusObject == GUI.stage.focus) && keyFilter.filter(e));
		}
		
		/**
		 * Список фильтруемых клавиш.
		 */
		public function get keyCode():Array {
			return keyFilter.keyCode;
		}
		
		/**
		 * @private
		 */
		public function toString():String {
			var result:String = new String();
			result+= "["+getQualifiedClassName(this)+"] " + "keyFilter: " + keyFilter;
			
			return result;	
		}
		
	}
}