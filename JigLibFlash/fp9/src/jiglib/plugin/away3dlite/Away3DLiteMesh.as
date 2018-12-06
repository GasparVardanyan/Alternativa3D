package jiglib.plugin.away3dlite
{
	import away3dlite.core.base.Object3D;
	
	import flash.geom.Matrix3D;
	
	import jiglib.math.JMatrix3D;
	import jiglib.plugin.ISkin3D;

	/**
	 * @author katopz
	 */
	public class Away3DLiteMesh implements ISkin3D
	{
		private var object3D:Object3D;
		public var mesh:Object3D;

		public function Away3DLiteMesh(object3D:Object3D)
		{
			mesh = this.object3D = object3D;
		}

		public function get transform():JMatrix3D
		{
			var _rawData:Vector.<Number> = object3D.transform.matrix3D.rawData;
			return new JMatrix3D([
				_rawData[0], _rawData[4], _rawData[8],  _rawData[12],
				_rawData[1], _rawData[5], _rawData[9],  _rawData[13],
				_rawData[2], _rawData[6], _rawData[10], _rawData[14],
				_rawData[3], _rawData[7], _rawData[11], _rawData[15]
			]);
		}
		
		public function set transform(m:JMatrix3D):void
		{
			object3D.transform.matrix3D = new Matrix3D(Vector.<Number>([
				 m.n11, -m.n21,  m.n31, m.n41,
				-m.n12,  m.n22, -m.n32, m.n42,
				 m.n13, -m.n23,  m.n33, m.n43,
				 m.n14, -m.n24,  m.n34, m.n44
			]));
		}
	}
}