package alternativa.physics.collision {
	import alternativa.physics.altphysics;
	import alternativa.physics.collision.primitives.CollisionBox;
	import alternativa.physics.collision.primitives.CollisionPrimitive;
	import alternativa.physics.collision.primitives.CollisionRect;
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactPoint;
	import alternativa.physics.types.Matrix4;
	import alternativa.physics.types.Vector3;
	use namespace altphysics;

	public class BoxRectCollider implements ICollider {

		private var tolerance:Number = 0.001;
		
		private var bPos:Vector3 = new Vector3();
		private var rPos:Vector3 = new Vector3();

		private var vectorToBox:Vector3 = new Vector3();
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

		/**
		 * 
		 */		
		public function BoxRectCollider() {
			for (var i:int = 0; i < 8; i++) {
				verts1[i] = new Vector3();
				verts2[i] = new Vector3();
			}
		}

		/**
		 * @param prim1
		 * @param prim2
		 * @param contact
		 * @return 
		 */
		public function collide(prim1:CollisionPrimitive, prim2:CollisionPrimitive, contact:Contact):Boolean {
			minOverlap = 1e10;
			var box:CollisionBox = prim1 as CollisionBox;
			var rect:CollisionRect;
			if (box == null) {
				box = prim2 as CollisionBox;
				rect = prim1 as CollisionRect;
			} else {
				rect = prim2 as CollisionRect;
			}

			// Вектор из центра прямоугольника в центр бокса
			box.transform.getAxis(3, bPos);
			rect.transform.getAxis(3, rPos);
			vectorToBox.vDiff(bPos, rPos);
			
			// Проверка пересечения по нормали прямоугольника
			rect.transform.getAxis(2, axis22);
			if (!testAxis(box, rect, axis22, 0, vectorToBox)) return false;

			// Проверка пересечения по основным осям бокса
			box.transform.getAxis(0, axis10);
			if (!testAxis(box, rect, axis10, 1, vectorToBox)) return false;
			box.transform.getAxis(1, axis11);
			if (!testAxis(box, rect, axis11, 2, vectorToBox)) return false;
			box.transform.getAxis(2, axis12);
			if (!testAxis(box, rect, axis12, 3, vectorToBox)) return false;

			// Получаем направляющие рёбер прямоугольника
			rect.transform.getAxis(0, axis20);
			rect.transform.getAxis(1, axis21);
			
			// Проверка производных осей
			if (!testAxis(box, rect, axis.vCross2(axis10, axis20), 4, vectorToBox)) return false;
			if (!testAxis(box, rect, axis.vCross2(axis10, axis21), 5, vectorToBox)) return false;
			
			if (!testAxis(box, rect, axis.vCross2(axis11, axis20), 6, vectorToBox)) return false;
			if (!testAxis(box, rect, axis.vCross2(axis11, axis21), 7, vectorToBox)) return false;

			if (!testAxis(box, rect, axis.vCross2(axis12, axis20), 8, vectorToBox)) return false;
			if (!testAxis(box, rect, axis.vCross2(axis12, axis21), 9, vectorToBox)) return false;
			
			if (bestAxisIndex < 4) {
				// Контакт вдоль одной из основных осей
				if (!findFaceContactPoints(box, rect, vectorToBox, bestAxisIndex, contact)) return false;
			} else {
				// Контакт ребро-ребро
				bestAxisIndex -= 4;
				findEdgesIntersection(box, rect, vectorToBox, int(bestAxisIndex/2), bestAxisIndex%2, contact);
			}
			contact.body1 = box.body;
			contact.body2 = rect.body;

			return true;
		}
		
		/**
		 * @param prim1
		 * @param prim2
		 * @return 
		 */
		public function testCollision(prim1:CollisionPrimitive, prim2:CollisionPrimitive):Boolean {
			return false;
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
		private function findFaceContactPoints(box:CollisionBox, rect:CollisionRect, vectorToBox:Vector3, faceAxisIdx:int, colInfo:Contact):Boolean {
			var pnum:int, i:int, v:Vector3, cp:ContactPoint;
			if (faceAxisIdx == 0) {
				// Столкновение с плоскостью прямоугольника

				// Проверим положение бокса относительно плоскости прямоугольника
				rect.transform.getAxis(2, colAxis);
				var offset:Number = colAxis.vDot(rPos);
				if (bPos.vDot(colAxis) < offset) return false;

				// Ищем ось бокса, определяющую наиболее антипараллельную грань
				var incFaceAxisIdx:int = 0;
				var maxDot:Number = 0;
				for (var axisIdx:int = 0; axisIdx < 3; axisIdx++) {
					box.transform.getAxis(axisIdx, axis);
					var dot:Number = axis.vDot(colAxis);
					if (dot < 0) dot = -dot;
					if (dot > maxDot) {
						maxDot = dot;
						incFaceAxisIdx = axisIdx;
					}
				}
				// Получаем список вершин грани бокса, переводим их в систему координат прямоугольника и выполняем обрезку
				// по прямоугольнику. Таким образом получается список потенциальных точек контакта.
				box.transform.getAxis(incFaceAxisIdx, axis);
				getFaceVertsByAxis(box.hs, incFaceAxisIdx, axis.vDot(colAxis) > 0, verts1);
				box.transform.transformVectors(verts1, verts2);
				rect.transform.transformVectorsInverse(verts2, verts1);
				pnum = clipByRect(rect.hs);
				// Проверяем каждую потенциальную точку на принадлежность нижней полуплоскости прямоугольника и добавляем такие точки в список контактов
				colInfo.pcount = 0;
				for (i = 0; i < pnum; i++) {
					v = verts1[i];
					if (v.z < tolerance) {
						cp = colInfo.points[colInfo.pcount++];
						rect.transform.transformVector(v, cp.pos);
						cp.r1.vDiff(cp.pos, bPos);
						cp.r2.vDiff(cp.pos, rPos);
						cp.penetration = -v.z;
					}
				}
				colInfo.normal.vCopy(colAxis);
			} else {
				// Столкновение с гранью бокса
				faceAxisIdx--;
				box.transform.getAxis(faceAxisIdx, colAxis);
				var faceReversed:Boolean = colAxis.vDot(vectorToBox) > 0;
				if (!faceReversed) colAxis.vReverse();
				
				rect.transform.getAxis(2, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) return false;
				
				getFaceVertsByAxis(rect.hs, 2, false, verts1);
				rect.transform.transformVectors(verts1, verts2);
				box.transform.transformVectorsInverse(verts2, verts1);
				pnum = clipByBox(box.hs, faceAxisIdx);
				// Проверяем каждую потенциальную точку на принадлежность первому боксу и добавляем такие точки в список контактов
				var pen:Number;
				colInfo.pcount = 0;
				for (i = 0; i < pnum; i++) {
					if ((pen = getPointBoxPenetration(box.hs, verts1[i], faceAxisIdx, faceReversed)) > -tolerance) {
						cp = colInfo.points[colInfo.pcount++];
						box.transform.transformVector(verts1[i], cp.pos);
						cp.r1.vDiff(cp.pos, bPos);
						cp.r2.vDiff(cp.pos, rPos);
						cp.penetration = pen;
					}
				}
				colInfo.normal.vCopy(colAxis);
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
		 * Формирует список вершин грани бокса, заданной нормальной к грани осью. Вершины перечисляются против часовой стрелки.
		 * 
		 * @param box бокс, в котором ишутся вершины 
		 * @param axisIdx индекс нормальной оси
		 * @param reverse если указано значение true, возвращаются вершины противоположной грани
		 * @param result список, в который помещаются вершины
		 */
		private function getFaceVertsByAxis(hs:Vector3, axisIdx:int, reverse:Boolean, result:Vector.<Vector3>):void {
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
		private function clipByBox(hs:Vector3, faceAxisIdx:int):int {
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
		 * @param hs
		 * @return 
		 */
		private function clipByRect(hs:Vector3):int {
			var pnum:int = 4;
			if ((pnum = clipLowX(-hs.x, pnum, verts1, verts2)) == 0) return 0;
			if ((pnum = clipHighX(hs.x, pnum, verts2, verts1)) == 0) return 0;
			if ((pnum = clipLowY(-hs.y, pnum, verts1, verts2)) == 0) return 0;
			return clipHighY(hs.y, pnum, verts2, verts1);
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
		 * @param box первый бокс
		 * @param rect второй бокс
		 * @param vectorToBox1 вектор, направленный из центра второго бокса в центр первого
		 * @param axisIdx1 индекс направляющей оси ребра первого бокса
		 * @param axisIdx2 индекс направляющей оси ребра второго бокса
		 * @param colInfo структура, в которую записывается информация о столкновении
		 */
		private function findEdgesIntersection(box:CollisionBox, rect:CollisionRect, vectorToBox:Vector3, axisIdx1:int, axisIdx2:int, colInfo:Contact):void {
			box.transform.getAxis(axisIdx1, axis10);
			rect.transform.getAxis(axisIdx2, axis20);
			colAxis.vCross2(axis10, axis20).vNormalize();
			// Разворот оси в сторону бокса
			if (colAxis.vDot(vectorToBox) < 0) colAxis.vReverse();
			
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
			point1.vCopy(box.hs);
			point2.vCopy(rect.hs);
			// x
			if (axisIdx1 == 0) {
				point1.x = 0;
				halfLen1 = box.hs.x;
			} else {
				box.transform.getAxis(0, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.x = -point1.x;
					edgeCode1 |= 8; // 1 << 3
				}
			}
			if (axisIdx2 == 0) {
				point2.x = 0;
				halfLen2 = rect.hs.x;
			} else {
				rect.transform.getAxis(0, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) {
					point2.x = -point2.x;
					edgeCode2 |= 8; // 1 << 3
				}
			}
			// y
			if (axisIdx1 == 1) {
				point1.y = 0;
				halfLen1 = box.hs.y;
				edgeCode1 |= 2; // 1 << 1
			} else {
				box.transform.getAxis(1, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.y = -point1.y;
					edgeCode1 |= 16; // 1 << 4
				}
			}
			if (axisIdx2 == 1) {
				point2.y = 0;
				halfLen2 = rect.hs.y;
				edgeCode2 |= 2; // 1 << 1
			} else {
				rect.transform.getAxis(1, tmpAxis);
				if (tmpAxis.vDot(colAxis) < 0) {
					point2.y = -point2.y;
					edgeCode2 |= 16; // 1 << 4
				}
			}
			// z
			if (axisIdx1 == 2) {
				point1.z = 0;
				halfLen1 = box.hs.z;
				edgeCode1 |= 4; // 2 << 1
			} else {
				box.transform.getAxis(2, tmpAxis);
				if (tmpAxis.vDot(colAxis) > 0) {
					point1.z = -point1.z;
					edgeCode1 |= 32; // 1 << 5
				}
			}
			// Получаем глобальные координаты средних точек рёбер
			point1.vTransformBy4(box.transform);
			point2.vTransformBy4(rect.transform);
			// Находим точку пересечения рёбер, решая систему уравнений
			var k:Number = axis10.vDot(axis20);
			var det:Number = k*k - 1;
			vector.vDiff(point2, point1);
			var c1:Number = axis10.vDot(vector);
			var c2:Number = axis20.vDot(vector);
			var t1:Number = (c2*k - c1)/det;
			var t2:Number = (c2 - c1*k)/det;
			// Запись данных о столкновении
			colInfo.normal.vCopy(colAxis);
			colInfo.pcount = 1;
			var cp:ContactPoint = colInfo.points[0];
			// Точка столкновения вычисляется как среднее между ближайшими точками на рёбрах
			cp.pos.x = 0.5*(point1.x + axis10.x*t1 + point2.x + axis20.x*t2);
			cp.pos.y = 0.5*(point1.y + axis10.y*t1 + point2.y + axis20.y*t2);
			cp.pos.z = 0.5*(point1.z + axis10.z*t1 + point2.z + axis20.z*t2);
			cp.r1.vDiff(cp.pos, bPos);
			cp.r2.vDiff(cp.pos, rPos);
			cp.penetration = minOverlap;
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
		private function testAxis(box:CollisionBox, rect:CollisionRect, axis:Vector3, axisIndex:int, vectorToBox:Vector3):Boolean {
			if (axis.vLengthSqr() < 0.0001) return true;
			axis.vNormalize();

			var overlap:Number = overlapOnAxis(box, rect, axis, vectorToBox);
			if (overlap < -tolerance)	return false;
			if (overlap + tolerance < minOverlap) {
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