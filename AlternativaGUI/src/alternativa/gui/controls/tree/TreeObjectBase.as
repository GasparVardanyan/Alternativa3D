package alternativa.gui.controls.tree {

	import flash.display.DisplayObject;

	/**
	 * Базовый объект Tree.
	 * 
	 */	
	public class TreeObjectBase implements ITreeObject {
		protected var _label:String;

		protected var _icon:DisplayObject;

		protected var _itemId:String;

		protected var _parentId:String;

		protected var _opened:Boolean;

		protected var _canExpand:Boolean;
		
		protected var _hasChildren:Boolean;

		protected var _level:int;

		public function TreeObjectBase() {
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		public function get label():String {
			return _label;
		}

		public function set label(value:String):void {
			_label = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get icon():DisplayObject {
			return _icon;
		}
		public function set icon(value:DisplayObject):void {
			_icon = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get itemId():String {
			return _itemId;
		}
		public function set itemId(value:String):void {
			_itemId = value;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get parentId():String {
			return _parentId;
		}
		public function set parentId(value:String):void {
			_parentId = value;
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */
		public function get opened():Boolean {
			return _opened;
		}
		public function set opened(value:Boolean):void {
			_opened = value;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get canExpand():Boolean {
			return _canExpand;
		}
		public function set canExpand(value:Boolean):void {
			_canExpand = value;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get hasChildren():Boolean {
			return _hasChildren;
		}
		public function set hasChildren(value:Boolean):void {
			_hasChildren = value;
		}

		/**
		 * @inheritDoc 
		 * 
		 */
		public function get level():int {
			return _level;
		}
		public function set level(value:int):void {
			_level = value;
		}

	}
}
