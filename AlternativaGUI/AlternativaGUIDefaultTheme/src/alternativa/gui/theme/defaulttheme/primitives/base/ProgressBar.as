package alternativa.gui.theme.defaulttheme.primitives.base {

	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.ProgressBarSkin;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.HorizontalBar;
	import alternativa.gui.primitives.stretch.StretchBitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatBitmap;
	import alternativa.gui.primitives.stretch.VerticalBar;

	import flash.display.BitmapData;

	import alternativa.gui.alternativagui;

	import flash.display.BlendMode;

	use namespace alternativagui;

	/**
	 * RU:
	 * класс линии прогресса с текстовой меткой
     * EN:
     * class of the progress line with a text label
	 *
	 */
	public class ProgressBar extends GUIobject {
		// RU: фон
        // EN: background
		protected var bgLine:HorizontalBar;

		// RU: заполненная линия
        // EN: filled line
		protected var fullLine:HorizontalBar;

		// RU: маска
        // EN: mask
		protected var maskLine:StretchRepeatBitmap;

		// RU: процент загрузки (0 - 1)
        // EN: load percent (from 0 to 1)
		protected var _percent:Number;

		// RU: смещение
        // EN: shift
		protected var offset:int = 1;

		// RU: текстовая метка
        // EN: text label
		protected var _label:Label;

		public function ProgressBar() {
			bgLine = new HorizontalBar(ProgressBarSkin.lineBGTexture, ProgressBarSkin.edge, ProgressBarSkin.edge);
			addChild(bgLine);
			fullLine = new HorizontalBar(ProgressBarSkin.lineFullTexture, ProgressBarSkin.lineFullEdge, ProgressBarSkin.lineFullEdge);
			addChild(fullLine);
			maskLine = new StretchRepeatBitmap(ProgressBarSkin.maskTexture, ProgressBarSkin.edge, ProgressBarSkin.edge,ProgressBarSkin.edge,ProgressBarSkin.edge);
			maskLine.cacheAsBitmap = true;
			fullLine.cacheAsBitmap = true;
			addChild(maskLine);
			fullLine.mask = maskLine;
			bgLine.height = 1;

			_label = new Label();
			addChild(_label);

			_height = ProgressBarSkin.lineBGTexture.height - offset * 2;
		}

		public function get percent():Number {
			return _percent;
		}

		public function set percent(value:Number):void {
			_percent = value;
			draw();
			drawChildren();
		}

		override protected function draw():void {
			super.draw();
			bgLine.x = bgLine.y = -offset;

			bgLine.resize(_width + offset * 2, _height + offset * 2);
			fullLine.x = fullLine.y = offset;
			fullLine.width = (_width - offset * 2) * _percent;
			maskLine.x = maskLine.y = offset;
			maskLine.width = _width - offset * 2;
			maskLine.height = _height - offset * 2;
			_label.x = (_width - int(_label.width)) >> 1;
			_label.y = (_height - int(_label.height)) >> 1;
		}
		
		// RU: отдаем фиксированную высоту
        // EN: pass the fixes height
		override protected function calculateHeight(value:int):int {
			return _height;
		}

		public function get label():String {
			return _label.text;
		}

		public function set label(value:String):void {
			_label.text = value;
			draw();
			drawChildren();
		}
	}
}
