package alternativa.editor.prop {
	
	import alternativa.editor.scene.EditorScene;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.events.MouseEvent3D;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.materials.SurfaceMaterial;
	import alternativa.engine3d.materials.TextureMaterial;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.types.Texture;
	import alternativa.utils.MathUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.BlendMode;
	import flash.geom.Matrix;
	import flash.geom.Point;

	/**
	 * 
	 * @author danilova
	 */	
	public class Prop extends Object3D {
		
		public static const TILE:int = 1;
		public static const SPAWN:int = 2;
		public static const BONUS:int = 3;
		public static const FLAG:int = 4;

		public var type:int = BONUS;
		
		// Объект на сцене
		protected var _object:Object3D;
		// Группа
		protected var _group:String;
		// Библиотека
		protected var _library:String;
		// Расстояния от центра до крайних вершин по оси X
		public var distancesX:Point;
		// Расстояния от центра до крайних вершин по оси Y
		public var distancesY:Point;
		// Расстояния от центра до крайних вершин по оси Z
		public var distancesZ:Point;
		// Индикатор многоячеечности
		protected var _multi:Boolean = false;
		// Индикатор занесенности на карту
		public var free:Boolean = true;
		// Исходный материал
		protected var _material:Material;
		// Битмапдата текстуры исходного материала
		public var bitmapData:BitmapData;
		// Битмапдата выделенного пропа
		protected var _selectBitmapData:BitmapData;
		//
		public var icon:Bitmap;
		// 
		protected var _selected:Boolean = false;
		//
		private var matrix:Matrix = new Matrix();
		
		
		[Embed (source = "/red_cursor.jpg")] private static var redClass:Class;
		private static const redBmp:BitmapData = new redClass().bitmapData;
		
		public function Prop(object:Object3D, library:String, group:String, needCalculate:Boolean=true) {
			
			super(object.name);
			addChild(object);
			
			_object = object;
			_object.addEventListener(MouseEvent3D.MOUSE_DOWN, onMouseDown);
			_library = library;
			_group = group;
			
			initBitmapData();
			
			if (needCalculate) {
				calculate();
			}
			
		}
		
		/**
		 * 
		 */		
		private function onMouseDown(e:MouseEvent3D):void {
			e.object = this;
		}
		
		/**
		 * 
		 */		
		protected function initBitmapData():void {
			_material = (_object as Mesh).surfaces.peek().material; 
			bitmapData = (_material as TextureMaterial).texture.bitmapData;
					
		}
		
		/**
		 * Расчет расстояний от центра по всем осям.
		 */		
		public function calculate():void {
				
			var vertices:Array = (_object as Mesh).vertices.toArray(true);
			var maxZ:Number = 0;
			var maxY:Number = 0;
			var maxX:Number = 0;
			
			var z1:Number = 0;
			var z2:Number = 0;
			var y1:Number = 0;
			var y2:Number = 0;
			var x1:Number = 0;
			var x2:Number = 0;
			var len:int = vertices.length;
			for (var i:int = 0; i < len; i++) {
				var vertex1:Point3D = vertices[i].coords;
				if (scene) {
					vertex1 = localToGlobal(vertex1);
				}					
				for (var j:int = i+1; j < len; j++) {
					var vertex2:Point3D = vertices[j].coords;
					if (scene) {
						vertex2 = localToGlobal(vertex2);
					}			
					var dx:Number = (vertex1.x - vertex2.x);
					var dy:Number = (vertex1.y - vertex2.y);
					var dz:Number = (vertex1.z - vertex2.z);
					var distanceX:Number = dx*dx;
					var distanceY:Number = dy*dy;
					var distanceZ:Number = dz*dz;
					
					if (distanceX > maxX) {
						maxX = distanceX;
						x1 = vertex1.x;
						x2 = vertex2.x;
					}
					if (distanceY > maxY) {
						maxY = distanceY;
						y1 = vertex1.y;
						y2 = vertex2.y;
					}
					if (distanceZ > maxZ) {
						maxZ = distanceZ;
						z1 = vertex1.z;
						z2 = vertex2.z;
					}
				}
			}			
			
			distancesX = calcDistance(x, x1, x2, EditorScene.hBase);
			distancesY = calcDistance(y, y1, y2, EditorScene.hBase);
			distancesZ = calcDistance(z, z1, z2, EditorScene.vBase);
			
			if (Math.abs(int(x2) - int(x1))/EditorScene.hBase2 > 1 ||
			    Math.abs(int(y1) - int(y2))/EditorScene.hBase2 > 1) { 
			    	_multi = true;
			}
				
		}
		
		/**
		 * Расчет расстояния от точки центра до 1й и 2й точек, приведённых к сетке.
		 * @param centre точка центра
		 * @param value1 1я точка
		 * @param value2 2я точка
		 * @param base шаг сетки
		 * return расстояние от центра до меньшей точки со знаком "-", расстояние от центра до большей точки
		 */		
		private function calcDistance(centre:Number, value1:Number, value2:Number, base:Number):Point {
			
			var distances:Point = new Point();
		
			value2 = floorTo(value2, base);
			value1 = floorTo(value1, base);
			
			if (value2 == 0 && value1 == 0) {
				distances.x = 0;
				distances.y = base;
			} else {
				if (value2 > value1) {
					if (value1 == 0) {
						distances.x = 0;
						distances.y = value2 - centre;	
					} else {
						distances.x = value1 - centre;
						distances.y = value2 - centre;
					}	
				} else {
					if (value2 == 0) {
						distances.x = 0;
						distances.y = value1 - centre;
					} else {
						distances.x = value2 - centre;
						distances.y = value1 - centre;
					}	
				}	
			}
			
			return distances;
		}
		
		/**
		 * Привязка к узлу сетки.
		 * @param value округляемое значение
		 * @param base шаг сетки
		 * @return округленное значение
		 */		
		public static function floorTo(value:Number, base:Number):Number {
			
			return Math.floor((value + base/2)/base)*base;
			
		}

		/**
		 * Привязка к центру ячейки.
		 * @param value округляемое значение
		 * @param base шаг сетки
		 * @return округленное значение
		 */		
		public static function roundTo(value:Number, base:Number):Number {
			
			return Math.round((value + base/2)/base)*base - base/2;
		}
		/**
		 * Выделить проп. 
		 */		
		public function select():void {
			
			_selectBitmapData = bitmapData.clone();
			matrix.a = bitmapData.width/redBmp.width;
			matrix.d = matrix.a;
			_selectBitmapData.draw(redBmp, matrix, null, BlendMode.MULTIPLY);
			setMaterial(newSelectedMaterial);
			_selected = true;
		}
		
		/**
		 * Снять выделение. 
		 */		
		public function deselect():void {
			
			_selectBitmapData.dispose();	
			setMaterial(_material);
			_selected = false;
		}
		
		/**
		 * Создает материал для выделения пропа.
		 * @return новый материал
		 */		
		protected function get newSelectedMaterial():Material {
			return new TextureMaterial(new Texture(_selectBitmapData));
		}
		
		/**
		 * Назначает пропу материал. 
		 * @param material материал
		 */		
		public function setMaterial(material:Material):void {
			var sm:SurfaceMaterial = material as SurfaceMaterial;
			(_object as Mesh).cloneMaterialToAllSurfaces(sm);
		}
		
		/**
		 * 
		 * @return 
		 */		
		public function get multi():Boolean {
			return _multi;
		}
		
		/**
		 * 
		 * @return 
		 */		
		public function get library():String {
			return _library;
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		/**
		 * 
		 * @return 
		 */		
		public function get group():String {
			return _group;
		}
		
		/**
		 * 
		 * @return 
		 */		
		public function get vertices():Map {
			return (_object as Mesh).vertices;
		}
		
		/**
		 * 
		 * @return 
		 */		
		public function get material():Material {
			return _material;
		}
		
		/**
		 * Поворот. 
		 * @param plus флаг положительного поворота
		 */		
		public function rotate(plus:Boolean):void {
			
			var point:Point;
			
			if (plus) {
				point = new Point(distancesX.x, distancesX.y);
				distancesX.x = distancesY.x;
				distancesX.y = distancesY.y;
				distancesY.x = -point.y;
				distancesY.y = -point.x;
				rotationZ -= MathUtils.DEG90;
			} else {
				point = new Point(distancesY.x, distancesY.y);
				distancesY.x = distancesX.x;
				distancesY.y = distancesX.y;
				distancesX.x = -point.y;
				distancesX.y = -point.x;
				rotationZ += MathUtils.DEG90;
			}
			
		}
		
		
		override public function addEventListener(type:String, listener:Function, useCapture:Boolean=false, priority:int=0, useWeakReference:Boolean=false):void {
			
			_object.addEventListener(type, listener);
		}
		
		override public function clone():Object3D {
			var copyObject:Mesh = _object.clone() as Mesh;
			copyObject.cloneMaterialToAllSurfaces(_material as TextureMaterial);
			var prop:Prop = new Prop(copyObject, _library, _group, false);
			prop.distancesX = distancesX.clone();
			prop.distancesY = distancesY.clone();
			prop.distancesZ = distancesZ.clone();
			prop._multi = _multi;
			prop.name = name;
			return prop;
		}
		
		/**
		 * Выравнивание по сетке.
		 */		
		public function snapCoords():void  {
			
			if (_multi) {
				x = floorTo(x, EditorScene.hBase2);
				y = floorTo(y, EditorScene.hBase2);
			} else {
				x = roundTo(x, EditorScene.hBase2);
				y = roundTo(y, EditorScene.hBase2);
			}
			
			z = floorTo(z, EditorScene.vBase);
		}
		
		
		
	}
}