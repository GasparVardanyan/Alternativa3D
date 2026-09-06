package alternativaphysics.extend {

	import alternativa.engine3d.materials.FillMaterial;
	import alternativa.engine3d.materials.Material;
	import alternativa.engine3d.objects.Mesh;
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.resources.Geometry;
	import flash.display.BitmapData;
	import flash.geom.Vector3D;


	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class Elevation extends Mesh {

		/** 
		* 
		* @private 
		*/
		private var _segmentsW:uint;

		/** 
		* 
		* @private 
		*/
		private var _segmentsH:uint;

		/** 
		* 
		* @private 
		*/
		private var _width:Number;

		/** 
		* 
		* @private 
		*/
		private var _height:Number;

		/** 
		* 
		* @private 
		*/
		private var _depth:Number;

		/** 
		* 
		* @private 
		*/
		private var _heightMap:BitmapData;

		/** 
		* 
		* @private 
		*/
		private var _material:Material;

		/** 
		* 
		* @private 
		*/
		private var _smoothedHeightMap:BitmapData;

		/** 
		* 
		* @private 
		*/
		private var _activeMap:BitmapData;

		/** 
		* 
		* @private 
		*/
		private var _minElevation:uint;

		/** 
		* 
		* @private 
		*/
		private var _maxElevation:uint;

		/** 
		* 
		* @private 
		*/
		private var attributes:Array;

		/**
		 * Class Elevation generates (and becomes) a mesh from an heightmap. <code>Elevation</code>
		 *
		 * @param	material 		MaterialBase. The Mesh (Elevation) material
		 * @param	heightMap		BitmapData. The heightmap to generate the mesh from
		 * @param	width				[optional] Number. The width of the mesh. Default is 1000.
		 * @param	height			[optional] Number. The height of the mesh. Default is 100.
		 * @param	depth			[optional] Number. The depth of the mesh. Default is 1000.
		 * @param	segmentsW	[optional] uint. The subdivision of the mesh along the x axis. Default is 30.
		 * @param	segmentsH		[optional] uint. The subdivision of the mesh along the y axis. Default is 30.
		 * @param	maxElevation	[optional] uint. The maximum color value to be used. Allows canyon like elevations instead of mountainious. Default is 255.
		 * @param	minElevation	[optional] uint. The minimum color value to be used. Default is 0.
		 * @param	smoothMap	[optional] Boolean. If surface tracking is used, an internal smoothed version of the map is generated,
		 * prevents irregular height readings if original map is blowed up or is having noise. Default is false.
		 */
		public function Elevation(material:Material, heightMap:BitmapData, width:Number = 1000, height:Number = 100, depth:Number = 1000, segmentsW:uint = 30, segmentsH:uint = 30, maxElevation:uint = 255, minElevation:uint = 0, smoothMap:Boolean = false){
			super();
			geometry = new Geometry();
			_heightMap = heightMap;
			_activeMap = _heightMap;
			_segmentsW = segmentsW;
			_segmentsH = segmentsH;
			_material = material;
			_width = width;
			_height = height;
			_depth = depth;
			_maxElevation = maxElevation;
			_minElevation = minElevation;

			buildGeometry();

			if (smoothMap) smoothHeightMap();
		}

		/**
		 * Locks elevation factor beneath this color reading level. Default is 0;
		 */
		public function set minElevation(val:uint):void {
			if (_minElevation == val) return;

			_minElevation = val;
			buildGeometry();
		}


		/** 
		* 
		* @public (getter) 
		* @return uint 
		*/
		public function get minElevation():uint {
			return _minElevation;
		}

		/**
		 * Locks elevation factor above this color reading level. Default is 255;
		 * Allows to build "canyon" like landscapes with no additional work on heightmap source.
		 */
		public function set maxElevation(val:uint):void {
			if (_maxElevation == val) return;

			_maxElevation = val;
			buildGeometry();
		}


		/** 
		* 
		* @public (getter) 
		* @return uint 
		*/
		public function get maxElevation():uint {
			return _maxElevation;
		}

		/**
		 * The number of segments that make up the plane along the Y or Z-axis, depending on whether yUp is true or
		 * false, respectively. Defaults to 1.
		 */
		public function get segmentsH():uint {
			return _segmentsH;
		}


		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set segmentsH(value:uint):void {
			_segmentsH = value;
			buildGeometry();
		}

		/**
		 * The width of the terrain plane.
		 */
		public function get width():Number {
			return _width;
		}


		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set width(value:Number):void {
			_width = value;
			buildGeometry();
		}


		/** 
		* 
		* @public (getter) 
		* @return Number 
		*/
		public function get height():Number {
			return _height;
		}


		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set height(value:Number):void {
			_height = value;
		}

		/**
		 * The depth of the terrain plane.
		 */
		public function get depth():Number {
			return _depth;
		}


		/** 
		* 
		* @public (setter) 
		* @param value 
		* @return void 
		*/
		public function set depth(value:Number):void {
			_depth = value;
			buildGeometry();
		}

		/**
		 * Reading the terrain height from a given x z position
		 * for surface tracking purposes
		 *
		 * @see away3d.extrusions.Elevation.smoothHeightMap
		 */
		public function getHeightAt(x:Number, z:Number):Number {
			var col:uint = _activeMap.getPixel((x / _width + .5) * _activeMap.width, (-z / _depth + .5) * _activeMap.height) & 0xff;
			return (col > _maxElevation) ? (_maxElevation / 0xff) * _height : ((col < _minElevation) ? (_minElevation / 0xff) * _height : (col / 0xff) * _height);
		}

		/**
		 * Generates a smoother representation of the geometry using the original heightmap and subdivision settings.
		 * Allows smoother readings for surface tracking if original heightmap has noise, causing choppy camera movement.
		 *
		 * @see away3d.extrusions.Elevation.getHeightAt
		 */
		public function smoothHeightMap():void {
			if (_smoothedHeightMap)
				_smoothedHeightMap.dispose();
			_smoothedHeightMap = new BitmapData(_heightMap.width, _heightMap.height, false, 0);

			var w:uint = _smoothedHeightMap.width;
			var h:uint = _smoothedHeightMap.height;
			var i:uint;
			var j:uint;
			var k:uint;
			var l:uint;

			var px1:uint;
			var px2:uint;
			var px3:uint;
			var px4:uint;

			var lockx:uint;
			var locky:uint;

			_smoothedHeightMap.lock();

			var incXL:Number;
			var incXR:Number;
			var incYL:Number;
			var incYR:Number;
			var pxx:Number;
			var pxy:Number;

			for (i = 0; i < w + 1; i += _segmentsW){

				if (i + _segmentsW > w - 1){
					lockx = w - 1;
				} else {
					lockx = i + _segmentsW;
				}

				for (j = 0; j < h + 1; j += _segmentsH){

					if (j + _segmentsH > h - 1){
						locky = h - 1;
					} else {
						locky = j + _segmentsH;
					}

					if (j == 0){
						px1 = _heightMap.getPixel(i, j) & 0xFF;
						px1 = (px1 > _maxElevation) ? _maxElevation : ((px1 < _minElevation) ? _minElevation : px1);
						px2 = _heightMap.getPixel(lockx, j) & 0xFF;
						px2 = (px2 > _maxElevation) ? _maxElevation : ((px2 < _minElevation) ? _minElevation : px2);
						px3 = _heightMap.getPixel(lockx, locky) & 0xFF;
						px3 = (px3 > _maxElevation) ? _maxElevation : ((px3 < _minElevation) ? _minElevation : px3);
						px4 = _heightMap.getPixel(i, locky) & 0xFF;
						px4 = (px4 > _maxElevation) ? _maxElevation : ((px4 < _minElevation) ? _minElevation : px4);
					} else {
						px1 = px4;
						px2 = px3;
						px3 = _heightMap.getPixel(lockx, locky) & 0xFF;
						px3 = (px3 > _maxElevation) ? _maxElevation : ((px3 < _minElevation) ? _minElevation : px3);
						px4 = _heightMap.getPixel(i, locky) & 0xFF;
						px4 = (px4 > _maxElevation) ? _maxElevation : ((px4 < _minElevation) ? _minElevation : px4);
					}

					for (k = 0; k < _segmentsW; ++k){
						incXL = 1 / _segmentsW * k;
						incXR = 1 - incXL;

						for (l = 0; l < _segmentsH; ++l){
							incYL = 1 / _segmentsH * l;
							incYR = 1 - incYL;

							pxx = ((px1 * incXR) + (px2 * incXL)) * incYR;
							pxy = ((px4 * incXR) + (px3 * incXL)) * incYL;

							//_smoothedHeightMap.setPixel(k+i, l+j, pxy+pxx << 16 |  0xFF-(pxy+pxx) << 8 | 0xFF-(pxy+pxx) );
							_smoothedHeightMap.setPixel(k + i, l + j, pxy + pxx << 16 | pxy + pxx << 8 | pxy + pxx);
						}
					}
				}
			}
			_smoothedHeightMap.unlock();

			_activeMap = _smoothedHeightMap;
		}


		/*
		 * Returns the smoothed heightmap if smoothHeightMap() has been called.
		 */
		public function get smoothedHeightMap():BitmapData {
			return _smoothedHeightMap;
		}


		/** 
		* 
		* @private 
		* @return void 
		*/
		private function buildGeometry():void {

			attributes = [];
			attributes[0] = VertexAttributes.POSITION;
			attributes[1] = VertexAttributes.POSITION;
			attributes[2] = VertexAttributes.POSITION;
			attributes[3] = VertexAttributes.TEXCOORDS[0];
			attributes[4] = VertexAttributes.TEXCOORDS[0];
			attributes[5] = VertexAttributes.NORMAL, 
			attributes[6] = VertexAttributes.NORMAL, 
			attributes[7] = VertexAttributes.NORMAL, 
			geometry.addVertexStream(attributes);

			var vertices:Vector.<Number>;
			var indices:Vector.<uint>;
			var normals:Vector.<Number> = new Vector.<Number>();
			var tangent:Vector.<Number> = new Vector.<Number>();
			var x:Number, z:Number;
			var numInds:uint;
			var base:uint;
			var tw:uint = _segmentsW + 1;
			var numVerts:uint = (_segmentsH + 1) * tw;
			var uDiv:Number = (_heightMap.width - 1) / _segmentsW;
			var vDiv:Number = (_heightMap.height - 1) / _segmentsH;
			var u:Number, v:Number;
			var y:Number;

			if (numVerts == geometry.numVertices){
				vertices = geometry.getAttributeValues(VertexAttributes.POSITION);
				indices = geometry.indices;
			} else {
				vertices = new Vector.<Number>(numVerts * 3, true);
				indices = new Vector.<uint>(_segmentsH * _segmentsW * 6, true);
			}

			numVerts = 0;
			var col:uint;

			for (var zi:uint = 0; zi <= _segmentsH; ++zi){
				for (var xi:uint = 0; xi <= _segmentsW; ++xi){
					x = (xi / _segmentsW - .5) * _width;
					z = (zi / _segmentsH - .5) * _depth;
					u = xi * uDiv;
					v = (_segmentsH - zi) * vDiv;

					col = _heightMap.getPixel(u, v) & 0xff;
					y = (col > _maxElevation) ? (_maxElevation / 0xff) * _height : ((col < _minElevation) ? (_minElevation / 0xff) * _height : (col / 0xff) * _height);

					vertices[numVerts++] = x;
					vertices[numVerts++] = y;
					vertices[numVerts++] = z;

					if (xi != _segmentsW && zi != _segmentsH){
						base = xi + zi * tw;
						indices[numInds++] = base;
						indices[numInds++] = base + tw;
						indices[numInds++] = base + tw + 1;
						indices[numInds++] = base;
						indices[numInds++] = base + tw + 1;
						indices[numInds++] = base + 1;
					}
				}
			}

			geometry.numVertices = vertices.length / 3;
			geometry.indices = indices;
			geometry.setAttributeValues(VertexAttributes.POSITION, vertices);

			var uvs:Vector.<Number> = new Vector.<Number>();
			var numUvs:uint = (_segmentsH + 1) * (_segmentsW + 1) * 2;

			if (geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]) && numUvs == geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0]).length)
				uvs = geometry.getAttributeValues(VertexAttributes.TEXCOORDS[0])
			else
				uvs = new Vector.<Number>(numUvs, true);

			numUvs = 0;
			for (var yuvs:uint = 0; yuvs <= _segmentsH; ++yuvs){
				for (var xuvs:uint = 0; xuvs <= _segmentsW; ++xuvs){
					uvs[numUvs++] = xuvs / _segmentsW;
					uvs[numUvs++] = 1 - yuvs / _segmentsH;
				}
			}
			
			var index:int;
			var normal:Vector3D;
			
			for (index = 0; index < geometry.numVertices; index++){
					normal = calcNormals(new Vector3D(vertices[index], vertices[index + 1], vertices[index + 2]), 
												  new Vector3D(vertices[index + 3], vertices[index + 4], vertices[index + 5]), 
												  new Vector3D(vertices[index + 6], vertices[index + 7], vertices[index + 8]))
				normals.push(normal.x, normal.y, normal.z);
			}

			geometry.setAttributeValues(VertexAttributes.TEXCOORDS[0], uvs);
			geometry.setAttributeValues(VertexAttributes.NORMAL, normals);

			addSurface(_material, 0, geometry.numTriangles);
		}



		/** 
		* 
		* @private 
		* @param a 
		* @param b 
		* @param c 
		* @return Vector3D 
		*/
		private function calcNormals(a:Vector3D, b:Vector3D, c:Vector3D):Vector3D {
			var v1:Vector3D = a.subtract(b);
			var v2:Vector3D = a.subtract(c);
			var v3:Vector3D = v1.crossProduct(v2);
			v3.normalize();
			return (v3);
		}
	}
}
