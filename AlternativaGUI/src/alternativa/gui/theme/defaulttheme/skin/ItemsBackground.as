package alternativa.gui.theme.defaulttheme.skin {
	import alternativa.gui.alternativagui;
	import alternativa.gui.base.ActiveObject;
	import alternativa.gui.mouse.CursorManager;
	import alternativa.gui.theme.defaulttheme.primitives.base.StretchBitmapOffset;
	
	import flash.display.BitmapData;
	
	use namespace alternativagui;
	
	public class ItemsBackground extends StretchBitmapOffset {
		private var area:ActiveObject;
		public function ItemsBackground(texture:BitmapData = null,
										leftEdgeWidth:int = 10,
										rightEdgeWidth:int = 10,
										topEdgeHeight:int = 10,
										bottomEdgeHeight:int = 10,
										drawMiddleCenter:Boolean = true,
										offsetTop:int = 2,
										offsetRight:int = 3,
										offsetLeft:int = 3,
										offsetBottom:int = 4) {
			if(!texture){
				texture = DropDownMenuSkin.itemsBackgroundTexture;
			}
			super(texture, leftEdgeWidth,rightEdgeWidth,topEdgeHeight,bottomEdgeHeight,drawMiddleCenter,offsetTop,offsetRight,offsetLeft,offsetBottom);
			area = new ActiveObject();
			area.cursorType = CursorManager.ARROW;
			addChild(area);
		}
		
		
		override public function drawGraphics():void {
			super.drawGraphics();
			area.graphics.clear();
			area.graphics.beginFill(0x00FF00, 0);
			area.graphics.drawRect(0,0,_width,_height);		
		}
	}
}
