package alternativa.physics.collision {
	import __AS3__.vec.Vector;
	
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionTriangle;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactPoint;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;

	/**
	 * 
	 */
	public class BoxTriangleCollider implements ICollider {
		
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
		public function getContact(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			var tri:CollisionTriangle = prim1 as CollisionTriangle;
			var box:CollisionBox;
			if (tri == null) {
				box = CollisionBox(prim1);
				tri = CollisionTriangle(prim2);
			} else {
				box = CollisionBox(prim2);
			}
			
			var mTri:Matrix4 = tri.transform;
			var mBox:Matrix4 = box.transform;
			
			toBox.x = mBox.d - mTri.d;
			toBox.y = mBox.h - mTri.h;
			toBox.z = mBox.l - mTri.l;
			
			minOverlap = 1e308;
			
			// Сначала проверяется нормаль треугольника
			axis.x = mTri.d;
			axis.y = mTri.h;
			axis.z = mTri.l;
			if (!testAxis(box, tri, axis, 0, toBox)) return false;
			
			// Проверка основных осей бокса
			axis10.x = mBox.a;
			axis10.y = mBox.e;
			axis10.z = mBox.i;
			if (!testAxis(box, tri, axis10, 1, toBox)) return false;
			axis11.x = mBox.b;
			axis11.y = mBox.f;
			axis11.z = mBox.j;
			if (!testAxis(box, tri, axis11, 2, toBox)) return false;
			axis12.x = mBox.c;
			axis12.y = mBox.g;
			axis12.z = mBox.k;
			if (!testAxis(box, tri, axis10, 3, toBox)) return false;
			
			// Проверка производных осей
			// TODO: заменить вычисления векторных произведений инлайнами
			var v:Vector3 = tri.e0;
			axis20.x = mTri.a*v.x + mTri.b*v.y + mTri.c*v.z;
			axis20.y = mTri.e*v.x + mTri.f*v.y + mTri.g*v.z;
			axis20.z = mTri.i*v.x + mTri.j*v.y + mTri.k*v.z;
			if (!testAxis(box, tri, axis.vCross2(axis10, axis20), 4, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis11, axis20), 5, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis12, axis20), 6, toBox)) return false;

			v = tri.e1;
			axis21.x = mTri.a*v.x + mTri.b*v.y + mTri.c*v.z;
			axis21.y = mTri.e*v.x + mTri.f*v.y + mTri.g*v.z;
			axis21.z = mTri.i*v.x + mTri.j*v.y + mTri.k*v.z;
			if (!testAxis(box, tri, axis.vCross2(axis10, axis21), 7, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis11, axis21), 8, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis12, axis21), 9, toBox)) return false;
			 
			v = tri.e2;
			axis22.x = mTri.a*v.x + mTri.b*v.y + mTri.c*v.z;
			axis22.y = mTri.e*v.x + mTri.f*v.y + mTri.g*v.z;
			axis22.z = mTri.i*v.x + mTri.j*v.y + mTri.k*v.z;
			if (!testAxis(box, tri, axis.vCross2(axis10, axis22), 10, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis11, axis22), 11, toBox)) return false;
			if (!testAxis(box, tri, axis.vCross2(axis12, axis22), 12, toBox)) return false;
			
			if (bestAxisIndex < 4) {
				// Контакт вдоль одной из основных осей
				if (!findFaceContactPoints(box, tri, toBox, bestAxisIndex, contact)) return false;
			} else {
				// Контакт ребро-ребро
				bestAxisIndex -= 4;
				findEdgesIntersection(box, tri, toBox, bestAxisIndex%3, int(bestAxisIndex/3), contact);
			}
			
			contact.body1 = box.body;
			contact.body2 = tri.body;
			
			return true;
		}
		
		/**
		 * Выполняет быстрый тест на наличие пересечения двух примитивов.
		 * 
		 * @param prim1 первый примитив
		 * @param prim2 второй примитив
		 * @return true, если пересечение существует, иначе false
		 */
		public function haveCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
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
		private function testAxis(box:CollisionBox, tri:CollisionTriangle, axis:Vector3, axisIndex:int, toBox:Vector3):Boolean {
			var len:Number = axis.x*axis.x + axis.y*axis.y + axis.z*axis.z;
			if (len < 0.0001) return true;
			len = 1/Math.sqrt(len);
			axis.x *= len;
			axis.y *= len;
			axis.z *= len;
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
				getBoxToTriContact(box, tri, toBox, contact);
			} else {
				// Столкновение с гранью бокса
				getTriToBoxContact(box, tri, toBox, faceAxisIndex, contact);
			}
			return true;
		}
		
		/**
		 * 
		 * @param box
		 * @param tri
		 * @param toBox
		 * @param contact
		 */
		private function getBoxToTriContact(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, contact:Contact):void {
			tri.transform.getAxis(2, colNormal);
			var over:Boolean = toBox.vDot(colNormal) > 0;
			if (!over) colNormal.vReverse();
			// Ищем ось бокса, определяющую наиболее антипараллельную грань
			var incFaceAxisIdx:int = 0;
			var incAxisDot:Number = 0;
			var maxDot:Number = 0;
			for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
				box.transform.getAxis(axisIdx, axis);
				var dot:Number = axis.vDot(colNormal);
				var absDot:Number = dot < 0 ? -dot : dot;
				if (absDot > maxDot) {
					maxDot = absDot;
					incAxisDot = dot;
					incFaceAxisIdx = axisIdx;
				}
			}
			// Обрезка грани
			var negativeFace:Boolean = incAxisDot > 0;
			getFaceVertsByAxis(box.hs, incFaceAxisIdx, negativeFace, points1);
			box.transform.transformVectorsN(points1, points2, 4);
			tri.transform.transformVectorsInverseN(points2, points1, 4);
			var pnum:int = clipByTriangle(tri);
			// Среди конечного списка точек определяются лежащие под плоскостью треугольника
			var cp:ContactPoint;
			contact.pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				var v:Vector3 = points2[i];
				if ((over && v.z < 0) || (!over && v.z > 0)) {
					cp = contact.points[contact.pcount++];
					var cpPos:Vector3 = cp.pos;
					tri.transform.transformVector(v, cpPos);
					var r:Vector3 = cp.r1;
					r.x = cpPos.x - box.transform.d;
					r.y = cpPos.y - box.transform.h;
					r.z = cpPos.z - box.transform.l;
					r = cp.r2;
					r.x = cpPos.x - tri.transform.d;
					r.y = cpPos.y - tri.transform.h;
					r.z = cpPos.z - tri.transform.l;
					cp.penetration = over ? -v.z : v.z;
				}
			}
			if (contact.pcount > 0) {
				contact.normal.vCopy(colNormal);
			}
		}
		
		/**
		 * 
		 * @param box
		 * @param tri
		 * @param toBox
		 * @param faceAxisIndex
		 * @param contact
		 */
		private function getTriToBoxContact(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, faceAxisIdx:int, contact:Contact):void {
			faceAxisIdx--;
			box.transform.getAxis(faceAxisIdx, colNormal);
			var negativeFace:Boolean = colNormal.vDot(toBox) > 0;
			if (!negativeFace) {
				colNormal.vReverse();
			}
			Vector3(points1[0]).vCopy(tri.v0);
			Vector3(points1[1]).vCopy(tri.v1);
			Vector3(points1[2]).vCopy(tri.v2);
			tri.transform.transformVectorsN(points1, points2, 3);
			box.transform.transformVectorsInverseN(points2, points1, 3);
			var pnum:int = clipByBox(box.hs, faceAxisIdx);
			// Проверяем каждую потенциальную точку на принадлежность боксу и добавляем такие точки в список контактов
			var pen:Number;
			contact.pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				var v:Vector3 = points1[i];
				pen = getPointBoxPenetration(box.hs, v, faceAxisIdx, negativeFace);
				if (pen > -epsilon) {
					var cp:ContactPoint = contact.points[contact.pcount++];
					var cpPos:Vector3 = cp.pos;
					box.transform.transformVector(v, cp.pos);
					var r:Vector3 = cp.r1;
					r.x = cpPos.x - box.transform.d;
					r.y = cpPos.y - box.transform.h;
					r.z = cpPos.z - box.transform.l;
					r = cp.r2;
					r.x = cpPos.x - tri.transform.d;
					r.y = cpPos.y - tri.transform.h;
					r.z = cpPos.z - tri.transform.l;
					cp.penetration = pen;
				}
			}
			contact.normal.vCopy(colNormal);
		}

		/**
		 * 
		 * @param hs
		 * @param p
		 * @param axisIndex
		 * @param reverse
		 * @return 
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
			var pnum:int = 4;
			switch (faceAxisIdx) {
				case 0:
					if ((pnum = clipLowZ(-hs.z, pnum, points1, points2)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, points2, points1)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, points1, points2)) == 0) return 0;
					return clipHighY(hs.y, pnum, points2, points1);
				case 1:
					if ((pnum = clipLowZ(-hs.z, pnum, points1, points2)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, points2, points1)) == 0) return 0;
					if ((pnum = clipLowX(-hs.x, pnum, points1, points2)) == 0) return 0;
					return clipHighX(hs.x, pnum, points2, points1);
				case 2:
					if ((pnum = clipLowX(-hs.x, pnum, points1, points2)) == 0) return 0;
					if ((pnum = clipHighX(hs.x, pnum, points2, points1)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, points1, points2)) == 0) return 0;
					return clipHighY(hs.y, pnum, points2, points1);
			}
			return 0;
		}

		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipLowX(x:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var x1:Number = x - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.x > x1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.x < x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.x > x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}

		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipHighX(x:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var x1:Number = x + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.x < x1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.x > x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.x < x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}
		
		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipLowY(y:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var y1:Number = y - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.y > y1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.y < y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.y > y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}
		
		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipHighY(y:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var y1:Number = y + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.y < y1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.y > y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.y < y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}

		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipLowZ(z:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var z1:Number = z - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.z > z1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.z < z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.z > z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}

		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		private function clipHighZ(z:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>):int {
			var z1:Number = z + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.z < z1) {
					Vector3(result[num++]).vCopy(p1);
					if (p2.z > z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.z < z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					Vector3(result[num++]).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
		}

		/**
		 * Формирует список вершин грани бокса, заданной нормальной к грани осью. Вершины перечисляются против часовой стрелки.
		 * 
		 * @param box бокс, в котором ишутся вершины 
		 * @param axisIdx индекс нормальной оси
		 * @param negativeFace если указано значение true, возвращаются вершины противоположной грани
		 * @param result список, в который помещаются вершины
		 */
		private function getFaceVertsByAxis(hs:Vector3, axisIdx:int, negativeFace:Boolean, result:Vector.<Vector3>):void {
			switch (axisIdx) {
				case 0:
					if (negativeFace) {
						Vector3(result[0]).vReset(-hs.x, hs.y, -hs.z);
						Vector3(result[1]).vReset(-hs.x, -hs.y, -hs.z);
						Vector3(result[2]).vReset(-hs.x, -hs.y, hs.z);
						Vector3(result[3]).vReset(-hs.x, hs.y, hs.z);
					} else {
						Vector3(result[0]).vReset(hs.x, -hs.y, -hs.z);
						Vector3(result[1]).vReset(hs.x, hs.y, -hs.z);
						Vector3(result[2]).vReset(hs.x, hs.y, hs.z);
						Vector3(result[3]).vReset(hs.x, -hs.y, hs.z);
					}
					break;
				case 1:
					if (negativeFace) {
						Vector3(result[0]).vReset(-hs.x, -hs.y, -hs.z);
						Vector3(result[1]).vReset(hs.x, -hs.y, -hs.z);
						Vector3(result[2]).vReset(hs.x, -hs.y, hs.z);
						Vector3(result[3]).vReset(-hs.x, -hs.y, hs.z);
					} else {
						Vector3(result[0]).vReset(hs.x, hs.y, -hs.z);
						Vector3(result[1]).vReset(-hs.x, hs.y, -hs.z);
						Vector3(result[2]).vReset(-hs.x, hs.y, hs.z);
						Vector3(result[3]).vReset(hs.x, hs.y, hs.z);
					}
					break;
				case 2:
					if (negativeFace) {
						Vector3(result[0]).vReset(-hs.x, hs.y, -hs.z);
						Vector3(result[1]).vReset(hs.x, hs.y, -hs.z);
						Vector3(result[2]).vReset(hs.x, -hs.y, -hs.z);
						Vector3(result[3]).vReset(-hs.x, -hs.y, -hs.z);
					} else {
						Vector3(result[0]).vReset(-hs.x, -hs.y, hs.z);
						Vector3(result[1]).vReset(hs.x, -hs.y, hs.z);
						Vector3(result[2]).vReset(hs.x, hs.y, hs.z);
						Vector3(result[3]).vReset(-hs.x, hs.y, hs.z);
					}
					break;
			}
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
			var nx:Number = lineDir.y;
			var ny:Number = -lineDir.x;
			var offset:Number = linePoint.x*nx + linePoint.y*ny;
			var v1:Vector3 = verticesIn[vnum -1];
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
		private function findEdgesIntersection(box:CollisionBox, tri:CollisionTriangle, toBox:Vector3, boxAxisIdx:int, triAxisIdx:int, contact:Contact):void {
			box.transform.getAxis(boxAxisIdx, axis10);
			point1.vCopy(box.hs);
			var boxHalfLen:Number;
			// X
			if (boxAxisIdx == 0) {
				point1.x = 0;
				boxHalfLen = box.hs.x;
			} else {
				box.transform.getAxis(0, axis11);
				if (axis11.vDot(toBox) > 0) {
					point1.x = -point1.x;
				}
			}
			// Y
			if (boxAxisIdx == 1) {
				point1.y = 0;
				boxHalfLen = box.hs.y;
			} else {
				box.transform.getAxis(1, axis11);
				if (axis11.vDot(toBox) > 0) {
					point1.y = -point1.y;
				}
			}
			// Z
			if (boxAxisIdx == 2) {
				point1.z = 0;
				boxHalfLen = box.hs.z;
			} else {
				box.transform.getAxis(2, axis11);
				if (axis11.vDot(toBox) > 0) {
					point1.z = -point1.z;
				}
			}
			point1.vTransformBy4(box.transform);

			var triLen:Number;
			switch (triAxisIdx) {
				case 0:
					point2.vCopy(tri.v0);
					axis20.vCopy(tri.e0);
					triLen = tri.len0;
					break;
				case 1:
					point2.vCopy(tri.v1);
					axis20.vCopy(tri.e1);
					triLen = tri.len1;
					break;
				case 2:
					point2.vCopy(tri.v2);
					axis20.vCopy(tri.e2);
					triLen = tri.len2;
					break;
			}
			axis20.vDeltaTransformBy4(tri.transform);
			point2.vTransformBy4(tri.transform);

			colNormal.vCross2(axis10, axis20).vNormalize();
			// Разворот оси в сторону бокса
			if (colNormal.vDot(toBox) < 0) colNormal.vReverse();

			// Находим точку пересечения рёбер, решая систему уравнений
			// axis10 - направляющий вектор ребра бокса
			// point1 - средняя точка ребра бокса
			// axis20 - направляющий вектор ребра треугольника
			// point2 - начальная точка ребра треугольника
			var k:Number = axis10.vDot(axis20);
			var det:Number = k*k - 1;
			vector.vDiff(point2, point1);
			var c1:Number = axis10.vDot(vector);
			var c2:Number = axis20.vDot(vector);
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;
			// Запись данных о столкновении
			contact.normal.vCopy(colNormal);
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			var cpPos:Vector3 = cp.pos;
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			cpPos.x = 0.5*(point1.x + axis10.x*t1 + point2.x + axis20.x*t2);
			cpPos.y = 0.5*(point1.y + axis10.y*t1 + point2.y + axis20.y*t2);
			cpPos.z = 0.5*(point1.z + axis10.z*t1 + point2.z + axis20.z*t2);
			var r:Vector3 = cp.r1;
			r.x = cpPos.x - box.transform.d;
			r.y = cpPos.y - box.transform.h;
			r.z = cpPos.z - box.transform.l;
			r = cp.r2;
			r.x = cpPos.x - tri.transform.d;
			r.y = cpPos.y - tri.transform.h;
			r.z = cpPos.z - tri.transform.l;
			cp.penetration = minOverlap;
		}
		
	}
}