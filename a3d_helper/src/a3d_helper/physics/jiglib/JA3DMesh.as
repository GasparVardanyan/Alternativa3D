package a3d_helper.physics.jiglib
{
	import alternativa.engine3d.core.VertexAttributes;
	import alternativa.engine3d.core.Object3D;
	import alternativa.engine3d.objects.Mesh;
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	import jiglib.data.TriangleVertexIndices;
	import jiglib.plugin.ISkin3D;

	// Copied from JigLibFlash.
	
	public class JA3DMesh implements ISkin3D
	{
		private var _mesh:Object3D;
		private var _translationOffset:Vector3D;
		private var _scale:Vector3D;
		
		public function JA3DMesh(inputMesh:Object3D, translationOffset:Vector3D = null)
		{
			this._mesh = inputMesh;
			this._translationOffset = translationOffset;
			if (inputMesh.scaleX != 1 || inputMesh.scaleY != 1 || inputMesh.scaleZ != 1)
			{
				_scale = new Vector3D(inputMesh.scaleX, inputMesh.scaleY, inputMesh.scaleZ);
			}
		}
		
		public function get translationOffset():Vector3D
		{
			return this._translationOffset;
		}
		
		public function set translationOffset(val:Vector3D):void
		{
			this._translationOffset = val;
		}
		
		public function get transform():Matrix3D
		{
			return this._mesh.matrix;
		}
		
		public function set transform(matrix:Matrix3D):void
		{
			this._mesh.matrix = matrix.clone();
		}
		
		public function get mesh():Object3D
		{
			return this._mesh;
		}
		
		public function get vertices():Vector.<Vector3D>
		{
			var result:Vector.<Vector3D> = new Vector.<Vector3D>;
			var vts:Vector.<Number> = Mesh(this._mesh).geometry.getAttributeValues(VertexAttributes.POSITION);
			var i:uint = 0;
			while (i < vts.length)
			{
				result.push(new Vector3D(vts[i], vts[i + 1], vts[i + 2]));
				i += 3;
			}
			return result;
		}
		
		public function get indices():Vector.<TriangleVertexIndices>
		{
			var result:Vector.<TriangleVertexIndices> = new Vector.<TriangleVertexIndices>();
			var ids:Vector.<uint> = Mesh(_mesh).geometry.indices;
			for (var i:uint = 0; i < ids.length; i += 3)
			{
				result.push(new TriangleVertexIndices(ids[i], ids[i + 1], ids[i + 2]));
			}
			return result;
		}
	}
}
