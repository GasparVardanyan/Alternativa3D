package alternativa.engine3d.resources {
	
	import alternativa.engine3d.alternativa3d;
	
	import flash.utils.ByteArray;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.display.BitmapData;
	import flash.display.Bitmap;
	import flash.display3D.textures.Texture;
	import flash.display3D.Context3D;
	import flash.display3D.Context3DTextureFormat;

	
	
	public class ByteArrayTexture extends Texture{
		
		 
		private var loader : Loader;
		private var c3d : Context3D;
		
		public function ByteArrayTexture(byteArray:ByteArray, context3d : Context3D) {
			// линкуем контекст
			c3d = context3d;
			// создаем лоадер и загружаем картинку 
			loader = new Loader();
			loader.contentLoaderInfo.addEventListener(Event.COMPLETE, decoded);
			loader.loadBytes( byteArray );
		}
		private function decoded(e:Event):void{
			loader.contentLoaderInfo.removeEventListener(Event.COMPLETE, decoded);
			// создаем клон картинки
			var bmp : BitmapData = (loader.content as Bitmap).bitmapData.clone();
			// очищаем память в лоадере
			(loader.content as Bitmap).bitmapData.dispose();
			// умертвляем лоадер
			loader.unload();
			loader = null;
			// создаем текстуру и говорим ей формат
			super ( c3d.createTexture( bmp.width, bmp.height, Context3DTextureFormat.BGR_PACKED, false, 0) );
			// загружаемся
			uploadFromBitmapData(bmp,0);
			// убиваем картинку
			bmp = null;
		}

	}
	
}
