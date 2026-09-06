package strategy.progress {

	import flash.events.Event;
	import flash.filters.BlurFilter;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;

	public class ProgressWindow extends Window {

		private static const normalTextFormat:TextFormat = new TextFormat("Tahoma", 11, 0xFFFFFF); 
		private static const lockedTextFormat:TextFormat = new TextFormat("Tahoma", 11, 0xFF0000); 

		private var statusText:TextField = new TextField();
		private var progressBar:ProgressBar = new ProgressBar();
		private var _locked:Boolean = false;

		public function ProgressWindow(status:String = "", width:int = 400, height:int = 20) {
			super(width, height);
			statusText.selectable = false;
			statusText.autoSize = TextFieldAutoSize.LEFT;
			statusText.defaultTextFormat = normalTextFormat;
			statusText.text = status;
			statusText.filters = [new BlurFilter(0,0)];
			innerContainer.addChild(statusText);
			innerContainer.addChild(progressBar);
			innerContainer.x = 6;
			innerContainer.y = int((height - innerContainer.height)*0.5);
			progressBar.y = int((innerContainer.height - progressBar.height)*0.5);
			resizeProgressBar(); 
		}

		/**
		 * @private 
		 */
		override public function set width(value:Number):void {
			if (_width != value) {
				super.width = value;
				resizeProgressBar();
			}
		}

		/**
		 * @private 
		 */
		override public function set height(value:Number):void {
			if (_height != value) {
				super.height = value;
				innerContainer.y = int((_height - innerContainer.height)*0.5);
				progressBar.y = int((innerContainer.height - progressBar.height)*0.5);
			}
		}

		/**
		 * Текст статуса. 
		 */
		public function get status():String {
			return statusText.text;
		}

		/**
		 * @private 
		 */
		public function set status(value:String):void {
			statusText.text = value;
			resizeProgressBar();
		}

		/**
		 * Режим блокировки. 
		 */
		public function get locked():Boolean {
			return _locked;
		}

		/**
		 * @private 
		 */
		public function set locked(value:Boolean):void {
			if (_locked != value) {
				_locked = value;
				if (value) {
					statusText.setTextFormat(lockedTextFormat);
				} else {
					statusText.setTextFormat(normalTextFormat);
				}
			}
		}

		/**
		 * Прогресс.
		 */
		public function get progress():Number {
			return progressBar.progress;
		}

		/**
		 * @private
		 */
		public function set progress(value:Number):void {
			progressBar.progress = value;
		}
		
		/**
		 *  Спрятать.
		 */ 
		public function hide():void {
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}

		/**
		 * Пересчет прогресса.
		 */
		protected function resizeProgressBar():void {
				progressBar.x = statusText.textWidth + 6;
				progressBar.width = _width - progressBar.x - 12; 
		}
		
		private function onEnterFrame(event:Event):void {
			this.alpha -= 0.01;
			if (this.alpha <= 0) {
				removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				this.parent.removeChild(this);
			}
			
		}
		

	}
}
