package bunker {
	import alternativa.utils.MathUtils;
	
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.media.Sound;
	import flash.media.SoundChannel;
	import flash.media.SoundLoaderContext;
	import flash.media.SoundTransform;
	import flash.net.URLRequest;
	import flash.utils.clearInterval;
	import flash.utils.setInterval;
	
	/**
	 * The class controls the sounds of motion.
	 */
	public class MoveSound {
		public static const NONE:uint = 0;
		public static const WALK:uint = 1;
		public static const RUN:uint = 2;
		public static const FLY:uint = 3;
		
		// List of sound files in loading order
		private var sequence:Array = ["step1.mp3", "step2.mp3", "step3.mp3", "step4.mp3", "fly.mp3"];
		private var loaded:Boolean = false;
		private var soundsLoaded:int = -1;
		private var onLoadMethod:Function;
		
		private var sounds:Array = new Array();
		private var sound:Sound;
		private var channel:SoundChannel;
		private var transform:SoundTransform = new SoundTransform();
		
		private var currentMode:int = NONE;
		private var intervalId:int;
		
		/**
		 * The method loads all sound files.
		 * 
		 * @param onLoadMethod callback function which is called after loading is complete
		 */
		public function load(onLoadMethod:Function):String {
			this.onLoadMethod = onLoadMethod;
			loadNext();
			return "Loading sound";
		}

		/**
		 * The method loads next sound file.
		 */
		private function loadNext():void {
			soundsLoaded++;
			if (sound != null) {
				// Removing event handlers of the previous sound object
				sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				sound.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				sound.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			}
			if (soundsLoaded < sequence.length) {
				// Loading next file
				sound = new Sound();
				sound.addEventListener(Event.COMPLETE, onLoadComplete);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				sound.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				sound.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
				sound.load(new URLRequest(sequence[soundsLoaded]), new SoundLoaderContext());
			} else {
				complete();
			}
		}
		
		/**
		 * The method is called after the sound is loaded.
		 */
		private function onLoadComplete(e:Event):void {
			sounds.push(sound);
			loadNext();
		}

		/**
		 * Since it's just a demo, the method discards the error and loads next file.
		 */
		private function onLoadError(e:IOErrorEvent):void {
			loadNext();
		}
		
		/**
		 * The method is called after all sounds are loaded.
		 */
		private function complete():void {
			if (sounds.length == sequence.length) {
				loaded = true;
			}
			onLoadMethod.call();
			onLoadMethod = null;
			sound = null;
		}
		
		/**
		 * The method sets the type of the sound to play.
		 */
		public function setMode(mode:uint, soundVolume:Number = 1):void {
			if (loaded) {
				if (currentMode != mode) {
					if (channel != null) {
						channel.stop();
					}
					clearInterval(intervalId);
					currentMode = mode;
					if (mode == WALK || mode == RUN) {
						playRandomStepSample();
						intervalId = setInterval(playRandomStepSample, (mode == WALK) ? 500 : 300);
					}
					if (mode == FLY) {
						var sound:Sound = sounds[sounds.length - 1];
						if (sound != null) {
							channel = sound.play(0, 1000000, transform);
						}
					}
				}
				if (mode != NONE && transform.volume != soundVolume) {
					transform.volume = soundVolume > 8 ? 8 : soundVolume;
					channel.soundTransform = transform;
				}
			}
		}
		
		/**
		 * The method starts playing sound of steps. 
		 */
		private function playRandomStepSample():void {
			var sound:Sound = sounds[Math.round(MathUtils.random(sounds.length - 2))];
			if (sound != null) {
				channel = sound.play();
			}
		}

		/**
		 * The method plays single step.
		 */
		public function playSingleStepSample():void {
			var sound:Sound = sounds[Math.round(MathUtils.random(sounds.length - 2))];
			if (sound != null) {
				sound.play(0, 1);
			}
		}
	}
}