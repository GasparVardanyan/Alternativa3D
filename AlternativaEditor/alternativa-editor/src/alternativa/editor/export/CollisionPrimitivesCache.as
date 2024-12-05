package alternativa.editor.export {
	import __AS3__.vec.Vector;
	
	/**
	 * Кэш физических примитивов. Хранит наборы физических примтивов, индексированных значениями "имя библиотеки"-"имя группы"-"имя пропа".
	 */
	public class CollisionPrimitivesCache {
		
		private var cache:Object = {};
		
		/**
		 * 
		 */
		public function CollisionPrimitivesCache() {
		}
		
		/**
		 * Добавляет список примитивов пропа в кэш.
		 * 
		 * @param libName
		 * @param grpName
		 * @param propName
		 * @param prim
		 */
		public function addPrimitives(libName:String, grpName:String, propName:String, primitives:Vector.<CollisionPrimitive>):void {
			var libCache:Object = cache[libName];
			if (libCache == null) cache[libName] = libCache = {};
			var grpCache:Object = libCache[grpName];
			if (grpCache == null) libCache[grpName] = grpCache = {};
			grpCache[propName] = primitives;
		}
		
		/**
		 * Возвращает кэшированный список примитив пропа или null в случае отсутствия списка.
		 *  
		 * @param libName
		 * @param grpName
		 * @param propName
		 * @return 
		 */
		public function getPrimitives(libName:String, grpName:String, propName:String):Vector.<CollisionPrimitive> {
			var currCache:Object = cache[libName];
			if (currCache == null) return null;
			currCache = currCache[grpName];
			return currCache != null ? currCache[propName] : null;
		}
		
		/**
		 * Очищает кэш.
		 */
		public function clear():void {
			cache = {};
		}

	}
}