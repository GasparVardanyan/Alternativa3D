package alternativa.physics.collision.colliders {
	import alternativa.physics.Contact;
	import alternativa.physics.ContactPoint;
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionRect;
	import alternativa.math.Matrix4;
	import alternativa.math.Vector3;
	use namespace altphysics;

	/**
	 * 
	 */
	public class BoxRectCollider extends BoxCollider {

		private var epsilon:Number = 0.001;
		
		private var vectorToBox:Vector3 = new Vector3();
		private var axis:Vector3 = new Vector3();
		private var axis10:Vector3 = new Vector3();
		private var axis11:Vector3 = new Vector3();
		private var axis12:Vector3 = new Vector3();
		private var axis20:Vector3 = new Vector3();
		private var axis21:Vector3 = new Vector3();
		private var axis22:Vector3 = new Vector3();
		
		private var bestAxisIndex:int;
		private var minOverlap:Number;
		
		private var points1:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var points2:Vector.<Vector3> = new Vector.<Vector3>(8, true);

		/**
		 * 
		 */		
		public function BoxRectCollider() {
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

			var box:CollisionBox = prim1 as CollisionBox;
			var rect:CollisionRect;
			if (box == null) {
				box = prim2 as CollisionBox;
				rect = prim1 as CollisionRect;
			} else {
				rect = prim2 as CollisionRect;
			}
			
			if (bestAxisIndex < 4) {
				// Контакт вдоль одной из основных осей
				if (!findFaceContactPoints(box, rect, vectorToBox, bestAxisIndex, contact)) return false;
			} else {
				// Контакт ребро-ребро
				bestAxisIndex -= 4;
				if (!findEdgesIntersection(box, rect, vectorToBox, int(bestAxisIndex/2), bestAxisIndex%2, contact)) {
					return false;
				}
			}
			contact.body1 = box.body;
			contact.body2 = rect.body;
			
			// Хак для танков, чтобы исключить утыкания танков в стыки статических примитивов
			if (rect.transform.k > 0.99999) {
				contact.normal.x = 0;
				contact.normal.y = 0;
				contact.normal.z = 1;
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
			minOverlap = 1e10;
			var box:CollisionBox = prim1 as CollisionBox;
			var rect:CollisionRect;
			if (box == null) {
				box = prim2 as CollisionBox;
				rect = prim1 as CollisionRect;
			} else {
				rect = prim2 as CollisionRect;
			}
			var boxTransform:Matrix4 = box.transform;
			var rectTransform:Matrix4 = rect.transform;

			// Вектор из центра прямоугольника в центр бокса
			vectorToBox.x = boxTransform.d - rectTransform.d;
			vectorToBox.y = boxTransform.h - rectTransform.h;
			vectorToBox.z = boxTransform.l - rectTransform.l;
			
			// Проверка пересечения по нормали прямоугольника
			rectTransform.getAxis(2, axis22);
			if (!testMainAxis(box, rect, axis22, 0, vectorToBox)) return false;

			// Проверка пересечения по основным осям бокса
			boxTransform.getAxis(0, axis10);
			if (!testMainAxis(box, rect, axis10, 1, vectorToBox)) return false;
			boxTransform.getAxis(1, axis11);
			if (!testMainAxis(box, rect, axis11, 2, vectorToBox)) return false;
			boxTransform.getAxis(2, axis12);
			if (!testMainAxis(box, rect, axis12, 3, vectorToBox)) return false;

			// Получаем направляющие рёбер прямоугольника
			rectTransform.getAxis(0, axis20);
			rectTransform.getAxis(1, axis21);
			
			// Проверка производных осей
			if (!testDerivedAxis(box, rect, axis10, axis20, 4, vectorToBox)) return false;
			if (!testDerivedAxis(box, rect, axis10, axis21, 5, vectorToBox)) return false;
			
			if (!testDerivedAxis(box, rect, axis11, axis20, 6, vectorToBox)) return false;
			if (!testDerivedAxis(box, rect, axis11, axis21, 7, vectorToBox)) return false;

			if (!testDerivedAxis(box, rect, axis12, axis20, 8, vectorToBox)) return false;
			if (!testDerivedAxis(box, rect, axis12, axis21, 9, vectorToBox)) return false;
			
			return true;
		}
		
		/**
		 * Выполняет поиск точек контакта бокса с прямоугольником.
		 * 
		 * @param box бокс
		 * @param rect прямоугольник
		 * @param vectorToBox вектор, направленный из центра прямоугольника в центр бокса
		 * @param faceAxisIdx индекс оси, идентифицирующей полскость столкновения (грань бокса или полскость прямоугольника)   
		 * @param colInfo структура, в которую записывается информация о точках контакта
		 */
		private function findFaceContactPoints(box:CollisionBox, rect:CollisionRect, vectorToBox:Vector3, faceAxisIdx:int, contact:Contact):Boolean {
			var pnum:int;
			var i:int;
			var v:Vector3;
			var cp:ContactPoint;
			var boxTransform:Matrix4 = box.transform;
			var rectTransform:Matrix4 = rect.transform;
			var colAxis:Vector3 = contact.normal;
			
			var negativeFace:Boolean;
			var code:int;
			
			if (faceAxisIdx == 0) {
				// Столкновение с плоскостью прямоугольника

				// Проверим положение бокса относительно плоскости прямоугольника
				colAxis.x = rectTransform.c;
				colAxis.y = rectTransform.g;
				colAxis.z = rectTransform.k;
				
//				var offset:Number = colAxis.x*rectTransform.d + colAxis.y*rectTransform.h + colAxis.z*rectTransform.l;
//				if (bbPos.vDot(colAxis) < offset) return false;

				// Ищем ось бокса, определяющую наиболее антипараллельную грань
				var incidentAxisIdx:int = 0;
				var incidentAxisDot:Number;
				var maxDot:Number = 0;
				for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
					boxTransform.getAxis(axisIdx, axis);
					var dot:Number = axis.x*colAxis.x + axis.y*colAxis.y + axis.z*colAxis.z;
					var absDot:Number = dot < 0 ? -dot : dot;
					if (absDot > maxDot) {
						maxDot = absDot;
						incidentAxisIdx = axisIdx;
						incidentAxisDot = dot;
					}
				}
				negativeFace = incidentAxisDot > 0;
				
				code = 1 << (incidentAxisIdx << 1);
				if (negativeFace) {
					code <<= 1;
				}
				if ((code & box.excludedFaces) != 0) return false;
				
				
				// Получаем список вершин грани бокса, переводим их в систему координат прямоугольника и выполняем обрезку
				// по прямоугольнику. Таким образом получается список потенциальных точек контакта.
				boxTransform.getAxis(incidentAxisIdx, axis);
				getFaceVertsByAxis(box.hs, incidentAxisIdx, negativeFace, points1);
				boxTransform.transformVectorsN(points1, points2, 4);
				rectTransform.transformVectorsInverseN(points2, points1, 4);
				pnum = clipByRect(rect.hs);
				// Проверяем каждую потенциальную точку на принадлежность нижней полуплоскости прямоугольника и добавляем такие точки в список контактов
				contact.pcount = 0;
				for (i = 0; i < pnum; i++) {
					v = points1[i];
					if (v.z < epsilon) {
						cp = contact.points[contact.pcount++];
						cp.penetration = -v.z;
						var cpPos:Vector3 = cp.pos;
						cpPos.x = rectTransform.a*v.x + rectTransform.b*v.y + rectTransform.c*v.z + rectTransform.d;
						cpPos.y = rectTransform.e*v.x + rectTransform.f*v.y + rectTransform.g*v.z + rectTransform.h;
						cpPos.z = rectTransform.i*v.x + rectTransform.j*v.y + rectTransform.k*v.z + rectTransform.l;
						v = cp.r1;
						v.x = cpPos.x - boxTransform.d;
						v.y = cpPos.y - boxTransform.h;
						v.z = cpPos.z - boxTransform.l;
						v = cp.r2;
						v.x = cpPos.x - rectTransform.d;
						v.y = cpPos.y - rectTransform.h;
						v.z = cpPos.z - rectTransform.l;
					}
				}
			} else {
				// Столкновение с гранью бокса
				faceAxisIdx--;
				boxTransform.getAxis(faceAxisIdx, colAxis);
				negativeFace = colAxis.x*vectorToBox.x + colAxis.y*vectorToBox.y + colAxis.z*vectorToBox.z > 0;
				
				code = 1 << (faceAxisIdx << 1);
				if (negativeFace) {
					code <<= 1;
				}
				if ((code & box.excludedFaces) != 0) {
					return false;
				}
				
				if (!negativeFace) {
					colAxis.x = -colAxis.x;
					colAxis.y = -colAxis.y;
					colAxis.z = -colAxis.z;
				}
				
				if (rectTransform.c*colAxis.x + rectTransform.g*colAxis.y + rectTransform.k*colAxis.z < 0) return false;
				
				getFaceVertsByAxis(rect.hs, 2, false, points1);
				rectTransform.transformVectorsN(points1, points2, 4);
				boxTransform.transformVectorsInverseN(points2, points1, 4);
				pnum = clipByBox(box.hs, faceAxisIdx);
				// Проверяем каждую потенциальную точку на принадлежность первому боксу и добавляем такие точки в список контактов
				var pen:Number;
				contact.pcount = 0;
				for (i = 0; i < pnum; i++) {
					v = points1[i];
					if ((pen = getPointBoxPenetration(box.hs, v, faceAxisIdx, negativeFace)) > -epsilon) {
						cp = contact.points[contact.pcount++];
						cp.penetration = pen;
						cpPos = cp.pos;
						cpPos.x = boxTransform.a*v.x + boxTransform.b*v.y + boxTransform.c*v.z + boxTransform.d;
						cpPos.y = boxTransform.e*v.x + boxTransform.f*v.y + boxTransform.g*v.z + boxTransform.h;
						cpPos.z = boxTransform.i*v.x + boxTransform.j*v.y + boxTransform.k*v.z + boxTransform.l;
						v = cp.r1;
						v.x = cpPos.x - boxTransform.d;
						v.y = cpPos.y - boxTransform.h;
						v.z = cpPos.z - boxTransform.l;
						v = cp.r2;
						v.x = cpPos.x - rectTransform.d;
						v.y = cpPos.y - rectTransform.h;
						v.z = cpPos.z - rectTransform.l;
					}
				}
			}
			return true;
		}
		
		/**
		 * 
		 * @param hs
		 * @param p
		 * @param axisIndex
		 * @param reverse
		 * @return 
		 */
		private function getPointBoxPenetration(hs:Vector3, p:Vector3, faceAxisIdx:int, reverse:Boolean):Number {
			switch (faceAxisIdx) {
				case 0:
					if (reverse) return p.x + hs.x;
					else return hs.x - p.x;
				case 1:
					if (reverse) return p.y + hs.y;
					else return hs.y - p.y;
				case 2:
					if (reverse) return p.z + hs.z;
					else return hs.z - p.z;
			}
			return 0;
		}
		
		/**
		 * Выполняет обрезку грани, заданной списком вершин в поле объекта verts1. Результат сохраняется в этом же поле.
		 * 
		 * @param hs вектор половинных размеров бокса, гранью которого обрезается грань второго бокса
		 * @param faceAxisIdx индекс нормальной оси грани, по которой выполняется обрезка
		 * @return количество вершин, получившихся в результате обрезки грани, заданной вершинами в поле verts1
		 */
		private function clipByBox(hs:Vector3, faceAxisIdx:int):int {
			var pnum:int = 4;
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
		 * 
		 * @param hs
		 * @return 
		 */
		private function clipByRect(hs:Vector3):int {
			var pnum:int = 4;
			if ((pnum = clipLowX(-hs.x, pnum, points1, points2, epsilon)) == 0) return 0;
			if ((pnum = clipHighX(hs.x, pnum, points2, points1, epsilon)) == 0) return 0;
			if ((pnum = clipLowY(-hs.y, pnum, points1, points2, epsilon)) == 0) return 0;
			return clipHighY(hs.y, pnum, points2, points1, epsilon);
		}
		
		/**
		 * Вычисляет точку столкновения рёбер двух боксов.
		 * 
		 * @param box первый бокс
		 * @param rect второй бокс
		 * @param vectorToBox1 вектор, направленный из центра второго бокса в центр первого
		 * @param axisIdx1 индекс направляющей оси ребра первого бокса
		 * @param axisIdx2 индекс направляющей оси ребра второго бокса
		 * @param colInfo структура, в которую записывается информация о столкновении
		 */
		private function findEdgesIntersection(box:CollisionBox, rect:CollisionRect, vectorToBox:Vector3, axisIdx1:int, axisIdx2:int, contact:Contact):Boolean {
			var boxTransform:Matrix4 = box.transform;
			var rectTransform:Matrix4 = rect.transform;

			boxTransform.getAxis(axisIdx1, axis10);
			rectTransform.getAxis(axisIdx2, axis20);
			var colAxis:Vector3 = contact.normal;
			colAxis.x = axis10.y*axis20.z - axis10.z*axis20.y;
			colAxis.y = axis10.z*axis20.x - axis10.x*axis20.z;
			colAxis.z = axis10.x*axis20.y - axis10.y*axis20.x;
			var k:Number = 1/Math.sqrt(colAxis.x*colAxis.x + colAxis.y*colAxis.y + colAxis.z*colAxis.z);
			colAxis.x *= k;
			colAxis.y *= k;
			colAxis.z *= k;
			
			// Разворот оси в сторону бокса
			if (colAxis.x*vectorToBox.x + colAxis.y*vectorToBox.y + colAxis.z*vectorToBox.z < 0) {
				colAxis.x = -colAxis.x;
				colAxis.y = -colAxis.y;
				colAxis.z = -colAxis.z;
			}
			
			// Находим среднюю точку на каждом из пересекающихся рёбер 
			var halfLen1:Number;
			var halfLen2:Number;
			var vx:Number = box.hs.x;
			var vy:Number = box.hs.y;
			var vz:Number = box.hs.z;
			var x2:Number = rect.hs.x;
			var y2:Number = rect.hs.y;
			var z2:Number = rect.hs.z;
			// x
			if (axisIdx1 == 0) {
				vx = 0;
				halfLen1 = box.hs.x;
			} else {
				if (boxTransform.a*colAxis.x + boxTransform.e*colAxis.y + boxTransform.i*colAxis.z > 0) {
					vx = -vx;
					if ((box.excludedFaces & 2) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 1) != 0) {
						return false;
					}
				}
			}
			if (axisIdx2 == 0) {
				x2 = 0;
				halfLen2 = rect.hs.x;
			} else {
				if (rectTransform.a*colAxis.x + rectTransform.e*colAxis.y + rectTransform.i*colAxis.z < 0) {
					x2 = -x2;
				}
			}
			// y
			if (axisIdx1 == 1) {
				vy = 0;
				halfLen1 = box.hs.y;
			} else {
				if (boxTransform.b*colAxis.x + boxTransform.f*colAxis.y + boxTransform.j*colAxis.z > 0) {
					vy = -vy;
					if ((box.excludedFaces & 8) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 4) != 0) {
						return false;
					}
				}
			}
			if (axisIdx2 == 1) {
				y2 = 0;
				halfLen2 = rect.hs.y;
			} else {
				if (rectTransform.b*colAxis.x + rectTransform.f*colAxis.y + rectTransform.j*colAxis.z < 0) {
					y2 = -y2;
				}
			}
			// z
			if (axisIdx1 == 2) {
				vz = 0;
				halfLen1 = box.hs.z;
			} else {
				if (boxTransform.c*colAxis.x + boxTransform.g*colAxis.y + boxTransform.k*colAxis.z > 0) {
					vz = -vz;
					if ((box.excludedFaces & 32) != 0) {
						return false;
					}
				} else {
					if ((box.excludedFaces & 16) != 0) {
						return false;
					}
				}
			}
			// Получаем глобальные координаты средних точек рёбер
			
			var x1:Number = boxTransform.a*vx + boxTransform.b*vy + boxTransform.c*vz + boxTransform.d;
			var y1:Number = boxTransform.e*vx + boxTransform.f*vy + boxTransform.g*vz + boxTransform.h;
			var z1:Number = boxTransform.i*vx + boxTransform.j*vy + boxTransform.k*vz + boxTransform.l;
			vx = x2;
			vy = y2;
			vz = z2;
			x2 = rectTransform.a*vx + rectTransform.b*vy + rectTransform.c*vz + rectTransform.d;
			y2 = rectTransform.e*vx + rectTransform.f*vy + rectTransform.g*vz + rectTransform.h;
			z2 = rectTransform.i*vx + rectTransform.j*vy + rectTransform.k*vz + rectTransform.l;
			// Находим точку пересечения рёбер, решая систему уравнений
			k = axis10.x*axis20.x + axis10.y*axis20.y + axis10.z*axis20.z;
			var det:Number = k*k - 1;
			vx = x2 - x1;
			vy = y2 - y1;
			vz = z2 - z1;
			var c1:Number = axis10.x*vx + axis10.y*vy + axis10.z*vz;
			var c2:Number = axis20.x*vx + axis20.y*vy + axis20.z*vz;
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;
			// Запись данных о столкновении
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			cp.penetration = minOverlap;
			var cpPos:Vector3 = cp.pos;
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			cpPos.x = 0.5*(x1 + axis10.x*t1 + x2 + axis20.x*t2);
			cpPos.y = 0.5*(y1 + axis10.y*t1 + y2 + axis20.y*t2);
			cpPos.z = 0.5*(z1 + axis10.z*t1 + z2 + axis20.z*t2);
			var v:Vector3 = cp.r1;
			v.x = cpPos.x - boxTransform.d;
			v.y = cpPos.y - boxTransform.h;
			v.z = cpPos.z - boxTransform.l;
			v = cp.r2;
			v.x = cpPos.x - rectTransform.d;
			v.y = cpPos.y - rectTransform.h;
			v.z = cpPos.z - rectTransform.l;
			return true;
		}
		
		/**
		 * Проверяет пересечение вдоль заданной оси. При наличии пересечения сохраняется глубина пересечения, если она минимальна.
		 * 
		 * @param box
		 * @param rect
		 * @param axis
		 * @param axisIndex
		 * @param vectorToBox
		 * @param bestAxis
		 * @return true в случае, если проекции боксов на заданную ось пересекаются, иначе false
		 */
		private function testMainAxis(box:CollisionBox, rect:CollisionRect, axis:Vector3, axisIndex:int, vectorToBox:Vector3):Boolean {
			var overlap:Number = overlapOnAxis(box, rect, axis, vectorToBox);
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
		 * @param rect
		 * @param axis1
		 * @param axis2
		 * @param axisIndex
		 * @param vectorToBox
		 * @return 
		 * 
		 */
		private function testDerivedAxis(box:CollisionBox, rect:CollisionRect, axis1:Vector3, axis2:Vector3, axisIndex:int, vectorToBox:Vector3):Boolean {
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
			var overlap:Number = overlapOnAxis(box, rect, axis, vectorToBox);
			if (overlap < -epsilon)	return false;
			if (overlap + epsilon < minOverlap) {
				minOverlap = overlap;
				bestAxisIndex = axisIndex;
			}
			return true;
		}
		
		/**
		 * Вычисляет глубину перекрытия вдоль заданной оси.
		 * 
		 * @param box бокс
		 * @param rect прямоугольник
		 * @param axis ось
		 * @param vectorToBox вектор, соединяющий центр прямоугольника с центром бокса
		 * @return величина перекрытия вдоль оси 
		 */
		public function overlapOnAxis(box:CollisionBox, rect:CollisionRect, axis:Vector3, vectorToBox:Vector3):Number {
			var m:Matrix4 = box.transform;
			var d:Number = (m.a*axis.x + m.e*axis.y + m.i*axis.z)*box.hs.x;
			if (d < 0) d = -d;
			var projection:Number = d;
			d = (m.b*axis.x + m.f*axis.y + m.j*axis.z)*box.hs.y;
			if (d < 0) d = -d;
			projection += d;
			d = (m.c*axis.x + m.g*axis.y + m.k*axis.z)*box.hs.z;
			if (d < 0) d = -d;
			projection += d;

			m = rect.transform;
			d = (m.a*axis.x + m.e*axis.y + m.i*axis.z)*rect.hs.x;
			if (d < 0) d = -d;
			projection += d;
			d = (m.b*axis.x + m.f*axis.y + m.j*axis.z)*rect.hs.y;
			if (d < 0) d = -d;
			projection += d;
			
			d = vectorToBox.x*axis.x + vectorToBox.y*axis.y + vectorToBox.z*axis.z;
			if (d < 0) d = -d;
			
			return projection - d;
		}
		
	}
}
