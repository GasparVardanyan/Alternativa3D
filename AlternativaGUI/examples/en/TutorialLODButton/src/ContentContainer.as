package {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.layout.IStageSizeListener;
	import alternativa.gui.lod.simple.SimpleLODbitmap;
	
	import flash.display.BitmapData;

	use namespace alternativagui;
	/**
	 * Container with IStageSizeListener interface.
	 * Container for the visual data.
	 * Comes new scene sizes
	 * 
	 */	
	public class ContentContainer extends GUIobject implements IStageSizeListener {
		
		// Button
		private var button:Button;
		
		public function ContentContainer() {
			super();
			
			button = new Button();
			button.x = 50;
			button.y = 50;
			button.label = "Settings";
			button.icon = new SimpleLODbitmap(Vector.<BitmapData>([IconSkin.iconLod0Texture, IconSkin.iconLod1Texture, IconSkin.iconLod2Texture]));
			button.resize(150,10);
			addChild(button);
		}
		
		override protected function draw():void {
			super.draw();
			button.width = _width * 0.5;
		}

	}
}
