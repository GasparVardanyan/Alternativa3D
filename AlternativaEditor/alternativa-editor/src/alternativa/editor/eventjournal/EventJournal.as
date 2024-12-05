package alternativa.editor.eventjournal {
	import alternativa.types.Set;
	
	
	public class EventJournal {
		
		public static const ADD:int = 0;
		public static const DELETE:int = 1;
		public static const ROTATE:int = 2;
		public static const MOVE:int = 3;
		public static const COPY:int = 4;
		public static const CHANGE_TEXTURE:int = 5;

		private var events:Array;
		private var cancelEvents:Array; 
				
		public function EventJournal() {
			events = [];
			cancelEvents = [];
		}
		
		public function addEvent(operation:int, props:Set, oldState:* = null):void {
			
			events.push(new EventJournalItem(operation, props, oldState));
			cancelEvents.length = 0;
		}
		

		public function undo(deleteEvent:Boolean = false):EventJournalItem {
			var len:int = events.length; 
			if (len > 0) {
				var e:EventJournalItem = events[len - 1];
				events.pop();
				if (!deleteEvent) {
					cancelEvents.push(e);
				}
				return e; 
			}
			return null;
		}
		
		public function redo():EventJournalItem {
			var len:int = cancelEvents.length; 
			if (len > 0) {
				var e:EventJournalItem = cancelEvents[len - 1];
				cancelEvents.pop();
				events.push(e);
				return e;
			}
			return null;
		}
	}
}

	

