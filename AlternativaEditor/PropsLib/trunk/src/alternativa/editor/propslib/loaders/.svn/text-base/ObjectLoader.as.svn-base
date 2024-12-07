package alternativa.editor.propslib.loaders {
	import flash.events.ErrorEvent;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.system.LoaderContext;

	[Event (name="complete", type="flash.events.Event")]
	[Event (name="ioError", type="flash.events.IOErrorEvent")]
	[Event (name="securityError", type="flash.events.SecurityErrorEvent")]
	/**
	 * 
	 */
	public class ObjectLoader extends EventDispatcher {
		
		/**
		 * 
		 */
		public function ObjectLoader() {
			super();
		}
		
		/**
		 * 
		 * @param loaderContext
		 */
		public function load(loaderContext:LoaderContext):void {
		}
		
		/**
		 * 
		 */
		public function complete():void {
			dispatchEvent(new Event(Event.COMPLETE));
		}
		
		/**
		 * 
		 */
		protected function onErrorEvent(e:ErrorEvent):void {
			dispatchEvent(e);
		}
		
	}
}