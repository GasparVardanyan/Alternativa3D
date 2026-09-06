package alternativa.gui.lod.auto {
	import alternativa.gui.lod.auto.AutoLODobject;
	
	import flash.display.DisplayObject;
	
	
	/**
	 * Лодируемый контейнер, выбирающий лод в зависимости от заданных ему размеров.
	 * 
	 */	
	public class AutoLODContainer extends AutoLODobject {
		
		/**
		 * Список дочерних объектов.
		 */	
		protected var _objects:Vector.<DisplayObject>;
		
		public function AutoLODContainer() {
			_objects = new Vector.<DisplayObject>();
		}
		
		/**
		 * Добавляет экземпляр дочернего элемента DisplayObject к экземпляру DisplayObjectContainer.
		 * <p>Дочерний элемент добавляется перед (сверху) всеми остальными дочерними элементами в данном экземпляре DisplayObjectContainer. 
		 * (Чтобы добавить дочерний элемент в конкретную позицию в индексе, используйте метод addChildAt()).</p>
		 * <p>Элемент добавляется в конец вектора objects.</p>
		 * 
		 * @param child Экземпляр DisplayObject для добавления в качестве нижестоящего элемента экземпляра DisplayObjectContainer. 
		 * @return Экземпляр DisplayObject, передаваемый в параметр child. 
		 * 
		 */	
		override public function addChild(child:DisplayObject):DisplayObject {
			if (_objects.indexOf(child) == -1) {
				super.addChild(child);
				_objects.push(child);
			}
			return child;
		}
		
		/**
		 * Добавляет экземпляр дочернего элемента DisplayObject к экземпляру DisplayObjectContainer. 
		 * <p>Дочерний элемент добавляется к указанной позиции индекса. Индекс 0 представляет собой заднюю (нижнюю) часть списка отображения для объекта DisplayObjectContainer.</p>
		 * <p>Элемент добавляется к указанной позиции индекса в вектор objects.</p> 
		 * 
		 * @param child Экземпляр DisplayObject для добавления в качестве нижестоящего элемента экземпляра DisplayObjectContainer. 
		 * @param index Позиция индекса для добавления нижестоящего элемента. При указании занятой в настоящее время позиции индекса существующий в данной позиции дочерний объект и все вышестоящие позиции перемещаются по списку на одну позицию вверх. 
		 * @return Экземпляр DisplayObject, передаваемый в параметр child.
		 * 
		 */
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if (_objects.length >= index) {
				_objects.splice(index, 0, child);
				super.addChildAt(child, index);
			}
			return child;
		}
		
		/**
		 * Удаляет заданный объект child DisplayObject из списка дочерних элементов экземпляра DisplayObjectContainer. 
		 * <p>Свойство parent удаленного дочернего элемента получает значение null, а сам объект утилизуется в ходе «сборки мусора», если отсутствуют другие ссылки на дочерний элемент. Позиции индекса экранных объектов, расположенных над дочерним элементом в DisplayObjectContainer уменьшаются на 1.</p>
		 * <p>Элемент удаляется из вектора objects.</p>
		 *   
		 * @param child Удаляемый экземпляр DisplayObject. 
		 * @return Экземпляр DisplayObject, передаваемый в параметр child. 
		 * 
		 */	
		override public function removeChild(child:DisplayObject):DisplayObject {
			var index:int = _objects.indexOf(child);
			if (index != -1) {
				super.removeChild(child);
				_objects.splice(index, 1);
			}
			return child;
		}
		
		/**
		 * Удаляет дочерний DisplayObject из заданной позиции index в списке дочерних объектов DisplayObjectContainer. 
		 * <p>Свойство parent удаленного дочернего элемента получает значение null, а сам объект очищается, если нет других ссылок на дочерние элементы. Позиции индекса экранных объектов, расположенных над дочерним элементом в DisplayObjectContainer уменьшаются на 1.</p>
		 * <p>Элемент удаляется из вектора objects.</p>
		 * 
		 * @param index Удаляемый индекс нижестоящего элемента DisplayObject. 
		 * @return Удаленный экземпляр DisplayObject. 
		 * 
		 */	
		override public function removeChildAt(index:int):DisplayObject {
			var child:DisplayObject = _objects[index] as DisplayObject;
			if (child != null) {
				super.removeChildAt(index);
				_objects.splice(index, 1);
			}
			return child;
		}
				
		/**
		 * Список дочерних объектов. 
		 * 
		 */	
		public function get objects():Vector.<DisplayObject> {
			return _objects;
		}

	}
}