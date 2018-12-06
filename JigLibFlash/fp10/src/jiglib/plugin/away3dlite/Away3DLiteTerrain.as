package jiglib.plugin.away3dlite
{
	import away3dlite.arcane;

	use namespace arcane;

	import away3dlite.materials.Material;
	import away3dlite.primitives.AbstractPrimitive;

	import flash.display.BitmapData;
	import flash.geom.Vector3D;

	import jiglib.plugin.ITerrain;
	import away3dlite.primitives.Plane;

	public class Away3DLiteTerrain extends Plane implements ITerrain
	{
		//Min of coordinate horizontally;
		private var _minW:Number;

		//Min of coordinate vertically;
		private var _minH:Number;

		//Max of coordinate horizontally;
		private var _maxW:Number;

		//Max of coordinate vertically;
		private var _maxH:Number;

		//The horizontal length of each segment;
		private var _dw:Number;

		//The vertical length of each segment;
		private var _dh:Number;

		//the heights of all vertices
		private var _heights:Array;

		private var _terrainHeightMap:BitmapData;
		private var _maxHeight:Number;

		public function Away3DLiteTerrain(heightMapData:HeightMapData, material:Material = null, width:Number = 100, height:Number = 100, segmentsW:int = 1, segmentsH:int = 1)
		{
			super(material, width, height, segmentsW, segmentsH);
			
			type = "Terrain";
			url = "primitive";

			_terrainHeightMap = heightMapData.bitmapData;
			_maxHeight = heightMapData.maxHeight;

			updatePrimitive();
		}

		protected override function buildPrimitive():void
		{
			super.buildPrimitive();

			var gridX:int = _segmentsW + 1;
			var gridY:int = _segmentsH + 1;
			var textureX:Number = _width / 2;
			var textureY:Number = _height / 2;
			
			_minW = -textureX;
			_minH = -textureY;
			_maxW = textureX;
			_maxH = textureY;
			_dw = width / _segmentsW;
			_dh = height / _segmentsH;

			_heights = [];

			var _heights2:Vector.<Number> = new Vector.<Number>();
			var k:int = 0;

			for (var ix:int = 0; ix < gridX; ix++)
			{
				_heights[ix] = [];
				for (var iy:int = 0; iy < gridY; iy++)
				{
					_heights[ix][iy] = (_terrainHeightMap.getPixel((ix / gridX) * _terrainHeightMap.width, (iy / gridY) * _terrainHeightMap.height) & 0xFF);
					_heights[ix][iy] *= (_maxHeight / 255);

					_heights2[k++] = _heights[ix][iy];
				}
			}

			var _length:int = _vertices.length;
			k = 0;
			for (var i:int = 0; i < _length; i += 3)
			{
				_vertices[i + 1] = -_heights2[k++];
			}
		}
		
		public function get minW():Number
		{
			return _minW;
		}

		public function get minH():Number
		{
			return _minH;
		}

		public function get maxW():Number
		{
			return _maxW;
		}

		public function get maxH():Number
		{
			return _maxH;
		}

		public function get dw():Number
		{
			return _dw;
		}

		public function get dh():Number
		{
			return _dh;
		}

		public function get sw():int
		{
			return _segmentsW;
		}

		public function get sh():int
		{
			return _segmentsH;
		}

		public function get heights():Array
		{
			return _heights;
		}
		public function get maxHeight():Number{
			return 1000000;
		}
	}
}