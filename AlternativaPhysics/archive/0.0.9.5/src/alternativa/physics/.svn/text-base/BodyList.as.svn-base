package alternativa.physics {
	
	/**
	 * 
	 */
	public class BodyList {
		
		public var head:BodyListItem;
		public var tail:BodyListItem;
		public var size:int;
		
		/**
		 * 
		 */
		public function BodyList() {
		}
		
		/**
		 * 
		 * @param body
		 */
		public function append(body:Body):void {
			var item:BodyListItem = BodyListItem.create(body);
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
		 * @param body
		 */
		public function remove(body:Body):Boolean {
			var item:BodyListItem = findItem(body);
			if (item == null) return false;
			if (item == head) {
				if (size == 1) {
					head = tail = null;
				} else {
					head = item.next;
					head.prev = null;
				}
			} else {
				if (item == tail) {
					tail = item.prev;
					tail.next = null;
				} else {
					item.prev.next = item.next;
					item.next.prev = item.prev;
				}
			}
			item.dispose();
			size--;
			return true;
		}
		
		/**
		 * 
		 * @param body
		 * @return 
		 */
		public function findItem(body:Body):BodyListItem {
			var item:BodyListItem = head;
			while (item != null && item.body != body) {
				item = item.next;
			}
			return item;
		}

	}
}