package alternativa.gui.container {
	import flash.display.DisplayObject;
	
	/**
	 * Контейнер с объектами.
	 * <p>Объекты принимают высоту и ширину контейнера.</p>
	 * 
	 */	
	public class SimpleContainer extends Container {
		
		public function SimpleContainer() {
			super();
		}
		
		override public function set width(value:Number):void {
			super.width = value;
			for (var i:int = 0; i < _objects.length; i++) {
				(_objects[i] as DisplayObject).width = value;
			}			
        }
		override public function set height(value:Number):void {
			super.height = value;
			for (var i:int = 0; i < _objects.length; i++) {
				(_objects[i] as DisplayObject).height = value;
			}			
        }

	}
}