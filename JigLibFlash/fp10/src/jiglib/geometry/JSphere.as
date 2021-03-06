package jiglib.geometry
{
	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.data.CollOutData;
	import jiglib.math.*;
	import jiglib.physics.PhysicsState;
	import jiglib.physics.RigidBody;
	import jiglib.plugin.ISkin3D;

	public class JSphere extends RigidBody
	{

		public var name:String;
		private var _radius:Number;

		public function JSphere(skin:ISkin3D, r:Number)
		{

			super(skin);
			_type = "SPHERE";
			_radius = r;
			_boundingSphere = _radius;
			mass = 1;
			updateBoundingBox();
		}

		public function set radius(r:Number):void
		{
			_radius = r;
			_boundingSphere = _radius;
			setInertia(getInertiaProperties(mass));
			setActive();
			updateBoundingBox();
		}

		public function get radius():Number
		{
			return _radius;
		}

		override public function segmentIntersect(out:CollOutData, seg:JSegment, state:PhysicsState):Boolean
		{
			out.frac = 0;
			out.position = new Vector3D();
			out.normal = new Vector3D();

			var frac:Number = 0,radiusSq:Number,rSq:Number,sDotr:Number,sSq:Number,sigma:Number,sigmaSqrt:Number,lambda1:Number,lambda2:Number;
			var r:Vector3D,s:Vector3D;
			r = seg.delta;
			s = seg.origin.subtract(state.position);

			radiusSq = _radius * _radius;
			rSq = r.lengthSquared;
			if (rSq < radiusSq)
			{
				out.frac = 0;
				out.position = seg.origin.clone();
				out.normal = out.position.subtract(state.position);
				out.normal.normalize();
				return true;
			}

			sDotr = s.dotProduct(r);
			sSq = s.lengthSquared;
			sigma = sDotr * sDotr - rSq * (sSq - radiusSq);
			if (sigma < 0)
			{
				return false;
			}
			sigmaSqrt = Math.sqrt(sigma);
			lambda1 = (-sDotr - sigmaSqrt) / rSq;
			lambda2 = (-sDotr + sigmaSqrt) / rSq;
			if (lambda1 > 1 || lambda2 < 0)
			{
				return false;
			}
			frac = Math.max(lambda1, 0);
			out.frac = frac;
			out.position = seg.getPoint(frac);
			out.normal = out.position.subtract(state.position);
			out.normal.normalize();
			return true;
		}

		override public function getInertiaProperties(m:Number):Matrix3D
		{
			var Ixx:Number = 0.4 * m * _radius * _radius;
			return JMatrix3D.getScaleMatrix(Ixx, Ixx, Ixx);
		}
		
		override protected function updateBoundingBox():void {
			_boundingBox.clear();
			_boundingBox.addSphere(this); // todo: only when needed like changing the scale?
		}
	}
}
