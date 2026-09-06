package alternativa.gui.controls.tree {
	import flash.display.DisplayObject;
	
	/**
	 * Данные для объекта Tree.
	 * 
	 */	
	public interface ITreeObject {
		
		/**
		 * Текстовая метка.
		 * 
		 */		
		function get label():String;
		function set label(value:String):void;
		
		/**
		 * Иконка.
		 * 
		 */		
		function get icon():DisplayObject;
		function set icon(value:DisplayObject):void;
		
		/**
		 * Уникальный идентификатор объекта.
		 * 
		 */		
		function get itemId():String;
		function set itemId(value:String):void;
		
		/**
		 * Идентификатор родительского объекта. 
		 * 
		 */		
		function get parentId():String;
		function set parentId(value:String):void;
		
		/**
		 * Флаг: открыт или закрыт раздел.
		 * 
		 */		
		function get opened():Boolean;
		function set opened(value:Boolean):void;
		
		/**
		 * Флаг: может ли данный объект быть открыт/закрыт. 
		 * 
		 */		
		function get canExpand():Boolean;
		function set canExpand(value:Boolean):void;
		
		/**
		 * Флаг: может ли данный объект иметь дочерние объекты. 
		 * 
		 */		
		function get hasChildren():Boolean;
		function set hasChildren(value:Boolean):void;
		
		/**
		 * Уровень вложенности объекта. 
		 * 
		 */		
		function get level():int;
		function set level(value:int):void;
	}
}