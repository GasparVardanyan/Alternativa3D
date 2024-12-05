
package {
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.controls.text.LabelTF;
	import alternativa.init.GUI;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	import flash.text.Font;
	import flash.text.TextFormat;
	
	[SWF(backgroundColor="#FFFFFF", frameRate="40", width="800", height="600")]
	public class TutorialHelloWorld extends Sprite {

		public function TutorialHelloWorld():void {
			if (stage)
				init();
			else
				addEventListener(Event.ADDED_TO_STAGE, init);
		}

		private function init(e:Event = null):void {
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point

			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.quality = StageQuality.HIGH;

			// инициализация шрифтов
			LabelTF.embedFonts = false;
			LabelTF.defaultFormat = new TextFormat("Tahoma", 12, 0xffffff, false);
			Label.fontDescription = new FontDescription("Tahoma");
			Label.fontDescription.fontLookup = FontLookup.DEVICE;

			// отключаем мышиные события у главного контейнера, для нормальной работы MouseManager
			this.mouseEnabled = false;
			this.tabEnabled = false;

			GUI.init(stage);

			// создание текстовой метки
			var label:Label = new Label();
			label.x = label.y = 50;
			label.text = "Hello World!";
			addChild(label);

		}

	}

}
