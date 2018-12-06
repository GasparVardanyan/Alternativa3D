/**
* ...
* @author muzer
*/

package {

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;
	
	import jiglib.geometry.JCapsule;
	import jiglib.geometry.JSphere;
	import jiglib.math.JMatrix3D;
	import jiglib.math.JNumber3D;
	import jiglib.plugin.ISkin3D;
	import jiglib.physics.PhysicsSystem;
	import jiglib.physics.HingeJoint;
	
	public class Ragdoll {
		 
		public static const HEAD:String = "head";
		public static const TORSO:String = "torso";
		public static const UPPER_ARM_LEFT:String = "upper_arm_left";
		public static const UPPER_ARM_RIGHT:String = "upper_arm_right";
		public static const LOWER_ARM_LEFT:String = "lower_arm_left";
		public static const LOWER_ARM_RIGHT:String = "lower_arm_right";
		public static const UPPER_LEG_LEFT:String = "upper_leg_left";
		public static const UPPER_LEG_RIGHT:String = "upper_leg_right";
		public static const LOWER_LEG_LEFT:String = "lower_leg_left";
		public static const LOWER_LEG_RIGHT:String = "lower_leg_right";
		 
		public static const NECK:String = "neck";
		public static const SHOULDER_LEFT:String = "shoulder_left";
		public static const SHOULDER_RIGHT:String = "shoulder_right";
		public static const ELBOW_LEFT:String = "elbow_left";
		public static const ELBOW_RIGHT:String = "elbow_right";
		public static const HIP_LEFT:String = "hip_left";
		public static const HIP_RIGHT:String = "hip_right";
		public static const KNEE_LEFT:String = "knee_left";
		public static const KNEE_Right:String = "knee_right";
		 
		private var _limbs:Array;
		private var _joints:Array;
		 
		public function Ragdoll(headSkin:ISkin3D, torsoSkin:ISkin3D, 
		                        upperArmLeftSkin:ISkin3D, upperArmRightSkin:ISkin3D,
		                        lowerArmLeftSkin:ISkin3D, lowerArmRightSkin:ISkin3D, 
								upperLegLeftSkin:ISkin3D, upperLegRightSkin:ISkin3D,
								lowerLegLeftSkin:ISkin3D, lowerLegRightSkin:ISkin3D) 
		{
			_limbs = new Array();
			
			_limbs["torso"] = new JCapsule(torsoSkin, 20, 45);
			_limbs["torso"].maxLinVelocities = 400;
			_limbs["torso"].maxRotVelocities = 10;
			PhysicsSystem.getInstance().addBody(limbs["torso"]);
			_limbs["head"] = new JSphere(headSkin, 16);
			_limbs["head"].maxLinVelocities = 400;
			_limbs["head"].maxRotVelocities = 10;
			_limbs["head"].moveTo(new Vector3D(0, 32, 0));
			PhysicsSystem.getInstance().addBody(limbs["head"]);
			_limbs["upper_arm_left"] = new JCapsule(upperArmLeftSkin, 10, 25);
			_limbs["upper_arm_left"].maxLinVelocities = 400;
			_limbs["upper_arm_left"].maxRotVelocities = 10;
			_limbs["upper_arm_left"].moveTo(new Vector3D(20, 9, 0));
			PhysicsSystem.getInstance().addBody(limbs["upper_arm_left"]);
			_limbs["upper_arm_right"] = new JCapsule(upperArmRightSkin, 10, 25);
			_limbs["upper_arm_right"].maxLinVelocities = 400;
			_limbs["upper_arm_right"].maxRotVelocities = 10;
			_limbs["upper_arm_right"].moveTo(new Vector3D( -20, 9, 0));
			PhysicsSystem.getInstance().addBody(limbs["upper_arm_right"]);
			_limbs["lower_arm_left"] = new JCapsule(lowerArmLeftSkin, 9, 30);
			_limbs["lower_arm_left"].maxLinVelocities = 400;
			_limbs["lower_arm_left"].maxRotVelocities = 10;
			_limbs["lower_arm_left"].moveTo(new Vector3D(20, -13, 0));
			PhysicsSystem.getInstance().addBody(limbs["lower_arm_left"]);
			_limbs["lower_arm_right"] = new JCapsule(lowerArmRightSkin, 9, 30);
			_limbs["lower_arm_right"].maxLinVelocities = 400;
			_limbs["lower_arm_right"].maxRotVelocities = 10;
			_limbs["lower_arm_right"].moveTo(new Vector3D( -20, -13, 0));
			PhysicsSystem.getInstance().addBody(limbs["lower_arm_right"]);
			_limbs["upper_leg_left"] = new JCapsule(upperLegLeftSkin, 12, 35);
			_limbs["upper_leg_left"].maxLinVelocities = 400;
			_limbs["upper_leg_left"].maxRotVelocities = 10;
			_limbs["upper_leg_left"].moveTo(new Vector3D(10, -36, 0));
			PhysicsSystem.getInstance().addBody(limbs["upper_leg_left"]);
			_limbs["upper_leg_right"] = new JCapsule(upperLegRightSkin, 12, 35);
			_limbs["upper_leg_right"].maxLinVelocities = 400;
			_limbs["upper_leg_right"].maxRotVelocities = 10;
			_limbs["upper_leg_right"].moveTo(new Vector3D( -10, -36, 0));
			PhysicsSystem.getInstance().addBody(limbs["upper_leg_right"]);
			_limbs["lower_leg_left"] = new JCapsule(lowerLegLeftSkin, 11, 35);
			_limbs["lower_leg_left"].maxLinVelocities = 400;
			_limbs["lower_leg_left"].maxRotVelocities = 10;
			_limbs["lower_leg_left"].moveTo(new Vector3D(10, -66, 0));
			PhysicsSystem.getInstance().addBody(limbs["lower_leg_left"]);
			_limbs["lower_leg_right"] = new JCapsule(lowerLegRightSkin, 11, 35);
			_limbs["lower_leg_right"].maxLinVelocities = 400;
			_limbs["lower_leg_right"].maxRotVelocities = 10;
			_limbs["lower_leg_right"].moveTo(new Vector3D( -10, -66, 0));
			PhysicsSystem.getInstance().addBody(limbs["lower_leg_right"]);
			
			
			// disable some collisions
			_limbs["head"].disableCollisions(_limbs["upper_arm_left"]);
			_limbs["head"].disableCollisions(_limbs["upper_arm_right"]);
			_limbs["head"].disableCollisions(_limbs["upper_leg_left"]);
			_limbs["head"].disableCollisions(_limbs["upper_leg_right"]);
			_limbs["head"].disableCollisions(_limbs["lower_leg_left"]);
			_limbs["head"].disableCollisions(_limbs["lower_leg_right"]);
			_limbs["torso"].disableCollisions(_limbs["head"]);
			_limbs["torso"].disableCollisions(_limbs["upper_arm_left"]);
			_limbs["torso"].disableCollisions(_limbs["upper_arm_right"]);
			_limbs["torso"].disableCollisions(_limbs["upper_leg_left"]);
			_limbs["torso"].disableCollisions(_limbs["upper_leg_right"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["upper_arm_right"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["lower_arm_left"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["upper_leg_left"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["upper_leg_right"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["lower_leg_left"]);
			_limbs["upper_arm_left"].disableCollisions(_limbs["lower_arm_right"]);
			_limbs["upper_arm_right"].disableCollisions(_limbs["lower_arm_right"]);
			_limbs["upper_arm_right"].disableCollisions(_limbs["upper_leg_left"]);
			_limbs["upper_arm_right"].disableCollisions(_limbs["upper_leg_right"]);
			_limbs["upper_arm_right"].disableCollisions(_limbs["lower_leg_left"]);
			_limbs["upper_arm_right"].disableCollisions(_limbs["lower_arm_right"]);
			_limbs["upper_leg_left"].disableCollisions(_limbs["lower_leg_left"]);
			_limbs["upper_leg_right"].disableCollisions(_limbs["lower_leg_right"]);
			
			
			_joints = new Array();
			// set up the hinge joints.
			_joints["neck"] = new HingeJoint(_limbs["torso"], _limbs["head"], Vector3D.X_AXIS, new Vector3D(0, 25, 0), 5, 20, 50, 0.4, 0.5);
			_joints["shoulder_left"] = new HingeJoint(_limbs["torso"], _limbs["upper_arm_left"], Vector3D.X_AXIS, new Vector3D(18, 22, 0), 5, 150, 10, 0.8, 0.5);
			_joints["shoulder_right"] = new HingeJoint(_limbs["torso"], _limbs["upper_arm_right"], Vector3D.X_AXIS, new Vector3D( -18, 22, 0), 5, 150, 10, 0.8, 0.5);
			_joints["elbow_left"] = new HingeJoint(_limbs["upper_arm_left"], _limbs["lower_arm_left"], Vector3D.X_AXIS, new Vector3D( 0, -12, 0), 5, 80, 0, 0.1, 0.5);
			_joints["elbow_right"] = new HingeJoint(_limbs["upper_arm_right"], _limbs["lower_arm_right"], Vector3D.X_AXIS, new Vector3D( 0, -12, 0), 5, 80, 0, 0.1, 0.5);
			_joints["hip_left"] = new HingeJoint(_limbs["upper_leg_left"], _limbs["torso"], Vector3D.X_AXIS, new Vector3D(0, 18, 0), 5, 20, 130, 0.6, 0.5);
			_joints["hip_right"] = new HingeJoint(_limbs["upper_leg_right"], _limbs["torso"], Vector3D.X_AXIS, new Vector3D(0, 18, 0), 5, 20, 130, 0.6, 0.5);
			_joints["knee_left"] = new HingeJoint(_limbs["upper_leg_left"], _limbs["lower_leg_left"], Vector3D.X_AXIS, new Vector3D( 0, -18, 0), 5, 0, 70, 0.1, 0.5);
			_joints["knee_right"] = new HingeJoint(_limbs["upper_leg_right"], _limbs["lower_leg_right"], Vector3D.X_AXIS, new Vector3D( 0, -18, 0), 5, 0, 70, 0.1, 0.5);
		}
		
		public function get limbs():Array {
			return _limbs;
		}
		
		public function get joints():Array {
			return _joints;
		}
		
		public function setActive():void {
			for (var i:String in _limbs) {
				_limbs[i].setActive();
			}
		}
		
		public function setInactive():void {
			for (var i:String in _limbs) {
				_limbs[i].setInactive();
			}
		}
		
		public function moveTo(pos:Vector3D):void {
			var delta:Vector3D = pos.subtract(_limbs["torso"].currentState.position);
			for (var i:String in _limbs) {
				_limbs[i].moveTo(_limbs[i].currentState.position.add(delta));
			}
		}
		
		public function setOrientation(orient:Matrix3D):void {
			var delta:Vector3D;
			var orientation:Matrix3D;
			var origTorsoPos:Vector3D = _limbs["torso"].currentState.position;
			for (var i:String in _limbs) {
				delta = _limbs[i].currentState.position.subtract(origTorsoPos);
				JMatrix3D.multiplyVector(orient, delta);
				orientation = JMatrix3D.getPrependMatrix(orient, _limbs[i].currentState.orientation);
				_limbs[i].moveTo(origTorsoPos.add(delta));
				_limbs[i].setOrientation(orientation);
			}
		}
	}
	
}
