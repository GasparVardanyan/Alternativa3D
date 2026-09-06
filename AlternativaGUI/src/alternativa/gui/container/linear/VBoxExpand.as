package alternativa.gui.container.linear {
	import alternativa.gui.alternativagui;
	import alternativa.gui.enum.Align;

	import flash.display.DisplayObject;

	use namespace alternativagui;

	/**
	 * Вертикальный контейнер с постоянным зазором между элементами. Размер контейнера увеличивается под размер элементов.
	 *
	 * @see VBox
	 * @see RelativeVBox
	 *
	 */
	public class VBoxExpand extends VBox {
		//    protected var _align:Align;

		/**
		 *
		 * @param space Зазор между объектами.
		 * @param align Выравнивание по горизонтали.
		 *
		 */
		public function VBoxExpand(space:int = 10, align:Align = null) {
			super(space);
			_align = (align == null ? Align.LEFT : align);
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
			//  child.y = _height + (_height > 0 ? _space : 0);
			calculateSize();
			return child;
		}

		/**
		 * Пересчет размера контейнера.
		 *
		 */
		public function calculateSize():void {
			var i:int;
			var object:DisplayObject;
			var maxWidth:int = 0;
			_height = 0;
			for (i = 0; i < _objects.length; i++) {
				object = _objects[i] as DisplayObject;
				var w:int = object.width;
				if (maxWidth < w) {
					maxWidth = w;
				}
				object.y = _height;
				_height += (object.height + (i < _objects.length - 1 ? _space : 0));
			}
			_width = maxWidth;
			for (i = 0; i < _objects.length; i++) {
				object = _objects[i] as DisplayObject;
				object.x = _align == Align.CENTER ? (_width - object.width) >> 1 : 0;
			}
		}

	}
}
