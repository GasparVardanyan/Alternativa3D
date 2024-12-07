package alternativa.editor.propslib.events {
	import flash.events.Event;

	public class PropLibProgressEvent extends Event {
		
		public static const PROGRESS:String = "progress";
		
		public var propsLoaded:int;
		public var propsTotal:int;
		
		public function PropLibProgressEvent(propsLoaded:int, propsTotal:int) {
			super(PROGRESS);
			this.propsLoaded = propsLoaded;
			this.propsTotal = propsTotal;
		}
		
		override public function clone():Event {
			return new PropLibProgressEvent(propsLoaded, propsTotal);
		}
	}
}