package jiglib.plugin.sandy3d 
{
	import flash.geom.Matrix3D;
	
	import jiglib.plugin.ISkin3D;
	
	import sandy.core.data.Matrix4;
	import sandy.core.scenegraph.Shape3D;

	public class Sandy3DMesh implements ISkin3D
	{
		
		private var shape:Shape3D;

		public function Sandy3DMesh(shape:Shape3D) 
		{
			this.shape = shape;
		}

		public function get transform():Matrix3D 
		{
			var rawData:Vector.<Number> = new Vector.<Number>(16, true);
			rawData[0] = this.shape.matrix.n11; 
			rawData[4] = this.shape.matrix.n12; 
			rawData[8] = this.shape.matrix.n13; 
			rawData[12] = this.shape.matrix.n14;
			rawData[1] = this.shape.matrix.n21; 
			rawData[5] = this.shape.matrix.n22; 
			rawData[9] = this.shape.matrix.n23; 
			rawData[13] = this.shape.matrix.n24;
			rawData[2] = this.shape.matrix.n31; 
			rawData[6] = this.shape.matrix.n32; 
			rawData[10] = this.shape.matrix.n33; 
			rawData[14] = this.shape.matrix.n34;
			rawData[3] = this.shape.matrix.n41; 
			rawData[7] = this.shape.matrix.n42; 
			rawData[11] = this.shape.matrix.n43; 
			rawData[15] = this.shape.matrix.n44;
			 
			return new Matrix3D(rawData);
		}
		
		public function set transform(m:Matrix3D):void 
		{
			var tr:Matrix4 = new Matrix4();
			//
			tr.n11 = m.rawData[0]; 
			tr.n12 = m.rawData[4]; 
			tr.n13 = m.rawData[8]; 
			tr.n14 = m.rawData[12];
			tr.n21 = m.rawData[1]; 
			tr.n22 = m.rawData[5]; 
			tr.n23 = m.rawData[9]; 
			tr.n24 = m.rawData[13];
			tr.n31 = m.rawData[2]; 
			tr.n32 = m.rawData[6]; 
			tr.n33 = m.rawData[10]; 
			tr.n34 = m.rawData[14];
			tr.n41 = m.rawData[3]; 
			tr.n42 = m.rawData[7]; 
			tr.n43 = m.rawData[11]; 
			tr.n44 = m.rawData[15];
			//
			this.shape.initFrame();
			this.shape.matrix = tr;
		}
		
		public function get mesh():Shape3D 
		{
			return shape;
		}
	}
}
