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
	public class BoxBoxCollider implements ICollider {
		
		private var tolerance:Number = 0.001;
		
		private var pos1:Vector3 = new Vector3();
		private var pos2:Vector3 = new Vector3();
		private var vectorToBox1:Vector3 = new Vector3();
		private var axis:Vector3 = new Vector3();
		private var axis10:Vector3 = new Vector3();
		private var axis11:Vector3 = new Vector3();
		private var axis12:Vector3 = new Vector3();
		private var axis20:Vector3 = new Vector3();
		private var axis21:Vector3 = new Vector3();
		private var axis22:Vector3 = new Vector3();
		private var colAxis:Vector3 = new Vector3();
		private var tmpAxis:Vector3 = new Vector3();
		private var vector:Vector3 = new Vector3();
		private var point1:Vector3 = new Vector3();
		private var point2:Vector3 = new Vector3();
		
		private var bestAxisIndex:int;
		private var minOverlap:Number;
		
		private var verts1:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var verts2:Vector.<Vector3> = new Vector.<Vector3>(8, true);
		private var tmpPoints:Vector.<ContactPoint> = new Vector.<ContactPoint>(8, true);
		private var pcount:int;
		
		/**
		 * 
		 */
		public function BoxBoxCollider() {
			for (var i:int = 0; i < 8; i++) {
				tmpPoints[i] = new ContactPoint();
				verts1[i] = new Vector3();
				verts2[i] = new Vector3();
			}
		}

		/**
		 * 
		 * @param body1
		 * @param body2
		 * @param contactInfo
		 * @return 
		 */
		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
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
			pos1.x = transform1.d; pos1.y = transform1.h; pos1.z = transform1.l;
			pos2.x = transform2.d; pos2.y = transform2.h; pos2.z = transform2.l;
			vectorToBox1.x = pos1.x - pos2.x;
			vectorToBox1.y = pos1.y - pos2.y;
			vectorToBox1.z = pos1.z - pos2.z;
			
			// Проверка пересечения по основным осям
//			box1.transform.getAxis(0, axis10);
			axis10.x = transform1.a; axis10.y = transform1.e; axis10.z = transform1.i;
			if (!testAxis(box1, box2, axis10, 0, vectorToBox1)) return false;
//			box1.transform.getAxis(1, axis11);
			axis11.x = transform1.b; axis11.y = transform1.f; axis11.z = transform1.j;
			if (!testAxis(box1, box2, axis11, 1, vectorToBox1)) return false;
//			box1.transform.getAxis(2, axis12);
			axis12.x = transform1.c; axis12.y = transform1.g; axis12.z = transform1.k;
			if (!testAxis(box1, box2, axis12, 2, vectorToBox1)) return false;
			
//			box2.transform.getAxis(0, axis20);
			axis20.x = transform2.a; axis20.y = transform2.e; axis20.z = transform2.i;
			if (!testAxis(box1, box2, axis20, 3, vectorToBox1)) return false;
//			box2.transform.getAxis(1, axis21);
			axis21.x = transform2.b; axis21.y = transform2.f; axis21.z = transform2.j;
			if (!testAxis(box1, box2, axis21, 4, vectorToBox1)) return false;
//			box2.transform.getAxis(2, axis22);
			axis22.x = transform2.c; axis22.y = transform2.g; axis22.z = transform2.k;
			if (!testAxis(box1, box2, axis22, 5, vectorToBox1)) return false;
			
			// Проверка производных осей
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis20), 6, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis21), 7, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis22), 8, vectorToBox1)) return false;
			
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis20), 9, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis21), 10, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis22), 11, vectorToBox1)) return false;

			if (!testAxis(box1, box2, axis.vCross2(axis12, axis20), 12, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis12, axis21), 13, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis12, axis22), 14, vectorToBox1)) return false;
			
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
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
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
			pos1.x = transform1.d; pos1.y = transform1.h; pos1.z = transform1.l;
			pos2.x = transform2.d; pos2.y = transform2.h; pos2.z = transform2.l;
			vectorToBox1.x = pos1.x - pos2.x;
			vectorToBox1.y = pos1.y - pos2.y;
			vectorToBox1.z = pos1.z - pos2.z;
			
			// Проверка пересечения по основным осям
			axis10.x = transform1.a; axis10.y = transform1.e; axis10.z = transform1.i;
			if (!testAxis(box1, box2, axis10, 0, vectorToBox1)) return false;
			axis11.x = transform1.b; axis11.y = transform1.f; axis11.z = transform1.j;
			if (!testAxis(box1, box2, axis11, 1, vectorToBox1)) return false;
			axis12.x = transform1.c; axis12.y = transform1.g; axis12.z = transform1.k;
			if (!testAxis(box1, box2, axis12, 2, vectorToBox1)) return false;
			
			axis20.x = transform2.a; axis20.y = transform2.e; axis20.z = transform2.i;
			if (!testAxis(box1, box2, axis20, 3, vectorToBox1)) return false;
			axis21.x = transform2.b; axis21.y = transform2.f; axis21.z = transform2.j;
			if (!testAxis(box1, box2, axis21, 4, vectorToBox1)) return false;
			axis22.x = transform2.c; axis22.y = transform2.g; axis22.z = transform2.k;
			if (!testAxis(box1, box2, axis22, 5, vectorToBox1)) return false;
			
			// Проверка производных осей
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis20), 6, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis21), 7, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis10, axis22), 8, vectorToBox1)) return false;
			
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis20), 9, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis21), 10, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis11, axis22), 11, vectorToBox1)) return false;

			if (!testAxis(box1, box2, axis.vCross2(axis12, axis20), 12, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis12, axis21), 13, vectorToBox1)) return false;
			if (!testAxis(box1, box2, axis.vCross2(axis12, axis22), 14, vectorToBox1)) return false;

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
		private function findFaceContactPoints(box1:CollisionBox, box2:CollisionBox, vectorToBox1:Vector3, faceAxisIdx:int, contactInfo:Contact):void {
			var swapNormal:Boolean = false;
			if (faceAxisIdx > 2) {
				// Столкновение с гранью второго бокса. Для дальнейших расчётов боксы меняются местами,
				// но нормаль контакта всё равно должна быть направлена в сторону первоначального box1
				var tmpBox:CollisionBox = box1;
				box1 = box2;
				box2 = tmpBox;
				vectorToBox1.vReverse();
				faceAxisIdx -= 3;
				swapNormal = true;
			}
			box1.transform.getAxis(faceAxisIdx, colAxis);
			var faceReversed:Boolean = colAxis.vDot(vectorToBox1) > 0;
			if (!faceReversed) colAxis.vReverse();
			// Ищем ось второго бокса, определяющую наиболее антипараллельную грань
			var incFaceAxisIdx:int = 0;
			var maxDot:Number = 0;
			for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
				box2.transform.getAxis(axisIdx, axis);
				var dot:Number = axis.vDot(colAxis);
				if (dot < 0) dot = -dot;
				if (dot > maxDot) {
					maxDot = dot;
					incFaceAxisIdx = axisIdx;
				}
			}
			// Получаем список вершин грани второго бокса, переводим их в систему координат первого бокса и выполняем обрезку
			// по грани первого бокса. Таким образом получается список потенциальных точек контакта.
			box2.transform.getAxis(incFaceAxisIdx, axis);
			getFaceVertsByAxis(box2, incFaceAxisIdx, axis.vDot(colAxis) < 0, verts1);
			box2.transform.transformVectors(verts1, verts2);
			box1.transform.transformVectorsInverse(verts2, verts1);
			var pnum:int = clip(box1.hs, faceAxisIdx);
			// Проверяем каждую потенциальную точку на принадлежность первому боксу и добавляем такие точки в список контактов
			var pen:Number;
			pcount = 0;
			for (var i:int = 0; i < pnum; i++) {
				if ((pen = getPointBoxPenetration(box1.hs, verts1[i], faceAxisIdx, faceReversed)) > -tolerance) {
					var cp:ContactPoint = tmpPoints[pcount++];
					box1.transform.transformVector(verts1[i], cp.pos);
					cp.r1.vDiff(cp.pos, pos1);
					cp.r2.vDiff(cp.pos, pos2);
					cp.penetration = pen;
				}
			}
			contactInfo.normal.vCopy(colAxis);
			if (swapNormal) contactInfo.normal.vReverse();
			
			if (pcount > 4) reducePoints();
			for (i = 0; i < pcount; i++) (contactInfo.points[i] as ContactPoint).copyFrom(tmpPoints[i]);
			contactInfo.pcount = pcount;
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
				var p1:Vector3 = (tmpPoints[pcount - 1] as ContactPoint).pos;
				var p2:Vector3;
				for (i = 0; i < pcount; i++) {
					p2 = (tmpPoints[i] as ContactPoint).pos;
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
					for (i = minIdx; i < pcount; i++) tmpPoints[i - 1] = tmpPoints[i];
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
		 * Формирует список вершин грани бокса, заданной нормальной к грани осью. Вершины перечисляются против часовой стрелки.
		 * 
		 * @param box бокс, в котором ишутся вершины 
		 * @param axisIdx индекс нормальной оси
		 * @param reverse если указано значение true, возвращаются вершины противоположной грани
		 * @param result список, в который помещаются вершины
		 */
		private function getFaceVertsByAxis(box:CollisionBox, axisIdx:int, reverse:Boolean, result:Vector.<Vector3>):void {
			var hs:Vector3 = box.hs;
			switch (axisIdx) {
				case 0:
					if (reverse) {
						(result[0] as Vector3).vReset(-hs.x, hs.y, -hs.z);
						(result[1] as Vector3).vReset(-hs.x, -hs.y, -hs.z);
						(result[2] as Vector3).vReset(-hs.x, -hs.y, hs.z);
						(result[3] as Vector3).vReset(-hs.x, hs.y, hs.z);
					} else {
						(result[0] as Vector3).vReset(hs.x, -hs.y, -hs.z);
						(result[1] as Vector3).vReset(hs.x, hs.y, -hs.z);
						(result[2] as Vector3).vReset(hs.x, hs.y, hs.z);
						(result[3] as Vector3).vReset(hs.x, -hs.y, hs.z);
					}
					break;
				case 1:
					if (reverse) {
						(result[0] as Vector3).vReset(-hs.x, -hs.y, -hs.z);
						(result[1] as Vector3).vReset(hs.x, -hs.y, -hs.z);
						(result[2] as Vector3).vReset(hs.x, -hs.y, hs.z);
						(result[3] as Vector3).vReset(-hs.x, -hs.y, hs.z);
					} else {
						(result[0] as Vector3).vReset(hs.x, hs.y, -hs.z);
						(result[1] as Vector3).vReset(-hs.x, hs.y, -hs.z);
						(result[2] as Vector3).vReset(-hs.x, hs.y, hs.z);
						(result[3] as Vector3).vReset(hs.x, hs.y, hs.z);
					}
					break;
				case 2:
					if (reverse) {
						(result[0] as Vector3).vReset(-hs.x, hs.y, -hs.z);
						(result[1] as Vector3).vReset(hs.x, hs.y, -hs.z);
						(result[2] as Vector3).vReset(hs.x, -hs.y, -hs.z);
						(result[3] as Vector3).vReset(-hs.x, -hs.y, -hs.z);
					} else {
						(result[0] as Vector3).vReset(-hs.x, -hs.y, hs.z);
						(result[1] as Vector3).vReset(hs.x, -hs.y, hs.z);
						(result[2] as Vector3).vReset(hs.x, hs.y, hs.z);
						(result[3] as Vector3).vReset(-hs.x, hs.y, hs.z);
					}
					break;
			}
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
					if ((pnum = clipLowZ(-hs.z, pnum, verts1, verts2)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, verts2, verts1)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, verts1, verts2)) == 0) return 0;
					return clipHighY(hs.y, pnum, verts2, verts1);
				case 1:
					if ((pnum = clipLowZ(-hs.z, pnum, verts1, verts2)) == 0) return 0;
					if ((pnum = clipHighZ(hs.z, pnum, verts2, verts1)) == 0) return 0;
					if ((pnum = clipLowX(-hs.x, pnum, verts1, verts2)) == 0) return 0;
					return clipHighX(hs.x, pnum, verts2, verts1);
				case 2:
					if ((pnum = clipLowX(-hs.x, pnum, verts1, verts2)) == 0) return 0;
					if ((pnum = clipHighX(hs.x, pnum, verts2, verts1)) == 0) return 0;
					if ((pnum = clipLowY(-hs.y, pnum, verts1, verts2)) == 0) return 0;
					return clipHighY(hs.y, pnum, verts2, verts1);
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
			var x1:Number = x - tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.x < x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.x > x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
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
			var x1:Number = x + tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.x > x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.x < x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
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
			var y1:Number = y - tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.y < y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.y > y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
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
			var y1:Number = y + tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.y > y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.y < y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
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
			var z1:Number = z - tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.z < z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.z > z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
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
			var z1:Number = z + tolerance;
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
					(result[num++] as Vector3).vCopy(p1);
					if (p2.z > z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
					}
				} else if (p2.z < z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					(result[num++] as Vector3).vReset(p1.x + t*dx, p1.y + t*dy, p1.z + t*dz);
				} 
				p1 = p2;
			}
			return num;
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
			box1.transform.getAxis(axisIdx1, axis10);
			box2.transform.getAxis(axisIdx2, axis20);
			colAxis.vCross2(axis10, axis20).vNormalize();
			// Разворот оси в сторону первого бокса
			if (colAxis.vDot(vectorToBox1) < 0) colAxis.vReverse();
			
			/* Кодирование рёбер
				бит 0: 1 (тип контакта ребро-ребро)
				биты 1-2: индекс направляющей оси ребра
				бит 3: 
				бит 4:
				бит 5:
			*/
			var edgeCode1:int = 1;
			var edgeCode2:int = 1;
			
			// Находим среднюю точку на каждом из пересекающихся рёбер 
			var halfLen1:Number;
			var halfLen2:Number;
			point1.vCopy(box1.hs);
			point2.vCopy(box2.hs);
			// x
			if (axisIdx1 == 0) {
				point1.x = 0;
				halfLen1 = box1.hs.x;
			} else {
				box1.transform.getAxis(0, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.x = -point1.x;
					edgeCode1 |= 8; // 1 << 3
				}
			}
			if (axisIdx2 == 0) {
				point2.x = 0;
				halfLen2 = box2.hs.x;
			} else {
				box2.transform.getAxis(0, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) {
					point2.x = -point2.x;
					edgeCode2 |= 8; // 1 << 3
				}
			}
			// y
			if (axisIdx1 == 1) {
				point1.y = 0;
				halfLen1 = box1.hs.y;
				edgeCode1 |= 2; // 1 << 1
			} else {
				box1.transform.getAxis(1, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.y = -point1.y;
					edgeCode1 |= 16; // 1 << 4
				}
			}
			if (axisIdx2 == 1) {
				point2.y = 0;
				halfLen2 = box2.hs.y;
				edgeCode2 |= 2; // 1 << 1
			} else {
				box2.transform.getAxis(1, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) {
					point2.y = -point2.y;
					edgeCode2 |= 16; // 1 << 4
				}
			}
			// z
			if (axisIdx1 == 2) {
				point1.z = 0;
				halfLen1 = box1.hs.z;
				edgeCode1 |= 4; // 2 << 1
			} else {
				box1.transform.getAxis(2, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.z = -point1.z;
					edgeCode1 |= 32; // 1 << 5
				}
			}
			if (axisIdx2 == 2) {
				point2.z = 0;
				halfLen2 = box2.hs.z;
				edgeCode2 |= 4; // 2 << 1
			} else {
				box2.transform.getAxis(2, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) {
					point2.z = -point2.z;
					edgeCode2 |= 32; // 1 << 5
				}
			}
			// Получаем глобальные координаты средних точек рёбер
			point1.vTransformBy4(box1.transform);
			point2.vTransformBy4(box2.transform);
			// Находим точку пересечения рёбер, решая систему уравнений
			var k:Number = axis10.vDot(axis20);
			var det:Number = k*k - 1;
			vector.vDiff(point2, point1);
			var c1:Number = axis10.vDot(vector);
			var c2:Number = axis20.vDot(vector);
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;
			// Запись данных о столкновении
			contact.normal.vCopy(colAxis);
			contact.pcount = 1;
			var cp:ContactPoint = contact.points[0];
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			cp.pos.x = 0.5*(point1.x + axis10.x*t1 + point2.x + axis20.x*t2);
			cp.pos.y = 0.5*(point1.y + axis10.y*t1 + point2.y + axis20.y*t2);
			cp.pos.z = 0.5*(point1.z + axis10.z*t1 + point2.z + axis20.z*t2);
			cp.r1.vDiff(cp.pos, pos1);
			cp.r2.vDiff(cp.pos, pos2);
			cp.penetration = minOverlap;
		}
		
		/**
		 * Проверяет пересечение боксов вдоль заданной оси. При наличии пересечения сохраняется глубина пересечения, если она минимальна.
		 * 
		 * @param box1
		 * @param box2
		 * @param axis
		 * @param axisIndex
		 * @param vectorToBox1
		 * @param bestAxis
		 * @return true в случае, если проекции боксов на заданную ось пересекаются, иначе false
		 */
		private function testAxis(box1:CollisionBox, box2:CollisionBox, axis:Vector3, axisIndex:int, vectorToBox1:Vector3):Boolean {
			if (axis.vLengthSqr() < 0.0001) {
				return true;
			}
			axis.vNormalize();
			
			var overlap:Number = overlapOnAxis(box1, box2, axis, vectorToBox1);
			if (overlap < -tolerance)	return false;
			if (overlap + tolerance < minOverlap) {
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
