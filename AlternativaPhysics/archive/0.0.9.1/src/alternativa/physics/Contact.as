package alternativa.physics {
	
	
	import alternativa.math.Vector3;
	
	/**
	 * Описывает контакт одного или двух тел.
	 */
	public class Contact {
		/**
		 * Первое тело контакта, не может быть равно null.
		 */		
		public var body1:Body;
		/**
		 * Второе тело контакта, может быть равно null.
		 */
		public var body2:Body;
		/**
		 * Предрассчитанный взаимный коэффициент отскока.
		 */
		public var restitution:Number;
		/**
		 * Предрассчитанный взаимный коэффициент трения.
		 */
		public var friction:Number;
		/**
		 * Нормаль контакта. Направлена к первому телу.
		 */
		public var normal:Vector3 = new Vector3();
		/**
		 * Список точек контакта.
		 */
		public var points:Vector.<ContactPoint> = new Vector.<ContactPoint>(MAX_POINTS, true);
		/**
		 * Количество точек контакта.
		 */
		public var pcount:int;
		/**
		 * Максимальная глубина пересечения.
		 */
		public var maxPenetration:Number = 0;
		/**
		 * Флаг показывает, разрешён контакт или нет.
		 */
		public var satisfied:Boolean;
		/**
		 * Следующий контакт в списке.
		 */
		public var next:Contact;
		/**
		 * Индекс контакта. Первый контакт в списке имеет индекс 0.
		 */
		public var index:int;

		// Максимальное количество точек контакта
		private const MAX_POINTS:int = 8;
		
		/**
		 * 
		 */
		public function Contact(index:int) {
			this.index = index;
			for (var i:int = 0; i < MAX_POINTS; i++) {
				points[i] = new ContactPoint();
			}
		}
	
	}
}