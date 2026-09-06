package alternativa.gui.theme.defaulttheme.controls.dropDownList {

	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;

	import alternativa.gui.controls.dropDownList.DropDownList;

	use namespace alternativagui;

	public class DropDownList extends alternativa.gui.controls.dropDownList.DropDownList {

		public function DropDownList() {
			
			// RU: задаем кнопку
            // EN: set the button
			button = new DropDownButtonContainer();
			
			// RU: контейнер элементов
            // EN: items container
			itemPanel = new DropDownItemContainer();

			_height = calculateHeight(_height);
		}
		
		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (_button != null) {
				_button.width = value; 
				if (value < _button.width)
				value = _button.width;
			}
			return value;
		}
	}
}
