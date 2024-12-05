package alternativa.physics.rigid.generators {
	import alternativa.physics.rigid.Contact;
	import alternativa.physics.rigid.ContactGenerator;
	import alternativa.physics.rigid.primitives.RigidSphere;
	import alternativa.types.Point3D;

	public class SphereWithPlaneContactGenerator extends ContactGenerator {

		private var sphere:RigidSphere;
		private var normal:Point3D;
		private var offset:Number;

		public function SphereWithPlaneContactGenerator(sphere:RigidSphere, normal:Point3D, offset:Number) {
			super();
			this.sphere = sphere;
			this.normal = normal.clone();
			this.offset = offset;
		}
		
		override public function addContacts(contact:Contact):Contact {
			var d:Number = sphere.state.pos.dot(normal) - offset - sphere.r;
			if (d < 0) {
				contact.body1 = sphere;
				contact.body2 = null;
				contact.penetration = -d;
				contact.normal.copy(normal);
				contact.pos.copy(normal);
				contact.pos.multiply(-sphere.r);
				contact.pos.add(sphere.state.pos);
				return contact.next;
			}
			return contact;
		}
		
	}
}