package alternativa.gui.event {
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * Повторитель, срабатывающий по событиям и вызывающий заданную функцию в заданном объекте.
	 */	
	public class EventRepeater {
		
		/**
		 * Объект, рассылающий события.
		 *  
		 */		
		protected var eventDispatcher:EventDispatcher;
		
		/**
		 * Объект, в котором вызывается повторяемая функция.
		 *  
		 */		
		protected var funcObject:Object;
		
		/**
		 * Повторяемая функция.
		 *  
		 */		
		protected var func:Function;
		
		/**
		 * Параметры вызываемой функции.
		 *  
		 */		
		protected var args:Array;
		
		/**
		 * Задержка срабатывания в мс.
		 * 
		 */		
		protected var delay:Number;
		
		/**
		 * Период повторения в мс.
		 * 
		 */		
		protected var repeatInterval:Number;
		
		/**
		 * id таймера задержки.
		 *  
		 */		
		protected var delayId:uint;
		
		/**
		 * id таймера повторений.
		 * 
		 */		
		protected var repeatId:uint;
		
		
		/**
		 * @param eventDispatcher Объект, рассылающий события.
		 * @param startEvent Событие, начинающее повторение.
		 * @param stopEvent Событие, останавливающее повторение.
		 * @param funcObject Объект, содержащий вызываемую функцию.
		 * @param func Вызываемая при повторении функция.
		 * @param delay Задержка перед началом повторений в мс.
		 * @param repeatInterval Период повторения в мс.
		 */	
		public function EventRepeater(eventDispatcher:EventDispatcher, startEvent:String, stopEvent:String, funcObject:Object, func:Function, args:Array = null, delay:Number = 200, repeatInterval:Number = 50) {
			this.eventDispatcher = eventDispatcher;
			this.funcObject = funcObject;
			this.func = func;
			this.args = args;
			this.delay = delay;
			this.repeatInterval = repeatInterval;
			// Подписка на события начала и конца
			eventDispatcher.addEventListener(startEvent, onStart);
			eventDispatcher.addEventListener(stopEvent, onStop);
		}
		
		/** 
		 * Отсчет задержки до начала повторений.
		 * 
		 */		
		protected function onStart(e:Event):void {
			delayId = setInterval(startRepeat, delay);
		}
		
		/**
		 * Начало повторения.
		 * 
		 */		
		protected function startRepeat():void {
			clearInterval(delayId);
			repeatId = setInterval(repeat, repeatInterval);
		}
		
		/**
		 * Вызов повторяемой функции.
		 * 
		 */		
		protected function repeat():void {
			func.apply(funcObject, args);
		}
		
		/**
		 * Остановка повторений.
		 * 
		 */		
		protected function onStop(e:Event):void {
			clearInterval(delayId);
			clearInterval(repeatId);
		}

	}
}