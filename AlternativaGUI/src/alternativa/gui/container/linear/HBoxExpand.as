package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;

	import flash.display.DisplayObject;
	use namespace alternativagui;

	/**
	 * Горизонтальный контейнер с постоянным зазором между элементами. Размер контейнера увеличивается под размер элементов.
	 *
	 *
	 * @see HBox
	 * @see RelativeHBox
	 */
	public class HBoxExpand extends HBox {

		/**
		 * @inheritDoc
		 */
		public function HBoxExpand(space:int = 10) {
			super(space);
		}

		/**
		 * Ширина зависит от контента. При вызове <code>get width</code> вызывается <code>calculateSize()</code>.
		 */
		override public function get width():Number {
			calculateSize();
			return _width;
		}

		override public function set width(value:Number):void {
		}

		/**
		 * Высота зависит от контента. При вызове <code>get height</code> вызывается <code>calculateSize()</code>.
		 */
		override public function get height():Number {
			calculateSize();
			return _height;
		}

		override public function set height(value:Number):void {
		}

		override public function addChild(child:DisplayObject):DisplayObject {
			super.addChild(child);
			//   child.x = _width + (_width > 0 ? _space : 0);
			calculateSize();
			return child;
		}

		/**
		 * Пересчет размера контейнера.
		 *
		 */
		public function calculateSize():void {
			super.draw();
			var i:int;
			var object:DisplayObject;
			var maxHeight:int = 0;

			_width = 0;
			var objectsLength:int = _objects.length
			var h:int;
			for (i = 0; i < objectsLength; i++) {
				object = _objects[i] as DisplayObject;
				h = object.height;
				if (maxHeight < h) {
					maxHeight = h;
				}
				object.x = _width;
				_width += (object.width + (i < objectsLength - 1 ? _space : 0));
			}
			_height = maxHeight;
		}

	}
}
