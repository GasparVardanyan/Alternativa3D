package {
	import alternativa.engine3d.controllers.SimpleObjectController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.View;
	import alternativa.engine3d.lights.AmbientLight;
	import alternativa.engine3d.lights.DirectionalLight;
	import alternativa.engine3d.loaders.Parser3DS;
	import alternativa.engine3d.loaders.ParserA3D;
	import alternativa.engine3d.loaders.ParserCollada;
	import alternativa.engine3d.loaders.TexturesLoader;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.objects.SkyBox;
	import alternativa.engine3d.primitives.Box;
	import alternativa.engine3d.resources.BitmapTextureResource;
	import alternativa.engine3d.resources.ExternalTextureResource;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.net.ObjectEncoding;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;

	/**
	 * @author redefy
	 */
	public class Alternativa3DUtilities {
	
	public static function  settingsStage():void {
			GV.stage.align = StageAlign.TOP_LEFT;
			GV.stage.scaleMode = StageScaleMode.NO_SCALE;
	}

		/** 
		 * createCamera() -- Создает камеру и вьюпорт
		 * 
		 * @nearClipping: Ближнее расстояние отсечения.
		 * @farClipping: Дальнее расстояние отсечения.
		 * @x: Координата X.
		 * @y: Координата Y.
		 * @z: Координата Z.
		 * @rotationX: Угол поворота вокруг оси X.
		 * @rotationY: Угол поворота вокруг оси Y.
		 * @rotationZ: Угол поворота вокруг оси Z.
		 * @viewWidth: Ширина вьюпорта.
		 * @viewHeight: Высота вьюпорта.
		 * @backgroundColor: Цвет фона.
		 * @backgroundAlpha: Прозрачность фона.
		 * @diagram: Отображать диаграмму или нет ?
		 * @diagramHorizontalMargin: Отступ диаграммы от края рабочей области по горизонтали.
		 * @diagramVerticalMargin: Отступ диаграммы от края рабочей области по вертикали.
		 * @antiAlias: Степень сглаживания границ 
		 * @logoHorizontalMargin: Отступ логотипа от края вьюпорта по горизонтали.
		 * @logoVerticalMargin: Отступ логотипа от края вьюпорта по вертикали.
		 */  
		public static function  createCamera(object:Object=null):void {
			
			var obj:Object= {nearClipping:0.1,
							 farClipping:10000,
							 x:0,
							 y: -400,
						     z: 0,
							 rotationX: -90*Math.PI/180,
							 rotationY: 0,
							 rotationZ: 0,
							 viewWidth:800, 
							 viewHeight:600,
							 backgroundColor:0x1b1b1b,
							 backgroundAlpha:1.0,
							 diagram:true,
							 diagramHorizontalMargin:10,
							 diagramVerticalMargin:10,
							 antiAlias:2,
							 logoHorizontalMargin:0,
							 logoVerticalMargin:0,
							 shape:true
									      };
			if (object == null) object  = obj;
			
			for (var key:String in obj) {
				if (object[key]==null) object[key]=obj[key];
			}
		
			GV.camera = new Camera3D(object.nearClipping, object.farClipping);
			GV.camera.view = new View(object.viewWidth, object.viewHeight);
			GV.camera.view.backgroundColor = object.backgroundColor;
			GV.camera.view.backgroundAlpha = object.backgroundAlpha;
			GV.camera.view.antiAlias = object.antiAlias;
			GV.camera.view.logoHorizontalMargin = object.logoHorizontalMargin;
			GV.camera.view.logoVerticalMargin = object.logoVerticalMargin;
			
			GV.camera.rotationX = object.rotationX; 
			GV.camera.rotationY = object.rotationY; 
			GV.camera.rotationZ = object.rotationZ; 
			
			GV.camera.x = object.x; 
			GV.camera.y = object.y; 
			GV.camera.z = object.z; 
			
			GV.stage.addChildAt(GV.camera.view, 0);
			
			if(object.diagram){
				GV.stage.addChildAt(GV.camera.diagram,1);
				GV.camera.diagramHorizontalMargin = object.diagramHorizontalMargin;
				GV.camera.diagramVerticalMargin = object.diagramVerticalMargin;
			}
			
			GV.container.addChild(GV.camera); 
			if (object.shape) Alternativa3DUtilities.createShapeDiagram();
		}
		
		public static function createShapeDiagram():void {
				GV.shapeDiagram = new Shape(); //подложка под диаграмму
				GV.shapeDiagram.graphics.lineStyle(2, 0xFFFFFF,0.9);
				GV.shapeDiagram.graphics.beginFill(0x1b1b1b,0.8);
				GV.shapeDiagram.graphics.drawRoundRect(0, 0, 100, 105, 15, 15);
				GV.stage.addChildAt(GV.shapeDiagram, 0);
				GV.shapeDiagram.x = GV.camera.diagram.x - 10;
				GV.shapeDiagram.y = GV.camera.diagram.y - 10; 
		}
		
		public static function createSkybox():void {
			var textureScyD:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyD().bitmapData);
			var textureScyU:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyU().bitmapData);
			var textureScyR:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyR().bitmapData);
			var textureScyL:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyL().bitmapData);
			var textureScyF:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyF().bitmapData);
			var textureScyB:BitmapTextureResource = new BitmapTextureResource(new GFX.SkyB().bitmapData);
			
			GV.skybox = new SkyBox (7000, new TextureMaterial(textureScyL),new TextureMaterial(textureScyR),new TextureMaterial(textureScyB),new TextureMaterial(textureScyF),new TextureMaterial(textureScyD),new TextureMaterial(textureScyU),0.001);
			GV.container.addChild(GV.skybox);
		}
		
		/**
		 * createBoxRedefy() -- создает простой бокс с текстурой
		 * @width:  Ширина.
		 * @height: Длина.
		 * @length: Высота.
		 * @widthSegments: Количество сегментов по ширине.
		 * @heightSegments: Количество сегментов по длине.
		 * @lengthSegments: Количество сегментов по высоте. 
		 * @reverse: Флаг инвертирования нормалей.
		 * @urlTexture: Ссылка на картинку-текстуру
		 */
		public static function createBoxRedefy(object:Object = null):void {
			var obj:Object= {width:100,
							 height:100,
							 length:100,
							 widthSegments: 5,
						     heightSegments: 5,
							 lengthSegments: 5,
							 reverse: false,
							 urlTexture:'../src/resources/redefyBox.jpg'
										};
										
			if (object == null) object  = obj;
			
			for (var key:String in obj) {
				if (object[key]==null) object[key]=obj[key];
			}
			
			GV.model = new Box(object.width, object.length, object.height, object.widthSegments, object.heightSegments, object.lengthSegments, object.reverse);
			GV.texture = new ExternalTextureResource(object.urlTexture);
			GV.textureLoader = new TexturesLoader(GV.stage3D.context3D);
			GV.textureLoader.loadResource(GV.texture as ExternalTextureResource);
			GV.material = new TextureMaterial(GV.texture);
			Mesh(GV.model).setMaterialToAllSurfaces(GV.material);
			GV.container.addChild(GV.model);
		}
		
		/**
		 * createParsers() -- создает парсеры моделей
		 * @_3DS: Создать парсер 3DS ?
		 * @_A3D: Создать парсер A3D ?
		 * @_Collada: Создать парсер Collada ?
		 */
		public static function createParsers(_3DS:Boolean = true, _A3D:Boolean = true, _Collada:Boolean = true):void {
			if (_3DS) GV.parser3DS = new Parser3DS();
			if (_A3D) GV.parserA3D = new ParserA3D();
			if (_Collada) GV.parserCollada = new ParserCollada();
		}
		
		/**
		 * createController() -- создает контроллер
		 * @object: Объект, которым будет управлять контроллер
		 * @speed: Скорость перемещения объекта
		 */
		public static function createController (object:Object3D, speed:Number = 300):void {
			GV.controller = new SimpleObjectController(GV.stage,object, speed);
		}
		
		public static function createLight ():void {
			GV.lightAmbient = new AmbientLight(0xFFFFFF);
			GV.lightAmbient.intensity = 0.7;
			GV.container.addChild(GV.lightAmbient);
			
			GV.lightDirectional = new DirectionalLight(0xFFFFFF);
			GV.lightDirectional.intensity = 1;
			GV.lightDirectional.lookAt (0, 0, 0);
			GV.lightDirectional.z = - 2000;
			GV.container.addChild(GV.lightDirectional);
		}
	}
}