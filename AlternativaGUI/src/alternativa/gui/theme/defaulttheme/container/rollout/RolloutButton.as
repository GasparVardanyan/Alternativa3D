package alternativa.gui.theme.defaulttheme.container.rollout {

	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.controls.text.LabelWithIcon;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.RolloutSkin;
	import alternativa.gui.theme.defaulttheme.skin.TreeSkin;
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.primitives.stretch.HorizontalBar;


	import flash.display.Bitmap;
	import flash.display.DisplayObject;

	use namespace alternativagui;
	
	/**
	 *  
	 * RU: кнопка - заголовок для Rollout. Содержит текстовую метку и визуал.
     * EN: button-title for Rollout. Contains text label and visual part.
	 * 
	 */	
	public class RolloutButton extends BaseButton {
		
		// RU: текстовая метка
        // EN: text label
		protected var _label:Label;
		
		// RU: флаг: показан/скрыт контент
        // EN: show/hide content
		protected var _selected:Boolean;

		protected var _padding:int = NumericConst.basePadding;
		
		// RU: контейнер для иконки: открыт/закрыт
        // EN: icon container: open/close
		protected var arrowIcon:DisplayObject;
		
		// RU: иконка "открыт"
        // EN: icon "opened"
		protected var arrowOpen:Bitmap;

		// RU: иконка "закрыт"
        // EN: icon "closed"
		protected var arrowClose:Bitmap;
		
		// RU: ширина иконки
        // EN: icon width
		protected var arrowWidth:int = 9;
		
		// RU: зазор между иконкой и текстовой меткой
        // EN: distance between an icon and a text label
		protected var arrowPadding:int = NumericConst.basePadding;

		public function RolloutButton() {
			
			// RU: задаем состояния кнопки
            // EN: set the button states
			stateUP = new HorizontalBar(RolloutSkin.stateUp, RolloutSkin.edge, RolloutSkin.edge);
			stateDOWN = new HorizontalBar(RolloutSkin.stateDown, RolloutSkin.edge, RolloutSkin.edge);
			
			// RU: задаем текстовую метку
            // EN: set a text label
			_label = new Label();
			addChild(_label);
			
			// RU: иконки
            // EN: icons
			arrowOpen = new Bitmap(TreeSkin.arrowOpen);
			arrowClose = new Bitmap(TreeSkin.arrowClose);
			
			// RU: контейнер для иконки
            // EN: icon container
			arrowIcon = new GUIobject();
			addChild(arrowIcon);
			
			selected = false;
		}
		
		// RU: при выделении объекта изменяем иконки и состояния кнопки
        // EN: if an object is selected, then change the icons and button states
		public function set selected(value:Boolean):void {
			_selected = value;
			if (_selected) {
				pressed = true;
				setState(_stateDOWN);
				if (contains(arrowIcon)) {
					removeChild(arrowIcon);
				}
				arrowIcon = arrowOpen;
			} else {
				pressed = false;
				setState(_stateUP);
				if (contains(arrowIcon)) {
					removeChild(arrowIcon);
				}
				arrowIcon = arrowClose;
			}
			if (!contains(arrowIcon)) {
				addChild(arrowIcon);
			}
			_label.height = 1;
			draw();
		}

		public function get selected():Boolean {
			return _selected;
		}

		public function get label():String {
			return _label.text;
		}

		public function set label(value:String):void {
			_label.text = value;
			draw();
		}
		
		// RU: позиционирование иконки и текстовой метки
        // EN: set position to icon and text label
		override protected function draw():void {
			super.draw();
			arrowIcon.x = _padding + ((arrowWidth - arrowIcon.width) >> 1);
			arrowIcon.y = (_height - arrowIcon.height) >> 1;
			_label.x = _padding + arrowWidth + arrowPadding;
			_label.y = (_height - int(_label.height)) >> 1;
		}
		
		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			_label.width = 1;
			if (value < (_label.width + _padding * 2 + arrowWidth + arrowPadding)) {
				value = _label.width + _padding * 2 + arrowWidth + arrowPadding;
			}
			return value;
		}
	}
}
