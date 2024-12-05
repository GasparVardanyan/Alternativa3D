package alternativa.editor.scene {
	
	import alternativa.editor.prop.Prop;
	import alternativa.engine3d.core.Camera3D;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.core.Scene3D;
	import alternativa.engine3d.display.View;
	import alternativa.types.Point3D;
	import alternativa.types.Set;
	import alternativa.utils.KeyboardUtils;
	import alternativa.utils.MathUtils;
	
	import flash.geom.Point;

	public class EditorScene extends Scene3D {
		public var camera:Camera3D;
		public var view:View;
		// Карта занятых ячеек
		public var occupyMap:OccupyMap;
		
		public static const hBase:Number = 250;
		public static const hBase2:Number = 2*hBase;
		public static const vBase:Number = 300;
		
		protected var znormal:Point3D = new Point3D(0, 0, 1);
		protected var ynormal:Point3D = new Point3D(0, 1, 0);
		protected var xnormal:Point3D = new Point3D(1, 0, 0);
		
		/**
		 * 
		 */		
		public function EditorScene() {
			super();
			// Инициализация основной сцены
			initScene();
		}
		
		/**
		 * Корректировка размеров view.
		 * @param viewWidth ширина
		 * @param viewHeight высота
		 * 
		 */		
		public function viewResize(viewWidth:Number, viewHeight:Number):void {
			
			view.width = viewWidth;
			view.height = viewHeight;
			calculate();
			
		}	
		
		/**
		 * Инициализация основной сцены. 
		 */	
		protected function initScene():void {
			root = new Object3D();
			
			// Добавление камеры и области вывода
			camera = new Camera3D();
			camera.rotationX = -MathUtils.DEG90 - MathUtils.DEG30;
			camera.coords = new Point3D(250, -7800, 4670);
			root.addChild(camera);
						
			view = new View(camera);
			view.interactive = true;
			view.buttonMode = true;
			view.useHandCursor = false;
			
			view.graphics.beginFill(0xFFFFFF);
			view.graphics.drawRect(0, 0, 1, 1);
			view.graphics.endFill();
		}
		
		/**
		 * Переопределяется наследниками. 
		 * @param keyCode
		 * @param sector
		 */		
		public function moveByArrows(keyCode:uint, sector:int):void {
			
		}
		
		protected function move(prop:Prop, keyCode:uint, sector:int):void {
			
			if (prop) {
				switch (keyCode) {
					case KeyboardUtils.UP:
						
						switch (sector) {
							case 1:
								prop.x -= hBase2;
								break;
							case 4:
								prop.y += hBase2;
								break;
							case 3:
								prop.x += hBase2;
								break;
							case 2:
								prop.y -= hBase2;
								break;			
						}
						break;
					case KeyboardUtils.DOWN:
						switch (sector) {
							case 1:
								prop.x += hBase2;
								break;
							case 4:
								prop.y -= hBase2;
								break;
							case 3:
								prop.x -= hBase2;
								break;
							case 2:
								prop.y += hBase2;
								break;			
						}
						
						break;
					case KeyboardUtils.LEFT:
						
						switch (sector) {
							case 1:
								prop.y -= hBase2;
								break;
							case 4:
								prop.x -= hBase2;
								break;
							case 3:
								prop.y += hBase2;
								break;
							case 2:
								prop.x += hBase2;
								break;			
						}
						break;
					case KeyboardUtils.RIGHT:
						switch (sector) {
							case 1:
								prop.y += hBase2;
								break;
							case 4:
								prop.x += hBase2;
								break;
							case 3:
								prop.y -= hBase2;
								break;
							case 2:
								prop.x -= hBase2;
								break;			
						}
						break;
						
				}
		
			}
		}
		
		/**
		* Вычисляет центр группы пропов. 
		* @param props
		* @return 
		*/		
		public function getCentrePropsGroup(props:Set = null):Point {
			
			var minX:Number = Number.POSITIVE_INFINITY;
			var maxX:Number = Number.NEGATIVE_INFINITY;
			var minY:Number = Number.POSITIVE_INFINITY;
			var maxY:Number = Number.NEGATIVE_INFINITY;
			// Среднее арифметическое центров
			var averageX:Number = 0;
			var averageY:Number = 0;

			for (var p:* in props) {
				var prop:Prop = p;
				var left:Number = prop.distancesX.x + prop.x;
				var right:Number = prop.distancesX.y + prop.x; 
				if (left < minX) {
					minX = left;
				}
				if (right > maxX) {
					maxX = right;
				}
				
				left = prop.distancesY.x + prop.y;
				right = prop.distancesY.y + prop.y;
				if (left < minY) {
					minY = left;
				}
				if (right > maxY) {
					maxY = right;
				}
				averageX += prop.x;
				averageY += prop.y;
			}
			
			// Проверяем протяженность по x и по y на четность
			var modX:Number = (maxX - minX)/EditorScene.hBase2 % 2; 
			if ( modX != ((maxY - minY)/EditorScene.hBase2 % 2)) {
				
				if (modX != 0) {
					// Если протяженность по x нечетная, прибавим ширину ячейки со стороны, ближайшей к центру
					averageX = averageX/props.length; 
					if (Math.abs(averageX - maxX) < Math.abs(averageX - minX)) {
						maxX += EditorScene.hBase2;
					} else {
						minX -= EditorScene.hBase2;
					}
				} else {
					averageY = averageY/props.length;
					if (Math.abs(averageY - maxY) < Math.abs(averageY - minY)) {
						maxY += EditorScene.hBase2;
					} else {
						minY -= EditorScene.hBase2;
					}
				}					
			}
			return new Point((maxX + minX)/2, (maxY + minY)/2);
		}
		/**
		 * Поворот пропа. 
		 * @param plus флаг положительного поворота
		 * @param prop 
		 * 
		 */		
		public function rotateProps(plus:Boolean, props:Set = null):void {
			
			var centre:Point = getCentrePropsGroup(props);
			for (var p:* in props) {
				var prop:Prop = p;
				var x:Number = prop.x;
				var y:Number = prop.y;
				if (plus) {
					prop.x = y + centre.x - centre.y;
					prop.y = -x + centre.y + centre.x;
				} else {
					prop.x = -y + centre.x + centre.y;
					prop.y = x + centre.y - centre.x;
				} 
				prop.rotate(plus);
			}
			
			
		}
		
	}
}