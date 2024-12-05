package alternativa.editor {
	import alternativa.editor.prop.Prop;
	import alternativa.editor.prop.TileSprite3D;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.core.Vertex;
	import alternativa.engine3d.display.View;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.utils.MathUtils;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	import mx.core.UIComponent;
	

	public class Preview extends UIComponent {	
		
		private var sceneProp:Scene3D;
		private var cameraProp:Camera3D;
		private var cameraPropContainer:Object3D;
		private var viewProp:View;
		private var matrix:Matrix = new Matrix();
		// Мап проп -> оптимальное расстояние от камеры до пропа	
		private var propDistance:Map = new Map();
		private var halfFov:Number;
		private const iconWidth:Number = 50;
		private const sqrt2:Number = Math.sqrt(2);
		private const sqrt3:Number = Math.sqrt(3);
		
		public function Preview() {
			super();
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			
		}
		
		private function onAddedToStage(e:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
			initScene();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);
			addEventListener(Event.RESIZE, onResize);
			onResize();
		}
		
		/**
		 * Инициализация сцены предосмотра пропа. 
		 */				
		private function initScene(): void {
			
			// Создание сцены
			sceneProp = new Scene3D();
			sceneProp.root = new Object3D();
			
			// Добавление камеры и области вывода
			cameraProp = new Camera3D();
			cameraProp.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
			cameraPropContainer = new Object3D();
			cameraPropContainer.addChild(cameraProp);
			cameraProp.coords = new Point3D(0, -100, 40);
			sceneProp.root.addChild(cameraPropContainer);
			
			viewProp = new View(cameraProp);
			addChild(viewProp);
			viewProp.graphics.beginFill(0xFFFFFF);
			viewProp.graphics.drawRect(0, 0, 1, 1);
			viewProp.graphics.endFill();
			
			halfFov = cameraProp.fov/2;
									
		}
		
		private function onEnterFrame(e:Event):void {
			
			cameraPropContainer.rotationZ += MathUtils.DEG1;	
			sceneProp.calculate();
		}
		
		/**
		 * Находит расстояние, на котором должна быть камера, чтобы проп было хорошо видно. 
		 * @param prop проп
		 * @return расстояние
		 */		
		private function analyzeProp(prop:Prop):Point {
			
			var point:Point;
			var maxSqrDistance:Number = 0;
			var maxZ:Number = 0;
			var h:Number;
			
			var tileSprite3D:TileSprite3D = prop as TileSprite3D; 
			if (tileSprite3D) {
				
				var bitmapData:BitmapData = prop.bitmapData; 
				maxSqrDistance = tileSprite3D.scale*1.5*Math.max(bitmapData.width, bitmapData.height);
				maxZ = bitmapData.height;
				
			} else {
				var vertices:Array = prop.vertices.toArray(true);
				var len:int = vertices.length;
				var deltaZ:Number;
				var deltaY:Number;
				var deltaX:Number;
				var sqrDistance:Number;
				for (var i:int = 0; i < len; i++) {
					var vertex1:Point3D = (vertices[i] as Vertex).coords;
					deltaX = vertex1.x - prop.x;
					deltaY = vertex1.y - prop.y;
					deltaZ = vertex1.z - prop.z;
					sqrDistance = deltaX*deltaX + deltaY*deltaY + deltaZ*deltaZ;  
					if (sqrDistance > maxSqrDistance) {
						maxSqrDistance = sqrDistance;
					}
					
					for (var j:int = i + 1; j < len; j++) {
						var vertex2:Point3D = (vertices[j] as Vertex).coords;
						deltaZ = vertex1.z - vertex2.z;
						deltaZ = deltaZ < 0 ? -deltaZ : deltaZ;
						
						 if (deltaZ > maxZ) {
							maxZ = deltaZ;
						}
						
					}
				} 
				
				maxSqrDistance = 2*Math.sqrt(maxSqrDistance);
				
					
			}
			
			h = sqrt2*maxSqrDistance/(2*Math.tan(halfFov)) + maxSqrDistance/2;
			point = new Point(h, maxZ/2);
			
			propDistance.add(prop, point); 
			return point;
		}
		
		/**
		 * Получение иконки для пропа
		 * @param prop
		 * @return иконка
		 */		
		public function getPropIcon(prop:Prop):Bitmap {
			
			clearPropScene();
			analyzeProp(prop);
			setCameraCoords(prop);			
			sceneProp.root.addChild(prop);
			sceneProp.calculate();
			var bitmapData:BitmapData = new BitmapData(iconWidth, iconWidth, false, 0x0);
			matrix.a = iconWidth/viewProp.width;
			matrix.d = matrix.a;
			bitmapData.draw(viewProp, matrix);
			var result:Bitmap = new Bitmap(bitmapData);
			return result;
			
		}
		
		/**
		 * Установка координат камеры. 
		 * @param prop
		 * 
		 */		
		private function setCameraCoords(prop:Object3D):void {
			
			var yzDistance:Point = propDistance[prop];
			if (yzDistance) {
				cameraProp.y = -yzDistance.x;
				cameraProp.z = yzDistance.y/2 + yzDistance.x/sqrt3;
				 
			}
			
		}
		
		/**
		 * Очистка сцены предосмотра. 
		 */		
		private function clearPropScene():void {
			
			for (var child:* in sceneProp.root.children) {
				var prop:Prop = child as Prop;
				if (prop) {
					sceneProp.root.removeChild(prop);
				}
			}
			
		}
		
		public function showProp(prop:Prop):void {
			
			clearPropScene();
			setCameraCoords(prop);
			sceneProp.root.addChild(prop);
		}
		
		/**
		 * Корректировка размеров и положения объектов при изменении окна плеера.
		 */	
		public function onResize(e:Event = null):void {
			
			viewProp.width = parent.width;
			viewProp.height = parent.height;
			sceneProp.calculate();
		}
		
	}
}