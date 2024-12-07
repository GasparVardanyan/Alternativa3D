package alternativa.editor.propslib {
	import alternativa.engine3d.core.Object3D;
	
	/**
	 * Уровень деализации объекта.
	 */
	public class PropLOD extends ObjectContainer {
		
		public var distance:Number;
		
		/**
		 * Создаёт новый экземпляр объекта.
		 *  
		 * @param distance расстояние, на котором включается LOD
		 * @param object объект, представляющий данный уровень детализации. Если задано значение null, это означает, что начиная с указанной дистанции объект не отображается. 
		 */		
		public function PropLOD(distance:Number, object:PropObject) {
			super(object);
			this.distance = distance;
		}

	}
}