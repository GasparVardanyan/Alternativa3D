package {
	import flash.display.Bitmap;
	
	import mx.containers.VBox;
	import mx.controls.Image;
	import mx.controls.Label;
	import mx.core.ScrollPolicy;
	import mx.events.FlexEvent;

	public class ImageItemRenderer extends VBox {
		private var img:Image = new Image();
		private var lbl:Label = new Label();


		public function ImageItemRenderer() {
			super();
			
			this.width=52;
			this.height=82;
			
			setStyle("horizontalAlign","center");
			setStyle("verticalGap","0");
			
			addChild(img);
			addChild(lbl);
			
			img.width = img.height = 50;
			
			verticalScrollPolicy = ScrollPolicy.OFF;
			horizontalScrollPolicy = ScrollPolicy.OFF;
			
			updateDisplayList(52,82);
			
			addEventListener(FlexEvent.DATA_CHANGE, dataChangeHandler);
		}

		private function dataChangeHandler(event:FlexEvent):void {
			
			img.source = data["image"];
			lbl.text = data["label"];
		}
	

	}
}