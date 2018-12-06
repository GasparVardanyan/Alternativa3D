package jiglib.plugin.five3d {
	import jiglib.plugin.ISkin3D;
	import jiglib.math.JMatrix3D;
	
	import five3D.geom.Matrix3D;
	import five3D.display.Sprite3D;

	/**
	 * @author Devin Reimer (blog.almostlogical.com), based on class Pv3dMesh written by bartekd
	 * */
	public class FIVe3DMesh implements ISkin3D{
		
		private var sprite3D:Sprite3D;

		public function FIVe3DMesh(sprite3D:Sprite3D) {
			this.sprite3D = sprite3D;
		}

		public function get transform():JMatrix3D {
			var tr:JMatrix3D = new JMatrix3D();
			tr.n11 = sprite3D.matrix.a;
			tr.n12 = -sprite3D.matrix.b; //-
			tr.n13 = sprite3D.matrix.c; 
			tr.n14 = sprite3D.matrix.tx;
			tr.n21 = -sprite3D.matrix.d; //-
			tr.n22 = sprite3D.matrix.e;
			tr.n23 = -sprite3D.matrix.f; //-
			tr.n24 = -sprite3D.matrix.ty; //-
			tr.n31 = sprite3D.matrix.g; 
			tr.n32 = -sprite3D.matrix.h; //-
			tr.n33 = sprite3D.matrix.i;
			tr.n34 = sprite3D.matrix.tz;
			 
			return tr;
		}
		
		public function set transform(m:JMatrix3D):void {
			var tr:Matrix3D = new Matrix3D();
			tr.a = m.n11;
			tr.b = -m.n12; //-
			tr.c = m.n13; 
			tr.tx = m.n14;
			tr.d = -m.n21; //-
			tr.e = m.n22;
			tr.f = -m.n23; //-
			tr.ty = -m.n24; //-
			tr.g = m.n31; 
			tr.h = -m.n32; //-
			tr.i = m.n33;
			tr.tz = m.n34;
			
			sprite3D.matrix = tr;	
		}
		
		public function get mesh():Sprite3D {
			return sprite3D;
		}
	}
}
