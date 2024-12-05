package alternativa.editor.events {
	import flash.events.Event;

	public class LevelLoaded extends Event {
		public static const LEVEL_LOADED:String = "level_loaded";
		
		public function LevelLoaded(bubbles:Boolean=false, cancelable:Boolean=false) {
			super(LEVEL_LOADED, bubbles, cancelable);
		}
		
	}
}