package alternativa.physics.rigid {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.types.Vector3;
	
	/**
	 * Информация о контакте между двумя телами. Содержит нормаль, множество точек контакта и прочие величины.
	 */
	public class Contact {
		
//		private static var pool:Vector.<ContactInfo> = new Vector.<ContactInfo>();
//		
//		public static function create():ContactInfo {
//			if (pool.length > 0) {
//				return pool.pop();
//			}
//			return new ContactInfo();
//		}
//		
//		public static function destroy(collInfo:ContactInfo):void {
//			collInfo.body1 = collInfo.body2 = null;
//			pool.push(collInfo);
//		}

		// Максимальное количество точек контакта
		private const N:int = 8;
		
		public var body1:Body;
		public var body2:Body;
		// Взаимный коэффициент отскока
		public var restitution:Number;
		// Взаимный коэффициент трения
		public var friction:Number;
		// Нормаль контакта. Направлена от второго тела к первому.
		public var normal:Vector3 = new Vector3();
		// Список точек контакта
		public var points:Vector.<ContactPoint> = new Vector.<ContactPoint>(N, true);
		// Количество точек контакта
		public var pcount:int;
		// Максимальная глубина пересечения тел
		public var maxPenetration:Number = 0;
		
		public var satisfied:Boolean;
		
		/**
		 * 
		 */
		public function Contact() {
			for (var i:int = 0; i < N; i++) points[i] = new ContactPoint();
		}
	
	}
}