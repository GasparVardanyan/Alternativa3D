package alternativa.physics.rigid.generators {
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactGenerator;
	import alternativa.physics.rigid.primitives.RigidBox;
	import alternativa.types.Point3D;

	public class BoxWidthPlaneContactGenerator extends ContactGenerator {
		
		private var box:RigidBox;
		private var normal:Point3D;
		private var offset:Number;
		
		private var coeffs:Array = [-1, 1];
		
		public function BoxWidthPlaneContactGenerator(box:RigidBox, normal:Point3D, offset:Number) {
			super();
			this.box = box;
			this.normal = normal.clone();
			this.offset = offset;
		}
		
		private var xAxis:Point3D = new Point3D();
		private var yAxis:Point3D = new Point3D();
		private var zAxis:Point3D = new Point3D();
		
		private var vertex:Point3D = new Point3D();
		
		override public function addContacts(contact:Contact):Contact {
			box.baseMatrix.getAxis(0, xAxis);
			box.baseMatrix.getAxis(1, yAxis);
			box.baseMatrix.getAxis(2, zAxis);
			
			var kx:Number;
			var ky:Number;
			var kz:Number;
			
			for (var xIdx:int = 0; xIdx < 2; xIdx++) {
				kx = coeffs[xIdx];
				for (var yIdx:int = 0; yIdx < 2; yIdx++) {
					ky = coeffs[yIdx];
					for (var zIdx:int = 0; zIdx < 2; zIdx++) {
						kz = coeffs[zIdx];
						vertex.x = xAxis.x*kx*box.halfSize.x + yAxis.x*ky*box.halfSize.y + zAxis.x*kz*box.halfSize.z + box.state.pos.x;
						vertex.y = xAxis.y*kx*box.halfSize.x + yAxis.y*ky*box.halfSize.y + zAxis.y*kz*box.halfSize.z + box.state.pos.y;
						vertex.z = xAxis.z*kx*box.halfSize.x + yAxis.z*ky*box.halfSize.y + zAxis.z*kz*box.halfSize.z + box.state.pos.z;
						contact = addContactForVertex(vertex, contact);
						if (contact == null) {
							return null;
						}
					}
				}
			}
			return contact;
		}
		
		private function addContactForVertex(v:Point3D, contact:Contact):Contact {
			var d:Number = v.dot(normal) - offset;
			if (d < 0) {
				contact.body1 = box;
				contact.body2 = null;
				contact.penetration = -d;
				contact.pos.copy(v);
				contact.normal.copy(normal);
				return contact.next;
			}
			return contact;
		}
		
	}
}