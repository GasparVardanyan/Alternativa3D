package alternativa.gui.theme.defaulttheme.controls.dropDownMenu {
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.DropDownMenuSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.TreeSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.dropDownMenu.*;
	import alternativa.gui.enum.Align;
	import alternativa.gui.primitives.stretch.StretchBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;

	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.ColorTransform;

	use namespace alternativagui;

	/**
	 *
	 * RU: Кнопка в DropDownMenuItemContainer, основная особенность - при ролловере состояние нажатия
     * EN: Button in DropDownMenuItemContainer. Its main feature - on rollover occurs pressed state
	 *
	 */
	public class DropDownMenuItem extends alternativa.gui.controls.dropDownMenu.DropDownMenuItem {

		// RU: минимальная высота
        // EN: minimal height
		protected var _minHeight:int;

		// RU: зазор между иконкой и текстовой меткой
        // EN: distance between an icon and a text label
		protected var _iconPadding:int;

		// RU: размер иконки
        // EN: icon size
		protected var _iconSize:int;

		// RU: текстовая метка
        // EN: text label
		protected var _label:Label;

		// RU: иконка папки
        // EN: folder icon
		protected var _folderIcon:DisplayObject;

		// RU: иконка
        // EN: icon
		protected var _icon:DisplayObject;

		// RU: отступ для внутренноего контента
        // EN: content padding
		protected var _padding:int;

		// RU: отступ от иконки папки
        // EN: indentation of folder icons
		protected var _folderIconPadding:int;

		protected var _selectedIconColor:uint;

		protected var _iconColor:uint;

		protected var _colorTransform:ColorTransform;

		/**
         *
		 * RU: Конструктор
		 * @param parentContainer - Ссылка на родительскую панельку
         * EN: Constructor
         * @param parentContainer - Link to parent panel
         *
		 */
		public function DropDownMenuItem(parentContainer:IDropDownMenuItemContainer = null) {
			super(parentContainer);
		}

		override public function destroy():void {
			super.destroy();
			if (_icon && _icon.parent) {
				_icon.parent.removeChild(_icon);
			}
			_icon = null;

			if (_label && _label.parent) {
				_label.parent.removeChild(_label);
			}
			_label = null;

			if (_folderIcon && _folderIcon.parent) {
				_folderIcon.parent.removeChild(_folderIcon);
			}
			_folderIcon = null;
		}

		public function get label():String {
			if (_label != null) {
				return _label.text;
			} else {
				return "";
			}
		}

		public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				addChild(_label);
			}
			if (value != null || value != "") {
				_label.text = value;
			} else {
				if (_label != null) {
					if (contains(_label)) {
						removeChild(_label);
					}
					_label = null;
				}
			}
			draw();
		}

		public function get icon():DisplayObject {
			return _icon;
		}

		public function set icon(object:DisplayObject):void {
			if (_icon != null) {
				removeChild(_icon);
			}
			if (object != null) {
				_icon = object;
				addChild(_icon);
			}
			draw();
		}

		public function get iconPadding():int {
			return _iconPadding;
		}

		public function set iconPadding(value:int):void {
			_iconPadding = value;
		}

		override public function set locked(value:Boolean):void {
			super.locked = value;
			if (_locked) {
				if (_label != null) {
					_label.alpha = NumericConst.lockedAlpha;
				}
				if (_icon != null) {
					_icon.alpha = NumericConst.lockedAlpha;
				}
				if (_folderIcon) {
					_folderIcon.alpha = NumericConst.lockedAlpha;
				}
			} else {
				if (_label != null) {
					_label.alpha = 1;
				}
				if (_icon != null) {
					_icon.alpha = 1;
				}
				if (_folderIcon) {
					_folderIcon.alpha = 1;
				}
			}
		}


		override public function set data(value:Object):void {
			if (value != null) {
				_label.text = value.label;
				locked = value.locked;
			}
			super.data = value;
			// RU: если есть дочерние объекты устанавливаем фолдер иконку
            // EN: if child objects exists then set a folder icon
			if (_folderIcon != null) {
				_folderIcon.visible = hasDataChildren();
			}

		}


		override public function set selected(value:Boolean):void {
			_selected = value;
			if (value) {
				setState(_stateDOWN);
			} else {
				setState(_stateUP);
			}
			super.selected = value;
		}

		// RU: Инициализация
        // EN: initialization
		override protected function init():void {
			super.init();
			_minHeight = 20;
			_height = _minHeight;
			_padding = 10;
			_iconPadding = 2;
			_iconSize = 16;
			_folderIconPadding = 10;
			_selectedIconColor = 0xA5A5A5;
			_iconColor = 0xDDDDDD;
			_colorTransform = new ColorTransform();
			stateUP = createState(0xFFFFFFF);

			var temp:int = 2;
			stateDOWN = new StretchBitmap(DropDownMenuSkin.itemStateDownTexture, temp, temp, temp, temp);
			stateOVER = new StretchBitmap(DropDownMenuSkin.itemStateOverTexture, temp, temp, temp, temp);

			_label = new Label();
			_label.align = Align.LEFT;
			addChild(_label);

			_folderIcon = new Bitmap(TreeSkin.arrowClose);
			addChild(_folderIcon);

			icon = createState(_iconColor);
			icon.width = icon.height = _iconSize;
		}


		protected function createState(color:Number):Sprite {
			var sp:Sprite = new Sprite();
			sp.graphics.beginFill(color, 1);
			sp.graphics.drawRect(0, 0, 10, 10);
			sp.mouseEnabled = false;
			sp.tabEnabled = false;
			return sp;
		}

		override protected function draw():void {
			// RU: авто размеры
            // EN: auto sizes
			_width = this.calculateWidth(_width);
			_height = this.calculateHeight(height);


			if (_icon) {
				_icon.x = _iconPadding;
				_icon.y = (_height - int(_icon.height)) >> 1;
				if (_selected) {
					_colorTransform.color = _selectedIconColor;
				} else {
					_colorTransform.color = _iconColor;
				}
				_icon.transform.colorTransform = _colorTransform;
			}

			super.draw();
			if (_label) {
				if (_icon) {
					_label.x = int(_icon.x + _icon.width + _iconPadding);
				} else {
					_label.x = int(_padding);
				}

				_label.y = ((_height - int(_label.height)) >> 1);
			}

			if (_folderIcon) {
				_folderIcon.y = int((_height - _folderIcon.height) >> 1) + 1;
				if (_label) {
					_folderIcon.x = int(_label.x + _label.width + _folderIconPadding);
				} else if (_icon) {
					_folderIcon.x = int(_icon.x + _icon.width + _folderIconPadding);
				}
			}


		}

		override protected function calculateWidth(value:int):int {
			var w:int = (_label ? _label.width : 0) + (_icon ? (_icon.width + _iconPadding) : 0) + ((_folderIcon && hasDataChildren()) ? (_folderIcon.width + _folderIconPadding) : 0) + _padding;

			if (value < w) {
				return w;
			} else {
				return value;
			}
		}

		override protected function calculateHeight(value:int):int {
			if (value < _minHeight) {
				return _minHeight;
			} else {
				return value;
			}
		}

		public function get folderIcon():DisplayObject {
			return _folderIcon;
		}

		public function set folderIcon(value:DisplayObject):void {
			_folderIcon = value;
			addChild(_folderIcon);
			draw();
		}
	}
}
