package alternativa.physics.collision.colliders {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.Contact;
	import alternativa.physics.ContactPoint;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionTriangle;
	import alternativa.physics.math.Matrix4;
	import alternativa.physics.math.Vector3;

	/**
	 * 
	 */
	public class BoxTriangleCollider extends BoxCollider {
		
		public var epsilon:Number = 0.001;

		private var bestAxisIndex:int;
		private var minOverlap:Number;
		private var toBox:Vector3 = new Vector3();
		private var axis:Vector3 = new Vector3();
		private var colNormal:Vector3 = new Vector3();
		private var axis10:Vector3 = new Vector3();
		private var axis11:Vector3 = new Vector3();
		private var axis12:Vector3 = new Vector3();
		private var axis20:Vector3 = new Vector3();
		private var axis21:Vector3 = new Vector3();
		private var axis22:Vector3 = new Vector3();
		private var point1:Vector3 = new Vector3();
		private var point2:Vector3 = new Vector3();
		private var vector:Vector3 = new Vector3();
		private var points1:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var points2:Vector.<Vector3> = new Vector.<Vector3>(8, true);

		/**
		 * 
		 */
		public function BoxTriangleCollider() {
			for (var i:int = 0; i < 8; i++) {
				points1[i] = new Vector3();
				points2[i] = new Vector3();
			}
		}

		/**
		 * Проверяет наличие пересечения примитивов. Если пересечение существует, заполняется информация о контакте.
		 * 
		 * @param prim1 первый примитив
		 * @param prim2 второй примитив
		 * @param contact переменная, в которую записывается информация о контакте, если пересечение существует
		 * @return true, если пересечение существует, иначе false
		 */
		override public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			if (!haveCollision(prim1, prim2)) return false;
			
			var tri:CollisionTriangle = prim1 as CollisionTriangle;
			var box:CollisionBox;
			if (tri == null) {
				box = CollisionBox(prim1);
				tri = CollisionTriangle(prim2);
			} else {
				box = CollisionBox(prim2);
			}
			
			if (bestAxisIndex < 4) {
				// Контакт вдоль одной из основных осей
				if (!findFaceContactPoints(box, tri, toBox, bestAxisIndex, contact)) return false;
			} else {
				// Контакт ребро-ребро
				bestAxisIndex -= 4;
				if (!findEdgesIntersection(box, tri, toBox, bestAxisIndex%3, int(bestAxisIndex/3), contact)) return false;
			}
			
			contact.body1 = box.body;
			contact.body2 = tri.body;
			
			// Хак для танков, чтобы исключить утыкания танков в стыки статических примитивов
			if (tri.transform.k > 0.9999) {
				contact.normal.x = tri.transform.c;
				contact.normal.y = tri.transform.g;
				contact.normal.z = tri.transform.k;
			}
			
			return true;
		}
		
		/**
		 * Выполняет быстрый тест на наличие пересечения двух примитивов.
		 * 
		 * @param prim1 первый примитив
		 * @param prim2 второй примитив
		 * @return true, если пересечение существует, иначе false
		 */
		override public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			var tri:CollisionTriangle = prim1 as CollisionTriangle;
			var box:CollisionBox;
			if (tri == null) {
				box = CollisionBox(prim1);
				tri = CollisionTriangle(prim2);
			} else {
				box = CollisionBox(prim2);
			}
			
			var boxTransform:Matrix4 = box.transform;
			var triTransform:Matrix4 = tri.transform;
			
			toBox.x = boxTransform.d - triTransform.d;
			toBox.y = boxTransform.h - triTransform.h;
			toBox.z = boxTransform.l - triTransform.l;
			
			minOverlap = 1e308;
			
			// Сначала проверяется нормаль треугольника
			axis.x = triTransform.c;
			axis.y = triTransform.g;
			axis.z = triTransform.k;
			if (!testMainAxis(box, tri, axis, 0, toBox)) return false;
			
			// Проверка основных осей бокса
			axis10.x = boxTransform.a;
			axis10.y = boxTransform.e;
			axis10.z = boxTransform.i;
			if (!testMainAxis(box, tri, axis10, 1, toBox)) return false;
			axis11.x = boxTransform.b;
			axis11.y = boxTransform.f;
			axis11.z = boxTransform.j;
			if (!testMainAxis(box, tri, axis11, 2, toBox)) return false;
			axis12.x = boxTransform.c;
			axis12.y = boxTransform.g;
			axis12.z = boxTransform.k;
			if (!testMainAxis(box, tri, axis12, 3, toBox)) return false;
			
			// Проверка производных осей
			// TODO: заменить вычисления векторных произведений инлайнами
			var v:Vector3 = tri.e0;
			axis20.x = triTransform.a*v.x + triTransform.b*v.y + triTransform.c*v.z;
			axis20.y = triTransform.e*v.x + triTransform.f*v.y + triTransform.g*v.z;
			axis20.z = triTransform.i*v.x + triTransform.j*v.y + triTransform.k*v.z;
			if (!testDerivedAxis(box, tri, axis10, axis20, 4, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis11, axis20, 5, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis12, axis20, 6, toBox)) return false;

			v = tri.e1;
			axis21.x = triTransform.a*v.x + triTransform.b*v.y + triTransform.c*v.z;
			axis21.y = triTransform.e*v.x + triTransform.f*v.y + triTransform.g*v.z;
			axis21.z = triTransform.i*v.x + triTransform.j*v.y + triTransform.k*v.z;
			if (!testDerivedAxis(box, tri, axis10, axis21, 7, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis11, axis21, 8, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis12, axis21, 9, toBox)) return false;
			 
			v = tri.e2;
			axis22.x = triTransform.a*v.x + triTransform.b*v.y + triTransform.c*v.z;
			axis22.y = triTransform.e*v.x + triTransform.f*v.y + triTransform.g*v.z;
			axis22.z = triTransform.i*v.x + triTransform.j*v.y + triTransform.k*v.z;
			if (!testDerivedAxis(box, tri, axis10, axis22, 10, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis11, axis22, 11, toBox)) return false;
			if (!testDerivedAxis(box, tri, axis12, axis22, 12, toBox)) return false;
			
			return true;
		}
		
		/**
		 * Тестирует пересечение примитивов вдоль заданной оси.
		 * 
		 * @param box бокс
		 * @param tri треугольник
		 * @param axis ось
		 * @param axisIndex индекс оси
		 * @param toBox вектор, соединяющий центр треугольника с центром бокса
		 * @return true, если примитивы имеют перекрытие проекций вдоль указанной оси, иначе false
		 */
		private function testMainAxis(box:CollisionBox, tri:CollisionTriangle, axis:Vector3, axisIndex:int, toBox:Vector3):Boolean {
			var overlap:Number = overlapOnAxis(box, tri, axis, toBox);
			if (overlap < -epsilon)	return false;
			if (overlap + epsilon < minOverlap) {
				minOverlap = overlap;
				bestAxisIndex = axisIndex;
			}
			return true;
		}
		
		/**
		 * 
		 * @param box
		 * @param tri
		 * @param axis1
		 * @param axis2
		 * @param axisIndex
		 * @param toBox
		 * @return 
		 * 
		 */
		private function testDerivedAxis(box:CollisionBox, tri:CollisionTriangle, axis1:Vector3, axis2:Vector3, axisIndex:int, toBox:Vector3):Boolean {
			// axis = axis1 cross axis2
			axis.x = axis1.y*axis2.z - axis1.z*axis2.y;
			axis.y = axis1.z*axis2.x - axis1.x*axis2.z;
			axis.z = axis1.x*axis2.y - axis1.y*axis2.x;
			var lenSqr:Number = axis.x*axis.x + axis.y*axis.y + axis.z*axis.z;
			if (lenSqr < 0.0001) return true;
			var k:Number = 1/Math.sqrt(lenSqr);
			axis.x *= k;
			axis.y *= k;
			axis.z *= k;
			var overlap:Number = overlapOnAxis(box, tri, axis, toBox);
			if (overlap < -epsilon)	return false;
			if (overlap + epsilon < minOverlap) {
				minOverlap = overlap;
				bestAxisIndex = axisIndex;
			}
			return true;
		}
		
		/**
		 * Рассчитывает величину перекрытия проекций бокса и треугольника на заданную ось.
		 * 
		 * @param box бокс
		 * @param tri треугольник
		 * @param axis единичный направляющий вектор оси
		 * @param toBox вектор, соединяющий центр треугольника с центром бокса
		 * @return величина перекрытия. Положительное значение указывает на наличие перекрытия, нулевое или отрицательное значение указывает на отсутствие перекрытия.
		 */
		private function overlapOnAxis(box:CollisionBox, tri:CollisionTriangle, axis:Vector3, toBox:Vector3):Number {
			var t:Matrix4 = box.transform;
			var projection:Number = (t.a*axis.x + t.e*axis.y + t.i*axis.z)*box.hs.x;
			if (projection < 0) projection = -projection;
			var d:Number = (t.b*axis.x + t.f*axis.y + t.j*axis.z)*box.hs.y;
			projection += d < 0 ? -d : d;
			d = (t.c*axis.x + t.g*axis.y + t.k*axis.z)*box.hs.z;
			projection += d < 0 ? -d : d;
			
			var vectorProjection:Number = toBox.x*axis.x + toBox.y*axis.y + toBox.z*axis.z;
			// Для оптимизации ось преобразуется в систему треугольника, а не его вершины в мировую систему
			t = tri.transform;
			var ax:Number = t.a*axis.x + t.e*axis.y + t.i*axis.z;
			var ay:Number = t.b*axis.x + t.f*axis.y + t.j*axis.z;
			var az:Number = t.c*axis.x + t.g*axis.y + t.k*axis.z;
			var max:Number = 0;
			if (vectorProjection < 0) {
				vectorProjection = -vectorProjection;
				d = tri.v0.x*ax + tri.v0.y*ay + tri.v0.z*az;
				if (d < max) max = d;
				d = tri.v1.x*ax + tri.v1.y*ay + tri.v1.z*az;
				if (d < max) max = d;
				d = tri.v2.x*ax + tri.v2.y*ay + tri.v2.z*az;
				if (d < max) max = d;
				max = -max;
			} else {
				d = tri.v0.x*ax + tri.v0.y*ay + tri.v0.z*az;
				if (d > max) max = d;
				d = tri.v1.x*ax + tri.v1.y*ay + tri.v1.z*az;
				if (d > max) max = d;
				d = tri.v2.x*ax + tri.v2.y*ay + tri.v2.z*az;
				if (d > max) max = d;
			}
			
			return projection + max - vectorProjection;
		}
		
		/**
		 * Определяет точки контакта бокса и треугольника.
		 * 
		 * @param box бокс
		 * @param tri треугольник
		 * @param toBox вектор, соединяющий центр треугольника с центром бокса
		 * @param faceAxisIndex индекс оси, вдоль которой перекрытие минимально
		 * @param contact переменная, в которую записывается информация о контакте, если пересечение существует
		 * @return true, если пересечение существует, иначе false
		 */
		private function findFaceContactPoints(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, faceAxisIndex:int, contact:Contact):Boolean {
			if (faceAxisIndex == 0) {
				// Столкновение с плоскостью треугольника
				return getBoxToTriContact(box, tri, toBox, contact);
			} else {
				// Столкновение с гранью бокса
				return getTriToBoxContact(box, tri, toBox, faceAxisIndex, contact);
			}
		}
		
		/**
		 * Определяет точки контакта бокса с плоскостью треугольника.
		 * 
		 * @param box бокс
		 * @param tri треугольник
		 * @param toBox вектор, соединяющий центр треугольника с центром бокса
		 * @param contact переменная, в которую записывается информация о контакте, если пересечение существует
		 * @return true, если пересечение существует, иначе false
		 */
		private function getBoxToTriContact(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, contact:Contact):Boolean {
			var boxTransform:Matrix4 = box.transform;
			var triTransform:Matrix4 = tri.transform;
			
			colNormal.x = triTransform.c;
			colNormal.y = triTransform.g;
			colNormal.z = triTransform.k;
			
			var over:Boolean = toBox.x*colNormal.x + toBox.y*colNormal.y + toBox.z*colNormal.z > 0;
			if (!over) {
				colNormal.x = -colNormal.x;
				colNormal.y = -colNormal.y;
				colNormal.z = -colNormal.z;
			}
			// Ищем ось бокса, определяющую наиболее антипараллельную грань
			var incFaceAxisIdx:int = 0;
			var incAxisDot:Number = 0;
			var maxDot:Number = 0;
			for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
				boxTransform.getAxis(axisIdx, axis);
				var dot:Number = axis.x*colNormal.x + axis.y*colNormal.y + axis.z*colNormal.z;
				var absDot:Number = dot < 0 ? -dot : dot;
				if (absDot > maxDot) {
					maxDot = absDot;
					incAxisDot = dot;
					incFaceAxisIdx = axisIdx;
				}
			}
			// Обрезка грани
			var negativeFace:Boolean = incAxisDot > 0;
			
			var code:int = 1 << (incFaceAxisIdx << 1);
			if (negativeFace) {
				code <<= 1;
			}
			if ((code & box.excludedFaces) != 0) return false;
			
			getFaceVertsByAxis(box.hs, incFaceAxisIdx, negativeFace, points1);
			boxTransform.transformVectorsN(points1, points2, 4);
			triTransform.transformVectorsInverseN(points2, points1, 4);
			var pnum:int = clipByTriangle(tri);
			// Среди конечного списка точек определяются лежащие под плоскостью треугольника
			var cp:ContactPoint;
			contact.pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				var v:Vector3 = points2[i];
				if ((over && v.z < 0) || (!over && v.z > 0)) {
					cp = contact.points[contact.pcount++];
					var cpPos:Vector3 = cp.pos;
					cpPos.x = triTransform.a*v.x + triTransform.b*v.y + triTransform.c*v.z + triTransform.d;
					cpPos.y = triTransform.e*v.x + triTransform.f*v.y + triTransform.g*v.z + triTransform.h;
					cpPos.z = triTransform.i*v.x + triTransform.j*v.y + triTransform.k*v.z + triTransform.l;
					var r:Vector3 = cp.r1;
					r.x = cpPos.x - boxTransform.d;
					r.y = cpPos.y - boxTransform.h;
					r.z = cpPos.z - boxTransform.l;
					r = cp.r2;
					r.x = cpPos.x - triTransform.d;
					r.y = cpPos.y - triTransform.h;
					r.z = cpPos.z - triTransform.l;
					cp.penetration = over ? -v.z : v.z;
				}
			}
			contact.normal.x = colNormal.x;
			contact.normal.y = colNormal.y;
			contact.normal.z = colNormal.z;
			return true;
		}
		
		/**
		 * Оперделяет точки контакта треугольника с гранью бокса.
		 * 
		 * @param box бокс
		 * @param tri треугольник
		 * @param toBox вектор, соединяющий центр треугольника с центром бокса
		 * @param faceAxisIndex индекс оси, вдоль которой перекрытие минимально
		 * @param contact переменная, в которую записывается информация о контакте, если пересечение существует
		 * @return true, если пересечение существует, иначе false
		 */
		private function getTriToBoxContact(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, faceAxisIdx:int, contact:Contact):Boolean {
			faceAxisIdx--;
			
			var boxTransform:Matrix4 = box.transform;
			var triTransform:Matrix4 = tri.transform;
			
			boxTransform.getAxis(faceAxisIdx, colNormal);
			var negativeFace:Boolean = toBox.x*colNormal.x + toBox.y*colNormal.y + toBox.z*colNormal.z > 0;
			
			var code:int = 1 << (faceAxisIdx << 1);
			if (negativeFace) {
				code <<= 1;
			}
			if ((code & box.excludedFaces) != 0) return false;
			
			if (!negativeFace) {
				colNormal.x = -colNormal.x;
				colNormal.y = -colNormal.y;
				colNormal.z = -colNormal.z;
			}
			var v:Vector3 = points1[0];
			v.x = tri.v0.x;
			v.y = tri.v0.y;
			v.z = tri.v0.z;
			
			v = points1[1];
			v.x = tri.v1.x;
			v.y = tri.v1.y;
			v.z = tri.v1.z;
			
			v = points1[2];
			v.x = tri.v2.x;
			v.y = tri.v2.y;
			v.z = tri.v2.z;
			
			triTransform.transformVectorsN(points1, points2, 3);
			boxTransform.transformVectorsInverseN(points2, points1, 3);
			
			var pnum:int = clipByBox(box.hs, faceAxisIdx);
			// Проверяем каждую потенциальную точку на принадлежность боксу и добавляем такие точки в список контактов
			var penetration:Number;
			contact.pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				v = points1[i];
				penetration = getPointBoxPenetration(box.hs, v, faceAxisIdx, negativeFace);
				if (penetration > -epsilon) {
					var cp:ContactPoint = contact.points[contact.pcount++];
					var cpPos:Vector3 = cp.pos;
					cpPos.x = boxTransform.a*v.x + boxTransform.b*v.y + boxTransform.c*v.z + boxTransform.d;
					cpPos.y = boxTransform.e*v.x + boxTransform.f*v.y + boxTransform.g*v.z + boxTransform.h;
					cpPos.z = boxTransform.i*v.x + boxTransform.j*v.y + boxTransform.k*v.z + boxTransform.l;
					var r:Vector3 = cp.r1;
					r.x = cpPos.x - boxTransform.d;
					r.y = cpPos.y - boxTransform.h;
					r.z = cpPos.z - boxTransform.l;
					r = cp.r2;
					r.x = cpPos.x - triTransform.d;
					r.y = cpPos.y - triTransform.h;
					r.z = cpPos.z - triTransform.l;
					cp.penetration = penetration;
				}
			}
			contact.normal.x = colNormal.x;
			contact.normal.y = colNormal.y;
			contact.normal.z = colNormal.z;
			return true;
		}

		/**
		 * Вычисляет величину проникновения точки в бокс.
		 * 
		 * @param hs вектор половинных размеров бокса
		 * @param p точка в системе координат бокса
		 * @param axisIndex индекс оси
		 * @param negativeFace если true, проверяется нижняя грань
		 * @return величина проникновения точки в бокс
		 */
		private function getPointBoxPenetration(hs:Vector3, p:Vector3, faceAxisIdx:int, negativeFace:Boolean):Number {
			switch (faceAxisIdx) {
				case 0:
					if (negativeFace) return p.x + hs.x;
					else return hs.x - p.x;
				case 1:
					if (negativeFace) return p.y + hs.y;
					else return hs.y - p.y;
				case 2:
					if (negativeFace) return p.z + hs.z;
					else return hs.z - p.z;
			}
			return 0;
		}

		/**
		 * Выполняет обрезку грани, вершины которой заданы в списке points1. Результат сохраняется в этом же списке.
		 * 
		 * @param hs вектор половинных размеров бокса, гранью которого обрезается грань второго бокса
		 * @param faceAxisIdx индекс нормальной оси грани, по которой выполняется обрезка
		 * @return количество вершин, получившихся в результате обрезки грани
		 */
		private function clipByBox(hs:Vector3, faceAxisIdx:int):int {
			var pnum:int = 3;
			switch (faceAxisIdx) {
				case 0:
					if ((pnum = clipLowZ(-hs.z, pnum, points1, points2, epsilon)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, points2, points1, epsilon)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, points1, points2, epsilon)) == 0) return 0;
					return clipHighY(hs.y, pnum, points2, points1, epsilon);
				case 1:
					if ((pnum = clipLowZ(-hs.z, pnum, points1, points2, epsilon)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, points2, points1, epsilon)) == 0) return 0;
					if ((pnum = clipLowX(-hs.x, pnum, points1, points2, epsilon)) == 0) return 0;
					return clipHighX(hs.x, pnum, points2, points1, epsilon);
				case 2:
					if ((pnum = clipLowX(-hs.x, pnum, points1, points2, epsilon)) == 0) return 0;
					if ((pnum = clipHighX(hs.x, pnum, points2, points1, epsilon)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, points1, points2, epsilon)) == 0) return 0;
					return clipHighY(hs.y, pnum, points2, points1, epsilon);
			}
			return 0;
		}

		/**
		 * Обрезает грань прямоугольника сторонами треугольника. Обрезка выполняется в системе координат и в проекции на
		 * плоскость треугольника. Входные вершины грани в количестве четырёх штук должны находиться в списке points1.
		 * Конечные вершины сохраняются в списке points2. 
		 * 
		 * @param tri треугольник
		 * @return количество врешин в конечном списке
		 */
		private function clipByTriangle(tri:CollisionTriangle):int {
			var vnum:int = 4;
			vnum = clipByLine(tri.v0, tri.e0, points1, vnum, points2);
			if (vnum == 0) return 0;
			vnum = clipByLine(tri.v1, tri.e1, points2, vnum, points1);
			if (vnum == 0) return 0;
			return clipByLine(tri.v2, tri.e2, points1, vnum, points2);;
		}
		
		/**
		 * Обрезает полигон указанной прямой.
		 * 
		 * @param linePoint точка на прямой
		 * @param lineDir единичный направляющий вектор прямой
		 * @param verticesIn список вершин исходного полигона
		 * @param vnum количество вершин исходного полигона
		 * @param verticesOut список, куда будут записаны вершины конечного полигона
		 * @return количество вершин конечного полигона
		 */
		private function clipByLine(linePoint:Vector3, lineDir:Vector3, verticesIn:Vector.<Vector3>, vnum:int, verticesOut:Vector.<Vector3>):int {
			var nx:Number = -lineDir.y;
			var ny:Number = lineDir.x;
			var offset:Number = linePoint.x*nx + linePoint.y*ny;
			var v1:Vector3 = verticesIn[int(vnum - 1)];
			var offset1:Number = v1.x*nx + v1.y*ny;
			var t:Number;
			var v:Vector3;
			var num:int = 0;
			for (var i:int = 0; i < vnum; i++) {
				var v2:Vector3 = verticesIn[i];
				var offset2:Number = v2.x*nx + v2.y*ny;
				if (offset1 < offset) {
					// Первая точка ребра во внешней полуплоскости
					if (offset2 > offset) {
						// Вторая точка ребра во внутренней полуплоскости, в конечный список добавляется точка на пересечении
						t = (offset - offset1)/(offset2 - offset1);
						v = verticesOut[num];
						v.x = v1.x + t*(v2.x - v1.x);
						v.y = v1.y + t*(v2.y - v1.y);
						v.z = v1.z + t*(v2.z - v1.z);
						num++;
					}
				} else {
					// Первая точка ребра во внутренней полуплоскости. Добавляем её в конечный список.
					v = verticesOut[num];
					v.x = v1.x;
					v.y = v1.y;
					v.z = v1.z;
					num++;
					if (offset2 < offset) {
						// Вторая точка ребра во внешней полуплоскости, в конечный список добавляется точка на пересечении
						t = (offset - offset1)/(offset2 - offset1);
						v = verticesOut[num];
						v.x = v1.x + t*(v2.x - v1.x);
						v.y = v1.y + t*(v2.y - v1.y);
						v.z = v1.z + t*(v2.z - v1.z);
						num++;
					}
				}
				v1 = v2;
				offset1 = offset2;
			}
			return num;
		}
		
		/**
		 * 
		 * @param box
		 * @param tri
		 * @param toBox
		 * @param boxAxisIdx
		 * @param triAxisIdx
		 * @param contact
		 */
		private function findEdgesIntersection(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, boxAxisIdx:int, triAxisIdx:int, contact:Contact):Boolean {
			// Определение точки и направляющего вектора ребра треугольника
			var tmpx1:Number;
			var tmpy1:Number;
			var tmpz1:Number;
			var tmpx2:Number;
			var tmpy2:Number;
			var tmpz2:Number;
			switch (triAxisIdx) {
				case 0:
					tmpx1 = tri.e0.x;
					tmpy1 = tri.e0.y;
					tmpz1 = tri.e0.z;
					tmpx2 = tri.v0.x;
					tmpy2 = tri.v0.y;
					tmpz2 = tri.v0.z;
					break;
				case 1:
					tmpx1 = tri.e1.x;
					tmpy1 = tri.e1.y;
					tmpz1 = tri.e1.z;
					tmpx2 = tri.v1.x;
					tmpy2 = tri.v1.y;
					tmpz2 = tri.v1.z;
					break;
				case 2:
					tmpx1 = tri.e2.x;
					tmpy1 = tri.e2.y;
					tmpz1 = tri.e2.z;
					tmpx2 = tri.v2.x;
					tmpy2 = tri.v2.y;
					tmpz2 = tri.v2.z;
					break;
			}
			var triTransform:Matrix4 = tri.transform;
			axis20.x = triTransform.a*tmpx1 + triTransform.b*tmpy1 + triTransform.c*tmpz1;
			axis20.y = triTransform.e*tmpx1 + triTransform.f*tmpy1 + triTransform.g*tmpz1;
			axis20.z = triTransform.i*tmpx1 + triTransform.j*tmpy1 + triTransform.k*tmpz1;
			var x2:Number = triTransform.a*tmpx2 + triTransform.b*tmpy2 + triTransform.c*tmpz2 + triTransform.d;
			var y2:Number = triTransform.e*tmpx2 + triTransform.f*tmpy2 + triTransform.g*tmpz2 + triTransform.h;
			var z2:Number = triTransform.i*tmpx2 + triTransform.j*tmpy2 + triTransform.k*tmpz2 + triTransform.l;

			// Определение нормали контакта, точки и направляющего вектора ребра бокса
			var boxTransform:Matrix4 = box.transform;
			boxTransform.getAxis(boxAxisIdx, axis10);

			// Нормаль контакта
			var v:Vector3 = contact.normal;
			v.x = axis10.y*axis20.z - axis10.z*axis20.y;
			v.y = axis10.z*axis20.x - axis10.x*axis20.z;
			v.z = axis10.x*axis20.y - axis10.y*axis20.x;
			k = 1/Math.sqrt(v.x*v.x + v.y*v.y + v.z*v.z);
			v.x *= k;
			v.y *= k;
			v.z *= k;
			// Разворот нормали в сторону бокса
			if (v.x*toBox.x + v.y*toBox.y + v.z*toBox.z < 0) {
				v.x = -v.x;
				v.y = -v.y;
				v.z = -v.z;
			}
			
			var boxHalfLen:Number;
			tmpx1 = box.hs.x;
			tmpy1 = box.hs.y;
			tmpz1 = box.hs.z;
			// X
			if (boxAxisIdx == 0) {
				tmpx1 = 0;
				boxHalfLen = box.hs.x;
			} else {
				if (boxTransform.a*v.x + boxTransform.e*v.y + boxTransform.i*v.z > 0) {
					tmpx1 = -tmpx1;
					if ((box.excludedFaces & 2) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 1) != 0) {
						return false;
					}
				}
			}
			// Y
			if (boxAxisIdx == 1) {
				tmpy1 = 0;
				boxHalfLen = box.hs.y;
			} else {
				if (boxTransform.b*v.x + boxTransform.f*v.y + boxTransform.j*v.z > 0) {
					tmpy1 = -tmpy1;
					if ((box.excludedFaces & 8) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 4) != 0) {
						return false;
					}
				}
			}
			// Z
			if (boxAxisIdx == 2) {
				tmpz1 = 0;
				boxHalfLen = box.hs.z;
			} else {
				if (boxTransform.c*v.x + boxTransform.g*v.y + boxTransform.k*v.z > 0) {
					tmpz1 = -tmpz1;
					if ((box.excludedFaces & 32) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 16) != 0) {
						return false;
					}
				}
			}
			var x1:Number = boxTransform.a*tmpx1 + boxTransform.b*tmpy1 + boxTransform.c*tmpz1 + boxTransform.d;
			var y1:Number = boxTransform.e*tmpx1 + boxTransform.f*tmpy1 + boxTransform.g*tmpz1 + boxTransform.h;
			var z1:Number = boxTransform.i*tmpx1 + boxTransform.j*tmpy1 + boxTransform.k*tmpz1 + boxTransform.l;
			
			// Находим точку пересечения рёбер, решая систему уравнений
			// axis10 - направляющий вектор ребра бокса
			// x1, y1, z1 - средняя точка ребра бокса
			// axis20 - направляющий вектор ребра треугольника
			// x2, y2, z2 - начальная точка ребра треугольника
			var k:Number = axis10.x*axis20.x + axis10.y*axis20.y + axis10.z*axis20.z;
			var det:Number = k*k - 1;
			var vx:Number = x2 - x1;
			var vy:Number = y2 - y1;
			var vz:Number = z2 - z1;
			var c1:Number = axis10.x*vx + axis10.y*vy + axis10.z*vz;
			var c2:Number = axis20.x*vx + axis20.y*vy + axis20.z*vz;
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;

			// Запись данных о контакте
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			cp.penetration = minOverlap;
			v = cp.pos;
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			v.x = 0.5*(x1 + axis10.x*t1 + x2 + axis20.x*t2);
			v.y = 0.5*(y1 + axis10.y*t1 + y2 + axis20.y*t2);
			v.z = 0.5*(z1 + axis10.z*t1 + z2 + axis20.z*t2);
			var r:Vector3 = cp.r1;
			r.x = v.x - boxTransform.d;
			r.y = v.y - boxTransform.h;
			r.z = v.z - boxTransform.l;
			r = cp.r2;
			r.x = v.x - triTransform.d;
			r.y = v.y - triTransform.h;
			r.z = v.z - triTransform.l;
			return true;
		}
		
	}
}