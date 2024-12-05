package {

	import alternativa.gui.enum.Align;
	import alternativa.gui.layout.DefaultLayoutManager;
	import alternativa.gui.layout.LayoutManager;
	import alternativa.gui.mouse.CursorData;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.mouse.MouseManager;
	import alternativa.gui.theme.defaulttheme.init.DefaultTheme;
	import alternativa.gui.theme.defaulttheme.primitives.base.Hint;
	import alternativa.gui.theme.defaulttheme.skin.Cursors;
	import alternativa.init.GUI;
	
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.geom.Point;
	import flash.ui.MouseCursorData;

	[SWF(backgroundColor="#999999", frameRate="40", width="800", height="750")]
	public class AlternativaGUIDefaultThemeSample extends Sprite {
		
		private var objectContainer:Sprite;
		private var hintContainer:Sprite;
		
		public function AlternativaGUIDefaultThemeSample() {
			stage.align = StageAlign.TOP_LEFT;
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.stageFocusRect = false;
			stage.quality = StageQuality.HIGH;
			
			this.mouseEnabled = false;
			this.tabEnabled = false;
			
			// Контейнер с объектами
			objectContainer = new Sprite();
			objectContainer.mouseEnabled = false;
			objectContainer.tabEnabled = false;
			addChild(objectContainer);
			
			// Контейнер для хинта
			hintContainer = new Sprite();
			hintContainer.mouseEnabled = false;
			hintContainer.tabEnabled = false;
			addChild(hintContainer);
			
			// Инициализация AlternativaGUIDefaultTheme
			DefaultTheme.init();
			
			// Инициализация AlternativaGUI
			GUI.init(stage);
			GUI.logoAlign = Align.BOTTOM_LEFT;
			GUI.logoHorizontalMargin = 19;
			GUI.logoVerticalMargin = 10;
			
			// Инициализация LayoutManager 
			LayoutManager.init(stage, [objectContainer]);
			
			// Добавляем класс хинта в MouseManager
			MouseManager.setHintImaging(hintContainer, new Hint());
			
			// Инициализация CursorManager. Передаем массив кастомных курсоров
			CursorManager.init(Cursors.createCursors());
			
			// Создаем и добавляем контейнер с эелементами
			var containerSample:ContainerSample = new ContainerSample();
			objectContainer.addChild(containerSample);
			
			
		}

	}
}