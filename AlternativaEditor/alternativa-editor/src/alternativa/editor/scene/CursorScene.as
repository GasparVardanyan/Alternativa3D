package alternativa.editor.scene {
	
	import alternativa.editor.prop.CustomFillMaterial;
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.TileSprite3D;
	import alternativa.engine3d.controllers.WalkController;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.display.View;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.SpriteTextureMaterial;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.types.Texture;
	import alternativa.utils.MathUtils;
	
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.display.DisplayObject;
	import flash.display.Graphics;
	import flash.display.Shape;
	import flash.geom.Matrix;
	import flash.geom.Point;

	public class CursorScene extends EditorScene {
		// Курсорный проп
		protected var _object:Prop;
		private var redMaterial:Material;
		private var greenMaterial:Material;
		private var material:Material;
		// Индикатор свободного состояния ячейки, в которой находится курсор
		private var _freeState:Boolean = true;
		// Контроллер камеры
		public var cameraController:WalkController;
		// Контроллер для контейнера камеры
		public var containerController:WalkController;
		// Контейнер для камеры
		public var container:Object3D;
		// Индикатор вертикального перемещения
		protected var verticalMoving:Boolean = false;
		// stage
		private var eventSourceObject:DisplayObject;
		// Индикатор режима snap
		protected var _snapMode:Boolean = true;
		//
		private var matrix:Matrix = new Matrix();
		
		private var axisIndicatorOverlay:Shape;
		private var axisIndicatorSize:Number = 30;
		
		[Embed (source = "/red_cursor.jpg")] private static var redClass:Class;
		private static const redBmp:BitmapData = new redClass().bitmapData;
		[Embed (source = "/green_cursor.jpg")] private static var greenClass:Class;
		private static const greenBmp:BitmapData = new greenClass().bitmapData;
		
		public function CursorScene(eventSourceObject:DisplayObject) {
			super();
			this.eventSourceObject = eventSourceObject;
			initControllers();
			view.addChild(axisIndicatorOverlay = new Shape());
		}
		
		/**
		 * 
		 */
		private function initControllers():void {
			// Подключение контроллера камеры
			cameraController = new WalkController(eventSourceObject);
			cameraController.object = camera;
			cameraController.speedMultiplier = 4;
			cameraController.speedThreshold = 1;
			cameraController.mouseEnabled = false;
			
			cameraController.coords = new Point3D(250, -7800, 4670);
			
			// Контейнер
			container = new Object3D();
			root.addChild(container);
			// Контроллер контейнера
			containerController = new WalkController(eventSourceObject);
			containerController.object = container;
			containerController.mouseEnabled = false;
			container.addChild(camera);
		}
		
		/**
		 * Установка курсора. 
		 * @param value
		 * 
		 */		
		public function set object(value:Prop):void {
			var point3D:Point3D;
			if (_object) {
				point3D = _object.coords;
				if (_visible) {
					root.removeChild(_object);
				}
			}
			_object = value;
			material = _object.material.clone();
			material.alpha = 0.5;
			
			if (point3D) {
				_object.coords = point3D;
			}
			if (_visible) {
				root.addChild(_object);
			}
			if (_snapMode) {
				snapObject();
			} 
			
		}
		
		/**
		 * 
		 * @return 
		 */		
		public function get object():Prop {
			return _object;
		}
		
		/**
		 * 
		 * @param value
		 */		
		public function set snapMode(value:Boolean):void {
			if (_snapMode != value && _object) {
				
				_snapMode = value;
				if (value) {
					snapObject();
				} else {
					_object.setMaterial(material);
				}
				
			}
		}
		/**
		 * 
		 * @return 
		 */		
		public function get snapMode():Boolean {
			return _snapMode;
		}
		
		/**
		 * 
		 */		
		private function snapObject():void {
			createMaterials();
			_object.snapCoords();
			
		}
		
		/**
		 * Cоздание зеленого и красного материалов. 
		 */		
		private function createMaterials():void {
			
			var redBmd:BitmapData = _object.bitmapData.clone();
			var greenBmd:BitmapData = redBmd.clone();
			matrix.a = redBmd.width/redBmp.width;
			matrix.d = matrix.a; 
			redBmd.draw(redBmp, matrix, null, BlendMode.HARDLIGHT);
			greenBmd.draw(greenBmp, matrix, null, BlendMode.HARDLIGHT);
			
			if (_object is TileSprite3D) {
				greenMaterial = new SpriteTextureMaterial(new Texture(greenBmd));
				redMaterial = new SpriteTextureMaterial(new Texture(redBmd));
				
			} else {
//				greenMaterial = new TextureMaterial(new Texture(greenBmd));
//				redMaterial = new TextureMaterial(new Texture(redBmd));
				greenMaterial = new CustomFillMaterial(new Point3D(-1e10, -0.7e10, 0.4e10), 0x00FF00); 
				redMaterial = new CustomFillMaterial(new Point3D(-1e10, -0.7e10, 0.4e10), 0xFF0000);
			}
			
			redMaterial.alpha = greenMaterial.alpha = 0.8;
			
			updateMaterial();
		}
		
		
		/**
		 * Перемещение курсора мышью.
		 */		
		public function moveCursorByMouse():void {
			if (_object) {
				var point:Point3D = view.projectViewPointToPlane(new Point(view.mouseX, view.mouseY), znormal, _object.z);
				_object.x = point.x;
				_object.y = point.y;
				if (_snapMode) {
					_object.snapCoords();
				}				
				updateMaterial();
				
			}
		}
		
		
		/**
		 * 
		 * @return 
		 */		
		public function get freeState():Boolean {
			return _freeState;
		}
		
		
		/**
		 * Инициализация основной сцены. 
		 */		
		override protected function initScene():void {
			root = new Object3D();
			
			// Добавление камеры и области вывода
			camera = new Camera3D();
			camera.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
						
			view = new View(camera);
			view.interactive = false;
			view.mouseEnabled = false;
			view.mouseChildren = false;
			
			view.graphics.beginFill(0xFFFFFF);
			view.graphics.drawRect(0, 0, 1, 1);
			view.graphics.endFill();
		}
		
		/**
		 * 
		 */		
		public function updateMaterial():void {
			if (_object && _snapMode) {
				if (occupyMap.isConflict(_object)) {
					_freeState = false;	
					_object.setMaterial(redMaterial);			
				} else {
					_freeState = true;
					_object.setMaterial(greenMaterial);
				} 
			}
		}
		
		public function clear():void {
			if (_object) {
				if (root.getChildByName(_object.name)) {
					root.removeChild(_object);
				}
				_object = null;
				_visible = false;
				
			}
		}
		
		/**
		 * Рисование координатных осей. 
		 * @param matrix
		 * 
		 */		
		public function drawAxis(matrix:Matrix3D):void {
			var gfx:Graphics = axisIndicatorOverlay.graphics;
			var centreX:Number = axisIndicatorSize; 
			var centreY:Number = 0; 
			gfx.clear();
			gfx.lineStyle(2, 0xFF0000);
			gfx.moveTo(centreX, centreY);
			gfx.lineTo(matrix.a*axisIndicatorSize + centreX, matrix.b*axisIndicatorSize + centreY);
			gfx.lineStyle(2, 0x00FF00);
			gfx.moveTo(centreX, centreY);
			gfx.lineTo(matrix.e*axisIndicatorSize + centreX, matrix.f*axisIndicatorSize + centreY);
			gfx.lineStyle(2, 0x0000FF);
			gfx.moveTo(centreX, centreY);
			gfx.lineTo(matrix.i*axisIndicatorSize + centreX, matrix.j*axisIndicatorSize + centreY);
		}
		
		
		private var _visible:Boolean = false;
		
		public function set visible(value:Boolean):void {
			
			if (value != _visible) {
				_visible = value;
				if (_object) {
					if (_visible) {
						root.addChild(_object);
						updateMaterial();
					} else {
						root.removeChild(_object);
					}
				}
			}
		}
		
		public function get visible():Boolean {
			return _visible;
			
		} 
		
		override public function moveByArrows(keyCode:uint, sector:int):void {
			move(_object, keyCode, sector);
			updateMaterial();
		}			 
	
		override public function viewResize(viewWidth:Number, viewHeight:Number):void {
			super.viewResize(viewWidth, viewHeight);
			axisIndicatorOverlay.y = view.height - axisIndicatorSize;
		}	
		
		override public function rotateProps(plus:Boolean, props:Set = null):void {
			
			props = new Set();
			props.add(_object);
			super.rotateProps(plus, props);
		}
		
		
	}
}