package alternativa.physics.primitives {

	import alternativa.physics.Body;
	import alternativa.physics.altphysics;
	import alternativa.physics.math.Matrix3;

	use namespace altphysics;	

	public class RigidCylinder extends Body {
		
		altphysics var r:Number;
		altphysics var h:Number;
		
		public function RigidCylinder(mass:Number, radius:Number, height:Number) {
			super(0, Matrix3.ZERO);
			setParams(mass, radius, height);
		}
		
		public function setParams(mass:Number, radius:Number, height:Number):void {
			r = radius;
			h = height;
			invInertiaWorld.copy(Matrix3.ZERO);
			if (mass == Infinity) invMass = 0;
			else {
				invMass = 1/mass;
				invInertia.a = invInertia.f = mass*(h*h/12 + r*r/4);
				invInertia.k = 0.5*mass*r*r;
				invInertia.invert();
			}
		}
	}
}