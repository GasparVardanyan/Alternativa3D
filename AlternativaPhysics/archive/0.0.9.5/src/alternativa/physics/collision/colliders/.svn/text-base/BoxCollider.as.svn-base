package alternativa.physics.collision.colliders {
	
	
	import alternativa.physics.Contact;
	import alternativa.physics.collision.CollisionPrimitive;
	import alternativa.physics.collision.ICollider;
	import alternativa.math.Vector3;

	/**
	 * 
	 */
	public class BoxCollider implements ICollider {
		
		/**
		 * 
		 */
		public function BoxCollider() {
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
			return false;
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
		 * Формирует список вершин грани бокса, заданной нормальной к грани осью. Вершины перечисляются против часовой стрелки.
		 * 
		 * @param box бокс, в котором ишутся вершины 
		 * @param axisIdx индекс нормальной оси
		 * @param reverse если указано значение true, возвращаются вершины противоположной грани
		 * @param result список, в который помещаются вершины
		 */
		protected function getFaceVertsByAxis(hs:Vector3, axisIdx:int, negativeFace:Boolean, result:Vector.<Vector3>):void {
			var v:Vector3;
			switch (axisIdx) {
				case 0:
					if (negativeFace) {
						v = result[0]; v.x = -hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[1]; v.x = -hs.x; v.y = -hs.y; v.z = -hs.z;
						v = result[2]; v.x = -hs.x; v.y = -hs.y; v.z = hs.z;
						v = result[3]; v.x = -hs.x; v.y = hs.y; v.z = hs.z;
					} else {
						v = result[0]; v.x = hs.x; v.y = -hs.y; v.z = -hs.z;
						v = result[1]; v.x = hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[2]; v.x = hs.x; v.y = hs.y; v.z = hs.z;
						v = result[3]; v.x = hs.x; v.y = -hs.y; v.z = hs.z;
					}
					break;
				case 1:
					if (negativeFace) {
						v = result[0]; v.x = -hs.x; v.y = -hs.y; v.z = -hs.z;
						v = result[1]; v.x = hs.x; v.y = -hs.y; v.z = -hs.z;
						v = result[2]; v.x = hs.x; v.y = -hs.y; v.z = hs.z;
						v = result[3]; v.x = -hs.x; v.y = -hs.y; v.z = hs.z;
					} else {
						v = result[0]; v.x = hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[1]; v.x = -hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[2]; v.x = -hs.x; v.y = hs.y; v.z = hs.z;
						v = result[3]; v.x = hs.x; v.y = hs.y; v.z = hs.z;
					}
					break;
				case 2:
					if (negativeFace) {
						v = result[0]; v.x = -hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[1]; v.x = hs.x; v.y = hs.y; v.z = -hs.z;
						v = result[2]; v.x = hs.x; v.y = -hs.y; v.z = -hs.z;
						v = result[3]; v.x = -hs.x; v.y = -hs.y; v.z = -hs.z;
					} else {
						v = result[0]; v.x = -hs.x; v.y = -hs.y; v.z = hs.z;
						v = result[1]; v.x = hs.x; v.y = -hs.y; v.z = hs.z;
						v = result[2]; v.x = hs.x; v.y = hs.y; v.z = hs.z;
						v = result[3]; v.x = -hs.x; v.y = hs.y; v.z = hs.z;
					}
					break;
			}
		}
		
		/**
		 * 
		 * @param x
		 * @param pnum
		 * @param points
		 * @param result
		 * @return 
		 */
		protected function clipLowX(x:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var x1:Number = x - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.x > x1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.x < x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.x > x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
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
		protected function clipHighX(x:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var x1:Number = x + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.x < x1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.x > x1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (x - p1.x)/dx;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.x < x1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (x - p1.x)/dx;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
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
		protected function clipLowY(y:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var y1:Number = y - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.y > y1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.y < y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.y > y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
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
		protected function clipHighY(y:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var y1:Number = y + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.y < y1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.y > y1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (y - p1.y)/dy;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.y < y1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (y - p1.y)/dy;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
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
		protected function clipLowZ(z:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var z1:Number = z - epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.z > z1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.z < z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.z > z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
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
		protected function clipHighZ(z:Number, pnum:int, points:Vector.<Vector3>, result:Vector.<Vector3>, epsilon:Number):int {
			var z1:Number = z + epsilon;
			var num:int = 0;
			var p1:Vector3 = points[int(pnum - 1)];
			var p2:Vector3;

			var dx:Number;
			var dy:Number;
			var dz:Number;
			var t:Number;
			var v:Vector3;

			for (var i:int = 0; i < pnum; i++) {
				p2 = points[i];
				if (p1.z < z1) {
					v = result[num];
					num++;
					v.x = p1.x;
					v.y = p1.y;
					v.z = p1.z;
					if (p2.z > z1) {
						dx = p2.x - p1.x;
						dy = p2.y - p1.y;
						dz = p2.z - p1.z;
						t =  (z - p1.z)/dz;
						v = result[num];
						num++;
						v.x = p1.x + t*dx;
						v.y = p1.y + t*dy;
						v.z = p1.z + t*dz;
					}
				} else if (p2.z < z1) {
					dx = p2.x - p1.x;
					dy = p2.y - p1.y;
					dz = p2.z - p1.z;
					t =  (z - p1.z)/dz;
					v = result[num];
					num++;
					v.x = p1.x + t*dx;
					v.y = p1.y + t*dy;
					v.z = p1.z + t*dz;
				} 
				p1 = p2;
			}
			return num;
		}

	}
}