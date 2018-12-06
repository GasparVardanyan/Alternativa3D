package alternativa.gui.theme.defaulttheme.controls.tree {

	import alternativa.gui.theme.defaulttheme.container.list.ListObject;
	import alternativa.gui.theme.defaulttheme.controls.text.LabelWithIcon;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.TreeSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;

	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	use namespace alternativagui;

	// RU: расширяем класс ListObject. Визуальный класс элемента дерева. Содержит иконки: открыт/закрыт, папки, файла.
    // EN: extend ListObject class. Visual class of tree item. Contains icons: opened/closed, folder, file.
	public class TreeObject extends ListObject {

		// RU: уровень вложенности
        // EN: nesting level
		protected var level:int = 0;
		
		// RU: иконка открытой папки
        // EN: icon of the opened button
		protected var folderOpen:Bitmap;
		
		// RU: иконка закрытой папки
        // EN: icon of the closed button
		protected var folderClose:Bitmap;
		
		// RU: иконка файла
        // EN: file icon
		protected var file:Bitmap;
		
		// RU: контейнер для иконки стрелки
        // EN: container for the arrow icon
		protected var arrowIcon:DisplayObject;
		
		// RU: иконка стрелки - открыта ветка
        // EN: arrow icon - branch is opened
		protected var arrowOpen:Bitmap;
		
		// RU: иконка стрелки - закрыта ветка
        // EN: arrow icon - branch is closed
		protected var arrowClose:Bitmap;
		
		// RU: ширина иконки стрелки
        // EN: width of the arrow icon
		protected var arrowWidth:int = 9;
		
		// RU: отступ иконки стрелки
        // EN: padding of the arrow icon
		protected var arrowPadding:int = NumericConst.basePadding;

		public function TreeObject() {
			super();
			
			// RU: внутренний отступ
            // EN: padding
			_padding = 15;
			
			// RU: задаем иконки
            // EN: set an icon
			folderOpen = new Bitmap(TreeSkin.folderOpen);
			folderClose = new Bitmap(TreeSkin.folderClose);

			arrowOpen = new Bitmap(TreeSkin.arrowOpen);
			arrowClose = new Bitmap(TreeSkin.arrowClose);

			file = new Bitmap(TreeSkin.file);
			arrowIcon = new GUIobject();
		}
		
		// RU: получаем данные
        // EN: receive the data
		override public function set data(value:Object):void {
			_data = value;
			if (_data != null) {
				level = _data.level;
				_label.text = _data.label;
				// RU: если есть иконка - добавляем ее
                // EN: add an icon if it is
				if (_data.icon != null) {
					_label.icon = _data.icon;
				} else {
					var color:Number;
					// RU: если ветка дерева имеет дочерние объекты
                    // EN: if tree branch has child objects
					if (_data.canExpand) {
						// RU: если ветка открыта
                        // EN: if branch is opened
						if (_data.opened) {
							// RU: меняем иконку папки на открытую
                            // EN: change a folder icon (set to opened)
							_label.icon = folderOpen;
							if (contains(arrowIcon)) {
								removeChild(arrowIcon);
							}
							// RU: иконка стрелки - открыта ветка
                            // EN: arrow icon when branch is opened
							arrowIcon = arrowOpen;
						} else {
							// RU: если ветка закрыта, меняем иконку папки на закрытую
                            // EN: if branch is closed, then change a folder icon (set to closed)
							_label.icon = folderClose;
							if (contains(arrowIcon)) {
								removeChild(arrowIcon);
							}
							// RU: иконка стрелки - ветка закрыта
                            // EN: arrow icon when branch is closed
							arrowIcon = arrowClose;
						}
						if (!contains(arrowIcon)) {
							addChild(arrowIcon);
						}
					} else {
						// RU: если ветка дерева не имеет дочерние объекты
                        // EN: if tree branch has't child objects
						_label.icon = file;
						if (contains(arrowIcon)) {
							removeChild(arrowIcon);
						}
					}

				}
			} else {
				_label.text = " ";
				_label.icon = null;
				level = 0;
			}
			draw();
		}
		
		// RU: позиционирование и задание размеров
        // EN: set position and sizes
		override protected function draw():void {
			super.draw();
			if (_data != null) {
				if (_data.canExpand) {
					arrowIcon.x = _padding * level + ((arrowWidth - arrowIcon.width) >> 1);
					arrowIcon.y = (_height - arrowIcon.height) >> 1;
					_label.x = _padding * level + arrowWidth + arrowPadding;

					_label.width = _width - _padding * level - arrowPadding - arrowWidth;
				} else {
					_label.x = _padding * level + arrowPadding + arrowWidth;
					_label.width = _width - _padding * level - arrowPadding - arrowWidth;
				}
				_label.height = 1;
				_label.y = (_height - _label.height) >> 1;
			}
		}
	}
}
