package alternativa.gui.theme.defaulttheme.controls.numericStepper {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.numericStepper.NumericStepper;
	import alternativa.gui.controls.text.TextInput;
	import alternativa.gui.theme.defaulttheme.primitives.base.WhiteBG;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.theme.defaulttheme.skin.NumericStepperSkin;
	import alternativa.gui.theme.defaulttheme.skin.ScrollBarSkin;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.ui.KeyLocation;
	import flash.ui.Keyboard;

	use namespace alternativagui;

	public class NumericStepper extends alternativa.gui.controls.numericStepper.NumericStepper {

		// RU: смещение для кнопки
        // EN: shift for the button
		protected var offsetButton:int;

		
		// RU: смещение для рамки
        // EN: shift for a frame
		protected var offsetBorder:int = NumericConst.borderThickness;

		/**
         *
		 * RU:
		 * @param minValue Минимальное значение.
		 * @param maxValue Максимальное значение.
		 * @param step Шаг.
		 * @param sign Количество знаков после запятой.
         * EN:
         * @param minValue Minimal value
         * @param maxValue Maximal value
         * @param step Step
         * @param sign Number of chars after the comma
		 *
		 */
		public function NumericStepper(minValue:Number = 0, maxValue:Number = 10, step:Number = 1, sign:int = 5) {
			super(minValue, maxValue, step, sign);

			background = new WhiteBG(); 
			textInput.color = NumericConst.textColor;
			
			// RU: смещение кнопки
            // EN: button shift
			offsetButton = NumericStepperSkin.edge;
			
			// RU: внутренний отступ
            // EN: padding
			_padding = NumericConst.basePadding;
			
			// RU: создание и добавление кнопки увеличения значения
            // EN: creat the increase button and add it
			var incButton:NumericButton = new NumericButton(2);
			incButton.stateUP = new Bitmap(NumericStepperSkin.incStateUp);
			incButton.stateDOWN = new Bitmap(NumericStepperSkin.incStateDown);
			incButton.stateOVER = new Bitmap(NumericStepperSkin.incStateOver);
			incButton.stateOFF = new Bitmap(NumericStepperSkin.incStateUp);
			incButton.icon = new Bitmap(ScrollBarSkin.iconUpBD);
			incButton.resize(NumericStepperSkin.incStateUp.width, NumericStepperSkin.incStateUp.height);
			increaseButton = incButton;
			incButton.name = "increaseButton"; 

			// RU: создание и добавление кнопки уменьшения значения
            // EN: creat the decrease button and add it
			var decButton:NumericButton = new NumericButton(-1);
			decButton.stateUP = new Bitmap(NumericStepperSkin.decStateUp);
			decButton.stateDOWN = new Bitmap(NumericStepperSkin.decStateDown);
			decButton.stateOVER = new Bitmap(NumericStepperSkin.decStateOver);
			decButton.stateOFF = new Bitmap(NumericStepperSkin.decStateUp);
			decButton.icon = new Bitmap(ScrollBarSkin.iconDownBD);
			decButton.resize(NumericStepperSkin.decStateUp.width, NumericStepperSkin.decStateUp.height);
			decreaseButton = decButton;
			decButton.name = "decreaseButton";
			
			// RU: задаем высоту кнопки
            // EN: set the button height
			_height = calculateHeight(_height);
			
			// RU: вызываем отрисовку
            // EN: call draw method
			draw();
		}
		
		
		// RU: позиционирование и задание размеров
        // EN: set position and sizes
		override protected function draw():void {
			super.draw();

			_increaseButton.x = _width - _increaseButton.width + offsetButton;
			_increaseButton.y = -offsetButton;
			_decreaseButton.x = _width - _decreaseButton.width + offsetButton;
			_decreaseButton.y = _height - _decreaseButton.height + offsetButton;

			textInput.x = padding;
			textInput.y = int((_height - textInput.tf.height) >> 1) + 4;
			textInput.width = _width - _padding - _space - _increaseButton.width;
			textInput.height = _height - textInput.y;
		}

		// RU: возвращаем высоту
        // EN: return the height
		override protected function calculateHeight(value:int):int {
			value = NumericConst.buttonMinHeight;
			textInput.height = value;
			return value;
		}
		
		// RU: смотрим значение ширины, если меньше заданного, отдаем минимальную ширину
        // EN: if width value is less than the specified value, then return minimal width value
		override protected function calculateWidth(value:int):int {
			if (value < NumericConst.numStepMinWidth)
				value = NumericConst.numStepMinWidth;
			return value;
		}

		

	}
}
