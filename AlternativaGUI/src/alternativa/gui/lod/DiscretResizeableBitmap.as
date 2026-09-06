package alternativa.gui.lod {
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.ResizeableBitmap;
	
	import flash.display.BitmapData;
	use namespace alternativagui;
	
	/**
	 * Объект, представляющий текстуру в виде последовательности её уменьшенных копий.
	 * Каждая следующая в два раза меньше предыдущей. Последняя имеет размер 1х1 пиксел.
	 * Чем меньше ширина отрисовываемого объект, тем меньшая текстура выбирается.
	 * Размер объекта меняется дискретно.
	 */
	public class DiscretResizeableBitmap extends ResizeableBitmap {
		
		/**
		 * 
		 * @param texture Текстура.
		 * @param statesNum Количество лодов.
		 * 
		 */		
		public function DiscretResizeableBitmap(texture:BitmapData, statesNum:int) {
			super(texture, false, statesNum);
		}
		
		/**
		 * @inheritDoc 
		 * 
		 */		
		override protected function draw():void {
			if (textures.length > 0) {
				bitmap.bitmapData = textures[getLevel(_width)];
				bitmap.smoothing = true;
				_width = bitmap.width;
				_height = bitmap.height;
			}
		}

	}
}