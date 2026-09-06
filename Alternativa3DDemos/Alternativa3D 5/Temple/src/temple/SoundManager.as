package temple {
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
	 * The class is responsible for loading of sound files and steps sound switching.
	 */
	public class SoundManager {
		
		public static const STONE_WALK:uint = 0;
		public static const STONE_RUN:uint = 1;
		public static const GRASS_WALK:uint = 2;
		public static const GRASS_RUN:uint = 3;
		
		private var currentStepsType:int = -1;
		private var stepsIntervalId:int;
		private var volumeIntervalId:int;
		
		private var stepsLoaded:Boolean = false;
		private var environmentLoaded:Boolean = false;
		
		// Loading sequence
		private var sequence:Array = ["stone1.mp3", "stone2.mp3", "stone3.mp3", "stone4.mp3", "grass1.mp3", "grass2.mp3", "grass3.mp3", "grass4.mp3", "environment.mp3"];
		private var counter:int = -1;
		
		private var sound:Sound;
		private var stoneSounds:Array = new Array();
		private var grassSounds:Array = new Array();
		private var environmentSound:Sound;
		private var environmentChannel:SoundChannel;
		private var environmentTransform:SoundTransform;
		
		private var onLoadMethod:Function;

		/**
		 * The method starts loading of the sound files.
		 * 
		 * @param onLoadMethod function which is called after all sound files are loaded
		 * @return status message
		 */
		public function load(onLoadMethod:Function):String {
			this.onLoadMethod = onLoadMethod;
			loadNext();
			return "Loading sound";
		}

		/**
		 * The method loads next file from the loading sequence
		 */
		private function loadNext():void {
			counter++;
			if (sound != null) {
				sound.removeEventListener(Event.COMPLETE, onLoadComplete);
				sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				sound.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				sound.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			}
			if (counter < sequence.length) {
				sound = new Sound();
				sound.addEventListener(Event.COMPLETE, onLoadComplete);
				sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
				sound.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
				sound.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
				sound.load(new URLRequest(sequence[counter]), new SoundLoaderContext());
			} else {
				onLoadMethod.call();
				onLoadMethod = null;
				sound = null;
			}
		}
		
		/**
		 * The method is called after a sound file is loaded.
		 */
		private function onLoadComplete(e:Event):void {
			if (counter < 4) {
				stoneSounds.push(sound);
			} else {
				if (counter < 8) {
					grassSounds.push(sound);
					if (counter == 7) {
						stepsLoaded = true;
					}
				} else {
					environmentLoaded = true;
					environmentSound = sound;
					environmentTransform = new SoundTransform(0);
					environmentChannel = environmentSound.play(0, 1000000, environmentTransform);
					volumeIntervalId = setInterval(addVolume, 100); 
				}
			}
			loadNext();
		}

		/**
		 * Since it's just a demo, the method discards the error and loads the next file.
		 */
		private function onLoadError(e:IOErrorEvent):void {
			loadNext();
		}
		
		/**
		 * The method enables the steps sound of the given type.
		 * 
		 * @param type sound type
		 */
		public function playSteps(type:uint):void {
			if (currentStepsType != type) {
				stopSteps();
				currentStepsType = type;
				playRandomStepSample();
				stepsIntervalId = setInterval(playRandomStepSample, (type == STONE_WALK || type == GRASS_WALK) ? 500 : 300);
			}
		}
		
		/**
		 * The method turns off the steps sound.
		 */
		public function stopSteps():void {
			if (currentStepsType > -1) {
				clearInterval(stepsIntervalId);
				currentStepsType = -1;
			}
		}
		
		/**
		 * The method plays back random steps sound of the current type.
		 */
		private function playRandomStepSample():void {
			if (stepsLoaded) {
				var sound:Sound;
				if (currentStepsType == STONE_WALK || currentStepsType == STONE_RUN) {
					sound = stoneSounds[Math.round(MathUtils.random(0, stoneSounds.length - 1))];
				} else {
					sound = grassSounds[Math.round(MathUtils.random(0, grassSounds.length - 1))];
				}
				if (sound != null) {
					sound.play(0, 0, new SoundTransform(3));
				}
			}
		}
		
		/**
		 * The method increases ambient sound gradually.
		 */
		private function addVolume():void {
			environmentTransform.volume += 0.02;
			if (environmentTransform.volume >= 4) {
				environmentTransform.volume = 4;
				clearInterval(volumeIntervalId);
			} 
			environmentChannel.soundTransform = environmentTransform;
		}
	}
}