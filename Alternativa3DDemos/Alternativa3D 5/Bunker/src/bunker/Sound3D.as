package bunker {
	import alternativa.types.Point3D;
	
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
	 * The class represents a sound used in the demo.
	 */
	public class Sound3D {

		private var loaded:Boolean = false;
		private var fadeInned:Boolean = false;
		
		private var coords:Point3D;
		private var nearRadius:Number;
		private var farRadius:Number;
		private var maxVolume:Number;
		private var farDelimiter:Number;
		
		private var url:String;
		private var info:String;
		
		private var sound:Sound = new Sound();
		private var channel:SoundChannel;
		private var transform:SoundTransform = new SoundTransform(0);
		private var intervalId:int;
		
		private var volume:Number = 1;
		private var onLoadMethod:Function;
		
		/**
		 * The method calculates sound properties according to the relative position of sound source and an object.
		 * 
		 * @param objectCoords object's coordinates
		 * @param soundCoords sound source's coordinates
		 * @param normal right ear's normal of the object
		 * @param nearRadius inside near radius the sound has full strengh and panning is equal to zero. Outside the near radius the sound's strength is
		 *   dereased inversely proportional to square of the distance.
		 * @param farRadius at the far radius the sounds's strength is "delimiter" times less than full strength
		 * @param delimiter the coefficient shows how much times is the sound strength less at far radius than at near radius
		 * @param soundTransform calculated sound properties are stored here
		 */
		public static function getSoundProperties(objectCoords:Point3D, soundCoords:Point3D, normal:Point3D, nearRadius:Number, farRadius:Number, delimiter:Number, soundTransform:SoundTransform):void {
			var vector:Point3D = Point3D.difference(soundCoords, objectCoords);
			var len:Number = vector.length;
			if (len < nearRadius) {
				// Within the near radius limits the sound strength is at maximum, panning equals zero
				soundTransform.volume = 1;
				soundTransform.pan = 0;
			} else {
				delimiter = Math.sqrt(delimiter);
				var k:Number = 1 + (delimiter - 1) * (len - nearRadius) / (farRadius - nearRadius);
				k *= k;
				soundTransform.volume = 1 / k;
				// Calculating sound panning
				vector.normalize();
				soundTransform.pan = Point3D.dot(vector, normal) * (1 - 1 / k);
			}				
		}
		
		/**
		 * The constructor creates a new instance of the classs.
		 * 
		 * @param coords coordinates of the sound
		 * @param near Near radius. Inside near radius the sound has full strengh and panning is equal to zero. Outside the near radius the sound's strength is
		 *   dereased inversely proportional to square of the distance.
		 * @param far Far radius. At the far radius the sounds's strength is "delimiter" times less than full strength
		 * @param delimiter the coefficient shows how much times is the sound strength less at far radius than at near radius
		 * @param url URL URL of the sound file 
		 * @param info status string
		 * @param multiplier maximum sound strength
		 */
		public function Sound3D(coords:Point3D, near:Number, far:Number, delimiter:Number, url:String, info:String, maxVolume:Number = 1) {
			this.coords = coords.clone();
			this.nearRadius = near;
			this.farRadius = far;
			farDelimiter = delimiter;
			this.url = url;
			this.info = info;
			this.maxVolume = maxVolume;
		}
		
		/**
		 * The method starts loading process.
		 * 
		 * @param onLoadMethod callback function which is called after loading process is complete
		 * 
		 * @return status message
		 */
		public function load(onLoadMethod:Function):String {
			this.onLoadMethod = onLoadMethod;
			sound.addEventListener(Event.COMPLETE, onLoadComplete);
			sound.addEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			sound.addEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			sound.addEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			sound.load(new URLRequest(url), new SoundLoaderContext());
			return info;
		}

		/**
		 * The method is called when the sound is loaded.
		 */
		private function onLoadComplete(e:Event):void {
			channel = sound.play(0, 1000000, transform);
			// Starting method which gradually increases volume
			intervalId = setInterval(addVolume, 100);
			
			loaded = true;
			sound.removeEventListener(Event.COMPLETE, onLoadComplete);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			sound.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			sound.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			onLoadMethod.call();
			onLoadMethod = null;
		}
		
		/**
		 * Error handling during loading process.
		 */
		private function onLoadError(e:IOErrorEvent):void {
			sound.removeEventListener(Event.COMPLETE, onLoadComplete);
			sound.removeEventListener(IOErrorEvent.IO_ERROR, onLoadError);
			sound.removeEventListener(IOErrorEvent.NETWORK_ERROR, onLoadError);
			sound.removeEventListener(IOErrorEvent.VERIFY_ERROR, onLoadError);
			onLoadMethod.call();
			onLoadMethod = null;
		}
		
		/**
		 * 
		 */
		private function addVolume():void {
			transform.volume += 0.05;
			if (transform.volume >= volume) {
				transform.volume = volume;
				clearInterval(intervalId);
				fadeInned = true;
			}
			channel.soundTransform = transform;
		}
		
		/**
		 * The method sets new sound properties according to the relative position of the sound source and the given object.
		 * 
		 * @param coords the object's coordinates
		 * @param normal right ear's normal of the object
		 */
		public function checkVolume(coords:Point3D, normal:Point3D):void {
			if (loaded) {
				var v:Number = transform.volume;
				getSoundProperties(coords, this.coords, normal, nearRadius, farRadius, farDelimiter, transform);
				volume = transform.volume * maxVolume;
				if (fadeInned) {
					transform.volume = volume;
					channel.soundTransform = transform;
				} else {
					transform.volume = v;
				}
			}
		}
	}
}