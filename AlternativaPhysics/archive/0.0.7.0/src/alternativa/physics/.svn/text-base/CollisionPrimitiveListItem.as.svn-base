package alternativa.physics {
	import alternativa.physics.collision.CollisionPrimitive;
	
	/**
	 * Элемент списка примитивов.
	 */
	public class CollisionPrimitiveListItem {
		
		// Верхний элемент хранилища
		private static var poolTop:CollisionPrimitiveListItem;

		/**
		 * Создаёт новый элемент списка.
		 * 
		 * @param primitive примитив, содержащийся в элементе
		 * @return новый элемент списка
		 */
		public static function create(primitive:CollisionPrimitive):CollisionPrimitiveListItem {
			var item:CollisionPrimitiveListItem;
			if (poolTop == null) {
				item = new CollisionPrimitiveListItem(primitive);
			} else {
				item = poolTop;
				item.primitive = primitive;
				poolTop = item.next;
				item.next = null; 
			}
			return item;
		}
		
		/**
		 * Очищает хранилище.
		 */
		public static function clearPool():void {
			var curr:CollisionPrimitiveListItem = poolTop;
			while (curr != null) {
				poolTop = curr.next;
				curr.next = null;
				curr = poolTop;
			}
		}
		
		/**
		 * Примитив, хранящийся в элементе списка.
		 */
		public var primitive:CollisionPrimitive;
		/**
		 * Ссылка не следующий элемент списка.
		 */
		public var next:CollisionPrimitiveListItem;
		/**
		 * Ссылка не предыдущий элемент списка.
		 */
		public var prev:CollisionPrimitiveListItem;
		
		/**
		 * Создаёт новый экземпляр.
		 * 
		 * @param primitive примитив, хранящийся в элементе списка
		 */
		public function CollisionPrimitiveListItem(primitive:CollisionPrimitive) {
			this.primitive = primitive;
		}
		
		/**
		 * Очищает внутренние ссылки и помещает элемент в хранилище для дальнейшего использования.
		 */
		public function dispose():void {
			primitive = null;
			prev = null;
			next = poolTop;
			poolTop = this;
		}

	}
}