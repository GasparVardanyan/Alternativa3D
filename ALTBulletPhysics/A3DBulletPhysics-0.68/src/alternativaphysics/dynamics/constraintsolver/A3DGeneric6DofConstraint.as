package alternativaphysics.dynamics.constraintsolver {
	import alternativaphysics.dynamics.A3DRigidBody;
	import alternativaphysics.math.A3DMath;
	import alternativaphysics.math.A3DTransform;

	import flash.geom.Matrix3D;
	import flash.geom.Vector3D;

	/** 
	* 
	* @public 
	* @author redefy 
	*/
	public class A3DGeneric6DofConstraint extends A3DTypedConstraint {
		private var m_linearLimits : A3DTranslationalLimitMotor;
		private var m_angularLimits : Vector.<A3DRotationalLimitMotor>;
		
		private var m_rbAFrame:A3DTransform;
		private var m_rbBFrame:A3DTransform;

		public function A3DGeneric6DofConstraint(rbA : A3DRigidBody, pivotInA : Vector3D, rotationInA : Vector3D, rbB : A3DRigidBody = null, pivotInB : Vector3D = null, rotationInB : Vector3D = null, useLinearReferenceFrameA : Boolean = false) {
			super(3);
			m_rbA = rbA;
			m_rbB = rbB;
			
			m_rbAFrame = new A3DTransform();
			m_rbAFrame.position = pivotInA;
			m_rbAFrame.rotation = A3DMath.degrees2radiansV3D(rotationInA);

			var posInA : Vector3D = pivotInA.clone();
			posInA.scaleBy(1 / _scaling);
			var rotA:Matrix3D = A3DMath.euler2matrix(m_rbAFrame.rotation);
			var rotArrInA : Vector.<Number> = rotA.rawData;
			if (rbB) {
				m_rbBFrame = new A3DTransform();
				m_rbBFrame.position = pivotInB;
				m_rbBFrame.rotation = A3DMath.degrees2radiansV3D(rotationInB);
				
				var posInB : Vector3D = pivotInB.clone();
				posInB.scaleBy(1 / _scaling);
				var rotB:Matrix3D = A3DMath.euler2matrix(m_rbBFrame.rotation);
				var rotArrInB : Vector.<Number> = rotB.rawData;
				pointer = bullet.createGeneric6DofConstraintMethod2(rbA.pointer, posInA, new Vector3D(rotArrInA[0], rotArrInA[4], rotArrInA[8]), new Vector3D(rotArrInA[1], rotArrInA[5], rotArrInA[9]), new Vector3D(rotArrInA[2], rotArrInA[6], rotArrInA[10]), rbB.pointer, posInB, new Vector3D(rotArrInB[0], rotArrInB[4], rotArrInB[8]), new Vector3D(rotArrInB[1], rotArrInB[5], rotArrInB[9]), new Vector3D(rotArrInB[2], rotArrInB[6], rotArrInB[10]), useLinearReferenceFrameA ? 1 : 0);
			} else {
				m_rbBFrame = null;
				pointer = bullet.createGeneric6DofConstraintMethod1(rbA.pointer, posInA.x, posInA.y, posInA.z, rotArrInA[0], rotArrInA[4], rotArrInA[8], rotArrInA[1], rotArrInA[5], rotArrInA[9], rotArrInA[2], rotArrInA[6], rotArrInA[10], useLinearReferenceFrameA ? 1 : 0);
			}

			m_linearLimits = new A3DTranslationalLimitMotor(pointer + 668);

			m_angularLimits = new Vector.<A3DRotationalLimitMotor>(3, true);
			m_angularLimits[0] = new A3DRotationalLimitMotor(pointer + 856);
			m_angularLimits[1] = new A3DRotationalLimitMotor(pointer + 920);
			m_angularLimits[2] = new A3DRotationalLimitMotor(pointer + 984);
		}
		

		/** 
		* 
		* @public (getter) 
		* @return A3DTransform 
		*/
		public function get rbAFrame():A3DTransform {
			return m_rbAFrame;
		}
		

		/** 
		* 
		* @public (getter) 
		* @return A3DTransform 
		*/
		public function get rbBFrame():A3DTransform {
			return m_rbBFrame;
		}


		/** 
		* 
		* @public 
		* @return A3DTranslationalLimitMotor 
		*/
		public function getTranslationalLimitMotor() : A3DTranslationalLimitMotor {
			return m_linearLimits;
		}


		/** 
		* 
		* @public 
		* @param index 
		* @return A3DRotationalLimitMotor 
		*/
		public function getRotationalLimitMotor(index : int) : A3DRotationalLimitMotor {
			if (index > 2) return null;
			else return m_angularLimits[index];
		}


		/** 
		* 
		* @public 
		* @param low 
		* @param high 
		* @return void 
		*/
		public function setLinearLimit(low : Vector3D, high : Vector3D) : void {
			m_linearLimits.lowerLimit = low;
			m_linearLimits.upperLimit = high;
		}


		/** 
		* 
		* @public 
		* @param low 
		* @param high 
		* @return void 
		*/
		public function setAngularLimit(low : Vector3D, high : Vector3D) : void {
			m_angularLimits[0].loLimit = normalizeAngle(low.x);
			m_angularLimits[0].hiLimit = normalizeAngle(high.x);
			m_angularLimits[1].loLimit = normalizeAngle(low.y);
			m_angularLimits[1].hiLimit = normalizeAngle(high.y);
			m_angularLimits[2].loLimit = normalizeAngle(low.z);
			m_angularLimits[2].hiLimit = normalizeAngle(high.z);
		}


		/** 
		* 
		* @private 
		* @param angleInRadians 
		* @return Number 
		*/
		private function normalizeAngle(angleInRadians : Number) : Number {
			var pi2 : Number = 2 * Math.PI;
			var result : Number = angleInRadians % pi2;
			if (result < -Math.PI) {
				return result + pi2;
			} else if (result > Math.PI) {
				return result - pi2;
			} else {
				return result;
			}
		}
	}
}