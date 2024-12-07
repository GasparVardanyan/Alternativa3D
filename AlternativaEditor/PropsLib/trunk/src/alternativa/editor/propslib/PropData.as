package alternativa.editor.propslib {
	import alternativa.types.Map;
	import __AS3__.vec.Vector;
	
	/**
	 * Описание пропа. Проп может быть двух видов: без состояния и с состояниями. Проп без состояния содержит свои данные в поле statlessData,
	 * поле states при этом равно null. Проп с состояниями содержит данные в поле states, поле statelessData при этом равно null.
	 */
	public class PropData {
		/**
		 * Наименование пропа.
		 */		
		public var name:String;
		/**
		 * Данные пропа без состояний.
		 */		
		public var statelessData:StatelessData;
		/**
		 * Список состояний пропа.
		 */		
		public var states:Vector.<PropState>;
		
		/**
		 * 
		 * @param name
		 */
		public function PropData(name:String) {
			this.name = name;
		}
		
		/**
		 * Добавляет состояние пропа.
		 * 
		 * @param state добавляемое состояние
		 */
		public function addState(state:PropState):void {
			if (states == null) {
				states = new Vector.<PropState>();
			}
			states.push(state);
		}
		
		/**
		 * Получает состояние пропа по заданному имени состояния.
		 *  
		 * @param stateName имя состояния
		 * @return состояние пропа с заданным именем или null, если такого состояния не найдено
		 */
		public function getStateByName(stateName:String):PropState {
			if (states == null) {
				return null;
			}
			for each (var state:PropState in states) {
				if (state.name == stateName) {
					return state;
				}
			}
			return null;
		}
		
		/**
		 * 
		 */
		public function toString():String {
			return "[Prop name=" + name + ", statelessData=" + statelessData + "]";
		}

	}
}