package alternativa.gui.controls.tree {

    import alternativa.gui.container.list.IItemContainer;
    import alternativa.gui.container.list.List;
    import alternativa.gui.data.DataProvider;
    import alternativa.gui.event.ListEvent;
    
    import flash.display.DisplayObject;
    import flash.display.InteractiveObject;
    import flash.utils.Dictionary;
	
	/**
	 * Компонента Tree. Предоставленние данных ввиде дерева.
	 * 
	 */	
    public class Tree extends List {
		
		public function Tree() {
			super();
		}
		
		/**
		 * @inheritDoc
		 * 
		 */		
		override public function set dataProvider(value:DataProvider):void {
			_container.dataProvider = value; 
		}
	}
}
