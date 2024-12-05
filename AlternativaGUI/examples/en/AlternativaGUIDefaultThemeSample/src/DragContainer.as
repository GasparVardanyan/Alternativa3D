package {

	import alternativa.gui.base.GUIobject;

	/**
	 *
	 * Container for the dragging
	 *
	 */
	public class DragContainer extends GUIobject {
		public function DragContainer() {
			var dragArea:DragArea = new DragArea();
			addChild(dragArea);
			dragArea.x = dragArea.y = 50;

			var dropArea:DropArea = new DropArea();
			addChild(dropArea);
			dropArea.x = 70;
			dropArea.y = 350;
		}

		override protected function calculateWidth(value:int):int {
			if (value < 200)
				value = 200;
			return value;
		}

		override protected function calculateHeight(value:int):int {
			if (value < 500)
				value = 500;
			return value;
		}
	}
}
