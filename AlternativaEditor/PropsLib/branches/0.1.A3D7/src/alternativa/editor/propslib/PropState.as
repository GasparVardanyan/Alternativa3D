package alternativa.editor.propslib {
	import alternativa.engine3d.core.Object3D;
	
	/**
	 * Описание состояния объекта. Состояние может быть задано либо одним объектом, либо набором LOD'ов.
	 */
	public class PropState extends StatelessObject {
		/**
		 * Наименование состояния.
		 */		
		public var name:String;
		
		/**
		 * Создаёт новый экземпляр объекта. Если параметры object и lods одновременно равны null, создаётся исключение.
		 * 
		 * @param name наименование состояния
		 * @param object объект, представляющий состояние. Если указано ненулевое значение, массив lods игнорируется
		 * @param lods набор LOD'ов объекта. Параметр учитывется только если параметр object имеет нулевое значение.
		 */		
		public function PropState(name:String, object:PropObject, lods:Array) {
			super(object, lods);
			this.name = name;
		}

	}
}