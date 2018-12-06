package jiglib.plugin.away3d 
{
	import flash.geom.Vector3D;
	import flash.display.BitmapData;
	
	import away3d.primitives.Plane;
	
	import jiglib.plugin.ITerrain;
	
	public class Away3DTerrain extends Plane implements ITerrain
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
		
		public function Away3DTerrain(terrainHeightMap:BitmapData, init:Object = null)
		{
			super(init);
			
			var gridX:int = segmentsW + 1;
			var gridY:int = segmentsH + 1;
			var textureX:Number = width / 2;
			var textureY:Number = height / 2;
			var maxHeight:Number = ini.getNumber("maxHeight", 100, { min:0 } );
			
			_minW = -textureX;
			_minH = -textureY;
			_maxW = textureX;
			_maxH = textureY;
			_dw = width / segmentsW;
			_dh = height / segmentsH;
			
			_heights = [];
			
			for ( var ix:int = 0; ix < gridX; ix++ )
			{
				_heights[ix] = [];
				for ( var iy:int = 0; iy < gridY; iy++ )
				{
					_heights[ix][iy] = (terrainHeightMap.getPixel((ix / gridX) * terrainHeightMap.width, (iy / gridY) * terrainHeightMap.height) & 0xFF);
					_heights[ix][iy] *= (maxHeight / 255);
					
					vertex(iy, ix).y = _heights[ix][iy];
				}
			}
		}
		
		public function get minW():Number {
			return _minW;
		}
		public function get minH():Number {
			return _minH;
		}
		public function get maxW():Number {
			return _maxW;
		}
		public function get maxH():Number {
			return _maxH;
		}
		public function get dw():Number {
			return _dw;
		}
		public function get dh():Number {
			return _dh;
		}
		public function get sw():int {
			return segmentsW;
		}
		public function get sh():int {
			return segmentsH;
		}
		public function get heights():Array {
			return _heights;
		}
		
		public function get maxHeight():Number{
			return 1000000;
		}
	}

}