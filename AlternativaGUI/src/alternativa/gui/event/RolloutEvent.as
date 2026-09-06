package alternativa.gui.event {
	import alternativa.gui.container.rollout.Rollout;
	
	import flash.events.Event;
		
	/**
	 * Класс RolloutEvent определяет события при изменении Rollout.
	 * 
	 */	
	public class RolloutEvent extends Event {
		
		/**
		 * Свернули контейнер. 
		 */		
		public static const MINIMIZE:String = "RolloutEventMimimize";
		
		/**
		 * Развернули контейнер. 
		 */		
		public static const MAXIMIZE:String = "RolloutEventMaximize";
		
		/**
		 * Контейнер. 
		 */		
		public var rollout:Rollout;
		
		/**
		 * 
		 * @param type Тип события.
		 * @param rollout Контейнер.
		 * 
		 */		
		public function RolloutEvent(type:String, rollout:Rollout) {
			super(type, true, true);
			this.rollout = rollout;
		}

	}
}