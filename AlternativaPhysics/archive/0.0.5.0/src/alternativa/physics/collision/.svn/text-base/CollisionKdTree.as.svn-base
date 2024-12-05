package alternativa.physics.collision {
	
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.types.BoundBox;
	
	/**
	 * @author mike
	 */
	public class CollisionKdTree {
		
		public var threshold:Number = 0.1;
		public var minPrimitivesPerNode:int = 1;
		public var rootNode:CollisionKdNode;
		public var staticChildren:Vector.<CollisionPrimitive> = new Vector.<CollisionPrimitive>();
		public var numStaticChildren:int;
		public var staticBoundBoxes:Vector.<BoundBox> = new Vector.<BoundBox>();
		
		private var splitAxis:int;
		private var splitCoord:Number;
		private var splitCost:Number;
		
		private static const nodeBoundBoxThreshold:BoundBox = new BoundBox();
		private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
		private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
		private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
		private static const _nodeBB:Vector.<Number> = new Vector.<Number>(6);
		private static const _bb:Vector.<Number> = new Vector.<Number>(6);
		
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
			rootNode.indices = new Vector.<int>();
			// Расчитываем баунды объектов и рутовой ноды
			var rootNodeBoundBox:BoundBox = rootNode.boundBox = (boundBox != null) ? boundBox : new BoundBox();
			for (var i:int = 0; i < numStaticChildren; ++i) {
				var child:CollisionPrimitive = staticChildren[i];
				var childBoundBox:BoundBox = staticBoundBoxes[i] = child.calculateAABB();
				rootNodeBoundBox.addBoundBox(childBoundBox);
				rootNode.indices[i] = i;
			}
			staticBoundBoxes.length = numStaticChildren;
			// Разделяем рутовую ноду
			splitNode(rootNode);
			
			splitCoordsX.length = splitCoordsY.length = splitCoordsZ.length = 0;
		}
		
		/**
		 * @param node
		 */
		private function splitNode(node:CollisionKdNode):void {
			var indices:Vector.<int> = node.indices;
			var numPrimitives:int = indices.length;
			if (numPrimitives <= minPrimitivesPerNode) return;

			// Подготовка баунда с погрешностями
			var nodeBoundBox:BoundBox = node.boundBox;
			nodeBoundBoxThreshold.minX = nodeBoundBox.minX + threshold;
			nodeBoundBoxThreshold.minY = nodeBoundBox.minY + threshold;
			nodeBoundBoxThreshold.minZ = nodeBoundBox.minZ + threshold;
			nodeBoundBoxThreshold.maxX = nodeBoundBox.maxX - threshold;
			nodeBoundBoxThreshold.maxY = nodeBoundBox.maxY - threshold;
			nodeBoundBoxThreshold.maxZ = nodeBoundBox.maxZ - threshold;
			var doubleThreshold:Number = threshold*2;
			
			// Собираем опорные координаты
			var i:int;
			var j:int;
			var numSplitCoordsX:int = 0
			var numSplitCoordsY:int = 0;
			var numSplitCoordsZ:int = 0;
			for (i = 0; i < numPrimitives; ++i) {
				var boundBox:BoundBox = staticBoundBoxes[indices[i]];
				
				if (boundBox.maxX - boundBox.minX <= doubleThreshold) {
					if (boundBox.minX <= nodeBoundBoxThreshold.minX) splitCoordsX[numSplitCoordsX++] = nodeBoundBox.minX;
					else if (boundBox.maxX >= nodeBoundBoxThreshold.maxX) splitCoordsX[numSplitCoordsX++] = nodeBoundBox.maxX;
					else splitCoordsX[numSplitCoordsX++] = (boundBox.minX + boundBox.maxX)*0.5;
				} else {
					if (boundBox.minX > nodeBoundBoxThreshold.minX) splitCoordsX[numSplitCoordsX++] = boundBox.minX;
					if (boundBox.maxX < nodeBoundBoxThreshold.maxX) splitCoordsX[numSplitCoordsX++] = boundBox.maxX;
				}

				if (boundBox.maxY - boundBox.minY <= doubleThreshold) {
					if (boundBox.minY <= nodeBoundBoxThreshold.minY) splitCoordsY[numSplitCoordsY++] = nodeBoundBox.minY;
					else if (boundBox.maxY >= nodeBoundBoxThreshold.maxY) splitCoordsY[numSplitCoordsY++] = nodeBoundBox.maxY;
					else splitCoordsY[numSplitCoordsY++] = (boundBox.minY + boundBox.maxY)*0.5;
				} else {
					if (boundBox.minY > nodeBoundBoxThreshold.minY) splitCoordsY[numSplitCoordsY++] = boundBox.minY;
					if (boundBox.maxY < nodeBoundBoxThreshold.maxY) splitCoordsY[numSplitCoordsY++] = boundBox.maxY;
				}

				if (boundBox.maxZ - boundBox.minZ <= doubleThreshold) {
					if (boundBox.minZ <= nodeBoundBoxThreshold.minZ) splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.minZ;
					else if (boundBox.maxZ >= nodeBoundBoxThreshold.maxZ) splitCoordsZ[numSplitCoordsZ++] = nodeBoundBox.maxZ;
					else splitCoordsZ[numSplitCoordsZ++] = (boundBox.minZ + boundBox.maxZ)*0.5;
				} else {
					if (boundBox.minZ > nodeBoundBoxThreshold.minZ) splitCoordsZ[numSplitCoordsZ++] = boundBox.minZ;
					if (boundBox.maxZ < nodeBoundBoxThreshold.maxZ) splitCoordsZ[numSplitCoordsZ++] = boundBox.maxZ;
				}
			}
			
			// Поиск наилучшего сплита
			splitAxis = -1;
			splitCost = 1e308;
			_nodeBB[0] = nodeBoundBox.minX;
			_nodeBB[1] = nodeBoundBox.minY;
			_nodeBB[2] = nodeBoundBox.minZ;
			_nodeBB[3] = nodeBoundBox.maxX;
			_nodeBB[4] = nodeBoundBox.maxY;
			_nodeBB[5] = nodeBoundBox.maxZ;
			checkNodeAxis(node, 0, numSplitCoordsX, splitCoordsX, _nodeBB);
			checkNodeAxis(node, 1, numSplitCoordsY, splitCoordsY, _nodeBB);
			checkNodeAxis(node, 2, numSplitCoordsZ, splitCoordsZ, _nodeBB);

			// Если сплит не найден, выходим
			if (splitAxis < 0) return;
			
			// Сплиттер найден. Разделение узла.
			var axisX:Boolean = splitAxis == 0
			var axisY:Boolean = splitAxis == 1;
			node.axis = splitAxis;
			node.coord = splitCoord;
			// Создаём дочерние ноды
			node.negativeNode = new CollisionKdNode();
			node.negativeNode.parent = node;
			node.negativeNode.boundBox = nodeBoundBox.clone();
			node.positiveNode = new CollisionKdNode();
			node.positiveNode.parent = node;
			node.positiveNode.boundBox = nodeBoundBox.clone();
			if (axisX) node.negativeNode.boundBox.maxX = node.positiveNode.boundBox.minX = splitCoord;
			else if (axisY) node.negativeNode.boundBox.maxY = node.positiveNode.boundBox.minY = splitCoord;
			else node.negativeNode.boundBox.maxZ = node.positiveNode.boundBox.minZ = splitCoord;

			// Распределяем объекты по дочерним нодам
			var coordMin:Number = splitCoord - threshold;
			var coordMax:Number = splitCoord + threshold;
			for (i = 0; i < numPrimitives; ++i) {
				boundBox = staticBoundBoxes[indices[i]];
				var min:Number = axisX ? boundBox.minX : (axisY ? boundBox.minY : boundBox.minZ);
				var max:Number = axisX ? boundBox.maxX : (axisY ? boundBox.maxY : boundBox.maxZ);
				if (max <= coordMax) {
					if (min < coordMin) {
						// Объект в негативной стороне
						if (node.negativeNode.indices == null) node.negativeNode.indices = new Vector.<int>();
						node.negativeNode.indices.push(indices[i]);
						indices[i] = -1;
					} else {
						if (node.splitIndices == null) node.splitIndices = new Vector.<int>();
						node.splitIndices.push(indices[i]);
						indices[i] = -1;
					}
				} else {
					if (min >= coordMin) {
						// Объект в положительной стороне
						if (node.positiveNode.indices == null) node.positiveNode.indices = new Vector.<int>();
						node.positiveNode.indices.push(indices[i]);
						indices[i] = -1;
					}
				}
			}
			
			// Очистка списка объектов
			for (i = 0, j = 0; i < numPrimitives; ++i) {
				if (indices[i] >= 0) indices[j++] = indices[i];
			}
			if (j > 0) indices.length = j;
			else node.indices = null;
			
			if (node.splitIndices != null) {
				node.splitTree = new CollisionKdTree2D(this, node);
				node.splitTree.createTree();
			}

			// Разделение дочерних нод
			if (node.negativeNode.indices != null) splitNode(node.negativeNode);
			if (node.positiveNode.indices != null) splitNode(node.positiveNode);
		}
		
		/**
		 * 
		 * @param node
		 * @param axis
		 * @param numSplitCoords
		 * @param splitCoords
		 * @param bb
		 */
		private function checkNodeAxis(node:CollisionKdNode, axis:int, numSplitCoords:int, splitCoords:Vector.<Number>, bb:Vector.<Number>):void {
			var axis1:int = (axis + 1)%3;
			var axis2:int = (axis + 2)%3;
			var area:Number = (bb[axis1 + 3] - bb[axis1])*(bb[axis2 + 3] - bb[axis2]);
			for (var i:int = 0; i < numSplitCoords; ++i) {
				var currSplitCoord:Number = splitCoords[i];
				if (isNaN(currSplitCoord)) continue;
				var minCoord:Number = currSplitCoord - threshold;
				var maxCoord:Number = currSplitCoord + threshold;
				var areaNegative:Number = area*(currSplitCoord - bb[axis]);
				var areaPositive:Number = area*(bb[int(axis + 3)] - currSplitCoord);
				var numNegative:int = 0;
				var numPositive:int = 0;
				var conflict:Boolean = false;
				// Проверяем объекты
				var numObjects:int = node.indices.length;
				for (var j:int = 0; j < numObjects; j++) {
					var boundBox:BoundBox = staticBoundBoxes[node.indices[j]];
					_bb[0] = boundBox.minX;
					_bb[1] = boundBox.minY;
					_bb[2] = boundBox.minZ;
					_bb[3] = boundBox.maxX;
					_bb[4] = boundBox.maxY;
					_bb[5] = boundBox.maxZ;
					if (_bb[axis + 3] <= maxCoord) {
						if (_bb[axis] < minCoord) numNegative++;
					} else {
						if (_bb[axis] >= minCoord) {
							numPositive++;
						} else {
							conflict = true;
							break;
						}
					}
				}
				// Если хороший сплит, сохраняем
				var cost:Number = areaNegative*numNegative + areaPositive*numPositive;
				if (!conflict && cost < splitCost) {
					splitAxis = axis;
					splitCost = cost;
					splitCoord = currSplitCoord;
				}
				for (j = i + 1; j < numSplitCoords; ++j) {
					if (splitCoords[j] >= currSplitCoord - threshold && splitCoords[j] <= currSplitCoord + threshold) splitCoords[j] = NaN;
				}
			}
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
			trace(str, node.axis == -1 ? "end" : ((node.axis == 0) ? "X" : ((node.axis == 1) ? "Y" : "Z")), "splitCoord=" + splitCoord, "bound", node.boundBox, "objs:", node.indices);
			traceNode(str + "-", node.negativeNode);
			traceNode(str + "+", node.positiveNode);
		}
		
	}
}