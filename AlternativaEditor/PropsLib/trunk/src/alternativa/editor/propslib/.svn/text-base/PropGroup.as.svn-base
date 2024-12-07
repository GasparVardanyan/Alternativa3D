package alternativa.editor.propslib {
	import __AS3__.vec.Vector;
	
	/**
	 * Группа пропов. Может содержит в себе список пропов и список дочерних групп.
	 */	
	public class PropGroup {
		/**
		 * Наименование группы.
		 */		
		public var name:String;
		/**
		 * Пропы, содержащиеся в группе.
		 */		
		public var props:Vector.<PropData>;
		/**
		 * Группы, содержащиеся в группе.
		 */		
		public var groups:Vector.<PropGroup>;
		
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
			for each (var prop:PropData in props) {
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
			for each (var group:PropGroup in groups) {
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
				props = new Vector.<PropData>();
			}
			props.push(prop);
		}
		
		/**
		 * 
		 * @param group
		 */
		public function addGroup(group:PropGroup):void {
			if (groups == null) {
				groups = new Vector.<PropGroup>();
			}
			groups.push(group);
		}
		
	}
}