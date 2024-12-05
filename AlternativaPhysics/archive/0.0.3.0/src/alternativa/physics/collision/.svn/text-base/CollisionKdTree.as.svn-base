package alternativa.physics.collision {
	
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.types.BoundBox;
	
	/**
	 * @author mike
	 */
	public class CollisionKdTree {
		
		public var threshold:Number = 0.01;
		public var minPrimitivesPerNode:int = 1;
		
		public var rootNode:CollisionKdNode;
		public var staticChildren:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
		public var numStaticChildren:int;
		private var staticBoundBoxes:Vector.<BoundBox> = new Vector.<BoundBox>();
		
		/**
		 * @param primitive
		 */
		public function addStaticPrimitive(primitive:CollisionPrimitive):void {
			staticChildren[numStaticChildren++] = primitive;
		}
		
		/**
		 * @param primitive
		 * @return 
		 */
		public function removeStaticPrimitive(primitive:CollisionPrimitive):Boolean {
			var idx:int = staticChildren.indexOf(primitive);
			if (idx < 0) return false;
			staticChildren.splice(idx, 1);
			numStaticChildren--;
			return true;
		}
		
		/**
		 * @param boundBox
		 */
		public function createTree(boundBox:BoundBox = null):void {
			if (numStaticChildren == 0) return;
			// Создаём корневую ноду
			rootNode = new CollisionKdNode();
			rootNode.objects = new Vector.<int>();
			// Расчитываем баунды объектов и рутовой ноды
			var rootNodeBoundBox:BoundBox = rootNode.boundBox = (boundBox != null) ? boundBox : new BoundBox();
			for (var i:int = 0; i < numStaticChildren; i++) {
				var child:CollisionPrimitive = staticChildren[i];
				var childBoundBox:BoundBox = staticBoundBoxes[i] = child.calculateAABB();
				rootNodeBoundBox.addBoundBox(childBoundBox);
				rootNode.objects[i] = i;
			}
			staticBoundBoxes.length = numStaticChildren;
			// Разделяем рутовую ноду
			splitNode(rootNode);
		}
		
		private var splitAxis:int;
		private var splitCoord:Number;
		private var splitCost:Number;
		static private const nodeBoundBoxThreshold:BoundBox = new BoundBox();
		static private const splitCoordsX:Vector.<Number> = new Vector.<Number>();
		static private const splitCoordsY:Vector.<Number> = new Vector.<Number>();
		static private const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
		/**
		 * @param node
		 */
		private function splitNode(node:CollisionKdNode):void {
			if (node.objects.length <= minPrimitivesPerNode) return;

			var objects:Vector.<int> = node.objects;
			var i:int, j:int, k:int, length:int = objects.length, c1:Number, c2:Number, ct1:Number, ct2:Number, area:Number, areaNegative:Number, areaPositive:Number, numNegative:int, numPositive:int, conflict:Boolean, cost:Number;
			
			var nodeBoundBox:BoundBox = node.boundBox;

			// Подготовка баунда с погрешностями
			nodeBoundBoxThreshold.minX = nodeBoundBox.minX + threshold;
			nodeBoundBoxThreshold.minY = nodeBoundBox.minY + threshold;
			nodeBoundBoxThreshold.minZ = nodeBoundBox.minZ + threshold;
			nodeBoundBoxThreshold.maxX = nodeBoundBox.maxX - threshold;
			nodeBoundBoxThreshold.maxY = nodeBoundBox.maxY - threshold;
			nodeBoundBoxThreshold.maxZ = nodeBoundBox.maxZ - threshold;
			var doubleThreshold:Number = threshold*2;

			// Собираем опорные координаты
			var numSplitCoordsX:int = 0, numSplitCoordsY:int = 0, numSplitCoordsZ:int = 0;
			for (i = 0; i < length; i++) {
				var boundBox:BoundBox = staticBoundBoxes[objects[i]];
				if (boundBox.minX > nodeBoundBoxThreshold.minX) splitCoordsX[numSplitCoordsX++] = boundBox.minX;
				if (boundBox.maxX < nodeBoundBoxThreshold.maxX) splitCoordsX[numSplitCoordsX++] = boundBox.maxX;

				if (boundBox.minY > nodeBoundBoxThreshold.minY) splitCoordsY[numSplitCoordsY++] = boundBox.minY;
				if (boundBox.maxY < nodeBoundBoxThreshold.maxY) splitCoordsY[numSplitCoordsY++] = boundBox.maxY;

				if (boundBox.minZ > nodeBoundBoxThreshold.minZ) splitCoordsZ[numSplitCoordsZ++] = boundBox.minZ;
				if (boundBox.maxZ < nodeBoundBoxThreshold.maxZ) splitCoordsZ[numSplitCoordsZ++] = boundBox.maxZ;
			}
			
			// Убираем дубликаты координат, ищем наилучший сплит
			splitAxis = -1; splitCost = 1e308;
			i = 0; area = (nodeBoundBox.maxY - nodeBoundBox.minY)*(nodeBoundBox.maxZ - nodeBoundBox.minZ);
			while (i < numSplitCoordsX) {
				if (isNaN(c1 = splitCoordsX[i++])) continue;
				ct1 = c1 - threshold;
				ct2 = c1 + threshold;
				areaNegative = area*(c1 - nodeBoundBox.minX);
				areaPositive = area*(nodeBoundBox.maxX - c1);
				numNegative = numPositive = 0;
				conflict = false;
				// Проверяем объекты
				for (j = 0; j < length; j++) {
					boundBox = staticBoundBoxes[objects[j]];
					if (boundBox.maxX <= ct2) {
						if (boundBox.minX < ct1) numNegative++;
					} else {
						if (boundBox.minX >= ct1) numPositive++; else {conflict = true; break;}
					}
				}
				// Если хороший сплит, сохраняем
				if (!conflict && (cost = areaNegative*numNegative + areaPositive*numPositive) < splitCost) {
					splitCost = cost;
					splitAxis = 0;
					splitCoord = c1;
				}
				j = i;
				while (++j < numSplitCoordsX) if ((c2 = splitCoordsX[j]) >= c1 - threshold && c2 <= c1 + threshold) splitCoordsX[j] = NaN;
			}
			i = 0; area = (nodeBoundBox.maxX - nodeBoundBox.minX)*(nodeBoundBox.maxZ - nodeBoundBox.minZ);
			while (i < numSplitCoordsY) {
				if (isNaN(c1 = splitCoordsY[i++])) continue;
				ct1 = c1 - threshold;
				ct2 = c1 + threshold;
				areaNegative = area*(c1 - nodeBoundBox.minY);
				areaPositive = area*(nodeBoundBox.maxY - c1);
				numNegative = numPositive = 0;
				conflict = false;
				// Проверяем объекты
				for (j = 0; j < length; j++) {
					boundBox = staticBoundBoxes[objects[j]];
					if (boundBox.maxY <= ct2) {
						if (boundBox.minY < ct1) numNegative++;
					} else {
						if (boundBox.minY >= ct1) numPositive++; else {conflict = true; break;}
					}
				}
				// Если хороший сплит, сохраняем
				if (!conflict && (cost = areaNegative*numNegative + areaPositive*numPositive) < splitCost) {
					splitCost = cost;
					splitAxis = 1;
					splitCoord = c1;
				}
				j = i;
				while (++j < numSplitCoordsY) if ((c2 = splitCoordsY[j]) >= c1 - threshold && c2 <= c1 + threshold) splitCoordsY[j] = NaN;
			}
			i = 0; area = (nodeBoundBox.maxX - nodeBoundBox.minX)*(nodeBoundBox.maxY - nodeBoundBox.minY);
			while (i < numSplitCoordsZ) {
				if (isNaN(c1 = splitCoordsZ[i++])) continue;
				ct1 = c1 - threshold;
				ct2 = c1 + threshold;
				areaNegative = area*(c1 - nodeBoundBox.minZ);
				areaPositive = area*(nodeBoundBox.maxZ - c1);
				numNegative = numPositive = 0;
				conflict = false;
				// Проверяем объекты
				for (j = 0; j < length; j++) {
					boundBox = staticBoundBoxes[objects[j]];
					if (boundBox.maxZ <= ct2) {
						if (boundBox.minZ < ct1) numNegative++;
					} else {
						if (boundBox.minZ >= ct1) numPositive++; else {conflict = true; break;}
					}
				}
				// Если хороший сплит, сохраняем
				if (!conflict && (cost = areaNegative*numNegative + areaPositive*numPositive) < splitCost) {
					splitCost = cost;
					splitAxis = 2;
					splitCoord = c1;
				}
				j = i;
				while (++j < numSplitCoordsZ) if ((c2 = splitCoordsZ[j]) >= c1 - threshold && c2 <= c1 + threshold) splitCoordsZ[j] = NaN;
			}

			// Если сплит не найден, выходим
			if (splitAxis < 0) return;
			
			// Разделяем ноду
			var axisX:Boolean = splitAxis == 0, axisY:Boolean = splitAxis == 1;
			node.axis = splitAxis;
			node.coord = splitCoord;
			
			// Создаём дочерние ноды
			node.negativeNode = new CollisionKdNode();
			node.positiveNode = new CollisionKdNode();
			node.negativeNode.parent = node;
			node.positiveNode.parent = node;
			node.negativeNode.boundBox = nodeBoundBox.clone();
			node.positiveNode.boundBox = nodeBoundBox.clone();
			if (axisX) node.negativeNode.boundBox.maxX = node.positiveNode.boundBox.minX = splitCoord;
			else if (axisY) node.negativeNode.boundBox.maxY = node.positiveNode.boundBox.minY = splitCoord;
			else node.negativeNode.boundBox.maxZ = node.positiveNode.boundBox.minZ = splitCoord;

			// Распределяем объекты по дочерним нодам
			ct1 = splitCoord - threshold; ct2 = splitCoord + threshold;
			for (i = 0; i < length; i++) {
				boundBox = staticBoundBoxes[objects[i]];
				var min:Number = axisX ? boundBox.minX : (axisY ? boundBox.minY : boundBox.minZ);
				var max:Number = axisX ? boundBox.maxX : (axisY ? boundBox.maxY : boundBox.maxZ);
				if (max <= ct2) {
					// Объект в негативной стороне
					if (node.negativeNode.objects == null) node.negativeNode.objects = new Vector.<int>();
					node.negativeNode.objects.push(objects[i]);
					objects[i] = -1;
				} else {
					if (min >= ct1) {
						// Объект в положительной стороне
						if (node.positiveNode.objects == null) node.positiveNode.objects = new Vector.<int>();
						node.positiveNode.objects.push(objects[i]);
						objects[i] = -1;
					} else {
						// Распилился
					}
				}
			}
			
			// Очистка списка объектов
			j = 0;
			for (i = 0; i < length; i++) {
				if (objects[i] >= 0) objects[j++] = objects[i];
			}
			if (j > 0) objects.length = j; else node.objects = null;
			
			// Разделение дочерних нод
			if (node.negativeNode.objects != null) splitNode(node.negativeNode);
			if (node.positiveNode.objects != null) splitNode(node.positiveNode);
		}

		/**
		 * 
		 */
		public function traceTree():void {
			traceNode("", rootNode);
		}
		
		/**
		 * @param str
		 * @param node
		 */
		private function traceNode(str:String, node:CollisionKdNode):void {
			if (node == null) return;
			trace(str, node.axis == -1 ? "end" : ((node.axis == 0) ? "X" : ((node.axis == 1) ? "Y" : "Z")), "splitCoord=" + splitCoord, "bound", node.boundBox, "objs:", node.objects);
			traceNode(str + "-", node.negativeNode);
			traceNode(str + "+", node.positiveNode);
		}
		
	}
}