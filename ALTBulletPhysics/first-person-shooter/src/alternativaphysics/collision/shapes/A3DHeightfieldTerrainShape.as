package alternativaphysics.collision.shapes {
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.Geometry;
	import alternativaphysics.extend.A3DTerrain;


	/** 
	* Класс представляет из себя шейп, который берет данные о геометрии, необходимой для его построения из класса A3DTerrain. 
	* Можно использовать только для статических тел.
	* @public 
	* @author redefy 
	*/
	public class A3DHeightfieldTerrainShape extends A3DCollisionShape {

		private var dataPtr : uint;
		private var _geometry:Geometry;
		
		/** 
		* Конструктор
		* @public 
		* @param terrain экземпляр класса A3DTerrain
		*/
		public function A3DHeightfieldTerrainShape(terrain : A3DTerrain) {
			_geometry = terrain.geometry;
			var dataLen : int = terrain.sw * terrain.sh;
			dataPtr = bullet.createHeightmapDataBufferMethod(dataLen);

			var data : Vector.<Number> = terrain.heights;
			alchemyMemory.position = dataPtr;
			for (var i : int = 0; i < dataLen; i++ ) {
				alchemyMemory.writeFloat(data[i] / _scaling);
			}

			pointer = bullet.createTerrainShapeMethod(dataPtr, terrain.sw, terrain.sh, terrain.lw / _scaling, terrain.lh / _scaling, 1, -terrain.maxHeight / _scaling, terrain.maxHeight / _scaling, 1);
			super(pointer, 10);
		}
		
		/** 
		* Очищает буфер с данными о карте высот
		* @public 
		*/
		public function deleteHeightfieldTerrainShapeBuffer() : void {
			bullet.removeHeightmapDataBufferMethod(dataPtr);
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