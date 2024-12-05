package {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.mouse.dnd.IDragObject;
	import alternativa.gui.mouse.dnd.IDrop;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;

	use namespace alternativagui;

    // Drop-down area
	public class DropArea extends ActiveObject implements IDrop {

		private var objectLabel:Label;

		public function DropArea() {
			_width = 100;
			_height = 100;
			this.graphics.beginFill(0x00FF00, 1);
			this.graphics.drawRect(0,0,_width,_height);
			var label:Label = new Label();
			label.text = "Drop here";
			label.x = (_width - int(label.width)) >> 1;
			label.y = (_height - int(label.height)) >> 1;
			addChild(label);
			objectLabel = new Label();
			objectLabel.y = label.y + int(label.height) + 5;
			addChild(objectLabel);
		}

        // Enable/disable dragging the object
		public function canDrop(dragObject:IDragObject):Boolean {
			return true;
		}

        // Calls on dropping the object over this area
		public function drop(dragObject:IDragObject):void {
			objectLabel.text = dragObject.data.text;
			objectLabel.x = (_width - int(objectLabel.width)) >> 1;
		}
	}
}
