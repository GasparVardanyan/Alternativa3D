package bunker {
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.primitives.Plane;
	import alternativa.types.Texture;
	import alternativa.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.filters.GlowFilter;
	import flash.geom.Matrix;
	
	/**
	 * Animated energy discharge in the reactor room. 
	 */	
	public class Energy extends Plane {
		
		private static const bitmapWidth:uint = 90;
		private static const bitmapHeight:uint = 307;
		private static const glowSize:Number = 20;
		private static const xd:Number = bitmapWidth*0.5 - glowSize;
		private static const texture:Texture = new Texture(new BitmapData(bitmapWidth, bitmapHeight, false, 0x000000));
		
		public var material:TextureMaterial = new TextureMaterial(texture, 1, false, false, BlendMode.ADD, -1, 0xFFFFFF);
		private var shape:Shape = new Shape();
		private var gfx:Graphics = shape.graphics;
		private var drawMatrix:Matrix = new Matrix(1, 0, 0, 1, bitmapWidth*0.5);
		
		/**
		 * 
		 */
		public function Energy() {
			super(120, 409, 1, 1, false);
			// The plane has high mobility due to its constant rotation towards the camera.
			mobility = 100;
			
			rotationX = MathUtils.DEG90;
			
			y = 2322.835;
			z = -228.346;

			setMaterialToSurface(material, "front");
			
			shape.filters = [new GlowFilter(0xEEEE33, 1, glowSize, glowSize, 2, 1)];
		}
		
		/**
		 * Method draws an image of the lightning.
		 */
		public function redraw():void {
			// Drawing image to Shape object
			gfx.clear();
			var n:uint = MathUtils.random(3, 6);
			for (var i:uint = 0; i < n; i++) {
				var strength:Number = Math.random();
				var ex:Number = MathUtils.random(-xd*(1-strength), xd*(1-strength));
				var ey:Number = glowSize;
				gfx.moveTo(ex, ey);
				gfx.lineStyle(strength*8, 0xFFFFFF, strength);
				while (ey < bitmapHeight - glowSize - bitmapHeight/10) {
					ey += MathUtils.random(5, bitmapHeight/10);
					ex += MathUtils.random(-(1-strength)*15, (1-strength)*15);
					ex = (ex < -xd) ? -xd : ((ex > xd) ? xd : ex);
					gfx.lineTo(ex, ey);
				}
				ex += MathUtils.random(-10, 10);
				gfx.lineTo(ex, bitmapHeight - 10);
			}
			// Copying image to the texture
			texture.bitmapData.fillRect(texture.bitmapData.rect, 0);
			texture.bitmapData.draw(shape, drawMatrix);
		}
	}
}