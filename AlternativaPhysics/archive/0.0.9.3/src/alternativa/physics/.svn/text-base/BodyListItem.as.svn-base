package alternativa.physics {
	
	/**
	 * 
	 */
	public class BodyListItem {
		
		// Верхний элемент хранилища
		private static var poolTop:BodyListItem;

		/**
		 * Создаёт новый элемент списка.
		 * 
		 * @param primitive примитив, содержащийся в элементе
		 * @return новый элемент списка
		 */
		public static function create(body:Body):BodyListItem {
			var item:BodyListItem;
			if (poolTop == null) {
				item = new BodyListItem(body);
			} else {
				item = poolTop;
				poolTop = item.next;
				item.next = null;
				item.body = body;
			}
			return item;
		}
		
		/**
		 * Очищает хранилище.
		 */
		public static function clearPool():void {
			var item:BodyListItem = poolTop;
			while (item != null) {
				poolTop = item.next;
				item.next = null;
				item = poolTop;
			}
		}
		
		/**
		 * 
		 */
		public var body:Body;
		/**
		 * 
		 */
		public var next:BodyListItem;
		/**
		 * 
		 */
		public var prev:BodyListItem;
		
		/**
		 * 
		 * @param body
		 */
		public function BodyListItem(body:Body) {
			this.body = body;
		}
		
		/**
		 * 
		 */
		public function dispose():void {
			body = null;
			prev = null;
			next = poolTop;
			poolTop = this;
		}

	}
}