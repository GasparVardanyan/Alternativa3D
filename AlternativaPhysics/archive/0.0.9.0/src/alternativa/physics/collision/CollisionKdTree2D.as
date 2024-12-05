package alternativa.physics.collision {
	
	
	import alternativa.physics.collision.types.BoundBox;
	
	/**
	 * 
	 */
	public class CollisionKdTree2D {
		
		public var threshold:Number = 0.1;
		public var minPrimitivesPerNode:int = 1;
		
		public var parentTree:CollisionKdTree;
		public var parentNode:CollisionKdNode;
		public var rootNode:CollisionKdNode;

		private var splitAxis:int;
		private var splitCost:Number;
		private var splitCoord:Number;
		
		private static const nodeBoundBoxThreshold:BoundBox = new BoundBox();
		private static const splitCoordsX:Vector.<Number> = new Vector.<Number>();
		private static const splitCoordsY:Vector.<Number> = new Vector.<Number>();
		private static const splitCoordsZ:Vector.<Number> = new Vector.<Number>();
		private static const _nodeBB:Vector.<Number> = new Vector.<Number>(6);
		private static const _bb:Vector.<Number> = new Vector.<Number>(6);
		/**
		 * 
		 * @param parentTree
		 * @param parentNode
		 */
		public function CollisionKdTree2D(parentTree:CollisionKdTree, parentNode:CollisionKdNode) {
			this.parentTree = parentTree;
			this.parentNode = parentNode;
		}
		
		/**
		 * 
		 */
		public function createTree():void {
			rootNode = new CollisionKdNode();
			rootNode.boundBox = parentNode.boundBox.clone();
			rootNode.indices = new Vector.<int>();
			var numObjects:int = parentNode.splitIndices.length;
			for (var i:int = 0; i < numObjects; ++i) rootNode.indices[i] = parentNode.splitIndices[i];
			
			splitNode(rootNode);
			splitCoordsX.length = splitCoordsY.length = splitCoordsZ.length = 0;
		}

		/**
		 * @param node
		 */
		private function splitNode(node:CollisionKdNode):void {
			if (node.indices.length <= minPrimitivesPerNode) return;

			var objects:Vector.<int> = node.indices;
			var i:int;
			var j:int;
			
			var nodeBoundBox:BoundBox = node.boundBox;

			// Подготовка баунда с погрешностями
			nodeBoundBoxThreshold.minX = nodeBoundBox.minX + threshold;
			nodeBoundBoxThreshold.minY = nodeBoundBox.minY + threshold;
			nodeBoundBoxThreshold.minZ = nodeBoundBox.minZ + threshold;
			nodeBoundBoxThreshold.maxX = nodeBoundBox.maxX - threshold;
			nodeBoundBoxThreshold.maxY = nodeBoundBox.maxY - threshold;
			nodeBoundBoxThreshold.maxZ = nodeBoundBox.maxZ - threshold;
			var doubleThreshold:Number = threshold*2;
			
			var staticBoundBoxes:Vector.<BoundBox> = parentTree.staticBoundBoxes;
			// Собираем опорные координаты
			var numSplitCoordsX:int;
			var numSplitCoordsY:int;
			var numSplitCoordsZ:int;
			var numObjects:int = objects.length;
			for (i = 0; i < numObjects; ++i) {
				var bb:BoundBox = staticBoundBoxes[objects[i]];
				
				if (parentNode.axis != 0) {
					if (bb.minX > nodeBoundBoxThreshold.minX) splitCoordsX[numSplitCoordsX++] = bb.minX;
					if (bb.maxX < nodeBoundBoxThreshold.maxX) splitCoordsX[numSplitCoordsX++] = bb.maxX;
				}

				if (parentNode.axis != 1) {
					if (bb.minY > nodeBoundBoxThreshold.minY) splitCoordsY[numSplitCoordsY++] = bb.minY;
					if (bb.maxY < nodeBoundBoxThreshold.maxY) splitCoordsY[numSplitCoordsY++] = bb.maxY;
				}

				if (parentNode.axis != 2) {
					if (bb.minZ > nodeBoundBoxThreshold.minZ) splitCoordsZ[numSplitCoordsZ++] = bb.minZ;
					if (bb.maxZ < nodeBoundBoxThreshold.maxZ) splitCoordsZ[numSplitCoordsZ++] = bb.maxZ;
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
			if (parentNode.axis != 0) checkNodeAxis(node, 0, numSplitCoordsX, splitCoordsX, _nodeBB);
			if (parentNode.axis != 1) checkNodeAxis(node, 1, numSplitCoordsY, splitCoordsY, _nodeBB);
			if (parentNode.axis != 2) checkNodeAxis(node, 2, numSplitCoordsZ, splitCoordsZ, _nodeBB);

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
			for (i = 0; i < numObjects; ++i) {
				bb = staticBoundBoxes[objects[i]];
				var min:Number = axisX ? bb.minX : (axisY ? bb.minY : bb.minZ);
				var max:Number = axisX ? bb.maxX : (axisY ? bb.maxY : bb.maxZ);
				if (max <= coordMax) {
					if (min < coordMin) {
						// Объект в негативной стороне
						if (node.negativeNode.indices == null) node.negativeNode.indices = new Vector.<int>();
						node.negativeNode.indices.push(objects[i]);
						objects[i] = -1;
					}
				} else {
					if (min >= coordMin) {
						if (max > coordMax) {
							// Объект в положительной стороне
							if (node.positiveNode.indices == null) node.positiveNode.indices = new Vector.<int>();
							node.positiveNode.indices.push(objects[i]);
							objects[i] = -1;
						}
					}
				}
			}
			
			// Очистка списка объектов
			for (i = 0, j = 0; i < numObjects; ++i) {
				if (objects[i] >= 0) objects[j++] = objects[i];
			}
			if (j > 0) objects.length = j;
			else node.indices = null;
			
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
			var staticBoundBoxes:Vector.<BoundBox> = parentTree.staticBoundBoxes;
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

	}
}