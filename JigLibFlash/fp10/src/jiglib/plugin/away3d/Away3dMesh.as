package jiglib.plugin.away3d {
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import away3d.core.base.Mesh;
	import away3d.core.base.Vertex;
	
	import jiglib.data.TriangleVertexIndices;
	import jiglib.plugin.ISkin3D;
	
	public class Away3dMesh implements ISkin3D {
		
		private var _mesh:Mesh;

		public function Away3dMesh(do3d:Mesh) {
			this._mesh = do3d;
		}

		public function get transform():Matrix3D {
			
			return _mesh.transform;
		}
		
		public function set transform(m:Matrix3D):void {
			
			_mesh.transform = m.clone();
		}
		
		public function get mesh():Mesh {
			return _mesh;
		}
		
		public function get vertices():Vector.<Vector3D> { 
			var vertices : Vector.<Vector3D> = new Vector.<Vector3D>();	
			var vts : Vector.<Number> = _mesh.verts;
			
			for(var i:uint=0;i<vts.length;i+=3){
				vertices.push(new Vector3D(vts[i],vts[i+1],vts[i+2]));
			}
			return vertices; 
		}
		public function get indices():Vector.<TriangleVertexIndices> { 
			var indices : Vector.<TriangleVertexIndices> = new Vector.<TriangleVertexIndices>() 
			var ids : Vector.<int> = _mesh.indices; 
			
			for (var i : uint = 0; i < ids.length; i += 3) { 
				indices.push(new TriangleVertexIndices(ids[i+2], ids[i + 1], ids[i])); 
			} 
			return indices;	
		} 
	}
}
