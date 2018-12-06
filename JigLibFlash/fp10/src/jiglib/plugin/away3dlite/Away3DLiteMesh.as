package jiglib.plugin.away3dlite
{
	import away3dlite.core.base.Mesh;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	import jiglib.data.TriangleVertexIndices;
	import jiglib.plugin.ISkin3D;

	public class Away3DLiteMesh implements ISkin3D
	{
		public function get transform():Matrix3D
		{
			return _mesh.transform.matrix3D;
		}

		public function set transform(m:Matrix3D):void
		{
			_mesh.transform.matrix3D = m.clone();
		}

		private var _mesh:Mesh;

		public function get mesh():Mesh
		{
			return _mesh;
		}

		public function Away3DLiteMesh(mesh:Mesh)
		{
			_mesh = mesh;
		}

		public function get vertices():Vector.<Vector3D>
		{
			var vertices:Vector.<Vector3D> = new Vector.<Vector3D>();
			var vts:Vector.<Number> = _mesh.vertices;

			for (var i:uint = 0; i < vts.length; i += 3)
			{
				vertices.push(new Vector3D(vts[i], vts[i + 1], vts[i + 2]));
			}
			return vertices;
		}

		public function get indices():Vector.<TriangleVertexIndices>
		{
			/* TODO : need pull request to github 1st ;(
			var indices:Vector.<TriangleVertexIndices> = new Vector.<TriangleVertexIndices>()
			var ids:Vector.<int> = _mesh.indices;

			for (var i:uint = 0; i < ids.length; i += 3)
			{
				indices.push(new TriangleVertexIndices(ids[i + 2], ids[i + 1], ids[i]));
			}
			return indices;
			*/
			return null;
		}
	}
}
