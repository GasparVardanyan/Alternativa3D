package alternativa.editor.export {

	import alternativa.engine3d.alternativa3d;
	import alternativa.engine3d.core.Mesh;
	import alternativa.engine3d.core.Vertex;
	import alternativa.types.Matrix3D;
	import alternativa.types.Point3D;
	
	import flash.geom.Vector3D;

	use namespace alternativa3d;
	
	/**
	 * Физический примитив, представляющий ориентированный бокс.
	 */
	public class CollisionBox extends CollisionPrimitive {
		
		// Размеры бокса вдоль локальных осей (x-ширина, y-длина, z-высота)
		public var size:Point3D = new Point3D(); 
		
		/**
		 * 
		 * @param mesh
		 */
		public function CollisionBox(mesh:Mesh = null) {
			super(mesh);
		}
		
		/**
		 * 
		 * @param mesh
		 */
		override public function parse(mesh:Mesh):void {
			// Поиск максимальных положительных координат по каждой из осей
			var minX:Number = Number.MAX_VALUE;
			var maxX:Number = -Number.MAX_VALUE;
			var minY:Number = Number.MAX_VALUE;
			var maxY:Number = -Number.MAX_VALUE;
			var minZ:Number = Number.MAX_VALUE;
			var maxZ:Number = -Number.MAX_VALUE;
			for each (var v:Vertex in mesh._vertices) {
				var p:Point3D = v._coords;
				if (p.x < minX) minX = p.x;
				if (p.x > maxX) maxX = p.x;
				
				if (p.y < minY) minY = p.y;
				if (p.y > maxY) maxY = p.y;
				
				if (p.z < minZ) minZ = p.z;
				if (p.z > maxZ) maxZ = p.z;
			}
			size.x = maxX - minX;
			size.y = maxY - minY;
			size.z = maxZ - minZ;
			
			var midPoint:Point3D = new Point3D(0.5*(maxX + minX), 0.5*(maxY + minY), 0.5*(maxZ + minZ));
			
			transform.toIdentity();
			transform.rotate(mesh._rotationX, mesh._rotationY, mesh._rotationZ);
			transform.translate(mesh._coords.x, mesh._coords.y, mesh._coords.z);
			midPoint.transform(transform);

			transform.d = midPoint.x;
			transform.h = midPoint.y;
			transform.l = midPoint.z;
		}

		/**
		 * 
		 * @param parentTransform
		 * @return 
		 */
		override public function getXml(parentTransform:Matrix3D):XML {
			var globalTransfrom:Matrix3D = transform.clone();
			globalTransfrom.combine(parentTransform);
			var angles:Point3D = globalTransfrom.getRotations();
			var xml:XML = 
				<collision-box>
					<size>
						<x>{size.x}</x>
						<y>{size.y}</y>
						<z>{size.z}</z>
					</size>
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
				</collision-box>; 	
			return xml;
		}
	
	}
}