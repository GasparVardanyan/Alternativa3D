package strategy {
	import alternativa.engine3d.core.Sprite3D;
	import alternativa.types.Map;
	import alternativa.types.Point3D;
	import alternativa.utils.MathUtils;
	
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	/**
	 * Шагающий герой.
	 */	
	public class MovingHero  extends Sprite3D {
		
		// Путь, который герой должен пройти
		private var pathPoints:Array = new Array();
		// Вектор направления ходьбы
		private var direction:Point;
		//Позиция, в которую герой должен прийти
		private var finishPosition:Point;
		//Список открытых вершин для алгоритма А*
		private var open:Array = new Array();
		//Карта
		private var mapSquare:Array = Strategy.mapSquare;
		// Список занятых моментов времени, соответствующий текущей позиции
		private var currentBusyMoments:Array;
		// Индикатор режима ходьбы
		private var modeGo:Boolean = false;
		// Количество картинок для изображения шага
		private var stepsLen:int;
		// Материал 
		private var heroMaterial:MultiphaseSpriteMaterial;
		//Двумерый список текстур [шаг][фаза]
		protected var steps:Array;
		// Длина шага
		private var stepWidth:int;
		// Текущая позиция героя
		protected var _currentPosition:Point;
		// Время, которoе герой затрачивает, чтобы сменить позицию
		public static const STEP_TIME:Number = 750;
		
		public function MovingHero(position:Point, direction:Point) {
			// Устанавливаем текущую позицию
			this._currentPosition = position;
			// Занимаем момент времени
			currentBusyMoments = [getTimer() + 50];
			var map:Map = mapSquare[_currentPosition.x][_currentPosition.y].fix.heroBusyMoments;
			map.add(this, currentBusyMoments);
			this.finishPosition = position.clone();
			// Устанавливаем координаты
			var xy:Point = Strategy.mapCoords[position.x][position.y];
			this.x = xy.x;
			this.y = xy.y;
			this.z = 0.01;
			// Направление
			this.direction = direction;
			// Материал
			initMaterial();
			// Количество картинок для изображения шага
			stepsLen = steps.length;
			
			stepWidth = (Strategy.cellWidht/stepsLen);
		}
		
		public function get currentPosition():Point {
			_currentPosition.x = Math.floor((this.x + Strategy.LAND_WIDTH/2)/Strategy.cellWidht);
			_currentPosition.y = Math.floor((this.y + Strategy.LAND_WIDTH/2)/Strategy.cellWidht);
			return _currentPosition;
		}
		
		/**
		 * Настройка материала. 
		 */		
		private function initMaterial():void {

			heroMaterial = new MultiphaseSpriteMaterial(null);
			heroMaterial.originY = 0.88;
			
			var angle:Number = 0;
			var prevNormal:Point3D = new Point3D(-direction.x, -direction.y, 0);
			
			heroMaterial.addPhase(prevNormal, steps[0][0]);
			var len:int = steps[0].length;
			var deltaAngle:Number = MathUtils.DEG360/len;
			// Расчитываем нормали
			for (var i:int = 1; i < len; i++) {
				angle =+ deltaAngle;
				var sin:Number = Math.sin(angle);
				var cos:Number = Math.cos(angle); 
				var normal:Point3D = new Point3D(prevNormal.x*cos - prevNormal.y*sin, prevNormal.x*sin + prevNormal.y*cos, 0);
				heroMaterial.addPhase(normal, steps[0][i]);				
				prevNormal = normal;

			}
			this.material = heroMaterial;
		}
		
		 
		/**
		 * Вычисляет цену прохода в зависимости от направления движения. 
		 * @param direction направление движения
		 * @return цена прохода 
		 */		
		private function cost(direction:int):Number {
			
			switch (direction) {
				case 0: 
				case 2:
				case 4:
				case 6:
					return 1;
				case 1:
				case 3:
				case 5:
				case 7:
					return 1.5;
				
			}
			return 0;
		}
		
		/**
		 * Вычисляет точку, из которой пришли, по текущей позиции и направлению. 
		 * @param direction направление
		 * @param ij текущая позиция
		 * @return координаты точки
		 */
		private function getPrevPoint(direction:int, ij:Point):Point {
			
			switch (direction) {
				case 0:
					return new Point(ij.x + 1, ij.y);
				case 1:
					return new Point(ij.x + 1, ij.y - 1);
				case 2:
					return new Point(ij.x, ij.y - 1);
				case 3:
					return new Point(ij.x - 1, ij.y - 1);
				case 4:
					return new Point(ij.x - 1, ij.y);
				case 5:
					return new Point(ij.x - 1, ij.y + 1);
				case 6:
					return new Point(ij.x, ij.y + 1);
				case 7:
					return new Point(ij.x + 1, ij.y + 1);
						
			}
			return null;
			
		}	
		
		/**
		 * Осуществляет анализ соседней клетки.
		 * @param i номер строки соседней клетки на сетке 
		 * @param j номер столбца соседней клетки на сетке 
		 * @param direction направление от текущей клетки к соседней
		 * @param parentCost цена прохода в текущую клетку
		 * @return  false, если клетка финишная, иначе true
		 * 
		 */		
		private function neighbourTest(i:int, j:int, direction:int, parentCost:Number):Boolean {
			
			// Проверка на выход за границы сетки
			if (i >=0 && i < Strategy.COUNT_SQUARE && j >= 0 && j < Strategy.COUNT_SQUARE) {
				
				var mapSquarePoint:DoubleMapSquarePoint = mapSquare[i][j]; 
				var variable:MapSquarePoint = mapSquarePoint.variable;
				var fix:MapSquarePointFix = mapSquarePoint.fix;
				
				var state:int = variable.state;
							
				if (state == 2 || fix.impassable){
					// Если закрыта или недоступна
					return true;
				}


				// Цена прохода через клетку
				var neighbourCost:Number = parentCost + cost(direction);
				
				if (state == 1) {
					// Если открыта
					if (neighbourCost < variable.cost) {
						variable.cost = neighbourCost;
						variable.direction = direction;
						
					}
					
				} else { 
					// Если неопределена
					if (i == finishPosition.x && j == finishPosition.y) {
						// Дошли до финиша
						if (fix.busyMoment(time, this)) {
							// Если момент времени уже занят, считаем финишной предыдущую клетку
							var point:Point = getPrevPoint(direction, new Point(i, j));
							finishPosition.x = point.x;
							finishPosition.y = point.y;
						} else {
							variable.state = 2;
							variable.direction = direction;
						}
						open.length = 0;
						return false;
					} else {
						variable.cost = neighbourCost;
						var deltaX:Number = finishPosition.x - i;
						var deltaY:Number = finishPosition.y - j;
						variable.distance = (deltaX < 0 ? -deltaX : deltaX) + (deltaY < 0 ? -deltaY : deltaY);
						open.push(new Cell(i, j, neighbourCost + variable.distance));
						variable.state = 1;
						variable.direction = direction;
					}
					
				}
			}
			
			return true;
			
		}
		
		
		
		private var time:Number;

		/**
		 * Алгоритм А* поиска кратчайшего пути c учетом передвижения других героев. 
		 * @param startI номер строки стартовой клетки на сетке
		 * @param startJ номер столбца стартовой клетки на сетке
		 */
		private function  astar(startI:int, startJ:int):void {
			
			var startCell:Cell = new Cell(startI, startJ, 0);
			// Добавляем стартовую клетку в открытый список	
			open[0] = startCell;
			var len:int = open.length;
			var currentCell:Cell;
			var currentI:int;
			var currentJ:int; 
			var currentCost:Number;
			var doubleMapPoint:DoubleMapSquarePoint;
			
			var notFindedNextCell:Boolean = true;
			var index:int = len - 1;
			 
			while (len != 0) {
				// Пока открытый список не пуст
				while (notFindedNextCell && index >= 0) {
					// Пока не нашли следующую клетку и список не пуст				
					// Индикатор стартовой клетки
					var start:Boolean = false; 
					currentCell = open[index];
					currentI = currentCell.i;
					currentJ = currentCell.j;
					
					doubleMapPoint = mapSquare[currentI][currentJ]; 
					var variable:MapSquarePoint = doubleMapPoint.variable;
					var fix:MapSquarePointFix = doubleMapPoint.fix; 
					// Получаем родительскую клетку, чтобы определить момент времени, когда герой будет находится в текущей клетке
					var parentPos:Point = getPrevPoint(variable.direction, new Point(currentI, currentJ));
					if (parentPos != null) {
						var parentHeroBusyMoments:Map = mapSquare[parentPos.x][parentPos.y].fix.heroBusyMoments;
						var parentBusyMoments:Array = parentHeroBusyMoments[this];
						time = parentBusyMoments[parentBusyMoments.length - 1] + STEP_TIME;
					} else {
						// Момент времени, когда герой находится в стартовой вершине
						time = getTimer(); 
						start = true;
					}	
					
					if (!fix.busyMoment(time, this) || start) {
						// Если момент времени не занят или клетка стартовая, занимаем момент времени
						var busyMoment:Array;
						if (fix.heroBusyMoments.hasKey(this)) {
							busyMoment = fix.heroBusyMoments[this];
						} else {
							busyMoment = new Array();
							fix.heroBusyMoments.add(this, busyMoment);
						}
						busyMoment.push(time);
						notFindedNextCell = false; 
					} else { 
						//Если занят, рассматриваем следующую клетку
						index--;
					}
								
				}
				
				if (!notFindedNextCell) { 
					// Если смогли найти следующую клетку, ставим состояние "закрыто"
					variable.state = 2;
					open.pop();
					currentCost = variable.cost;
					time += STEP_TIME;
					// Просматриваем соседей
					if (neighbourTest(currentI - 1, currentJ, 0, currentCost)) {
						if (neighbourTest(currentI - 1, currentJ + 1, 1, currentCost)) {
							if (neighbourTest(currentI, currentJ + 1, 2, currentCost)) {
								if (neighbourTest(currentI + 1, currentJ + 1, 3, currentCost)) {
									if (neighbourTest(currentI + 1, currentJ, 4, currentCost)) {
										if (neighbourTest(currentI + 1, currentJ - 1, 5, currentCost)) {
											if (neighbourTest(currentI, currentJ - 1, 6, currentCost)) {
												if (neighbourTest(currentI - 1, currentJ - 1, 7, currentCost)) {
													// Сортируем открытый список по функции стоимости
													open.sortOn("f", Array.NUMERIC | Array.DESCENDING);
												}
											}
										} 
									} 
								} 
							} 
						} 
					} 
										
					len = open.length;
					if (len != 0) {
						notFindedNextCell = true;
						index = len - 1;
					}
				} else {
					len = 0;
				}
				
			}
			
			if (!notFindedNextCell) {
				// Если добрались до финиша, занимаем много времени для финишной позиции, чтобы остальные герои точно в нее не могли прийти
				doubleMapPoint = mapSquare[finishPosition.x][finishPosition.y];
				var finishBusyMoments:Array = doubleMapPoint.fix.heroBusyMoments[this]; 
				if (finishBusyMoments == null) {
					finishBusyMoments = new Array();
					doubleMapPoint.fix.heroBusyMoments.add(this, finishBusyMoments);
				}
				var t:Number = time;
				
				// Займем немного прошлого для финишной позиции
				for (var i:int = 0; i < 10; i++) {
					t -= STEP_TIME;			
					finishBusyMoments.push(t);
				}
				
				// Занимаем будущие моменты времени. Их количество равно максимальному пути другого героя
				var count:int = Strategy.COUNT_SQUARE*Strategy.COUNT_SQUARE;
				for (i = 0; i < count; i++) {
					finishBusyMoments.push(time);
					time += STEP_TIME;
				} 
			}
			
		}
		
		/**
		 * Вычисляет путь по линии Безье, построенной через три клетки. 
		 * @param start стартовая клетка
		 * @param control средняя клетка
		 * @param end конечная клетка
		 * @param firstHalf индикатор первой половины пути (из стартовой клетки в среднюю)
		 * @return путь из стартовой клетки в среднюю или из средней в конечную
		 * 
		 */		
		private function buildBezier(start:Point, control:Point, end:Point, firstHalf:Boolean):Array {
			
			var result:Array = new Array();
			var tStart:Number;
			var tFinish:Number; 
			if (firstHalf) {
				tStart = 0;
				tFinish = 0.5;
			} else {
				tStart = 0.5;
				tFinish = 1;
			}

			var delta:Number = 0.5/(stepsLen - 1);
			for (var t:Number = tStart; t <= tFinish; t += delta) {
				var a:Number = 1 - t;
				var aa:Number = a*a;
				var at:Number = a*t;
				var tt:Number = t*t;
				
				result.push(new Point(start.x*aa + 2* control.x*at + end.x*tt, start.y*aa + 2* control.y*at + end.y*tt)); 
			
			}
			return result;			
		}		
	
		/**
		 * Вычисляет путь по прямой. 
		 * @param coords1 координаты стартовой точки
		 * @param coords2 координаты финишной точки
		 * @param count количество узлов пути
		 * @return 
		 * 
		 */		
		private function lineDivision(coords1:Point, coords2:Point, count:int):Array {
			
			var result:Array = new Array();
			//Разбиваем прямую 
			for (var i:int = 0; i < count; i++) {
				var a:Number = i/(count - i);
				var b:Number = 1 + a;
				var point:Point = new Point((coords1.x + a*coords2.x)/b, (coords1.y + a*coords2.y)/b); 
				result.push(point);
			}	
			return result;
			
		}	

		
		/**
		 * Строит путь по матрице после работы A*. 
		 */		
		private function pathBuild():void {

			var finishValue:MapSquarePoint = mapSquare[finishPosition.x][finishPosition.y].variable;
		
			if (finishValue.state == 2 && !finishPosition.equals(_currentPosition)) {
				
				//Направление откуда пришли
				var prevDir:int = finishValue.direction;
				var prevCoords:Point = Strategy.mapCoords[finishPosition.x][finishPosition.y];
				var pos:Point = finishPosition.clone();
				var stepCoords:Array;
				
				pos = getPrevPoint(prevDir, pos);
				while (pos != null && !pos.equals(currentPosition)) {
					
					// Направление, откуда пришли в текущую точку
					var direction:int = mapSquare[pos.x][pos.y].variable.direction;
					// Координаты текущей точки
					var coords:Point = Strategy.mapCoords[pos.x][pos.y];
					// Путь от предыдущей клетки к текущей
					var stepPoints:StepPoints = new StepPoints(pos);
					
					if (direction != prevDir) {
						// Если в текущей точке сменили направление, строим путь от предыдушей к текущей и от текущей к следующей по кривой Безье		
						var pos1:Point = getPrevPoint(direction, pos);
						if (pos1 != null && !pos1.equals(currentPosition)) {
							pos = pos1;
							var nextCoords:Point = Strategy.mapCoords[pos.x][pos.y];
							stepCoords = buildBezier(prevCoords, coords, nextCoords, true);
							stepPoints.coords = stepCoords;
							pathPoints.push(stepPoints);
							
							stepPoints = new StepPoints(pos);
							stepCoords = buildBezier(prevCoords, coords, nextCoords, false);
							coords = nextCoords;
							direction = mapSquare[pos.x][pos.y].variable.direction;
								
						} else {
							stepCoords = lineDivision(prevCoords, coords, stepsLen);
						}		
							
					} else {
						stepCoords = lineDivision(prevCoords, coords, stepsLen);
					}
						
					prevDir = direction;
					prevCoords = coords;
					stepPoints.coords = stepCoords;
					pathPoints.push(stepPoints);
					
					pos = getPrevPoint(prevDir, pos);
					
										
				} 				
				// Достраиваем путь до стартовой позиции отдельно, чтобы переход был гладким
				var currentCoords:Point = new Point(this.x, this.y);
				var startStepPoints:StepPoints = new StepPoints(currentPosition);
				startStepPoints.coords = lineDivision(prevCoords, currentCoords, Math.round(Point.distance(prevCoords, currentCoords)/stepWidth));
				pathPoints.push(startStepPoints);
			}
		}
		
		/**
		 * Отправляет героя в путь до указаной позиции. 
		 * @param position позиция, куда герой должен прийти
		 */		
		public function moveTo(position:Point):void {
			
			if (_currentPosition.equals(position)) {
				return;

			}
			if (mapSquare[position.x][position.y].fix.impassable) {
				return;
			}
			// Обновляем переменную часть карты (заодно чистится давнее прошлое)
			for (var i:int = 0; i < Strategy.COUNT_SQUARE; i++){
				for (var j:int = 0; j < Strategy.COUNT_SQUARE; j++){
					mapSquare[i][j].restore();
				}
			}
			
			finishPosition.x = position.x;
			finishPosition.y = position.y;
			// Строим путь
			pathPoints.length = 0;
			astar(currentPosition.x, currentPosition.y);
			pathBuild();
			modeGo = true;	

		}
		
		private var stepTextureIndex:int = 0;

		/**
		 * Выполняет следующий шаг. 
		 */		
		public function nextStep():void {
			
			if (modeGo) {

				var len:int = pathPoints.length;
				if (len > 0) {
				
					var stepPoints:StepPoints = pathPoints[len - 1];
					var lenStep:int = stepPoints.coords.length - 1;
					var point:Point = stepPoints.coords[lenStep];
	
					// Направление, в котором будем двигаться
					var currentDirection:Point = new Point(point.x - this.x, point.y - this.y); 
					
					if (currentDirection.x != 0 || currentDirection.y != 0) {
					
						currentDirection.normalize(1);
						var dot:Number = currentDirection.x*direction.x + currentDirection.y*direction.y;
						
						if (dot < 0.99) {
							// Если сменили направление, поворачиваем все нормали
							var sin:Number = -currentDirection.x*direction.y + currentDirection.y*direction.x;
							heroMaterial.rotateNormals(dot, sin);
							direction.x = currentDirection.x;
							direction.y = currentDirection.y;
						}

	
						heroMaterial.updateTextures(steps[stepTextureIndex]);
						stepTextureIndex = stepTextureIndex == (stepsLen - 1) ? 0 : stepTextureIndex + 1;
						
						this.x = point.x;
						this.y = point.y;
					}
					
					
					if (lenStep == 0) {
						pathPoints.pop();
					} else {
						stepPoints.coords.pop();
					}
				} else {
					_currentPosition.x = finishPosition.x;
					_currentPosition.y = finishPosition.y;
					var map:Map = mapSquare[_currentPosition.x][_currentPosition.y].fix.heroBusyMoments;
					if (map.hasKey(this)) {
						currentBusyMoments = map[this];
					} 
					modeGo = false;
							
				}
			} else { 
				// Если стоим, занимаем момент времени
				currentBusyMoments.push(getTimer() + 50);
			}
		}
		 
		/**
		 * Чистит время текущего пути. 
		 */		
		public function clearTime():void {
			
			var moment:Number = getTimer();
			var len:int = pathPoints.length; 
			for (var i:int = 0; i < len; i++) {
				var stepPoints:StepPoints = pathPoints[i];
				clearTimePosition(stepPoints.position);

				if (stepPoints.position.equals(currentPosition)) {
					var map:Map = mapSquare[_currentPosition.x][_currentPosition.y].fix.heroBusyMoments;
					var array:Array = map[this];
					if (array == null) {
						array = new Array();
						map.add(this, array);
					}
					array.push(getTimer() + 50);
				}
			}
			clearTimePosition(finishPosition);
		}
		
		/**
		 * Чистит время указанной клетки. 
		 * @param position позиция клетки
		 */		
		private function clearTimePosition(position:Point):void {
			
			mapSquare[position.x][position.y].fix.clearTime(this);
			
		}
		

	}
}

import flash.geom.Point;
	/**
	 * Клетка. 
	 */	
	class Cell {
		// Значение функции стоимости
		protected var _f:Number;
		// Позиция в сетке по оси X
		protected var _i:int;
		// Позиция в сетке по оси Y
		protected var _j:int;
	
		public function Cell(i:int, j:int, f:Number):void {
			_i = i;
			_j = j;
			_f = f;
		}
		public function get i():int {
			return _i;
		}
		
		public function get j():int {
			return _j;
		}
		
		public function get f():Number {
			return _f;
		}
		
		public function set f(value:Number):void {
			_f = value;
		}
	}

	/**
	 * Точка пути. 
	 */	
	class StepPoints {
		// Позиция клетки
		protected var _position:Point;
		// Список координат, по которым герой будет шагать от предыдущей клетки до текущей
		protected var _coords:Array;
		
		public function StepPoints(pos:Point):void {
			
			_position = pos;
			
		}
		public function get coords():Array {
			return _coords;
		}
		
		public function set coords(value:Array):void {
			_coords = value;
		}
		
		public function get position():Point {
			return _position;
		}
		
		public function set position(value:Point):void {
			_position = value;
		}
		
	}