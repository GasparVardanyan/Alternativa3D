package {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.mouse.dnd.IDragObject;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;

	import flash.display.DisplayObject;

	use namespace alternativagui;
	
	// Визуальный объект, который показывается при перетаскивании
	public class DragObject extends GUIobject implements IDragObject {
		private var dataObject:Object;

		public function DragObject(dataObject:Object) {
			this.dataObject = dataObject;
			_width = 100;
			_height = 100;
			this.graphics.beginFill(0xFF0000, 0.5);
			this.graphics.drawRect(0,0,_width,_height);
			var label:Label = new Label();
			label.text = dataObject.text;
			label.x = (_width - int(label.width)) >> 1;
			label.y = (_height - int(label.height)) >> 1;
			addChild(label);
		}

		public function get data():Object {
			return dataObject;
		}

		public function get graphicObject():DisplayObject {
			return this;
		}
	}
}
