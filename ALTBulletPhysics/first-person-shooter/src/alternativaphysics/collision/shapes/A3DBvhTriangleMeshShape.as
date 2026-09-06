package alternativaphysics.collision.shapes {
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.Geometry;


	/** 
	* Класс представляет из себя полигональный шейп, который берет данные о геометрии, необходимой для его построения из загруженной 3D - модели. 
	* Можно использовать только для статических тел
	* @public 
	* @author redefy 
	*/
	public class A3DBvhTriangleMeshShape extends A3DCollisionShape {

		private var indexDataPtr : uint;
		private var vertexDataPtr : uint;
		private var _geometry:Geometry;

		/**
		 * Конструктор
		 * @public 
		 * @param geometry геометрия 3D-объекта.  
		 * @param useQuantizedAabbCompression 
		 */
		public function A3DBvhTriangleMeshShape(geometry : Geometry, useQuantizedAabbCompression : Boolean = true) {
			_geometry = geometry;
			var indexData : Vector.<uint>  = geometry.indices;
			
			var indexDataLen : int = indexData.length;
			indexDataPtr = bullet.createTriangleIndexDataBufferMethod(indexDataLen);

			alchemyMemory.position = indexDataPtr;
			for (var i : int = 0; i < indexDataLen; i++ ) {
				alchemyMemory.writeInt(indexData[i]);
			}

			var vertexData : Vector.<Number> = geometry.getAttributeValues(VertexAttributes.POSITION);
			var vertexDataLen : int = vertexData.length;
			vertexDataPtr = bullet.createTriangleVertexDataBufferMethod(vertexDataLen);

			alchemyMemory.position = vertexDataPtr;
			for (i = 0; i < vertexDataLen; i++ ) {
				alchemyMemory.writeFloat(vertexData[i] / _scaling);
			}

			var triangleIndexVertexArrayPtr : uint = bullet.createTriangleIndexVertexArrayMethod(int(indexDataLen / 3), indexDataPtr, int(vertexDataLen / 3), vertexDataPtr);

			pointer = bullet.createBvhTriangleMeshShapeMethod(triangleIndexVertexArrayPtr, useQuantizedAabbCompression ? 1 : 0, 1);
			super(pointer, 9);
		}
		
		/** 
		* Очищает буфер с данными о индексах/вершинах шейпа
		* @public
		* @return void 
		*/
		public function deleteBvhTriangleMeshShapeBuffer() : void {
			bullet.removeTriangleIndexDataBufferMethod(indexDataPtr);
			bullet.removeTriangleVertexDataBufferMethod(vertexDataPtr);
		}
		

		/** 
		* геометрия шейпа
		* @public (getter) 
		* @return Geometry 
		*/
		public function get geometry():Geometry {
			return _geometry;
		}
	}
}