package alternativa.editor.eventjournal {
	import alternativa.types.Set;
	
	
	public class EventJournalItem {
		
		public var operation:int;
		public var props:Set;
		public var oldState:*;
	
		public function EventJournalItem(operation:int, props:Set, oldState:*) {
		
			this.operation = operation;
			this.props = props;
			this.oldState = oldState;
		} 
	}
}