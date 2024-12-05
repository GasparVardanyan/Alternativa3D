package {
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.controls.text.LabelTF;
	import alternativa.gui.layout.DefaultLayoutManager;
	import alternativa.gui.layout.IStageSizeListener;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.init.GUI;
	
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.text.Font;
	import flash.text.TextFormat;
	import flash.text.engine.FontDescription;
	import flash.text.engine.FontLookup;
	
	[SWF(backgroundColor="#666666", frameRate="40", width="800", height="600")]
	public class TutorialLODButton extends Sprite {

		private var objectContainer:Sprite;

		public function TutorialLODButton():void {
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
			
			// Контейнер с объектами
			objectContainer = new Sprite();
			objectContainer.mouseEnabled = false;
			objectContainer.tabEnabled = false;
			addChild(objectContainer);

			GUI.init(stage);
			// Инициализация LayoutManager 
			LayoutManager.init(stage, [objectContainer]);

			// Создание контейнера для контента с интерфейсом  IStageSizeListener
			objectContainer.addChild(new ContentContainer());
		}

	}

}
