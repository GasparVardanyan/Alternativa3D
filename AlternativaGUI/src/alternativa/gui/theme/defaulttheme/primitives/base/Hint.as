package alternativa.gui.theme.defaulttheme.primitives.base {

	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.HintSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.mouse.IHint;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	/**
	 * RU: 
	 * класс хинта
     * EN:
     * hint class
	 * 
	 */	
	public class Hint extends GUIobject implements IHint {
		
		// RU: контент
        // EN: content
		private var content:DisplayObject;
		
		// RU: внутренний отступ
        // EN: padding
		private var padding:int = NumericConst.basePadding;
		
		// RU: фон хинта
        // EN: hint background
		private var bg:StretchRepeatBitmap;

		public function Hint() {
			super();
			bg = new StretchRepeatBitmap(HintSkin.bgBD, HintSkin.edge, HintSkin.edge, HintSkin.edge, HintSkin.edge);
			addChild(bg);
		}

		override public function resize(width:int, height:int):void {
		}

		override public function set width(value:Number):void {
		}

		override public function set height(value:Number):void {
		}
		
		// RU: задаем текст хинту
        // EN: set the text for hint
		public function set text(value:String):void {
			var label:Label = new Label();
			label.text = value;

			if (content != null) {
				removeChild(content);
			}

			content = label;
			addChild(content);

			redraw();
		}
		
		// RU: изменяем размер фону
        // EN: change background size
		override protected function draw():void {
			super.draw();
			bg.resize(_width, _height);
			this.drawChildren();
		}
		
		// RU: позиционирование и изменение размеров
        // EN: set position and change sizes
		private function redraw():void {
			content.x = padding;
			content.y = padding;

			_width = content.width + padding * 2;
			_height = content.height + padding * 2;

			draw();
		}

	}
}
