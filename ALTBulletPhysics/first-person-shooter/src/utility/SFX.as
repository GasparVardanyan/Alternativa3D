package utility {
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	
	/**
	 * ...
	 * @author redefy
	 */
	public class SFX extends Sound {
		private var _url:String;
		private var _music:SoundChannel;

		public function SFX(url:String){
			super();
			_url = url;
			super.load(new URLRequest(_url));
		}
		
		public function start(start:Number = 0, loops:int = 0, transform:SoundTransform = null):void {
			if (!transform) {
				var transform:SoundTransform = new SoundTransform(1, 0);
			}
			_music = super.play(start, loops, transform);
		}
		
		public function stop():void {
			_music.stop();
		}
		
		public function volume(vol:Number = 1):void {
			_music.soundTransform.volume = vol;
		}
	}
}