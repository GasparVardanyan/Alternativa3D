package alternativa.gui.utils {
	
	import alternativa.init.GUI;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	
	/**
	 * Создание BitmapData из DisplayObject заданного размера.
	 * 
	 */	
	public class UtilsGUI {
		
		/**
		 * 
		 * @param source Графический объект.
		 * @param width Ширина.
		 * @param height Высота.
		 * @param matrix Матрица преобразований.
		 * @param clipRect Объект Rectangle, определяющий для рисования область исходного объекта.
		 * 
		 * 
		 */		
		public static function rasterize(source:DisplayObject, width:int = 1, height:int = 1, matrix:Matrix = null, clipRect:Rectangle = null):BitmapData {
			var result:BitmapData = new BitmapData(width, height, true, 0x00ff0000);
			var stage:Stage = GUI.stage;
			
			var oldStageQuality:String = stage.quality;
			stage.quality = StageQuality.HIGH;
			
			var sourceVisible:Boolean = source.visible;
			source.visible = true;
			result.draw(source, matrix, null, BlendMode.NORMAL, clipRect, false);
			source.visible = sourceVisible;
			
			stage.quality = oldStageQuality;
			return result;			
		}

	}
}