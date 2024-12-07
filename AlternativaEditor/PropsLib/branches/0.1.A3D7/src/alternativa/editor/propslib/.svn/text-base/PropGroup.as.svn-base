package alternativa.editor.propslib {
	
	public class PropGroup {
		/**
		 * Наименование библиотеки.
		 */		
		public var name:String;
		/**
		 * Пропы, содержащиеся в группе. Список элементов типа PropData.
		 */		
		public var props:Array;
		/**
		 * Группы, содержащиеся в группе. Список элементов типа PropGroup.
		 */		
		public var groups:Array;
		
		/**
		 * 
		 * @param name
		 */
		public function PropGroup(name:String) {
			this.name = name;
		}
		
		/**
		 * 
		 * @param propName
		 * @return 
		 */
		public function getPropByName(propName:String):PropData {
			if (props == null) {
				return null;
			}
			for (var i:int = 0; i < props.length; i++) {
				var prop:PropData = props[i];
				if (prop.name == propName) {
					return prop;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param groupName
		 * @return 
		 */
		public function getGroupByName(groupName:String):PropGroup {
			if (groups == null) {
				return null;
			}
			for (var i:int = 0; i < groups.length; i++) {
				var group:PropGroup = groups[i];
				if (group.name == groupName) {
					return group;
				}
			}
			return null;
		}
		
		/**
		 * 
		 * @param prop
		 */
		public function addProp(prop:PropData):void {
			if (props == null) {
				props = new Array();
			}
			props.push(prop);
		}
		
		/**
		 * 
		 * @param group
		 */
		public function addGroup(group:PropGroup):void {
			if (groups == null) {
				groups = new Array();
			}
			groups.push(group);
		}
		
	}
}