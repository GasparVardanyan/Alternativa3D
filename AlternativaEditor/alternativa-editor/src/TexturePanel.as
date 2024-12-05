package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import gui.events.PropListEvent;
	
	import mx.collections.ArrayCollection;
	import mx.containers.HBox;
	import mx.containers.Panel;
	import mx.controls.Image;
	import mx.controls.TileList;
	import mx.core.ClassFactory;
	import mx.events.ListEvent;

	public class TexturePanel extends Panel {

		private var list:TileList = new TileList();
		private var thumb:Image = new Image();
		private static var dp:Array;
		public var selectedItem:* = null;
		public var empty:Boolean = true;
		
		public function TexturePanel() {
			var hbox:HBox = new HBox();
			
			super();
			dp = new Array();
			this.title = "Textures";
//			this.minimizable = this.maximizable = false;
//			this.type = NativeWindowType.UTILITY; 
//			this.alwaysInFront = true;
			
			addChild(hbox);
			
			hbox.addChild(list);
			hbox.addChild(thumb);
			
			this.percentWidth = 100;
			this.height = 140;
			
			hbox.percentHeight = hbox.percentWidth = 100;
			hbox.setStyle("verticalAlign","middle");
			
			thumb.width = thumb.height = 100;
			list.percentWidth = 100;
			list.height = 80;
			list.setStyle("verticalAlign","middle");
			
			
			list.dataProvider = dp;
			
			list.rowHeight=82;
			list.columnWidth=52;
			list.itemRenderer = new ClassFactory(ImageItemRenderer);
			list.addEventListener(ListEvent.ITEM_CLICK, onSelect);
			
		}
		
		private function onSelect(e:ListEvent):void {
			thumb.source = e.itemRenderer.data.pr;// new Bitmap(bmp);
			selectedItem = e.itemRenderer.data.id;
			dispatchEvent(new PropListEvent(0, e.itemRenderer.data.id));
		}
		
		public function addItem(id:Object, picture:Bitmap=null, label:String=''):void {
			var img:Sprite = new Sprite();
			var pr:Sprite = new Sprite();
			img.addChild(picture);
			pr.addChild(new Bitmap(picture.bitmapData));
			var item:Object = {id:id, image:img, label:label, pr:pr};
//			dp.addItem(item);
			dp.push(item);
			dp.sortOn("label");
			empty = false;
			
		}
		
		public function deleteAllProps():void {
			dp = new Array();
			list.dataProvider = dp;
			thumb.source=null;
			empty = true;
			
		}
		
	}
}