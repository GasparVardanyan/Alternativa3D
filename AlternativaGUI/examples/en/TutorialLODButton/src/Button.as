package {
	import alternativa.gui.alternativagui;
	import alternativa.gui.controls.button.BaseButton;
	import alternativa.gui.controls.text.Label;
	import alternativa.gui.lod.simple.ISimpleLODobject;
	import alternativa.gui.lod.simple.LODlistenerPriority;
	import alternativa.gui.lod.simple.SimpleLODbitmap;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;
	
	import flash.display.DisplayObject;

	use namespace alternativagui;

	public class Button extends BaseButton implements ISimpleLODobject {
		// LOD index
		private var index:int;

		// Pririty of button LOD (layer of detail)
		private var priority:LODlistenerPriority;

		// Icon
		private var _icon:SimpleLODbitmap;

		// Text label
		private var _label:Label;

		// Array of text label sizes
		private var fontSizeArray:Array;

		// Array of padding
		private var paddingArray:Array;

		// Current padding
		private var padding:int = 0;

		// Array of button heights
		private var buttonHeightArray:Array;

		// Current button height
		private var buttonHeight:int = 0;

		// Array of minimal button widths
		private var minWidthArray:Array;

		// Current minimal button width
		private var minWidth:int = 0;

		// Array of distances between icons and text labels
		private var spaceArray:Array;

		// Current distance between icon and text label
		private var space:int = 0;
		
		// Text color
		private var fontColor:Number = 0xe9e9e9;
		
		// Transparency on _locked = true;
		private var alphaValue:Number = 0.6;

		public function Button() {
			super();
			
			// Set priority
			priority = LODlistenerPriority.CONTROL;
			
			fontSizeArray = [ButtonSkin.fontSize0, ButtonSkin.fontSize1, ButtonSkin.fontSize2];
			paddingArray = [ButtonSkin.padding0, ButtonSkin.padding1, ButtonSkin.padding2];
			buttonHeightArray = [ButtonSkin.buttonHeight0, ButtonSkin.buttonHeight1, ButtonSkin.buttonHeight2];
			minWidthArray = [ButtonSkin.minWidth0, ButtonSkin.minWidth1, ButtonSkin.minWidth2];
			spaceArray = [ButtonSkin.space0, ButtonSkin.space1, ButtonSkin.space2];
			
			// Set skin to stateUP
			stateUP = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateUpLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
									   new StretchRepeatHBitmap(ButtonSkin.stateUpLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
									   new StretchRepeatHBitmap(ButtonSkin.stateUpLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));
			// Set skin to stateOVER
			stateOVER = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateOverLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
										 new StretchRepeatHBitmap(ButtonSkin.stateOverLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
										 new StretchRepeatHBitmap(ButtonSkin.stateOverLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));
			// Set skin to stateDOWN
			stateDOWN = new LODSkinState(new StretchRepeatHBitmap(ButtonSkin.stateDownLod0Texture, ButtonSkin.edge0, ButtonSkin.edge0), 
										 new StretchRepeatHBitmap(ButtonSkin.stateDownLod1Texture, ButtonSkin.edge1, ButtonSkin.edge1),
										 new StretchRepeatHBitmap(ButtonSkin.stateDownLod2Texture, ButtonSkin.edge2, ButtonSkin.edge2));

		}
		
		// Override draw method of BaseButton
		override protected function draw():void {
			super.draw();
			// Calculate value of unoccupied width to position an icon or a text label horizontally
			var emptyWidth:int = _width - padding * 2 - ((_icon != null) ? _icon.width : 0) - ((_label != null) ? int(_label.width) : 0) - ((_label != null && _icon != null) ? space : 0);
			
			// Check for an icon
			if (_icon != null) {
				_icon.x = padding + (emptyWidth >> 1);
				_icon.y = (_height - _icon.height) >> 1;
			}
			
			// Check for a text label
			if (_label != null) {
				if (_icon != null) {
					_label.x = _icon.x + _icon.width + space;
				} else {
					_label.x = padding + (emptyWidth >> 1);
				}
				_label.y = (_height - int(_label.height)) >> 1;
			}

		}
		
        // Override the method: give a fixed button height, depending on the LOD index
		override protected function calculateHeight(value:int):int {
			return buttonHeight;
		}
		
        // Override the method: calculate the minimal width. The size of the button can not be less than the actual width
		override protected function calculateWidth(value:int):int {
			var contentWidth:int = padding * 2 + ((_icon != null) ? _icon.width : 0) + ((_label != null) ? int(_label.width) : 0) + ((_label != null && _icon != null) ? space : 0);
			if (value < contentWidth) {
				value = contentWidth;
			}
			if (value < minWidth) {
				value = minWidth;
			}
			return value;
		}


        // Changes of button appearance when change the LOD index
		private function changeSkin():void {
			space = spaceArray[index];
			minWidth = minWidthArray[index];
			padding = paddingArray[index];
			buttonHeight = buttonHeightArray[index];
			
			if (_label != null) {
				_label.size = fontSizeArray[index];
			}
			resize(_width, _height);
		}
		
        // Override the method: if button is locked, then icon and text label are fade
		override public function set locked(value:Boolean):void {
			super.locked = value;
			if (_locked) {
				if (_icon != null) {
					_icon.alpha = alphaValue;
				}
				if (_label != null) {
					_label.alpha = alphaValue;
				}
			} else {
				if (_icon != null) {
					_icon.alpha = 1;
				}
				if (_label != null) {
					_label.alpha = 1;
				}
			}
		}
		
		/**
		 * LOD index. Also item sizes are depended on LOD index.
		 * So, item width or/and item height  will discrete change depending on index.
		 */

		public function get LODindex():int {
			return index;
		}

		public function set LODindex(value:int):void {
			index = value;
			changeSkin();
			
		}

		/**
		 * Priority of getting the new index on change.
		 */
		public function get LODpriority():LODlistenerPriority {
			return priority;
		}

		public function set LODpriority(value:LODlistenerPriority):void {
			priority = value;
		}

		public function get icon():SimpleLODbitmap {
			return _icon;
		}
		
		// Set an icon
		public function set icon(value:SimpleLODbitmap):void {
			if (_icon != null) {
				if (contains(_icon)) {
					removeChild(_icon);
				}
				_icon = null;
			}
			if (value != null) {
				_icon = value;
				addChild(_icon);
				if (_locked) {
					if (_icon != null) {
						_icon.alpha = alphaValue;
					}
				}
			}
			draw();
		}

		public function get label():String {
			return _label.text;
		}
		// Set the text of a text label.
		public function set label(value:String):void {
			if (_label == null) {
				_label = new Label();
				addChild(_label);
				_label.size = fontSizeArray[index];
				if (_locked) {
					if (_label != null) {
						_label.alpha = alphaValue;
					}
				}
				_label.color = fontColor;
			}
			_label.text = value;
			resize(_width, _height);
		}

	}

}
