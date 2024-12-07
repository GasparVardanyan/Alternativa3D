package alternativa.editor.propslib {
	import __AS3__.vec.Vector;
	
	/**
	 * Класс описывает данные пропа без состояния.
	 */
	public class StatelessData {
		/**
		 * 
		 */
		public var object:PropObject;
		/**
		 * Список LOD'ов объекта.
		 */		
		public var lods:Vector.<PropLOD>;
		
		/**
		 * 
		 * @param object
		 * @param lods
		 * @param PropLOD
		 */
		public function StatelessData(object:PropObject, lods:Vector.<PropLOD>) {
			this.object = object;
			this.lods = lods;
		}
		
		/**
		 * 
		 * @param distance
		 * @return 
		 */
		public function getLodByDistance(distance:Number):PropLOD {
			return null;
		}
		
		/**
		 * 
		 * @return 
		 */
		public function toString():String {
			return "[StatelessObject object=" + object + ", lods=" + lods + "]";
		}

	}
}