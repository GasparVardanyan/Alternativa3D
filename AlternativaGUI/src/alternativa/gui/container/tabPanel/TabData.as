package alternativa.gui.container.tabPanel {

    import alternativa.gui.controls.button.ITriggerButton;

    import flash.display.DisplayObject;
	
	
	/**
	 * Данные для контейнера с вкладками.
	 * 
	 * @see TabPanel
	 * 
	 */			
    public class TabData {
        /**
	    * Кнопка раздела.
	    *
	    */
        public var button:ITriggerButton;
        /**
	    * Контент раздела.
	    *
	    */
        public var content:DisplayObject;
		
		/**
		 * 
		 * @param button Кнопка раздела.
		 * @param content Контент раздела.
		 * 
		 */		
        public function TabData(button:ITriggerButton, content:DisplayObject) {
            this.button = button;
            this.content = content;
        }
    }
}
