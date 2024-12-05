package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactPoint;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;

	use namespace altphysics;

	/**
	 * Расчитывает точки контакта двух боксов. Нормаль контакта направляется в сторону бокса с меньшим ID.
	 */
	public class BoxBoxCollider extends BoxCollider {
		
		private var epsilon:Number = 0.001;
		private var vectorToBox1:Vector3 = new Vector3();
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
		private var tmpPoints:Vector.<ContactPoint> = new Vector.<ContactPoint>(8, true);
		private var pcount:int;
		
		/**
		 * 
		 */
		public function BoxBoxCollider() {
			for (var i:int = 0; i < 8; i++) {
				tmpPoints[i] = new ContactPoint();
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
			
			var box1:CollisionBox;
			var box2:CollisionBox;
			if (prim1.body != null) {
				box1 = prim1 as CollisionBox;
				box2 = prim2 as CollisionBox;
			} else {
				box1 = prim2 as CollisionBox;
				box2 = prim1 as CollisionBox;
			}

			if (bestAxisIndex < 6) {
				// Контакт грань-(грань|ребро|вершина)
				findFaceContactPoints(box1, box2, vectorToBox1, bestAxisIndex, contact);
			} else {
				// Контакт ребро-ребро
				bestAxisIndex -= 6;
				findEdgesIntersection(box1, box2, vectorToBox1, int(bestAxisIndex/3), bestAxisIndex%3, contact);
			}
			contact.body1 = box1.body;
			contact.body2 = box2.body;

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
			var box1:CollisionBox;
			var box2:CollisionBox;
			if (prim1.body != null) {
				box1 = prim1 as CollisionBox;
				box2 = prim2 as CollisionBox;
			} else {
				box1 = prim2 as CollisionBox;
				box2 = prim1 as CollisionBox;
			}
			var transform1:Matrix4 = box1.transform;
			var transform2:Matrix4 = box2.transform;

			// Вектор из центра второго бокса в центр первого
			vectorToBox1.x = transform1.d - transform2.d;
			vectorToBox1.y = transform1.h - transform2.h;
			vectorToBox1.z = transform1.l - transform2.l;
			
			// Проверка пересечения по основным осям
			axis10.x = transform1.a;
			axis10.y = transform1.e;
			axis10.z = transform1.i;
			if (!testMainAxis(box1, box2, axis10, 0, vectorToBox1)) return false;
			axis11.x = transform1.b;
			axis11.y = transform1.f;
			axis11.z = transform1.j;
			if (!testMainAxis(box1, box2, axis11, 1, vectorToBox1)) return false;
			axis12.x = transform1.c;
			axis12.y = transform1.g;
			axis12.z = transform1.k;
			if (!testMainAxis(box1, box2, axis12, 2, vectorToBox1)) return false;
			
			axis20.x = transform2.a;
			axis20.y = transform2.e;
			axis20.z = transform2.i;
			if (!testMainAxis(box1, box2, axis20, 3, vectorToBox1)) return false;
			axis21.x = transform2.b;
			axis21.y = transform2.f;
			axis21.z = transform2.j;
			if (!testMainAxis(box1, box2, axis21, 4, vectorToBox1)) return false;
			axis22.x = transform2.c;
			axis22.y = transform2.g;
			axis22.z = transform2.k;
			if (!testMainAxis(box1, box2, axis22, 5, vectorToBox1)) return false;
			
			// Проверка производных осей
			if (!testDerivedAxis(box1, box2, axis10, axis20, 6, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis10, axis21, 7, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis10, axis22, 8, vectorToBox1)) return false;
			
			if (!testDerivedAxis(box1, box2, axis11, axis20, 9, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis11, axis21, 10, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis11, axis22, 11, vectorToBox1)) return false;

			if (!testDerivedAxis(box1, box2, axis12, axis20, 12, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis12, axis21, 13, vectorToBox1)) return false;
			if (!testDerivedAxis(box1, box2, axis12, axis22, 14, vectorToBox1)) return false;

			return true;
		}

		/**
		 * Выполняет поиск точек контакта грани одного бокса с гранью/ребром/вершиной другого.
		 * 
		 * @param box1 первый бокс
		 * @param box2 второй бокс
		 * @param vectorToBox1 вектор, направленный из центра второго бокса в центр первого
		 * @param faceAxisIdx индекс оси первого бокса, перпендикулярной грани, с которой произошло столкновение  
		 * @param contactInfo структура, в которую записывается информация о точках контакта
		 */
		private function findFaceContactPoints(box1:CollisionBox, box2:CollisionBox, vectorToBox1:Vector3, faceAxisIdx:int, contact:Contact):void {
			var swapNormal:Boolean = false;
			if (faceAxisIdx > 2) {
				// Столкновение с гранью второго бокса. Для дальнейших расчётов боксы меняются местами,
				// но нормаль контакта всё равно должна быть направлена в сторону первоначального box1
				var tmpBox:CollisionBox = box1;
				box1 = box2;
				box2 = tmpBox;
				vectorToBox1.x = -vectorToBox1.x;
				vectorToBox1.y = -vectorToBox1.y;
				vectorToBox1.z = -vectorToBox1.z;
				faceAxisIdx -= 3;
				swapNormal = true;
			}
			
			var transform1:Matrix4 = box1.transform; 
			var transform2:Matrix4 = box2.transform; 
			
			var colAxis:Vector3 = contact.normal;
			
			transform1.getAxis(faceAxisIdx, colAxis);
			var negativeFace:Boolean = colAxis.x*vectorToBox1.x + colAxis.y*vectorToBox1.y + colAxis.z*vectorToBox1.z > 0;
			if (!negativeFace) {
				colAxis.x = -colAxis.x;
				colAxis.y = -colAxis.y;
				colAxis.z = -colAxis.z;
			}
			// Ищем ось второго бокса, определяющую наиболее антипараллельную грань
			var incidentAxisIdx:int = 0;
			var incidentAxisDot:Number;
			var maxDot:Number = 0;
			for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
				transform2.getAxis(axisIdx, axis);
				var dot:Number = axis.x*colAxis.x + axis.y*colAxis.y + axis.z*colAxis.z;
				var absDot:Number = dot < 0 ? -dot : dot;
				if (absDot > maxDot) {
					maxDot = absDot;
					incidentAxisDot = dot;
					incidentAxisIdx = axisIdx;
				}
			}
			// Получаем список вершин грани второго бокса, переводим их в систему координат первого бокса и выполняем обрезку
			// по грани первого бокса. Таким образом получается список потенциальных точек контакта.
			transform2.getAxis(incidentAxisIdx, axis);
			getFaceVertsByAxis(box2.hs, incidentAxisIdx, incidentAxisDot < 0, points1);
			
			// TODO: Вычислить результирующую матрицу, затем преобразовать векторы за один заход
			transform2.transformVectorsN(points1, points2, 4);
			transform1.transformVectorsInverseN(points2, points1, 4);
			
			var pnum:int = clip(box1.hs, faceAxisIdx);
			// Проверяем каждую потенциальную точку на принадлежность первому боксу и добавляем такие точки в список контактов
			var pen:Number;
			pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				var v:Vector3 = points1[i];
				if ((pen = getPointBoxPenetration(box1.hs, v, faceAxisIdx, negativeFace)) > -epsilon) {
					var cp:ContactPoint = tmpPoints[pcount++];
					var cpPos:Vector3 = cp.pos;
					cpPos.x = transform1.a*v.x + transform1.b*v.y + transform1.c*v.z + transform1.d;
					cpPos.y = transform1.e*v.x + transform1.f*v.y + transform1.g*v.z + transform1.h;
					cpPos.z = transform1.i*v.x + transform1.j*v.y + transform1.k*v.z + transform1.l;
					var r:Vector3 = cp.r1;
					r.x = cpPos.x - transform1.d;
					r.y = cpPos.y - transform1.h;
					r.z = cpPos.z - transform1.l;
					
					r = cp.r2;
					r.x = cpPos.x - transform2.d;
					r.y = cpPos.y - transform2.h;
					r.z = cpPos.z - transform2.l;
					
					cp.penetration = pen;
				}
			}
			if (swapNormal) {
				colAxis.x = -colAxis.x;
				colAxis.y = -colAxis.y;
				colAxis.z = -colAxis.z;
			}
			
			if (pcount > 4) {
				reducePoints();
			}
			for (i = 0; i < pcount; i++) {
				ContactPoint(contact.points[i]).copyFrom(tmpPoints[i]);
			}
			contact.pcount = pcount;
		}
		
		/**
		 * 
		 * @param contactInfo
		 */
		private function reducePoints():void {
			var i:int;
			var minIdx:int;
			var cp1:ContactPoint;
			var cp2:ContactPoint;
			while (pcount > 4) {
				var minLen:Number = 1e10;
				var p1:Vector3 = ContactPoint(tmpPoints[pcount - 1]).pos;
				var p2:Vector3;
				for (i = 0; i < pcount; i++) {
					p2 = ContactPoint(tmpPoints[i]).pos;
					var dx:Number = p2.x - p1.x;
					var dy:Number = p2.y - p1.y;
					var dz:Number = p2.z - p1.z;
					var len:Number = dx*dx + dy*dy + dz*dz;
					if (len < minLen) {
						minLen = len;
						minIdx = i;
					}
					p1 = p2;
				}
				cp1 = tmpPoints[minIdx == 0 ? (pcount - 1) : (minIdx - 1)];
				cp2 = tmpPoints[minIdx];
				p1 = cp1.pos;
				p2 = cp2.pos;
				p2.x = 0.5*(p1.x + p2.x);
				p2.y = 0.5*(p1.y + p2.y);
				p2.z = 0.5*(p1.z + p2.z);
				cp2.penetration = 0.5*(cp1.penetration + cp2.penetration);
				if (minIdx > 0) {
					for (i = minIdx; i < pcount; i++) {
						tmpPoints[i - 1] = tmpPoints[i];
					}
					tmpPoints[pcount - 1] = cp1;
				}
				pcount--;
			}
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
		private function clip(hs:Vector3, faceAxisIdx:int):int {
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
		 * Вычисляет точку столкновения рёбер двух боксов.
		 * 
		 * @param box1 первый бокс
		 * @param box2 второй бокс
		 * @param vectorToBox1 вектор, направленный из центра второго бокса в центр первого
		 * @param axisIdx1 индекс направляющей оси ребра первого бокса
		 * @param axisIdx2 индекс направляющей оси ребра второго бокса
		 * @param contactInfo структура, в которую записывается информация о столкновении
		 */
		private function findEdgesIntersection(box1:CollisionBox, box2:CollisionBox, vectorToBox1:Vector3, axisIdx1:int, axisIdx2:int, contact:Contact):void {
			var transform1:Matrix4 = box1.transform;
			var transform2:Matrix4 = box2.transform;
			transform1.getAxis(axisIdx1, axis10);
			transform2.getAxis(axisIdx2, axis20);
			
			var colAxis:Vector3 = contact.normal;
			
			colAxis.x = axis10.y*axis20.z - axis10.z*axis20.y;
			colAxis.y = axis10.z*axis20.x - axis10.x*axis20.z;
			colAxis.z = axis10.x*axis20.y - axis10.y*axis20.x;
			var k:Number = 1/Math.sqrt(colAxis.x*colAxis.x + colAxis.y*colAxis.y + colAxis.z*colAxis.z);
			colAxis.x *= k;
			colAxis.y *= k;
			colAxis.z *= k;
			
			// Разворот оси в сторону первого бокса
			if (colAxis.x*vectorToBox1.x + colAxis.y*vectorToBox1.y + colAxis.z*vectorToBox1.z < 0) {
				colAxis.x = -colAxis.x;
				colAxis.y = -colAxis.y;
				colAxis.z = -colAxis.z;
			}
			
			// Находим среднюю точку на каждом из пересекающихся рёбер 
			var halfLen1:Number;
			var halfLen2:Number;
			
			var tx:Number = box1.hs.x;
			var ty:Number = box1.hs.y;
			var tz:Number = box1.hs.z;
			
			var x2:Number = box2.hs.x;
			var y2:Number = box2.hs.y;
			var z2:Number = box2.hs.z;
			// x
			if (axisIdx1 == 0) {
				tx = 0;
				halfLen1 = box1.hs.x;
			} else {
				if (colAxis.x*transform1.a + colAxis.y*transform1.e + colAxis.z*transform1.i > 0) {
					tx = -tx;
				}
			}
			if (axisIdx2 == 0) {
				x2 = 0;
				halfLen2 = box2.hs.x;
			} else {
				if (colAxis.x*transform2.a + colAxis.y*transform2.e + colAxis.z*transform2.i < 0) {
					x2 = -x2;
				}
			}
			// y
			if (axisIdx1 == 1) {
				ty = 0;
				halfLen1 = box1.hs.y;
			} else {
				if (colAxis.x*transform1.b + colAxis.y*transform1.f + colAxis.z*transform1.j > 0) {
					ty = -ty;
				}
			}
			if (axisIdx2 == 1) {
				y2 = 0;
				halfLen2 = box2.hs.y;
			} else {
				if (colAxis.x*transform2.b + colAxis.y*transform2.f + colAxis.z*transform2.j < 0) {
					y2 = -y2;
				}
			}
			// z
			if (axisIdx1 == 2) {
				tz = 0;
				halfLen1 = box1.hs.z;
			} else {
				if (colAxis.x*transform1.c + colAxis.y*transform1.g + colAxis.z*transform1.k > 0) {
					tz = -tz;
				}
			}
			if (axisIdx2 == 2) {
				z2 = 0;
				halfLen2 = box2.hs.z;
			} else {
				if (colAxis.x*transform2.c + colAxis.y*transform2.g + colAxis.z*transform2.k < 0) {
					z2 = -z2;
				}
			}
			// Получаем глобальные координаты средних точек рёбер
			var x1:Number = transform1.a*tx + transform1.b*ty + transform1.c*tz + transform1.d;
			var y1:Number = transform1.e*tx + transform1.f*ty + transform1.g*tz + transform1.h;
			var z1:Number = transform1.i*tx + transform1.j*ty + transform1.k*tz + transform1.l;
			tx = x2;
			ty = y2;
			tz = z2;
			x2 = transform2.a*tx + transform2.b*ty + transform2.c*tz + transform2.d;
			y2 = transform2.e*tx + transform2.f*ty + transform2.g*tz + transform2.h;
			z2 = transform2.i*tx + transform2.j*ty + transform2.k*tz + transform2.l;
			
			// Находим точку пересечения рёбер, решая систему уравнений
			k = axis10.x*axis20.x + axis10.y*axis20.y + axis10.z*axis20.z;
			var det:Number = k*k - 1;
			tx = x2 - x1;
			ty = y2 - y1;
			tz = z2 - z1;
			var c1:Number = axis10.x*tx + axis10.y*ty + axis10.z*tz;
			var c2:Number = axis20.x*tx + axis20.y*ty + axis20.z*tz;
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;
			// Запись данных о столкновении
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			var cpPos:Vector3 = cp.pos;
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			cp.pos.x = 0.5*(x1 + axis10.x*t1 + x2 + axis20.x*t2);
			cp.pos.y = 0.5*(y1 + axis10.y*t1 + y2 + axis20.y*t2);
			cp.pos.z = 0.5*(z1 + axis10.z*t1 + z2 + axis20.z*t2);
			var r:Vector3 = cp.r1;
			r.x = cpPos.x - transform1.d;
			r.y = cpPos.y - transform1.h;
			r.z = cpPos.z - transform1.l;
			r = cp.r2;
			r.x = cpPos.x - transform2.d;
			r.y = cpPos.y - transform2.h;
			r.z = cpPos.z - transform2.l;
			cp.penetration = minOverlap;
		}
		
		/**
		 * Проверяет пересечение боксов вдоль заданной оси. При наличии пересечения сохраняется глубина пересечения, если она минимальна.
		 * 
		 * @param box1
		 * @param box2
		 * @param axis
		 * @param axisIndex
		 * @param toBox1
		 * @param bestAxis
		 * @return true в случае, если проекции боксов на заданную ось пересекаются, иначе false
		 */
		private function testMainAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, axisIndex:int, toBox1:Vector3):Boolean {
			var overlap:Number = overlapOnAxis(box1, box2, axis, toBox1);
			if (overlap < -epsilon)	return false;
			if (overlap + epsilon < minOverlap) {
				minOverlap = overlap;
				bestAxisIndex = axisIndex;
			}
			return true;
		}

		/**
		 * 
		 * @param box1
		 * @param box2
		 * @param axis1
		 * @param axis2
		 * @param axisIndex
		 * @param toBox1
		 * @return 
		 */
		private function testDerivedAxis(box1:CollisionBox, box2:CollisionBox, axis1:Vector3, axis2:Vector3, axisIndex:int, toBox1:Vector3):Boolean {
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
			var overlap:Number = overlapOnAxis(box1, box2, axis, toBox1);
			if (overlap < -epsilon)	return false;
			if (overlap + epsilon < minOverlap) {
				minOverlap = overlap;
				bestAxisIndex = axisIndex;
			}
			return true;
		}
		
		/**
		 * Вычисляет глубину перекрытия двух боксов вдоль заданной оси.
		 * 
		 * @param box1 первый бокс
		 * @param box2 второй бокс
		 * @param axis ось
		 * @param vectorToBox1 вектор, соединяющий центр второго бокса с центром первого
		 * @return величина перекрытия боксов вдоль оси 
		 */
		public function overlapOnAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, vectorToBox1:Vector3):Number {
			var m:Matrix4 = box1.transform;
			var d:Number = (m.a*axis.x + m.e*axis.y + m.i*axis.z)*box1.hs.x;
			if (d < 0) d = -d;
			var projection:Number = d;
			d = (m.b*axis.x + m.f*axis.y + m.j*axis.z)*box1.hs.y;
			if (d < 0) d = -d;
			projection += d;
			d = (m.c*axis.x + m.g*axis.y + m.k*axis.z)*box1.hs.z;
			if (d < 0) d = -d;
			projection += d;

			m = box2.transform;
			d = (m.a*axis.x + m.e*axis.y + m.i*axis.z)*box2.hs.x;
			if (d < 0) d = -d;
			projection += d;
			d = (m.b*axis.x + m.f*axis.y + m.j*axis.z)*box2.hs.y;
			if (d < 0) d = -d;
			projection += d;
			d = (m.c*axis.x + m.g*axis.y + m.k*axis.z)*box2.hs.z;
			if (d < 0) d = -d;
			projection += d;
			
			d = vectorToBox1.x*axis.x + vectorToBox1.y*axis.y + vectorToBox1.z*axis.z;
			if (d < 0) d = -d;
			
			return projection - d;
		}
		
	}
}
	import alternativa.physics.types.Vector3;
	
	class CollisionPointTmp {
		
		public var pos:Vector3 = new Vector3();
		public var penetration:Number;
		
		public var feature1:int;
		public var feature2:int;
	}
