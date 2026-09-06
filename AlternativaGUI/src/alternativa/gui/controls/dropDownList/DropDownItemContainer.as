package alternativa.gui.controls.dropDownList {

    import alternativa.gui.container.list.IItemContainer;
    import alternativa.gui.container.list.List;
	
	/**
	 * Контейнер элементов для DropDownList.
	 * 
	 */	
    public class DropDownItemContainer extends List {

        public function DropDownItemContainer() {
            super();
        }
		
		/**
		 * @inheritDoc 
		 * 
		 */		
        override protected function calculateHeight(value:int):int {
            var heightContent:int = 0;

			heightContent = ((_container as IItemContainer).contentHeight + _padding*2);

			if (heightContent < value) {
				value = heightContent;
			}
			value = super.calculateHeight(value);
            return value;
        }
    }
}
