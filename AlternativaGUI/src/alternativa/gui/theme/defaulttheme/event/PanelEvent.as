package alternativa.gui.theme.defaulttheme.event {

	import flash.events.Event;
	
	/**
	 * 
	 * RU: события рассылаемые панелью
     * EN: events are passed by panel
	 * 
	 */	
	public class PanelEvent extends Event {
		
		// RU: закрыли панель
        // EN: panel is closed
		public static const CLOSE:String = "CLOSE";
		
		// RU: нажали на заголовок панели
        // EN: panel title mouse down
		public static const MOUSE_DOWN:String = "MOUSE_DOWN";
		
		// RU: отжали
        // EN: panel title mouse up
		public static const MOUSE_UP:String = "MOUSE_UP";

		public function PanelEvent(type:String, bubbles:Boolean = true, cancelable:Boolean = false) {
			super(type, bubbles, cancelable);

		}

	}
}
