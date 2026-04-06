package {
	import alternativa.gui.alternativagui;
	import alternativa.gui.lod.simple.SimpleLODobject;
	import alternativa.gui.primitives.stretch.StretchRepeatHBitmap;
	
	import flash.display.DisplayObject;
	
	use namespace alternativagui;
	
	// Класс для лодирование состояний
	public class LODSkinState extends SimpleLODobject {
		
		// массив графики
		protected var lodSkinArr:Array;
		
		// Старый объект
		protected var oldObject:DisplayObject;

		public function LODSkinState(lodSkin0:StretchRepeatHBitmap, lodSkin1:StretchRepeatHBitmap, lodSkin2:StretchRepeatHBitmap) {
			super();
			lodSkinArr = new Array();
			lodSkinArr.push(lodSkin0);
			lodSkinArr.push(lodSkin1);
			lodSkinArr.push(lodSkin2);
			
		}
		
		// Изменение размером и отрисовка  
		override protected function draw():void {
			if (index == 0) {
				lodSkinArr[0].width = _width;
				lodSkinArr[0].height = _height;
			}

			if (index == 1) {
				lodSkinArr[1].width = _width;
				lodSkinArr[1].height = _height;
			}

			if (index == 2) {
				lodSkinArr[2].width = _width;
				lodSkinArr[2].height = _height;
			}
		}
	
		// Изменение графики в зависимости от индекса лода
		protected function changeSkin():void {
			if (index < 0) {
				index = 0;
			} else if (index > lodSkinArr.length) {
				index = lodSkinArr.length - 1;
			}
			if (oldObject != null) {
				removeChild(oldObject);
			}
			addChild(lodSkinArr[index]);
			oldObject = lodSkinArr[index];
			draw();
		}
		
		override public function set LODindex(value:int):void {
			super.LODindex = value;
			changeSkin();
		} 
	}

}
