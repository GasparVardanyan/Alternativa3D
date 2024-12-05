package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.Body;
	import alternativa.physics.Contact;
	import alternativa.physics.ContactPoint;
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.colliders.BoxBoxCollider;
	import alternativa.physics.collision.colliders.BoxRectCollider;
	import alternativa.physics.collision.colliders.BoxSphereCollider;
	import alternativa.physics.collision.colliders.BoxTriangleCollider;
	import alternativa.physics.collision.colliders.SphereSphereCollider;
	import alternativa.physics.collision.types.BoundBox;
	import alternativa.physics.collision.types.RayIntersection;
	import alternativa.physics.math.Vector3;
	
	use namespace altphysics;

	/**
	 * Детектор, хранящий статическую геометрию в kD-дереве и использующий дерево для ускорения тестов на пересечения.
	 */
	public class KdTreeCollisionDetector implements ICollisionDetector {
		
		altphysics var tree:CollisionKdTree;
		altphysics var dynamicPrimitives:Vector.<CollisionPrimitive>;
		altphysics var dynamicPrimitivesNum:int;
		altphysics var threshold:Number = 0.0001;
		private var colliders:Object = {};

		private var _time:MinMax = new MinMax();
		private var _n:Vector3 = new Vector3();
		private var _o:Vector3 = new Vector3();
		private var _dynamicIntersection:RayIntersection = new RayIntersection();

		/**
		 * 
		 */
		public function KdTreeCollisionDetector() {
			tree = new CollisionKdTree();
			dynamicPrimitives = new Vector.<CollisionPrimitive>();
			
			addCollider(CollisionPrimitive.BOX, CollisionPrimitive.BOX, new BoxBoxCollider());
			addCollider(CollisionPrimitive.BOX, CollisionPrimitive.SPHERE, new BoxSphereCollider());
			addCollider(CollisionPrimitive.BOX, CollisionPrimitive.RECT, new BoxRectCollider());
			addCollider(CollisionPrimitive.BOX, CollisionPrimitive.TRIANGLE, new BoxTriangleCollider());
//			addCollider(CollisionPrimitive.BOX, CollisionPrimitive.PLANE, new BoxPlaneCollider());
			
//			addCollider(CollisionPrimitive.SPHERE, CollisionPrimitive.PLANE, new SpherePlaneCollider());
			addCollider(CollisionPrimitive.SPHERE, CollisionPrimitive.SPHERE, new SphereSphereCollider());
		}

		/**
		 * @param primitive
		 * @param isStatic
		 * @return 
		 */
		public function addPrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true):Boolean	{
//			if (isStatic)	tree.addStaticPrimitive(primitive);
//			else dynamicPrimitives[dynamicPrimitivesNum++] = primitive;
			return true;
		}
		
		/**
		 * 
		 * @param primitive
		 * @param isStatic
		 * @return 
		 * 
		 */
		public function removePrimitive(primitive:CollisionPrimitive, isStatic:Boolean = true):Boolean {
//			if (isStatic) return tree.removeStaticPrimitive(primitive);
//			var idx:int = dynamicPrimitives.indexOf(primitive);
//			if (idx < 0) return false;
//			dynamicPrimitives.splice(idx, 1);
//			dynamicPrimitivesNum--;
			return true;
		}

		/**
		 * 
		 */
		public function init(collisionPrimitives:Vector.<CollisionPrimitive>):void {
			tree.createTree(collisionPrimitives);
		}
		
		/**
		 * 
		 * @param contacts
		 * @return 
		 */
		public function getAllContacts(contacts:Contact):Contact {
//			for (var i:int = 0; i < dynamicPrimitivesNum; i++) {
//				var primitive:CollisionPrimitive = dynamicPrimitives[i];
//				primitive.calculateAABB();
//				if (primitive.body != null && primitive.body.frozen) continue;
//				var contact:Contact = getPrimitiveNodeCollisions(tree.rootNode, primitive, contacts);
//				
//				// Столкновения динамических примитивов между собой
//				// TODO: Попробовать различные оптимизации (сортировка по баундам, встраивание в дерево)
//				for (var j:int = i + 1; j < dynamicPrimitivesNum; j++) {
//					if (getContact(primitive, dynamicPrimitives[j], contacts[colNum])) colNum++;
//				}
//			}
			return null;
		}
		
		/**
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			if ((prim1.collisionGroup & prim2.collisionGroup) == 0) return false;
			if (prim1.body != null && prim1.body == prim2.body) return false;
			if (!prim1.aabb.intersects(prim2.aabb, 0.01)) return false;
			var collider:ICollider = colliders[prim1.type <= prim2.type ? (prim1.type << 16) | prim2.type : (prim2.type << 16) | prim1.type] as ICollider;
			if (collider != null && collider.getContact(prim1, prim2, contact)) {
				if (prim1.postCollisionPredicate != null && !prim1.postCollisionPredicate.considerCollision(prim2)) return false;
				if (prim2.postCollisionPredicate != null && !prim2.postCollisionPredicate.considerCollision(prim1)) return false;
				// Сохраняем ссылку на контакт для каждого тела
//				if (prim1.body != null)	prim1.body.contacts[prim1.body.contactsNum++] = contact;
//				if (prim2.body != null)	prim2.body.contacts[prim2.body.contactsNum++] = contact;
//				// Вычисляем максимальную глубину пересечения для контакта
//				contact.maxPenetration = ContactPoint(contact.points[0]).penetration;
//				var pen:Number;
//				for (var i:int = contact.pcount - 1; i >= 1; i--) {
//					if ((pen = (contact.points[i] as ContactPoint).penetration) > contact.maxPenetration) contact.maxPenetration = pen;
//				}
				return true;
			}
			return false;
		}

		/**
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			if ((prim1.collisionGroup & prim2.collisionGroup) == 0) return false;
			if (prim1.body != null && prim1.body == prim2.body) return false;
			if (!prim1.aabb.intersects(prim2.aabb, 0.01)) return false;
			var collider:ICollider = colliders[prim1.type <= prim2.type ? (prim1.type << 16) | prim2.type : (prim2.type << 16) | prim1.type] as ICollider;
			if (collider != null && collider.haveCollision(prim1, prim2)) {
				if (prim1.postCollisionPredicate != null && !prim1.postCollisionPredicate.considerCollision(prim2)) return false;
				if (prim2.postCollisionPredicate != null && !prim2.postCollisionPredicate.considerCollision(prim1)) return false;
				return true;
			}
			return false;
		}
		
		/**
		 * Тестирует луч на пересечение с физической геометрией.  Подразумевается, что детектор содержит набор примитивов, для которых выполняется проверка.
		 * В случае наличия нескольких пересечений, метод должен возвращать ближайшее к началу луча.
		 *
		 * @param origin 
		 * @param dir 
		 * @param collisionGroup идентификатор группы
		 * @param maxTime параметр, задающий длину проверяемого сегмента
		 * @param predicate
		 * @param result переменная для записи информации о столкновении в случае положительного теста. В случае отрицательного результата сохранность начальных данных в
		 *  переданной структуре не гарантируется. 
		 * @return true в случае наличия пересечения, иначе false
		 */
		public function intersectRay(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean {
			var hasStaticIntersection:Boolean = intersectRayWithStatic(origin, dir, collisionGroup, maxTime, predicate, result);
			var hasDynamicIntersection:Boolean = intersectRayWithDynamic(origin, dir, collisionGroup, maxTime, predicate, _dynamicIntersection);

			if (!(hasDynamicIntersection || hasStaticIntersection)) return false;

			if (hasDynamicIntersection && hasStaticIntersection) {
				if (result.t > _dynamicIntersection.t) result.copy(_dynamicIntersection);
				return true;
			}

			if (hasStaticIntersection) return true;

			result.copy(_dynamicIntersection);
			return true;
		}
		
		/**
		 * 
		 * @param origin
		 * @param dir
		 * @param collisionGroup
		 * @param maxTime
		 * @param predicate
		 * @param result
		 * @return 
		 * 
		 */
		public function intersectRayWithStatic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean {
			// Вычисление точки пересечения с корневм узлом
			if (!getRayBoundBoxIntersection(origin, dir, tree.rootNode.boundBox, _time)) return false;
			if (_time.max < 0 || _time.min > maxTime) return false;
			
			if (_time.min <= 0) {
				_time.min = 0;
				_o.x = origin.x;
				_o.y = origin.y;
				_o.z = origin.z;
			}	else {
				_o.x = origin.x + _time.min*dir.x;
				_o.y = origin.y + _time.min*dir.y;
				_o.z = origin.z + _time.min*dir.z;
			}
			if (_time.max > maxTime) _time.max = maxTime;
			
			var hasIntersection:Boolean = testRayAgainstNode(tree.rootNode, origin, _o, dir, collisionGroup, _time.min, _time.max, predicate, result);
			return hasIntersection ? result.t <= maxTime : false;
		}
		
		/**
		 * 
		 * @param body
		 * @param primitive
		 * @return 
		 * 
		 */
		public function testBodyPrimitiveCollision(body:Body, primitive:CollisionPrimitive):Boolean {
			return false;
		}

		/**
		 * 
		 * @param type1
		 * @param type2
		 * @param collider
		 */
		private function addCollider(type1:int, type2:int, collider:ICollider):void {
			colliders[type1 <= type2 ? (type1 << 16) | type2 : (type2 << 16) | type1] = collider;
		}

		/**
		 * Выполняет поиск столкновений динамического примитива с примитивами узла дерева.
		 * 
		 * @param node
		 * @param primitive
		 * @param contacts
		 * @param startIndex
		 * @return 
		 */
		private function getPrimitiveNodeCollisions(node:CollisionKdNode, primitive:CollisionPrimitive, contacts:Contact):Contact {
//			var colNum:int = 0;
//			if (node.indices != null) {
//				// Поиск столкновений со статическими примитивами узла
//				var primitives:Vector.<CollisionPrimitive> = tree.staticChildren;
//				var indices:Vector.<int> = node.indices;
//				for (var i:int = indices.length - 1; i >= 0; i--)
//					if (getContact(primitive, primitives[indices[i]], contacts[startIndex + colNum])) colNum++;
//			}
//			if (node.axis == -1) return colNum;
//			var min:Number;
//			var max:Number;
//			switch (node.axis) {
//				case 0:
//					min = primitive.aabb.minX;
//					max = primitive.aabb.maxX;
//					break;
//				case 1:
//					min = primitive.aabb.minY;
//					max = primitive.aabb.maxY;
//					break;
//				case 2:
//					min = primitive.aabb.minZ;
//					max = primitive.aabb.maxZ;
//					break;
//			}
//			if (min < node.coord) colNum += getPrimitiveNodeCollisions(node.negativeNode, primitive, contacts, startIndex + colNum);
//			if (max > node.coord) colNum += getPrimitiveNodeCollisions(node.positiveNode, primitive, contacts, startIndex + colNum);
//			return colNum;
			return null;
		}
		
		private static var _rayAABB:BoundBox = new BoundBox(); 
		/**
		 * Тест пересечения луча с динамическими примитивами.
		 * 
		 * @param origin
		 * @param dir
		 * @param collisionGroup
		 * @param maxTime
		 * @param predicate
		 * @param result
		 * @return 
		 */
		private function intersectRayWithDynamic(origin:Vector3, dir:Vector3, collisionGroup:int, maxTime:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean {
			var xx:Number = origin.x + dir.x*maxTime;
			var yy:Number = origin.y + dir.y*maxTime;
			var zz:Number = origin.z + dir.z*maxTime;
			if (xx < origin.x) {
				_rayAABB.minX = xx;
				_rayAABB.maxX = origin.x;
			} else {
				_rayAABB.minX = origin.x;
				_rayAABB.maxX = xx;
			}
			if (yy < origin.y) {
				_rayAABB.minY = yy;
				_rayAABB.maxY = origin.y;
			} else {
				_rayAABB.minY = origin.y;
				_rayAABB.maxY = yy;
			}
			if (zz < origin.z) {
				_rayAABB.minZ = zz;
				_rayAABB.maxZ = origin.z;
			} else {
				_rayAABB.minZ = origin.z;
				_rayAABB.maxZ = zz;
			}
			
			var minTime:Number = maxTime + 1;
			for (var i:int = 0; i < dynamicPrimitivesNum; i++) {
				var primitive:CollisionPrimitive = dynamicPrimitives[i];
				if ((primitive.collisionGroup & collisionGroup) == 0) continue;
				var paabb:BoundBox = primitive.aabb;
				if (_rayAABB.maxX < paabb.minX || _rayAABB.minX > paabb.maxX || _rayAABB.maxY < paabb.minY || _rayAABB.minY > paabb.maxY || _rayAABB.maxZ < paabb.minZ || _rayAABB.minZ > paabb.maxZ) continue;
				if (predicate != null && primitive.body != null && !predicate.considerBody(primitive.body)) continue;
				var t:Number = primitive.getRayIntersection(origin, dir, threshold, _n);
				if (t > 0 && t < minTime) {
					minTime = t;
					result.primitive = primitive;
					result.normal.x = _n.x;
					result.normal.y = _n.y;
					result.normal.z = _n.z;
				}
			}
			if (minTime > maxTime) return false;
			result.pos.x = origin.x + dir.x*minTime;
			result.pos.y = origin.y + dir.y*minTime;
			result.pos.z = origin.z + dir.z*minTime;
			result.t = minTime;
			return true;
		}
		
		/**
		 * Вычисляет точки пересечения луча с AABB. 
		 * 
		 * @param origin точка начала луча
		 * @param dir направляющий вектор луча. Вектор может иметь любую отличную от нуля длину.
		 * @param bb AABB, с которым пересекается луч
		 * @param time возвращаемое значение. В эту переменную записывается минимальное и максимальное время пересечения
		 * @return true в случае наличия хотя бы одного пересечения, иначе false
		 */
		private function getRayBoundBoxIntersection(origin:Vector3, dir:Vector3, bb:BoundBox, time:MinMax):Boolean {
			time.min = -1;
			time.max = 1e308;
			var t1:Number;
			var t2:Number;
			// Цикл по осям бокса
			for (var i:int = 0; i < 3; i++) {
				switch (i) {
					case 0:
						if (dir.x < threshold && dir.x > -threshold) {
							if (origin.x < bb.minX || origin.x > bb.maxX) return false;
							else continue;
						}
						t1 = (bb.minX - origin.x)/dir.x;
						t2 = (bb.maxX - origin.x)/dir.x;
						break;
					case 1:
						if (dir.y < threshold && dir.y > -threshold) {
							if (origin.y < bb.minY || origin.y > bb.maxY) return false;
							else continue;
						}
						t1 = (bb.minY - origin.y)/dir.y;
						t2 = (bb.maxY - origin.y)/dir.y;
						break;
					case 2:
						if (dir.z < threshold && dir.z > -threshold) {
							if (origin.z < bb.minZ || origin.z > bb.maxZ) return false;
							else continue;
						}
						t1 = (bb.minZ - origin.z)/dir.z;
						t2 = (bb.maxZ - origin.z)/dir.z;
						break;
				}
				if (t1 < t2) {
					if (t1 > time.min) time.min = t1;
					if (t2 < time.max) time.max = t2;
				} else {
					if (t2 > time.min) time.min = t2;
					if (t1 < time.max) time.max = t1;
				}
				if (time.max < time.min) return false;
			}
			return true;
		}
		
		/**
		 * 
		 * @param node
		 * @param origin
		 * @param dir
		 * @param collisionGroup
		 * @param t1 время входа луча в узел
		 * @param t2 время выхода луча из узла
		 * @param intersection
		 */
		private function testRayAgainstNode(node:CollisionKdNode, origin:Vector3, localOrigin:Vector3, dir:Vector3, collisionGroup:int, t1:Number, t2:Number, predicate:IRayCollisionPredicate, result:RayIntersection):Boolean {
			// При наличии в узле объектов, проверяем пересечение с ними
			if (node.indices != null && getRayNodeIntersection(origin, dir, collisionGroup, tree.staticChildren, node.indices, predicate, result)) return true;
			// Выход из функции если это конечный узел
			if (node.axis == -1) return false;
			
			// Определение времени пересечения луча и плоскости разделения узла
			var splitTime:Number;
			var currChildNode:CollisionKdNode;
			switch (node.axis) {
				case 0:
					if (dir.x > -threshold && dir.x < threshold) splitTime = t2 + 1;
					else splitTime = (node.coord - origin.x)/dir.x;
					currChildNode = localOrigin.x < node.coord ? node.negativeNode : node.positiveNode;
					break;
				case 1:
					if (dir.y > -threshold && dir.y < threshold) splitTime = t2 + 1;
					else splitTime = (node.coord - origin.y)/dir.y;
					currChildNode = localOrigin.y < node.coord ? node.negativeNode : node.positiveNode;
					break;
				case 2:
					if (dir.z > -threshold && dir.z < threshold) splitTime = t2 + 1;
					else splitTime = (node.coord - origin.z)/dir.z;
					currChildNode = localOrigin.z < node.coord ? node.negativeNode : node.positiveNode;
					break;
			}
			// Определение порядка проверки
			if (splitTime < t1 || splitTime > t2) {
				// Луч не переходит в соседний дочерний узел
				return testRayAgainstNode(currChildNode, origin, localOrigin, dir, collisionGroup, t1, t2, predicate, result);
			} else {
				// Луч переходит из одного дочернего узла в другой
				var intersects:Boolean = testRayAgainstNode(currChildNode, origin, localOrigin, dir, collisionGroup, t1, splitTime, predicate, result);
				if (intersects) return true;
				_o.x = origin.x + splitTime*dir.x;
				_o.y = origin.y + splitTime*dir.y;
				_o.z = origin.z + splitTime*dir.z;
				return testRayAgainstNode(currChildNode == node.negativeNode ? node.positiveNode : node.negativeNode, origin, _o, dir, collisionGroup, splitTime, t2, predicate, result);
			}
		}
		
		/**
		 * 
		 * @param origin
		 * @param dir
		 * @param collisionGroup
		 * @param primitives
		 * @param indices
		 * @param intersection
		 * @return 
		 * 
		 */
		private function getRayNodeIntersection(origin:Vector3, dir:Vector3, collisionGroup:int, primitives:Vector.<CollisionPrimitive>, indices:Vector.<int>, predicate:IRayCollisionPredicate, intersection:RayIntersection):Boolean {
			var pnum:int = indices.length;
			var minTime:Number = 1e308;
			for (var i:int = 0; i < pnum; i++) {
				var primitive:CollisionPrimitive = primitives[indices[i]];
				if ((primitive.collisionGroup & collisionGroup) == 0) continue;
				if (predicate != null && primitive.body != null && !predicate.considerBody(primitive.body)) continue;
				var t:Number = primitive.getRayIntersection(origin, dir, threshold, _n);
				if (t > 0 && t < minTime) {
					minTime = t;
					intersection.primitive = primitive;
					intersection.normal.x = _n.x;
					intersection.normal.y = _n.y;
					intersection.normal.z = _n.z;
				}
			}
			if (minTime == 1e308) return false;
			intersection.pos.x = origin.x + dir.x*minTime;
			intersection.pos.y = origin.y + dir.y*minTime;
			intersection.pos.z = origin.z + dir.z*minTime;
			intersection.t = minTime;
			return true;
		}
		
	}
}

	class MinMax {
		public var min:Number = 0;
		public var max:Number = 0;
	}