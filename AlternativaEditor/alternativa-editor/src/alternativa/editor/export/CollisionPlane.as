package alternativa.editor.export {
	
	import __AS3__.vec.Vector;
	
	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Face;
	import alternativa.engine3d.core.Mesh;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	
	use namespace alternativa3d;
	
	/**
	 * Физический примитив, представляющий собой прямоугольник, лежащий в плоскости XY локальной системы координат.
	 * Нормаль прямоугольника направлена вдоль локальной оси Z.
	 */	
	public class CollisionPlane extends CollisionPrimitive {
		// Ширина, размер по оси X
		public var width:Number = 0;
		// Длина, размер по оси Y
		public var length:Number = 0;

		/**
		 * @param mesh
		 */
		public function CollisionPlane(mesh:Mesh = null) {
			super(mesh);
		}
		
		/**
		 * Конструирует примитив из полигонального объекта. Объект должен содержать в себе ориентированный прямоугольник, состоящий из двух треугольников.
		 * @param mesh
		 */
		override public function parse(mesh:Mesh):void {
			var i:int;
			// Подразумевается, что прямоугольник состоит из двух треугольников. Для определения параметров воспользуемся первым из них.
			var face:Face = mesh._faces.peek() as Face;
			// Найдём длины рёбер треугольника и индекс гипотенузы
			var max:Number = -1;
			var imax:int = 0;
			var edges:Vector.<Point3D> = Vector.<Point3D>([new Point3D(), new Point3D(), new Point3D()]);
			var lengths:Vector.<Number> = new Vector.<Number>(3);
			for (i = 0; i < 3; i++) {
				var edge:Point3D = edges[i];
				edge.difference(face.vertices[(i + 1)%3]._coords, face.vertices[i]._coords);
				var len:Number = lengths[i] = edge.length;
				if (len > max) { 
					max = len;
					imax = i;
				}
			}
			// Выберем оси X и Y
			var ix:int = (imax + 2)%3;
			var iy:int = (imax + 1)%3;
			var xAxis:Point3D = edges[ix];
			var yAxis:Point3D = edges[iy];
			yAxis.invert();
			width = lengths[ix];
			length = lengths[iy];
			// Смещение локального начала координат
			var trans:Point3D = face.vertices[(imax + 2)%3]._coords.clone();
			trans.x += 0.5*(xAxis.x + yAxis.x);
			trans.y += 0.5*(xAxis.y + yAxis.y);
			trans.z += 0.5*(xAxis.z + yAxis.z);
			// Оси локального базиса в родительской системе координат
			xAxis.normalize();
			yAxis.normalize();
			var zAxis:Point3D = Point3D.cross(xAxis, yAxis);
			// Матрица трансформации примитива в родительской системе координат
			transform.setVectors(xAxis, yAxis, zAxis, trans);
			transform.rotate(mesh._rotationX, mesh._rotationY, mesh._rotationZ);
			transform.translate(mesh._coords.x, mesh._coords.y, mesh._coords.z);
		}
		
		/**
		 * @param parentTransform
		 * @return 
		 */
		override public function getXml(parentTransform:Matrix3D):XML {
			var globalTransfrom:Matrix3D = transform.clone();
			globalTransfrom.combine(parentTransform);
			var angles:Point3D = globalTransfrom.getRotations();
			var xml:XML = 
				<collision-plane>
					<width>{width}</width>
					<length>{length}</length>
					<position>
						<x>{globalTransfrom.d}</x>
						<y>{globalTransfrom.h}</y>
						<z>{globalTransfrom.l}</z>
					</position>
					<rotation>
						<x>{angles.x}</x>
						<y>{angles.y}</y>
						<z>{angles.z}</z>
					</rotation>
				</collision-plane>; 	
			return xml;
		}
		
	}
}