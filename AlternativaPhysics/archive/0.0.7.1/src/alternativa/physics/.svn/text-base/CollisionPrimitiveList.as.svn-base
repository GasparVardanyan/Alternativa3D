package alternativa.physics {
	import alternativa.physics.collision.CollisionPrimitive;
	
	/**
	 * 
	 */
	public class CollisionPrimitiveList {
		
		public var head:CollisionPrimitiveListItem;
		public var tail:CollisionPrimitiveListItem;
		public var size:int;
		
		/**
		 * 
		 */
		public function CollisionPrimitiveList() {
		}
		
		/**
		 * 
		 * @param primitive
		 */
		public function append(primitive:CollisionPrimitive):void {
			var item:CollisionPrimitiveListItem = CollisionPrimitiveListItem.create(primitive);
			if (head == null) {
				head = tail = item;
			} else {
				tail.next = item;
				item.prev = tail;
				tail = item;
			}
			size++;
		}
		
		/**
		 * 
		 * @param primitve
		 */
		public function remove(primitve:CollisionPrimitive):void {
			if (head == null) return;
			var item:CollisionPrimitiveListItem = head;
			while (item != null) {
				if (item.primitive == primitve) break;
				item = item.next;
			}
			if (item == null) return;
			if (item == head) {
				if (size == 1) {
					head = tail = null;
				} else {
					head = item.next;
					head.prev = null;
				}
			} else {
				if (item == tail) {
					tail = tail.prev;
					tail.next = null;
				} else {
					item.prev.next = item.next;
					item.next.prev = item.prev;
				}
			}
			item.dispose();
			size--;
		}
		
		/**
		 * 
		 */
		public function clear():void {
			while (head != null) {
				var item:CollisionPrimitiveListItem = head;
				head = head.next;
				item.dispose();
			}
			tail = null;
			size = 0;
		}
		
	}
}