package alternativa.engine3d.utils {
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.resources.TextureResource;
	
	use namespace alternativa3d;
	
	public class FogParam {

		/**
		 * @private
		 */
		alternativa3d static const DISABLED:int = 0;
		/**
		 * @private
		 */
		alternativa3d static const SIMPLE:int = 1;
		/**
		 * @private
		 */
		alternativa3d static const ADVANCED:int = 2;
		
		/**
		 * @private
		 */
		public var fogMode:int = SIMPLE;
		/**
		 * @private
		 */
		public var fogNear:Number = 5000;
		/**
		 * @private
		 */
		public var fogFar:Number = 10000;

		/**
		 * @private
		 */
		public var fogMaxDensity:Number = 1;

		/**
		 * @private 83bde0
		 */
		public var fogColorR:Number = 0x83/255;
		/**
		 * @private
		 */
		public var fogColorG:Number = 0xbd/255;
		/**
		 * @private
		 */
		public var fogColorB:Number = 0xe0/255;

		/**
		 * @private
		 */
		public var fogTexture:TextureResource;

		public function FogParam() {
			// constructor code
		}

		public function setColor(color:uint) {
			fogColorR = ((color >> 16) & 0xFF)/ 255;
			fogColorG = ((color >> 8) & 0xFF)/ 255;
			fogColorB = (color & 0xFF)/ 255;
		}
	}
}
