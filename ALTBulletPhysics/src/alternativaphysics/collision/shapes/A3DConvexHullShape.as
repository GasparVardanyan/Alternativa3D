package alternativaphysics.collision.shapes {
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.Geometry;
	

	/** 
	* Класс представляет из себя шейп, который берет данные о геометрии, необходимой для его построения из 3D-модели выпуклого многоугольника.
	* Можно использовать как для динамических тел, так и для статических.
	* @public 
	* @author redefy 
	*/
	public class A3DConvexHullShape extends A3DCollisionShape {

		private var vertexDataPtr : uint;
		private var _geometry:Geometry;
		
		/** 
		* Конструктор
		* @public 
		* @param geometry 
		*/
		public function A3DConvexHullShape(geometry : Geometry) {
			_geometry = geometry;
			var vertexData : Vector.<Number> = geometry.getAttributeValues(VertexAttributes.POSITION);
			var vertexDataLen : int = vertexData.length;
			vertexDataPtr = bullet.createTriangleVertexDataBufferMethod(vertexDataLen);
			
			alchemyMemory.position = vertexDataPtr;
			for (var i:int = 0; i < vertexDataLen; i++ ) {
				alchemyMemory.writeFloat(vertexData[i] / _scaling);
			}
			
			pointer = bullet.createConvexHullShapeMethod(int(vertexDataLen / 3), vertexDataPtr);
			super(pointer, 5);
		}
		
		/** 
		* Очищает буфер с данными о геометрии выпуклого многоугольника
		* @public 
		* @return void 
		*/
		public function deleteConvexHullShapeBuffer() : void {
			bullet.removeTriangleVertexDataBufferMethod(vertexDataPtr);
		}
		

		/** 
		* Геометрия шейпа
		* @public (getter) 
		* @return Geometry 
		*/
		public function get geometry():Geometry {
			return _geometry;
		}
	}
}