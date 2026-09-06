package alternativa.gui.data {
	
	import alternativa.gui.event.DataChangeEvent;
	import alternativa.gui.event.DataChangeType;
	
	import flash.events.EventDispatcher;

	/**
	 * В классе DataProvider предусмотрены методы и свойства, которые позволяют запрашивать и изменять данные в любом компоненте, основанном на списке (List, DropDownList, DropDownMenu, Tree). 
	 * <p>Поставщик данных — это линейная коллекция элементов, которая служат источником данных (например, массив). Каждый элемент в поставщике данных является объектом, содержащим одно или несколько полей данных. 
	 * Элементы, которые содержатся в поставщике данных, можно вызвать, указав их индекс, при помощи метода DataProvider.getItemAt().</p>
	 */	
	public class DataProvider extends EventDispatcher {
		
		/**
		 * Вектор объектов. 
		 */		
		protected var data:Vector.<Object>;
		
		/**
		 * Способ сортировки: по возрастанию 
		 */		
		public static const ASC:String = "ASC";
		/**
		 * Способ сортировки: по убыванию 
		 */
		public static const DESC:String = "DESC";

		/**
		 * 
		 * @param value Вектор объектов
		 * 
		 */		
		public function DataProvider(value:Vector.<Object>=null) {			
			if (value == null) {
				data = new Vector.<Object>();
			} else {
				data = value;				
			}
		}
		
		/**
		 * Число элементов, содержащихся в поставщике данных. 
		 * 
		 */		
		public function get length():uint {
			return data.length;
		}

//		public function invalidateItemAt(index:int):void {
//			checkIndex(index,data.length-1)
//			dispatchChangeEvent(DataChangeType.INVALIDATE,[data[index]],index,index);
//		}


//		public function invalidateItem(item:Object):void {
//			var index:uint = getItemIndex(item);
//			if (index == -1) { return; }
//			invalidateItemAt(index);
//		}

//		public function invalidate():void {
//			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE, DataChangeType.INVALIDATE_ALL,data.concat(),0,data.length));
//		}

		/**
		 * Добавляет новый элемент к поставщику данных в заданном положении индекса. 
		 * @param item Объект, содержащий данные добавляемого элемента.
		 * @param index Индекс добавления элемента.
		 * 
		 */		
		public function addItemAt(item:Object,index:uint):void {
			checkIndex(index,data.length);
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),index,index);
			data.splice(index,0,item);
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),index,index);
		}
		
		/**
		 * Добавляет элемент в конец набора данных, предоставляемого поставщиком данных.  
		 * @param item Элемент, добавляемый в конец текущего поставщика данных. 
		 * 
		 */		
		public function addItem(item:Object):void {
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),data.length-1,data.length-1);
			data.push(item);
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>([item]),data.length-1,data.length-1);
		}
		
		/**
		 * Добавляет несколько элементов в поставщик данных по указанному индексу и отправляет событие DataChangeType.ADD.  
		 * @param items Элементы, добавляемые в поставщик данных.
		 * @param index Индекс положения вставки элементов. 
		 * 
		 */		
		public function addItemsAt(items:Array,index:uint):void {
			checkIndex(index,data.length);
			var arr:Vector.<Object> = Vector.<Object>(items);
			dispatchPreChangeEvent(DataChangeType.ADD,Vector.<Object>(arr),index,index+arr.length-1);			
			data.splice.apply(data, [index,0].concat(items));
			dispatchChangeEvent(DataChangeType.ADD,Vector.<Object>(arr),index,index+arr.length-1);
		}
		
		/**
		 * Добавляет несколько элементов в конец набора данных DataProvider и отправляет событие DataChangeType.ADD. Элементы, которые добавляются в том порядке, в котором они указаны. 
		 * @param items Элементы, добавляемые в конец поставщика данных.
		 * 
		 */		
		public function addItems(items:Array):void {
			addItemsAt(items,data.length);
		}
		
		/**
		 * Дописывает указанные элементы в конец набора данных, предоставляемых текущим поставщиком данных. 
		 * @param items Элементы, добавляемые в поставщик данных. 
		 * 
		 */		
		public function concat(items:Array):void {
			addItems(items);
		}

//		public function merge(newData:Object):void {
//			var arr:Array = getDataFromObject(newData);
//			var l:uint = arr.length;
//			var startLength:uint = data.length;
//			
//			dispatchPreChangeEvent(DataChangeType.ADD,data.slice(startLength,data.length),startLength,this.data.length-1);
//			
//			for (var i:uint=0; i<l; i++) {
//				var item:Object = arr[i];
//				if (getItemIndex(item) == -1) {
//					data.push(item);
//				}
//			}
//			if (data.length > startLength) {
//				dispatchChangeEvent(DataChangeType.ADD,data.slice(startLength,data.length),startLength,this.data.length-1);
//			} else {
//				dispatchChangeEvent(DataChangeType.ADD,[],-1,-1);
//			}
//		}

		/**
		 * Возвращает элемент из заданного положения индекса.  
		 * @param index Местоположение возвращаемого элемента. 
		 * @return Элемент в заданном положении индекса. 
		 * 
		 */		
		public function getItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			return data[index];
		}

		/**
		 * Возвращает индекс заданного элемента.  
		 * @param item Искомый элемент. 
		 * @return Индекс возвращаемого элемента, или -1, если указанный элемент не найден. 
		 * 
		 */		
		public function getItemIndex(item:Object):int {
			return data.indexOf(item);
		}
		
		
		/**
		 * Возвращает объект, у которого значение поля fieldName совпадает с value.
		 * @param fieldName Поле, по которому будет производиться поиск.
		 * @param value Искомое значение.
		 * @return Элемент который соответствует запросу поиска.
		 * 
		 */		
		public function getItemAtByField(fieldName:String, value:*):Object {
			var i:int = 0;
			var obj:Object = null;
			for (i = 0; i < data.length; i++) {
				if (data[i][fieldName] == value) {
					obj = data[i];
					break;
				}
			}
			return obj;
		}
		
		// отдаем идекс объекта, у которого значение поля совпадает с value
		/**
		 * Возвращает индекс объекта, у которого значение поля fieldName совпадает с value.
		 * @param fieldName Поле, по которому будет производиться поиск.
		 * @param value Искомое значение.
		 * @return Элемент который соответствует запросу поиска.
		 * 
		 */		
		public function getItemIndexByField(fieldName:String, value:*):int {
			return data.indexOf(getItemAtByField(fieldName, value));
		}
		
		/**
		 * Удаляет элемент в заданном положении индекса и передает событие DataChangeType.REMOVE. 
		 * @param index Индекс удаляемого элемента. 
		 * @return Удаленный элемент. 
		 * 
		 */		
		public function removeItemAt(index:uint):Object {
			checkIndex(index,data.length-1);
			dispatchPreChangeEvent(DataChangeType.REMOVE, data.slice(index,index+1), index, index);
			var arr:Vector.<Object> = data.splice(index,1);
			dispatchChangeEvent(DataChangeType.REMOVE,arr,index,index);
			return arr[0];
		}
		
		/**
		 * Удаляет указанный элемент из поставщика данных и отправляет событие DataChangeType.REMOVE. 
		 * @param item Удаляемый элемент. 
		 * @return Удаленный элемент.  
		 * 
		 */		
		public function removeItem(item:Object):Object {
			var index:int = getItemIndex(item);
			if (index != -1) {
				return removeItemAt(index);
			}
			return null;
		}
		
		/**
		 * Удаляет все элементы из поставщика данных и отправляет событие DataChangeType.REMOVE_ALL.  
		 * 
		 */		
		public function removeAll():void {
			var arr:Vector.<Object> = data.concat();
			
			dispatchPreChangeEvent(DataChangeType.REMOVE_ALL,arr,0,arr.length);
			//data = new Vector.<Object>();
			data.length = 0;
			dispatchChangeEvent(DataChangeType.REMOVE_ALL,data,0,data.length);
		}
		
		/**
		 * Заменяет существующий элемент новым и отправляет событие DataChangeType.REPLACE.  
		 * @param newItem Элемент-заместитель. 
		 * @param oldItem Заменяемый элемент. 
		 * @return Замененный элемент. 
		 * 
		 */		
		public function replaceItem(newItem:Object,oldItem:Object):Object {
			var index:int = getItemIndex(oldItem);
			if (index != -1) {
				return replaceItemAt(newItem,index);
			}
			return null;
		}

		/**
		 * Заменяет элемент с указанным индексом и отправляет событие DataChangeType.REPLACE.  
		 * @param newItem Элемент-заместитель. 
		 * @param index Индекс заменяемого элемента. 
		 * @return Замененный элемент. 
		 * 
		 */		
		public function replaceItemAt(newItem:Object,index:uint):Object {
			checkIndex(index,data.length-1);
			var arr:Vector.<Object> = Vector.<Object>([data[index]]);
			dispatchPreChangeEvent(DataChangeType.REPLACE,arr,index,index);
			data[index] = newItem;
			dispatchChangeEvent(DataChangeType.REPLACE,arr,index,index);
			return arr[0];
		}
		
		/**
		 * Сортирует элементы в поставщике данных и отправляет событие DataChangeType.SORT.  
		 * @param sortArgs Аргументы, используемый при сортировке. 
		 * @return Возвращаемое значение зависит от того, получает ли метод какие-либо аргументы. Более подробные сведения см. в описании метода Array.sort(). Этот метод возвращает 0, если для свойства sortOption установлено значение Array.UNIQUESORT. 
		 * 
		 */		
		public function sort(...sortArgs:Array):* {
			dispatchPreChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			var returnValue:Vector.<Object> = data.sort.apply(data,sortArgs);
			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
			return returnValue;
		}
		
		/**
		 * Сортирует элементы, содержащиеся в поставщике данных, по указанному полю и отправляет событие DataChangeType.SORT. Указанное поле может являться строкой или массивом строковых значений, определяющих несколько сортируемых полей в порядке старшинства.  
		 * @param fieldName Поле элемента, по которому требуется производить сортировку. Это значение может быть строкой или массивом строковых значений. 
		 * @param order Параметры сортировки. 
		 * @return Возвращаемое значение зависит от того, получает ли метод какие-либо аргументы. Дополнительную информацию см. в описании метода Array.sortOn(). Если свойство sortOption имеет значение Array.UNIQUESORT, этот метод возвращает 0. 
		 * 
		 */		
		public function sortOn(fieldName:String, order:String = ASC):* {
			return sort(generateSortFunction(fieldName, order));
//			dispatchPreChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
//			var returnValue:Vector.<Object> = data.sortOn(fieldName,options);
//			dispatchChangeEvent(DataChangeType.SORT,data.concat(),0,data.length-1);
//			return returnValue;
		}
		
		protected function generateSortFunction(sortField:String, order:String):Function {
			return function (x:*, y:*):Number {
				if (x[sortField] > y[sortField]) {
					return order == ASC ? 1 : -1;
				} else if (x[sortField] < y[sortField]) {
					return order == ASC ? -1 : 1;
				}
				return 0;
			}
		}

		/**
		 * Создает копию текущего объекта DataProvider.  
		 * @return Новый экземпляр объекта DataProvider. 
		 * 
		 */		
		public function clone():DataProvider {
			return new DataProvider(data.concat());
		}
		
		/**
		 * Создает объект <code>Vector.&lt;Object&gt;</code>, представляющий данные, содержащиеся в поставщике данных.  
		 * @return Объект <code>Vector.&lt;Object&gt;</code>, представляющий данные, содержащиеся в поставщике данных. 
		 * 
		 */		
		public function toVector():Vector.<Object> {
			return data.concat();
		}
		
		/**
		 * Создает строковое представление данных, содержащихся в поставщике данных.  
		 * @return Строковое представление данных, содержащихся в поставщике данных. 
		 * 
		 */		
		override public function toString():String {
			return "DataProvider ["+data.join(" , ")+"]";
		}

		/*protected function getDataFromObject(obj:Object):Array {
			var retArr:Array;
			if (obj is Array) {
				var arr:Array = obj as Array;
				if (arr.length > 0) {
					if (arr[0] is String || arr[0] is Number) {
						retArr = [];
						// convert to object array.
						for (var i:uint = 0; i < arr.length; i++) {
							var o:Object = {label:String(arr[i]),data:arr[i]}
							retArr.push(o);
						}
						return retArr;
					}
				}
				return obj.concat();
			} else if (obj is DataProvider) {
				return obj.toArray();
			} else if (obj is XML) {
				var xml:XML = obj as XML;
				retArr = [];
				var nodes:XMLList = xml.*;
				for each (var node:XML in nodes) {
					var obj:Object = {};
					var attrs:XMLList = node.attributes();
					for each (var attr:XML in attrs) {
						obj[attr.localName()] = attr.toString();
					}
					var propNodes:XMLList = node.*;
					for each (var propNode:XML in propNodes) {
						if (propNode.hasSimpleContent()) {
							obj[propNode.localName()] = propNode.toString();
						}
					}
					retArr.push(obj);
				}
				return retArr;
			} else {
				throw new TypeError("Error: Type Coercion failed: cannot convert "+obj+" to Array or DataProvider.");
				return null;
			}
		}*/
		
		protected function checkIndex(index:int,maximum:int):void {
			if (index > maximum || index < 0) {
				throw new RangeError("DataProvider index ("+index+") is not in acceptable range (0 - "+maximum+")");
			}
		}

		protected function dispatchChangeEvent(evtType:String,items:Vector.<Object>,startIndex:int,endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.DATA_CHANGE,evtType,items,startIndex,endIndex));
		}
		
		protected function dispatchPreChangeEvent(evtType:String, items:Vector.<Object>, startIndex:int, endIndex:int):void {
			dispatchEvent(new DataChangeEvent(DataChangeEvent.PRE_DATA_CHANGE, evtType, items, startIndex, endIndex));
		}
	}

}