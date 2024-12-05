package {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.mouse.dnd.IDrag;
	import alternativa.gui.mouse.dnd.IDragObject;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;

	use namespace alternativagui;

    // If we click on this object, drag is activated
	public class DragArea extends ActiveObject implements IDrag {

		private var data:Object;

		private var count:int = 0;

		public function DragArea() {
			super();
			data = new Object();

			_width = 100;
			_height = 100;
			this.graphics.beginFill(0xFF0000, 1);
			this.graphics.drawRect(0,0,_width,_height);
			var label:Label = new Label();
			label.text = "Drag me";
			label.x = (_width - int(label.width)) >> 1;
			label.y = (_height - int(label.height)) >> 1;
			addChild(label);
		}

		public function isDragable():Boolean {
			return true;
		}

		public function getDragObject():IDragObject {
			data.text = "Object" + String(count);
			count++;
			return new DragObject(data);
		}
	}
}
