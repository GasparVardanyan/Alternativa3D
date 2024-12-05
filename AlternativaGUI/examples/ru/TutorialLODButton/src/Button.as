package {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.lod.simple.ISimpleLODobject;
	import alternativa.gui.lod.simple.LODlistenerPriority;
	import alternativa.gui.lod.simple.SimpleLODbitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;
	
	import flash.display.DisplayObject;

	use namespace alternativagui;

	public class Button extends BaseButton implements ISimpleLODobject {
		// Индекс лода
		private var index:int;

		// Приоритет лодирования кнопки
		private var priority:LODlistenerPriority;

		// Иконка
		private var _icon:SimpleLODbitmap;

		// Текстовая метка
		private var _label:Label;

		// Массив размеров текстовой метки
		private var fontSizeArray:Array;

		// Массив внутреннего отступа
		private var paddingArray:Array;

		// Текущай внутренний отступ
		private var padding:int = 0;

		// Массив высот кнопки
		private var buttonHeightArray:Array;

		// Текущая высота кнопки
		private var buttonHeight:int = 0;

		// Массив минимальной ширины кнопки
		private var minWidthArray:Array;

		// Текущая минимальная ширина кнопки
		private var minWidth:int = 0;

		// Массив зазора между иконкой и текстовой меткой
		private var spaceArray:Array;

		// Текущий зазор между иконкой и текстовой меткой
		private var space:int = 0;
		
		// Цвет текста
		private var fontColor:Number = 0xe9e9e9;
		
		// Значение прозрачности при _locked = true;
		private var alphaValue:Number = 0.6;

		public function Button() {
			super();
			
			// Задаем приоритет
			priority = LODlistenerPriority.CONTROL;
			
			fontSizeArray = [ButtonSkin.fontSize0, ButtonSkin.fontSize1, ButtonSkin.fontSize2];
			paddingArray = [ButtonSkin.padding0, ButtonSkin.padding1, ButtonSkin.padding2];
			buttonHeightArray = [ButtonSkin.buttonHeight0, ButtonSkin.buttonHeight1, ButtonSkin.buttonHeight2];
			minWidthArray = [ButtonSkin.minWidth0, ButtonSkin.minWidth1, ButtonSkin.minWidth2];
			spaceArray = [ButtonSkin.space0, ButtonSkin.space1, ButtonSkin.space2];
			
			// Задаем скин состоянию "отжатый"
			stateUP = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateUpLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
									   new StretchRepeatHBitmap(ButtonSkin.stateUpLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
									   new StretchRepeatHBitmap(ButtonSkin.stateUpLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));
			// Задаем скин состоянию "наведенный"
			stateOVER = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateOverLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
										 new StretchRepeatHBitmap(ButtonSkin.stateOverLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
										 new StretchRepeatHBitmap(ButtonSkin.stateOverLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));
			// Задаем скин состоянию "нажатый"
			stateDOWN = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateDownLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
										 new StretchRepeatHBitmap(ButtonSkin.stateDownLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
										 new StretchRepeatHBitmap(ButtonSkin.stateDownLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));

		}
		
		// Переопределяем отрисовку у BaseButton
		override protected function draw():void {
			super.draw();
			// Вычситываем значение не занятой ширины, чтобы позиционировать иконку или текстовую метку по горизонтали
			var emptyWidth:int = _width - padding * 2 - ((_icon != null) ? _icon.width : 0) - ((_label != null) ? int(_label.width) : 0) - ((_label != null && _icon != null) ? space : 0);
			
			// Проверка на наличие иконки
			if (_icon != null) {
				_icon.x = padding + (emptyWidth >> 1);
				_icon.y = (_height - _icon.height) >> 1;
			}
			
			// Проверка на наличие текстовой метки
			if (_label != null) {
				if (_icon != null) {
					_label.x = _icon.x + _icon.width + space;
				} else {
					_label.x = padding + (emptyWidth >> 1);
				}
				_label.y = (_height - int(_label.height)) >> 1;
			}

		}
		
		// Переопредялем метод: отдаем фиксированную высоту кнопки в зависимости от индекса лода
		override protected function calculateHeight(value:int):int {
			return buttonHeight;
		}
		
		// Переопредялем метод: высчитываем минимальную ширину. Не даем кнопке сжаться меньше, чем она занимает, возваращем актуальную ширину
		override protected function calculateWidth(value:int):int {
			var contentWidth:int = padding * 2 + ((_icon != null) ? _icon.width : 0) + ((_label != null) ? int(_label.width) : 0) + ((_label != null && _icon != null) ? space : 0);
			if (value < contentWidth) {
				value = contentWidth;
			}
			if (value < minWidth) {
				value = minWidth;
			}
			return value;
		}


		// Изменения внешнего вида кнопки при смене индекса лода
		private function changeSkin():void {
			space = spaceArray[index];
			minWidth = minWidthArray[index];
			padding = paddingArray[index];
			buttonHeight = buttonHeightArray[index];
			
			if (_label != null) {
				_label.size = fontSizeArray[index];
			}
			resize(_width, _height);
		}
		
		// Переопредялем метод: если кнопка залоченна, то иконка и текстовая метка тускнеют		
		override public function set locked(value:Boolean):void {
			super.locked = value;
			if (_locked) {
				if (_icon != null) {
					_icon.alpha = alphaValue;
				}
				if (_label != null) {
					_label.alpha = alphaValue;
				}
			} else {
				if (_icon != null) {
					_icon.alpha = 1;
				}
				if (_label != null) {
					_label.alpha = 1;
				}
			}
		}
		
		/**
		 * Индекс уровня детализации. Также от индекса зависят и размеры элемента.
		 * Т.е. ширина или высота элемента (или и то, и другое) будут меняться дискретно в зависимости от индекса.
		 */

		public function get LODindex():int {
			return index;
		}

		public function set LODindex(value:int):void {
			index = value;
			changeSkin();
			
		}

		/**
		 * Приоритет получения нового индекса при его изменении.
		 */
		public function get LODpriority():LODlistenerPriority {
			return priority;
		}

		public function set LODpriority(value:LODlistenerPriority):void {
			priority = value;
		}

		public function get icon():SimpleLODbitmap {
			return _icon;
		}
		
		// Задаем иконку 
		public function set icon(value:SimpleLODbitmap):void {
			if (_icon != null) {
				if (contains(_icon)) {
					removeChild(_icon);
				}
				_icon = null;
			}
			if (value != null) {
				_icon = value;
				addChild(_icon);
				if (_locked) {
					if (_icon != null) {
						_icon.alpha = alphaValue;
					}
				}
			}
			draw();
		}

		public function get label():String {
			return _label.text;
		}
		// Задаем текст кнопки
		public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				addChild(_label);
				_label.size = fontSizeArray[index];
				if (_locked) {
					if (_label != null) {
						_label.alpha = alphaValue;
					}
				}
				_label.color = fontColor;
			}
			_label.text = value;
			resize(_width, _height);
		}

	}

}
