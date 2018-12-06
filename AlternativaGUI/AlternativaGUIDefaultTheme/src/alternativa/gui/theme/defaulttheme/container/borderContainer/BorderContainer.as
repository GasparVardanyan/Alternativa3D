package alternativa.gui.theme.defaulttheme.container.borderContainer {

	import alternativa.gui.alternativagui;
	import alternativa.gui.base.GUIobject;
	import alternativa.gui.primitives.stretch.StretchBitmap;
	import alternativa.gui.theme.defaulttheme.controls.text.Label;
	import alternativa.gui.theme.defaulttheme.skin.BorderContainerSkin;
	import alternativa.gui.theme.defaulttheme.skin.NumericConst;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.DisplayObject;

	use namespace alternativagui;

	public class BorderContainer extends GUIobject {

		protected var _title:Label;

		protected var border:StretchBitmap;

		protected var leftLine:Bitmap;

		protected var rightLine:Bitmap;

		protected var _padding:int;

		protected var _space:int;

		protected var _lineLeftWidth:int;

		protected var edge:int;

		protected var _content:DisplayObject;

		public function BorderContainer() {
			super();

			_padding = NumericConst.borderContainerPadding;
			_space = NumericConst.borderContainerSpace;
			_lineLeftWidth = NumericConst.borderContainerLineLeftWidth;

			edge = BorderContainerSkin.edge;
			border = new StretchBitmap(BorderContainerSkin.borderTexture, edge, edge, edge, edge);
			addChild(border);
			leftLine = new Bitmap(BorderContainerSkin.lineTexture.clone());
			addChild(leftLine);
			rightLine = new Bitmap(BorderContainerSkin.lineTexture.clone());
			addChild(rightLine);
		}

		override protected function draw():void {
			if (_title != null) {
				_title.x = edge + _lineLeftWidth + _space;
				border.y = _title.height >> 1;

				border.resize(_width, (_height - (_title.height >> 1)));
				if (_content != null) {
					_content.x = _padding;
					_content.y = _padding + int(_title.height);
					_content.width = _width - _padding * 2;
					_content.height = _height - _padding * 2 - int(_title.height);
				}
			} else {

				border.resize(_width, _height);
				if (_content != null) {
					_content.x = _padding;
					_content.y = _padding;
					_content.width = _width - _padding * 2;
					_content.height = _height - _padding * 2;
				}
			}
		}

		override public function drawGraphics():void {
			if (_title != null) {
				leftLine.x = edge;
				leftLine.width = _lineLeftWidth;
				leftLine.y = _title.height >> 1;
				rightLine.x = _title.x + int(_title.width) + _space;
				rightLine.width = _width - edge * 2 - _space * 2 - int(_title.width) - _lineLeftWidth;
				rightLine.y = _title.height >> 1;
			} else {
				leftLine.x = edge;
				leftLine.width = 0;
				rightLine.x = edge;
				rightLine.width = _width - edge * 2;
			}
		}

		override protected function calculateHeight(value:int):int {
			if (value > NumericConst.listMinHeight) {
				if (_title != null) {
					if (_content) {
						_content.height = value - _padding * 2 - int(_title.height);
						var contHeight:int = _content.height + int(_title.height) + _padding * 2;
						if (value < contHeight) {
							value = contHeight;
						}
					}
				} else {
					if (_content) {
						_content.height = value - _padding * 2;
						contHeight = _content.height + _padding * 2;
						if (value < contHeight) {
							value = contHeight;
						}
					}
				}
			} else {
				value = NumericConst.listMinHeight;
			}
			return value;
		}
		
		override protected function calculateWidth(value:int):int {
			var contWidth:int = (_title != null ? (int(_title.width) + _space*2 + _lineLeftWidth*2) : 0) + edge * 2;
			if (contWidth < NumericConst.listMinWidth) {
				contWidth = NumericConst.listMinWidth;
			}
			if (value < contWidth) {
				value = contWidth;	
			}
			return value;
		}

		public function get lineLeftWidth():int {
			return _lineLeftWidth;
		}

		public function set lineLeftWidth(value:int):void {
			_lineLeftWidth = value;
		}

		public function get space():int {
			return _space;
		}

		public function set space(value:int):void {
			_space = value;
		}

		public function get padding():int {
			return _padding;
		}

		public function set padding(value:int):void {
			_padding = value;
		}

		public function get title():String {
			return _title.text;
		}

		public function set title(value:String):void {
			if (value != "") {
				if (_title == null) {
					_title = new Label();
					addChild(_title);
				}
				_title.text = value;
			} else {
				if (_title != null) {
					removeChild(_title);
				}
				_title = null;
			}
			draw();
		}

		public function get content():DisplayObject {
			return _content;
		}

		public function set content(value:DisplayObject):void {
			if (_content != null) {
				if (contains(_content)) {
					removeChild(_content);
				}
				_content = null;
			}
			_content = value;
			addChild(_content);
			draw();
		}


	}
}
