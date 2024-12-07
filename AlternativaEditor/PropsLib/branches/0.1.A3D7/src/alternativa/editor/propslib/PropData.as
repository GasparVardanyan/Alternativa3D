package alternativa.editor.propslib {
	
	/**
	 * 
	 */
	public class PropData {
		/**
		 * Наименование пропа.
		 */		
		public var name:String;
		/**
		 * Данные пропа без состояний.
		 */		
		public var statelessData:StatelessObject;
		/**
		 * Список состояний пропа. Каждый элемент является объектом типа PropState.
		 */		
		public var states:Array;
		
		/**
		 * 
		 * @param name
		 * @param object
		 * @param states
		 * @param lods
		 */
		public function PropData(name:String) {
			this.name = name;
		}
		
		/**
		 * 
		 * @param state
		 */
		public function addState(state:PropState):void {
			if (states == null) {
				states = new Array();
			}
			states.push(state);
		}
		
		/**
		 * 
		 * @param stateName
		 * @return 
		 */
		public function getStateByName(stateName:String):PropState {
			if (states == null) {
				return null;
			}
			for (var i:int = 0; i < states.length; i++) {
				var state:PropState = states[i];
				if (state.name == stateName) {
					return state;
				}
			}
			return null;
		}
		
		public function toString():String {
			return "[Prop name=" + name + ", statelessData=" + statelessData + "]";
		}

	}
}