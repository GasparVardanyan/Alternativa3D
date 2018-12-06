package alternativa.physics3dintegration {
	import alternativa.engine3d.materials.VertexLightTextureMaterial;
	import alternativa.engine3d.resources.BitmapTextureResource;

	import flash.display.BitmapData;

	/**
     * EN:
     * <code>VertexLightTextureMaterial<code> with one color texture.
     *
     * RU:
	 * <code>VertexLightTextureMaterial<code> с одноцветной текстурой.
	 */
	public class VertexLightMaterial extends VertexLightTextureMaterial{
		/**
         * EN:
         * Creates material.
         * @param color texture color
         * @param alpha transparency
         *
         * RU:
		 * Создает материал.
		 * @param color цвет текстуры
		 * @param alpha прозрачность
		 */
		public function VertexLightMaterial(color:uint, alpha:Number = 1.0) {
			super(new BitmapTextureResource(new BitmapData(1, 1, false, color)), null, alpha);
		}
	}
}
